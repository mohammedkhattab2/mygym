// Fitness class entities for class booking feature

/// Class category enum
enum ClassCategory {
  yoga,
  cardio,
  strength,
  hiit,
  pilates,
  spinning,
  boxing,
  swimming,
  dance,
  crossfit,
  other,
}

/// Extension for ClassCategory
extension ClassCategoryX on ClassCategory {
  String get displayName {
    switch (this) {
      case ClassCategory.yoga:
        return 'Yoga';
      case ClassCategory.cardio:
        return 'Cardio';
      case ClassCategory.strength:
        return 'Strength Training';
      case ClassCategory.hiit:
        return 'HIIT';
      case ClassCategory.pilates:
        return 'Pilates';
      case ClassCategory.spinning:
        return 'Spinning';
      case ClassCategory.boxing:
        return 'Boxing';
      case ClassCategory.swimming:
        return 'Swimming';
      case ClassCategory.dance:
        return 'Dance';
      case ClassCategory.crossfit:
        return 'CrossFit';
      case ClassCategory.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case ClassCategory.yoga:
        return '🧘';
      case ClassCategory.cardio:
        return '🏃';
      case ClassCategory.strength:
        return '💪';
      case ClassCategory.hiit:
        return '⚡';
      case ClassCategory.pilates:
        return '🤸';
      case ClassCategory.spinning:
        return '🚴';
      case ClassCategory.boxing:
        return '🥊';
      case ClassCategory.swimming:
        return '🏊';
      case ClassCategory.dance:
        return '💃';
      case ClassCategory.crossfit:
        return '🏋️';
      case ClassCategory.other:
        return '🎯';
    }
  }
}

/// Difficulty level
enum DifficultyLevel {
  beginner,
  intermediate,
  advanced,
  allLevels,
}

/// Extension for DifficultyLevel
extension DifficultyLevelX on DifficultyLevel {
  String get displayName {
    switch (this) {
      case DifficultyLevel.beginner:
        return 'Beginner';
      case DifficultyLevel.intermediate:
        return 'Intermediate';
      case DifficultyLevel.advanced:
        return 'Advanced';
      case DifficultyLevel.allLevels:
        return 'All Levels';
    }
  }

  String get color {
    switch (this) {
      case DifficultyLevel.beginner:
        return '#4CAF50'; // Green
      case DifficultyLevel.intermediate:
        return '#FF9800'; // Orange
      case DifficultyLevel.advanced:
        return '#F44336'; // Red
      case DifficultyLevel.allLevels:
        return '#2196F3'; // Blue
    }
  }
}

/// Booking status
enum BookingStatus {
  confirmed,
  waitlisted,
  cancelled,
  completed,
  noShow,
}

/// Extension for BookingStatus
extension BookingStatusX on BookingStatus {
  String get displayName {
    switch (this) {
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.waitlisted:
        return 'Waitlisted';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.noShow:
        return 'No Show';
    }
  }
}

/// Fitness class entity
class FitnessClass {
  final String id;
  final String name;
  final String description;
  final ClassCategory category;
  final DifficultyLevel difficulty;
  final String gymId;
  final String gymName;
  final Instructor instructor;
  final int durationMinutes;
  final int maxParticipants;
  final int currentParticipants;
  final int waitlistCount;
  final List<String> equipment;
  final List<String> tags;
  final String? imageUrl;
  final bool isRecurring;
  final String? recurringPattern; // e.g., "Every Monday and Wednesday"

  const FitnessClass({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.gymId,
    required this.gymName,
    required this.instructor,
    required this.durationMinutes,
    required this.maxParticipants,
    this.currentParticipants = 0,
    this.waitlistCount = 0,
    this.equipment = const [],
    this.tags = const [],
    this.imageUrl,
    this.isRecurring = false,
    this.recurringPattern,
  });

  bool get isFull => currentParticipants >= maxParticipants;
  int get spotsLeft => maxParticipants - currentParticipants;
  double get fillPercentage => currentParticipants / maxParticipants;
}

