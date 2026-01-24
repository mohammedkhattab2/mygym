import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mygym/src/features/classes/domain/entities/fitness_class.dart';
import '../../domain/repositories/classes_repository.dart';

class ClassesState {
  final bool isLoading;
  final String? errorMessage;
  final DateTime focusedDay; // اليوم اللي ظاهر في الكاليندر
  final DateTime selectedDay; // اليوم اللي مختاره اليوزر
  final List<ClassSchedule> schedules; // لكل الفترة المحملة
  final List<ClassBooking> myBookings;

  const ClassesState({
    required this.isLoading,
    this.errorMessage,
    required this.focusedDay,
    required this.selectedDay,
    this.schedules = const [],
    this.myBookings = const [],
  });

  List<ClassSchedule> get schedulesForSelectedDay {
    return schedules.where((s) {
      final d = DateTime(
        s.startTime.year,
        s.startTime.month,
        s.startTime.day,
      );
      final sel = DateTime(
        selectedDay.year,
        selectedDay.month,
        selectedDay.day,
      );
      return d == sel;
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  ClassesState copyWith({
    bool? isLoading,
    String? errorMessage,
    DateTime? focusedDay,
    DateTime? selectedDay,
    List<ClassSchedule>? schedules,
    List<ClassBooking>? myBookings,
  }) {
    return ClassesState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      schedules: schedules ?? this.schedules,
      myBookings: myBookings ?? this.myBookings,
    );
  }

  factory ClassesState.initial() {
    final now = DateTime.now();
    return ClassesState(
      isLoading: false,
      focusedDay: DateTime(now.year, now.month, now.day),
      selectedDay: DateTime(now.year, now.month, now.day),
    );
  }
}

@injectable
class ClassesCubit extends Cubit<ClassesState> {
  final ClassesRepository _repository;

  ClassesCubit(this._repository) : super(ClassesState.initial());

  Future<void> loadInitial() async {
    final now = state.focusedDay;
    final start = now.subtract(const Duration(days: 7));
    final end = now.add(const Duration(days: 7));
    await loadSchedule(startDate: start, endDate: end);
  }

  Future<void> loadSchedule({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final schedules = await _repository.getScedule(
        startDate: startDate,
        endDate: endDate,
      );
      final bookings = await _repository.getMyBookings();
      emit(
        state.copyWith(
          isLoading: false,
          schedules: schedules,
          myBookings: bookings,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    emit(
      state.copyWith(
        selectedDay: DateTime(
            selectedDay.year, selectedDay.month, selectedDay.day),
        focusedDay: DateTime(
            focusedDay.year, focusedDay.month, focusedDay.day),
      ),
    );
  }

  Future<void> bookClass(String scheduleId) async {
    try {
      await _repository.bookClass(scheduleId: scheduleId);
      // بعد الحجز: أعد تحميل الـ bookings و schedules
      final now = state.focusedDay;
      final start = now.subtract(const Duration(days: 7));
      final end = now.add(const Duration(days: 7));
      await loadSchedule(startDate: start, endDate: end);
    } catch (_) {}
  }
}