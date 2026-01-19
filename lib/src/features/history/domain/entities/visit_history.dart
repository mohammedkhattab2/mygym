// Visit history entities for tracking gym visits

/// Visit entry for history log
class VisitEntry {
  final String id;
  final String userId;
  final String gymId;
  final String gymName;
  final String? gymImageUrl;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final VisitType type;
  final int? pointsEarned;
  final bool wasDeducted; // For visit-based subscriptions
  final String? notes;

  const VisitEntry({
    required this.id,
    required this.userId,
    required this.gymId,
    required this.gymName,
    this.gymImageUrl,
    required this.checkInTime,
    this.checkOutTime,
    required this.type,
    this.pointsEarned,
    this.wasDeducted = false,
    this.notes,
  });

  Duration? get duration {
    if (checkOutTime == null) return null;
    return checkOutTime!.difference(checkInTime);
  }

  bool get isOngoing => checkOutTime == null;
}

/// Visit type enum
enum VisitType {
  regular,
  classAttendance,
  guestPass,
  trialVisit,
}

/// Extension for VisitType
extension VisitTypeX on VisitType {
  String get displayName {
    switch (this) {
      case VisitType.regular:
        return 'Regular Visit';
      case VisitType.classAttendance:
        return 'Class Attendance';
      case VisitType.guestPass:
        return 'Guest Pass';
      case VisitType.trialVisit:
        return 'Trial Visit';
    }
  }

  String get icon {
    switch (this) {
      case VisitType.regular:
        return '🏋️';
      case VisitType.classAttendance:
        return '📚';
      case VisitType.guestPass:
        return '👥';
      case VisitType.trialVisit:
        return '🎫';
    }
  }
}

/// User statistics summary
class UserStats {
  final int totalVisits;
  final int visitsThisMonth;
  final int visitsThisWeek;
  final int currentStreak;
  final int longestStreak;
  final Duration totalDuration;
  final Duration averageDuration;
  final int uniqueGymsVisited;
  final String? favoriteGymId;
  final String? favoriteGymName;
  final Map<String, int> visitsByGym;
  final Map<int, int> visitsByDayOfWeek; // 1-7
  final Map<int, int> visitsByHour; // 0-23

  const UserStats({
    this.totalVisits = 0,
    this.visitsThisMonth = 0,
    this.visitsThisWeek = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalDuration = Duration.zero,
    this.averageDuration = Duration.zero,
    this.uniqueGymsVisited = 0,
    this.favoriteGymId,
    this.favoriteGymName,
    this.visitsByGym = const {},
    this.visitsByDayOfWeek = const {},
    this.visitsByHour = const {},
  });
}

/// Subscription usage tracking
class SubscriptionUsage {
  final String subscriptionId;
  final String bundleName;
  final int totalVisits;
  final int? visitLimit;
  final int usedVisits;
  final int remainingVisits;
  final DateTime startDate;
  final DateTime endDate;
  final int daysRemaining;
  final bool isExpired;
  final bool isUnlimited;

  const SubscriptionUsage({
    required this.subscriptionId,
    required this.bundleName,
    required this.totalVisits,
    this.visitLimit,
    required this.usedVisits,
    required this.remainingVisits,
    required this.startDate,
    required this.endDate,
    required this.daysRemaining,
    required this.isExpired,
    required this.isUnlimited,
  });

  double get usagePercentage {
    if (isUnlimited || visitLimit == null || visitLimit == 0) return 0.0;
    return usedVisits / visitLimit!;
  }
}

/// History filter options
class HistoryFilter {
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? gymId;
  final VisitType? visitType;
  final HistorySortBy sortBy;
  final bool sortAscending;
  final int page;
  final int pageSize;

  const HistoryFilter({
    this.dateFrom,
    this.dateTo,
    this.gymId,
    this.visitType,
    this.sortBy = HistorySortBy.date,
    this.sortAscending = false,
    this.page = 1,
    this.pageSize = 20,
  });

  HistoryFilter copyWith({
    DateTime? dateFrom,
    DateTime? dateTo,
    String? gymId,
    VisitType? visitType,
    HistorySortBy? sortBy,
    bool? sortAscending,
    int? page,
    int? pageSize,
  }) {
    return HistoryFilter(
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      gymId: gymId ?? this.gymId,
      visitType: visitType ?? this.visitType,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

/// Sort options for history
enum HistorySortBy {
  date,
  duration,
  gymName,
}

/// Paginated history response
class PaginatedHistory {
  final List<VisitEntry> visits;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  const PaginatedHistory({
    required this.visits,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
  });
}

/// Monthly summary for charts
class MonthlySummary {
  final int year;
  final int month;
  final int visitCount;
  final Duration totalDuration;
  final int pointsEarned;

  const MonthlySummary({
    required this.year,
    required this.month,
    required this.visitCount,
    required this.totalDuration,
    required this.pointsEarned,
  });

  String get monthName {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}