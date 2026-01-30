import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/fitness_class.dart';
import '../../domain/repositories/classes_repository.dart';
import 'classes_state.dart';

@injectable
class ClassesCubit extends Cubit<ClassesState> {
  final ClassesRepository _repository;

  ClassesCubit(this._repository) : super(const ClassesState());

  Future<void> loadInitial() async {
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 0);
  
  await loadSchedule(
    startDate: startOfMonth,
    endDate: endOfMonth,
  );
  
  await loadMyBookings();
}

  // ═══════════════════════════════════════════════════════════════════════════
  // LOAD SCHEDULE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Load schedule for a date range
  Future<void> loadSchedule({
    required DateTime startDate,
    required DateTime endDate,
    ClassFilter? filter,
  }) async {
    emit(state.copyWith(
      scheduleStatus: ClassesStatus.loading,
      scheduleStartDate: startDate,
      scheduleEndDate: endDate,
    ));

    try {
      final schedules = await _repository.getScedule(
        startDate: startDate,
        endDate: endDate,
        filter: filter ?? state.filter,
      );

      // Group by day
      final weekSchedule = _groupSchedulesByDay(schedules, startDate, endDate);

      emit(state.copyWith(
        scheduleStatus: ClassesStatus.success,
        schedules: schedules,
        weekSchedule: weekSchedule,
        filter: filter ?? state.filter,
      ));
    } catch (e) {
      emit(state.copyWith(
        scheduleStatus: ClassesStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Load this week's schedule
  Future<void> loadThisWeekSchedule() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    await loadSchedule(
      startDate: startOfWeek,
      endDate: endOfWeek,
    );
  }

  /// Group schedules by day
  List<DaySchedule> _groupSchedulesByDay(
    List<ClassSchedule> schedules,
    DateTime startDate,
    DateTime endDate,
  ) {
    final result = <DaySchedule>[];
    var currentDate = startDate;

    while (!currentDate.isAfter(endDate)) {
      final dayClasses = schedules.where((s) {
        return s.startTime.year == currentDate.year &&
               s.startTime.month == currentDate.month &&
               s.startTime.day == currentDate.day;
      }).toList();

      // Sort by start time
      dayClasses.sort((a, b) => a.startTime.compareTo(b.startTime));

      result.add(DaySchedule(
        date: currentDate,
        classes: dayClasses,
      ));

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return result;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SELECT CLASS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Select a class schedule to view details
  void selectSchedule(ClassSchedule schedule) {
    emit(state.copyWith(
      selectedSchedule: schedule,
      selectedClass: schedule.fitnessClass,
    ));
  }

  /// Select a schedule by ID from already loaded schedules
  void selectScheduleById(String scheduleId) {
    final schedule = state.schedules.where((s) => s.id == scheduleId).firstOrNull;
    if (schedule != null) {
      emit(state.copyWith(
        selectedSchedule: schedule,
        selectedClass: schedule.fitnessClass,
      ));
    }
  }

  /// Load a specific schedule and select it for detail view
Future<void> loadAndSelectSchedule(String scheduleId) async {
  emit(state.copyWith(scheduleStatus: ClassesStatus.loading));

  try {
    // Load schedule for current month to find the specific schedule
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month - 1, 1);
    final endOfMonth = DateTime(now.year, now.month + 2, 0);

    final schedules = await _repository.getScedule(
      startDate: startOfMonth,
      endDate: endOfMonth,
    );

    // Find the specific schedule
    final schedule = schedules.firstWhere(
      (s) => s.id == scheduleId,
      orElse: () => throw Exception('Schedule not found'),
    );

    emit(state.copyWith(
      scheduleStatus: ClassesStatus.success,
      schedules: schedules,
      selectedSchedule: schedule,
      selectedClass: schedule.fitnessClass,
    ));
  } catch (e) {
    emit(state.copyWith(
      scheduleStatus: ClassesStatus.failure,
      errorMessage: e.toString(),
    ));
  }
}

  /// Clear selection
  void clearSelection() {
    emit(state.copyWith(
      selectedSchedule: null,
      selectedClass: null,
    ));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BOOKINGS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Load user's bookings
  Future<void> loadMyBookings() async {
    emit(state.copyWith(bookingsStatus: ClassesStatus.loading));

    try {
      final bookings = await _repository.getMyBookings();
      
      // Split into upcoming and past
      final upcoming = bookings.where((b) {
        return !b.schedule.hasEnded && 
               (b.status == BookingStatus.confirmed || 
                b.status == BookingStatus.waitlisted);
      }).toList();

      final past = bookings.where((b) {
        return b.schedule.hasEnded || 
               b.status == BookingStatus.cancelled ||
               b.status == BookingStatus.completed ||
               b.status == BookingStatus.noShow;
      }).toList();

      // Sort upcoming by start time
      upcoming.sort((a, b) => a.schedule.startTime.compareTo(b.schedule.startTime));
      
      // Sort past by start time descending
      past.sort((a, b) => b.schedule.startTime.compareTo(a.schedule.startTime));

      emit(state.copyWith(
        bookingsStatus: ClassesStatus.success,
        myBookings: bookings,
        upcomingBookings: upcoming,
        pastBookings: past,
      ));
    } catch (e) {
      emit(state.copyWith(
        bookingsStatus: ClassesStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Book a class
  Future<bool> bookClass(String scheduleId) async {
    emit(state.copyWith(bookingActionStatus: ClassesStatus.loading));

    try {
      final booking = await _repository.bookClass(scheduleId: scheduleId);

      // Add to bookings list
      final updatedBookings = [...state.myBookings, booking];
      
      // Update upcoming if confirmed or waitlisted
      List<ClassBooking> updatedUpcoming = state.upcomingBookings;
      if (booking.status == BookingStatus.confirmed || 
          booking.status == BookingStatus.waitlisted) {
        updatedUpcoming = [...state.upcomingBookings, booking];
        updatedUpcoming.sort((a, b) => 
            a.schedule.startTime.compareTo(b.schedule.startTime));
      }

      emit(state.copyWith(
        bookingActionStatus: ClassesStatus.success,
        myBookings: updatedBookings,
        upcomingBookings: updatedUpcoming,
      ));

      return true;
    } catch (e) {
      emit(state.copyWith(
        bookingActionStatus: ClassesStatus.failure,
        errorMessage: e.toString(),
      ));
      return false;
    }
  }

  /// Cancel a booking
  Future<bool> cancelBooking(String bookingId, {String? reason}) async {
    emit(state.copyWith(bookingActionStatus: ClassesStatus.loading));

    try {
      final cancelledBooking = await _repository.cancelBooking(
        bookingId: bookingId,
        reason: reason,
      );

      // Update booking in list
      final updatedBookings = state.myBookings.map((b) {
        if (b.id == bookingId) return cancelledBooking;
        return b;
      }).toList();

      // Remove from upcoming
      final updatedUpcoming = state.upcomingBookings
          .where((b) => b.id != bookingId)
          .toList();

      // Add to past
      final updatedPast = [cancelledBooking, ...state.pastBookings];

      emit(state.copyWith(
        bookingActionStatus: ClassesStatus.success,
        myBookings: updatedBookings,
        upcomingBookings: updatedUpcoming,
        pastBookings: updatedPast,
      ));

      return true;
    } catch (e) {
      emit(state.copyWith(
        bookingActionStatus: ClassesStatus.failure,
        errorMessage: e.toString(),
      ));
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FILTER
  // ═══════════════════════════════════════════════════════════════════════════

  /// Update filter
  void updateFilter(ClassFilter filter) {
    emit(state.copyWith(filter: filter));
    
    // Reload schedule with new filter
    if (state.scheduleStartDate != null && state.scheduleEndDate != null) {
      loadSchedule(
        startDate: state.scheduleStartDate!,
        endDate: state.scheduleEndDate!,
        filter: filter,
      );
    }
  }

  /// Clear filter
  void clearFilter() {
    updateFilter(const ClassFilter());
  }
}