import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/fitness_class.dart';

part 'classes_state.freezed.dart';

@freezed
class ClassesState with _$ClassesState {
  const factory ClassesState({
    // Schedule data
    @Default([]) List<ClassSchedule> schedules,
    @Default([]) List<DaySchedule> weekSchedule,
    
    // Selected class detail
    ClassSchedule? selectedSchedule,
    FitnessClass? selectedClass,
    
    // Bookings
    @Default([]) List<ClassBooking> myBookings,
    @Default([]) List<ClassBooking> upcomingBookings,
    @Default([]) List<ClassBooking> pastBookings,
    
    // Filter
    @Default(ClassFilter()) ClassFilter filter,
    
    // Date range for schedule
    DateTime? scheduleStartDate,
    DateTime? scheduleEndDate,
    
    // Status
    @Default(ClassesStatus.initial) ClassesStatus scheduleStatus,
    @Default(ClassesStatus.initial) ClassesStatus bookingsStatus,
    @Default(ClassesStatus.initial) ClassesStatus bookingActionStatus,
    
    // Error
    String? errorMessage,
  }) = _ClassesState;

  const ClassesState._();

  /// Check if has upcoming bookings
  bool get hasUpcomingBookings => upcomingBookings.isNotEmpty;

  /// Get confirmed bookings count
  int get confirmedBookingsCount => myBookings
      .where((b) => b.status == BookingStatus.confirmed)
      .length;

  /// Get waitlisted bookings count
  int get waitlistedBookingsCount => myBookings
      .where((b) => b.status == BookingStatus.waitlisted)
      .length;

  /// Check if a specific schedule is booked by user
  bool isScheduleBooked(String scheduleId) {
    return myBookings.any(
      (b) => b.schedule.id == scheduleId && 
             (b.status == BookingStatus.confirmed || 
              b.status == BookingStatus.waitlisted),
    );
  }

  /// Get booking for a specific schedule
  ClassBooking? getBookingForSchedule(String scheduleId) {
    try {
      return myBookings.firstWhere(
        (b) => b.schedule.id == scheduleId && 
               (b.status == BookingStatus.confirmed || 
                b.status == BookingStatus.waitlisted),
      );
    } catch (_) {
      return null;
    }
  }
}

enum ClassesStatus {
  initial,
  loading,
  success,
  failure,
}