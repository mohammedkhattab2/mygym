/// Partner gym report data
/// 
/// Contains statistics and reports for gym partners.
class PartnerReport {
  final String gymId;
  final String gymName;
  final DateTime reportDate;
  final ReportPeriod period;
  final VisitSummary visitSummary;
  final RevenueSummary revenueSummary;
  final List<DailyStats> dailyStats;
  final List<PeakHourData> peakHours;
  final UserRetention userRetention;

  const PartnerReport({
    required this.gymId,
    required this.gymName,
    required this.reportDate,
    required this.period,
    required this.visitSummary,
    required this.revenueSummary,
    required this.dailyStats,
    required this.peakHours,
    required this.userRetention,
  });
}

/// Report period enum
enum ReportPeriod {
  daily,
  weekly,
  monthly,
  quarterly,
  yearly,
  custom,
}

/// Visit summary statistics
class VisitSummary {
  final int totalVisits;
  final int uniqueVisitors;
  final double averageVisitsPerUser;
  final int previousPeriodVisits;
  final double growthPercentage;
  final Map<String, int> visitsBySubscriptionType;

  const VisitSummary({
    required this.totalVisits,
    required this.uniqueVisitors,
    required this.averageVisitsPerUser,
    required this.previousPeriodVisits,
    required this.growthPercentage,
    this.visitsBySubscriptionType = const {},
  });

  /// Check if visits increased compared to previous period
  bool get isGrowthPositive => growthPercentage >= 0;
}

/// Revenue summary for the gym
class RevenueSummary {
  final double totalRevenue;
  final double revenueShare; // Gym's share percentage
  final double netRevenue; // After platform fee
  final double previousPeriodRevenue;
  final double growthPercentage;
  final String currency;
  final Map<String, double> revenueByBundle;

  const RevenueSummary({
    required this.totalRevenue,
    required this.revenueShare,
    required this.netRevenue,
    required this.previousPeriodRevenue,
    required this.growthPercentage,
    this.currency = 'EGP',
    this.revenueByBundle = const {},
  });

  String get formattedTotalRevenue => '${totalRevenue.toStringAsFixed(2)} $currency';
  String get formattedNetRevenue => '${netRevenue.toStringAsFixed(2)} $currency';
  bool get isGrowthPositive => growthPercentage >= 0;
}

/// Daily statistics entry
class DailyStats {
  final DateTime date;
  final int visits;
  final double revenue;
  final int newUsers;
  final double averageOccupancy;

  const DailyStats({
    required this.date,
    required this.visits,
    required this.revenue,
    this.newUsers = 0,
    this.averageOccupancy = 0,
  });
}

/// Peak hour data for optimization
class PeakHourData {
  final int hour;
  final int dayOfWeek;
  final double averageVisits;
  final double averageOccupancy;
  final bool isRecommendedPromo;

  const PeakHourData({
    required this.hour,
    required this.dayOfWeek,
    required this.averageVisits,
    required this.averageOccupancy,
    this.isRecommendedPromo = false,
  });

  String get timeLabel {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour $period';
  }

  String get dayLabel {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[dayOfWeek - 1];
  }
}

/// User retention metrics
class UserRetention {
  final int totalActiveUsers;
  final int newUsersThisPeriod;
  final int returningUsers;
  final double retentionRate;
  final double churnRate;
  final Map<int, int> visitFrequencyDistribution; // visits per month -> user count

  const UserRetention({
    required this.totalActiveUsers,
    required this.newUsersThisPeriod,
    required this.returningUsers,
    required this.retentionRate,
    required this.churnRate,
    this.visitFrequencyDistribution = const {},
  });
}

/// Partner gym settings
class PartnerSettings {
  final String gymId;
  final double revenueSharePercentage;
  final int maxDailyVisitsPerUser;
  final int maxWeeklyVisitsPerUser;
  final bool allowNetworkSubscriptions;
  final List<String> blockedUserIds;
  final GymWorkingHours workingHours;
  final bool autoUpdateOccupancy;
  final int maxCapacity;

  const PartnerSettings({
    required this.gymId,
    required this.revenueSharePercentage,
    this.maxDailyVisitsPerUser = 1,
    this.maxWeeklyVisitsPerUser = 7,
    this.allowNetworkSubscriptions = true,
    this.blockedUserIds = const [],
    required this.workingHours,
    this.autoUpdateOccupancy = false,
    required this.maxCapacity,
  });
}

/// Gym working hours configuration
class GymWorkingHours {
  final Map<int, DaySchedule> schedule; // 1-7 (Mon-Sun)

  const GymWorkingHours({required this.schedule});

  DaySchedule? getScheduleForDay(int dayOfWeek) => schedule[dayOfWeek];

  bool isOpenNow() {
    final now = DateTime.now();
    final todaySchedule = schedule[now.weekday];
    if (todaySchedule == null || todaySchedule.isClosed) return false;

    final currentMinutes = now.hour * 60 + now.minute;
    final openMinutes = todaySchedule.openHour * 60 + todaySchedule.openMinute;
    final closeMinutes = todaySchedule.closeHour * 60 + todaySchedule.closeMinute;

    return currentMinutes >= openMinutes && currentMinutes <= closeMinutes;
  }
}

/// Single day schedule
class DaySchedule {
  final int openHour;
  final int openMinute;
  final int closeHour;
  final int closeMinute;
  final bool isClosed;

  const DaySchedule({
    this.openHour = 6,
    this.openMinute = 0,
    this.closeHour = 22,
    this.closeMinute = 0,
    this.isClosed = false,
  });

  factory DaySchedule.closed() => const DaySchedule(isClosed: true);

  String get formattedOpenTime => _formatTime(openHour, openMinute);
  String get formattedCloseTime => _formatTime(closeHour, closeMinute);

  String _formatTime(int hour, int minute) {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');
    return '$displayHour:$displayMinute $period';
  }
}

/// Blocked user entry
class BlockedUser {
  final String visitorId;
  final String visitorName;
  final String? reason;
  final DateTime blockedAt;
  final String? blockedBy;

  const BlockedUser({
    required this.visitorId,
    required this.visitorName,
    this.reason,
    required this.blockedAt,
    this.blockedBy,
  });
}