/// Class schedule - specific instance of a class
class ClassSchedule {
  final String id;
  final FitnessClass fitnessClass;
  final DateTime startTime;
  final DateTime endTime;
  final String? room;
  final bool isCancelled;
  final String? cancellationReason;
  final Instructor? substituteInstructor;
  final int currentParticipants;
  final int waitlistCount;

  const ClassSchedule({
    required this.id,
    required this.fitnessClass,
    required this.startTime,
    required this.endTime,
    this.room,
    this.isCancelled = false,
    this.cancellationReason,
    this.substituteInstructor,
    this.currentParticipants = 0,
    this.waitlistCount = 0,
  });

  bool get isFull => currentParticipants >= fitnessClass.maxParticipants;
  int get spotsLeft => fitnessClass.maxParticipants - currentParticipants;
  Duration get duration => endTime.difference(startTime);
  bool get hasStarted => DateTime.now().isAfter(startTime);
  bool get hasEnded => DateTime.now().isAfter(endTime);
  bool get isBookable => !isCancelled && !hasStarted && !isFull;
}

/// Instructor entity
class Instructor {
  final String id;
  final String name;
  final String? photoUrl;
  final String? bio;
  final List<ClassCategory> specialties;
  final double rating;
  final int totalClasses;
  final int totalReviews;

  const Instructor({
    required this.id,
    required this.name,
    this.photoUrl,
    this.bio,
    this.specialties = const [],
    this.rating = 0.0,
    this.totalClasses = 0,
    this.totalReviews = 0,
  });
}

/// Class booking entity
class ClassBooking {
  final String id;
  final String userId;
  final ClassSchedule schedule;
  final BookingStatus status;
  final DateTime bookedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final int? waitlistPosition;
  final bool reminderSent;
  final DateTime? checkedInAt;

  const ClassBooking({
    required this.id,
    required this.userId,
    required this.schedule,
    required this.status,
    required this.bookedAt,
    this.cancelledAt,
    this.cancellationReason,
    this.waitlistPosition,
    this.reminderSent = false,
    this.checkedInAt,
  });

  bool get isOnWaitlist => status == BookingStatus.waitlisted;
  bool get canCancel => 
      status == BookingStatus.confirmed && 
      !schedule.hasStarted;
}

/// Filter for classes
class ClassFilter {
  final String? gymId;
  final ClassCategory? category;
  final DifficultyLevel? difficulty;
  final String? instructorId;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final TimeOfDay? timeFrom;
  final TimeOfDay? timeTo;
  final bool showFullClasses;
  final bool showCancelled;

  const ClassFilter({
    this.gymId,
    this.category,
    this.difficulty,
    this.instructorId,
    this.dateFrom,
    this.dateTo,
    this.timeFrom,
    this.timeTo,
    this.showFullClasses = true,
    this.showCancelled = false,
  });

  ClassFilter copyWith({
    String? gymId,
    ClassCategory? category,
    DifficultyLevel? difficulty,
    String? instructorId,
    DateTime? dateFrom,
    DateTime? dateTo,
    TimeOfDay? timeFrom,
    TimeOfDay? timeTo,
    bool? showFullClasses,
    bool? showCancelled,
  }) {
    return ClassFilter(
      gymId: gymId ?? this.gymId,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      instructorId: instructorId ?? this.instructorId,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      timeFrom: timeFrom ?? this.timeFrom,
      timeTo: timeTo ?? this.timeTo,
      showFullClasses: showFullClasses ?? this.showFullClasses,
      showCancelled: showCancelled ?? this.showCancelled,
    );
  }
}

/// TimeOfDay class for time filtering
class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});

  String get formatted {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

/// Day schedule - classes grouped by day
class DaySchedule {
  final DateTime date;
  final List<ClassSchedule> classes;

  const DaySchedule({
    required this.date,
    required this.classes,
  });

  bool get isEmpty => classes.isEmpty;
  int get classCount => classes.length;
}