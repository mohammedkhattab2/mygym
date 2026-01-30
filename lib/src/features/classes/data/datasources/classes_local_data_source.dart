import 'package:injectable/injectable.dart';
import 'package:mygym/src/features/classes/domain/entities/fitness_class.dart';



@lazySingleton
class ClassesLocalDataSource {
  // Fake in-memory data للتطوير
  final List<FitnessClass> _classes = [];
  final List<ClassSchedule> _schedules = [];
  final List<ClassBooking> _bookings = [];

  ClassesLocalDataSource() {
    _seedDummyData();
  }

  void _seedDummyData() {
    if (_classes.isNotEmpty) return;

    final instructor1 = Instructor(
      id: 'inst_1',
      name: 'Sarah Ahmed',
      specialties: const [ClassCategory.yoga, ClassCategory.pilates],
      rating: 4.8,
      totalClasses: 320,
      totalReviews: 120,
    );

    final instructor2 = Instructor(
      id: 'inst_2',
      name: 'Omar Hassan',
      specialties: const [ClassCategory.hiit, ClassCategory.strength],
      rating: 4.6,
      totalClasses: 280,
      totalReviews: 95,
    );

    final yogaClass = FitnessClass(
      id: 'class_yoga_1',
      name: 'Morning Flow Yoga',
      description: 'A gentle morning yoga session to wake up your body.',
      category: ClassCategory.yoga,
      difficulty: DifficultyLevel.beginner,
      gymId: 'gym_1',
      gymName: 'Downtown Fitness',
      instructor: instructor1,
      durationMinutes: 60,
      maxParticipants: 15,
      currentParticipants: 8,
      equipment: const ['Yoga mat'],
      tags: const ['Relax', 'Stretch', 'Morning'],
      isRecurring: true,
      recurringPattern: 'Every Monday, Wednesday, Friday',
    );

    final hiitClass = FitnessClass(
      id: 'class_hiit_1',
      name: 'Evening HIIT Blast',
      description: 'High intensity interval training for fat burning.',
      category: ClassCategory.hiit,
      difficulty: DifficultyLevel.intermediate,
      gymId: 'gym_2',
      gymName: 'Power House Gym',
      instructor: instructor2,
      durationMinutes: 45,
      maxParticipants: 20,
      currentParticipants: 18,
      equipment: const ['Towel', 'Water bottle'],
      tags: const ['Intense', 'Cardio'],
      isRecurring: true,
      recurringPattern: 'Every Tuesday, Thursday',
    );

    _classes.addAll([yogaClass, hiitClass]);

    // نولّد شوية schedule للأسبوع الحالي
    final now = DateTime.now();
    DateTime day(int offset) => DateTime(now.year, now.month, now.day + offset);

    _schedules.addAll([
      ClassSchedule(
        id: 'sched_yoga_${day(0).toIso8601String()}',
        fitnessClass: yogaClass,
        startTime: day(0).add(const Duration(hours: 8)), // اليوم 8:00
        endTime: day(0).add(const Duration(hours: 9)),
        room: 'Studio A',
        currentParticipants: 10,
        waitlistCount: 0,
      ),
      ClassSchedule(
        id: 'sched_yoga_${day(2).toIso8601String()}',
        fitnessClass: yogaClass,
        startTime: day(2).add(const Duration(hours: 8)),
        endTime: day(2).add(const Duration(hours: 9)),
        room: 'Studio A',
        currentParticipants: 12,
        waitlistCount: 1,
      ),
      ClassSchedule(
        id: 'sched_hiit_${day(1).toIso8601String()}',
        fitnessClass: hiitClass,
        startTime: day(1).add(const Duration(hours: 19)), // 7:00 pm
        endTime: day(1).add(const Duration(hours: 19, minutes: 45)),
        room: 'Main Hall',
        currentParticipants: 18,
        waitlistCount: 2,
      ),
      ClassSchedule(
        id: 'sched_hiit_${day(3).toIso8601String()}',
        fitnessClass: hiitClass,
        startTime: day(3).add(const Duration(hours: 19)),
        endTime: day(3).add(const Duration(hours: 19, minutes: 45)),
        room: 'Main Hall',
        currentParticipants: 15,
        waitlistCount: 0,
      ),
    ]);
  }

  /// Get a specific schedule by ID
  Future<ClassSchedule?> getScheduleById(String scheduleId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _schedules.firstWhere((s) => s.id == scheduleId);
    } catch (_) {
      return null;
    }
  }

  Future<List<ClassSchedule>> getSchedule({
    required DateTime startDate,
    required DateTime endDate,
    ClassFilter? filter,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _schedules.where((s) {
      final d = DateTime(s.startTime.year, s.startTime.month, s.startTime.day);
      final afterStart =
          !d.isBefore(DateTime(startDate.year, startDate.month, startDate.day));
      final beforeEnd =
          !d.isAfter(DateTime(endDate.year, endDate.month, endDate.day));

      if (!afterStart || !beforeEnd) return false;

      // filters (بسيط)
      if (filter != null) {
        if (filter.gymId != null && filter.gymId != s.fitnessClass.gymId) {
          return false;
        }
        if (filter.category != null &&
            filter.category != s.fitnessClass.category) {
          return false;
        }
        if (filter.difficulty != null &&
            filter.difficulty != s.fitnessClass.difficulty) {
          return false;
        }
        if (!filter.showCancelled && s.isCancelled) return false;
        if (!filter.showFullClasses && s.isFull) return false;
      }

      return true;
    }).toList();
  }

  Future<List<ClassBooking>> getMyBookings(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _bookings.where((b) => b.userId == userId).toList();
  }

  Future<ClassBooking> bookClass({
    required String userId,
    required String scheduleId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final sched = _schedules.firstWhere((s) => s.id == scheduleId);
    final now = DateTime.now();

    final status =
        sched.isFull ? BookingStatus.waitlisted : BookingStatus.confirmed;

    final booking = ClassBooking(
      id: 'book_${now.millisecondsSinceEpoch}',
      userId: userId,
      schedule: sched,
      status: status,
      bookedAt: now,
      waitlistPosition: sched.isFull ? sched.waitlistCount + 1 : null,
    );
    _bookings.add(booking);

    // عدّل الأرقام في schedule
    final index = _schedules.indexWhere((s) => s.id == scheduleId);
    if (index != -1) {
      final s = _schedules[index];
      final updated = ClassSchedule(
        id: s.id,
        fitnessClass: s.fitnessClass,
        startTime: s.startTime,
        endTime: s.endTime,
        room: s.room,
        isCancelled: s.isCancelled,
        cancellationReason: s.cancellationReason,
        substituteInstructor: s.substituteInstructor,
        currentParticipants: s.currentParticipants + (s.isFull ? 0 : 1),
        waitlistCount: s.waitlistCount + (s.isFull ? 1 : 0),
      );
      _schedules[index] = updated;
    }

    return booking;
  }

  Future<ClassBooking> cancelBooking({
    required String bookingId,
    String? reason,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index == -1) {
      throw Exception('Booking not found');
    }

    final b = _bookings[index];
    final updated = ClassBooking(
      id: b.id,
      userId: b.userId,
      schedule: b.schedule,
      status: BookingStatus.cancelled,
      bookedAt: b.bookedAt,
      cancelledAt: DateTime.now(),
      cancellationReason: reason,
      waitlistPosition: b.waitlistPosition,
      reminderSent: b.reminderSent,
      checkedInAt: b.checkedInAt,
    );
    _bookings[index] = updated;

    return updated;
  }
}