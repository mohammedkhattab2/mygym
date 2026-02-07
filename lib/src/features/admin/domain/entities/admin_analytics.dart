/// Analytics time range
enum AnalyticsRange {
  last7Days,
  last30Days,
  last90Days,
  last6Months,
  lastYear,
  allTime,
}

extension AnalyticsRangeX on AnalyticsRange {
  String get displayName {
    switch (this) {
      case AnalyticsRange.last7Days: return 'Last 7 Days';
      case AnalyticsRange.last30Days: return 'Last 30 Days';
      case AnalyticsRange.last90Days: return 'Last 90 Days';
      case AnalyticsRange.last6Months: return 'Last 6 Months';
      case AnalyticsRange.lastYear: return 'Last Year';
      case AnalyticsRange.allTime: return 'All Time';
    }
  }

  int get days {
    switch (this) {
      case AnalyticsRange.last7Days: return 7;
      case AnalyticsRange.last30Days: return 30;
      case AnalyticsRange.last90Days: return 90;
      case AnalyticsRange.last6Months: return 180;
      case AnalyticsRange.lastYear: return 365;
      case AnalyticsRange.allTime: return 9999;
    }
  }
}

/// Key metrics overview
class AnalyticsOverview {
  final int totalUsers;
  final int newUsersThisPeriod;
  final double userGrowthPercent;
  final int activeSubscriptions;
  final int newSubscriptionsThisPeriod;
  final double subscriptionGrowthPercent;
  final int totalVisits;
  final int visitsThisPeriod;
  final double visitsGrowthPercent;
  final int totalGyms;
  final int activeGyms;
  final double averageRating;
  final double retentionRate;
  final double churnRate;
  final double conversionRate;

  const AnalyticsOverview({
    this.totalUsers = 0,
    this.newUsersThisPeriod = 0,
    this.userGrowthPercent = 0,
    this.activeSubscriptions = 0,
    this.newSubscriptionsThisPeriod = 0,
    this.subscriptionGrowthPercent = 0,
    this.totalVisits = 0,
    this.visitsThisPeriod = 0,
    this.visitsGrowthPercent = 0,
    this.totalGyms = 0,
    this.activeGyms = 0,
    this.averageRating = 0,
    this.retentionRate = 0,
    this.churnRate = 0,
    this.conversionRate = 0,
  });
}

/// User growth data point
class GrowthDataPoint {
  final String label;
  final DateTime date;
  final int value;
  final int cumulativeValue;

  const GrowthDataPoint({
    required this.label,
    required this.date,
    required this.value,
    required this.cumulativeValue,
  });
}

/// User acquisition source
class AcquisitionSource {
  final String source;
  final int count;
  final double percentage;
  final double conversionRate;

  const AcquisitionSource({
    required this.source,
    required this.count,
    required this.percentage,
    this.conversionRate = 0,
  });
}

/// Geographic distribution
class GeographicData {
  final String city;
  final int usersCount;
  final int gymsCount;
  final double revenuePercent;
  final int visitsCount;

  const GeographicData({
    required this.city,
    required this.usersCount,
    required this.gymsCount,
    required this.revenuePercent,
    required this.visitsCount,
  });
}

/// Visit analytics
class VisitAnalytics {
  final Map<String, int> visitsByDayOfWeek;
  final Map<String, int> visitsByHour;
  final double averageVisitDuration;
  final int peakHour;
  final String peakDay;
  final double averageVisitsPerUser;

  const VisitAnalytics({
    this.visitsByDayOfWeek = const {},
    this.visitsByHour = const {},
    this.averageVisitDuration = 0,
    this.peakHour = 0,
    this.peakDay = '',
    this.averageVisitsPerUser = 0,
  });
}

/// Subscription analytics
class SubscriptionAnalytics {
  final Map<String, int> byTier;
  final Map<String, int> byDuration;
  final double averageLifetimeValue;
  final double averageSubscriptionLength;
  final List<ChurnDataPoint> churnTrend;
  final Map<String, double> renewalRateByTier;

  const SubscriptionAnalytics({
    this.byTier = const {},
    this.byDuration = const {},
    this.averageLifetimeValue = 0,
    this.averageSubscriptionLength = 0,
    this.churnTrend = const [],
    this.renewalRateByTier = const {},
  });
}

/// Churn data point
class ChurnDataPoint {
  final String label;
  final DateTime date;
  final double churnRate;
  final int churned;
  final int total;

  const ChurnDataPoint({
    required this.label,
    required this.date,
    required this.churnRate,
    required this.churned,
    required this.total,
  });
}

/// Popular gym
class PopularGym {
  final String id;
  final String name;
  final String city;
  final int visitsCount;
  final int subscribersCount;
  final double rating;
  final int reviewsCount;

  const PopularGym({
    required this.id,
    required this.name,
    required this.city,
    required this.visitsCount,
    required this.subscribersCount,
    required this.rating,
    required this.reviewsCount,
  });
}

/// User engagement metrics
class EngagementMetrics {
  final double dailyActiveUsers;
  final double weeklyActiveUsers;
  final double monthlyActiveUsers;
  final double dauWauRatio;
  final double dauMauRatio;
  final int averageSessionsPerWeek;
  final double appOpenRate;

  const EngagementMetrics({
    this.dailyActiveUsers = 0,
    this.weeklyActiveUsers = 0,
    this.monthlyActiveUsers = 0,
    this.dauWauRatio = 0,
    this.dauMauRatio = 0,
    this.averageSessionsPerWeek = 0,
    this.appOpenRate = 0,
  });
}

/// Complete analytics data
class AnalyticsData {
  final AnalyticsOverview overview;
  final List<GrowthDataPoint> userGrowthTrend;
  final List<GrowthDataPoint> subscriptionGrowthTrend;
  final List<GrowthDataPoint> visitsTrend;
  final List<AcquisitionSource> acquisitionSources;
  final List<GeographicData> geographicDistribution;
  final VisitAnalytics visitAnalytics;
  final SubscriptionAnalytics subscriptionAnalytics;
  final List<PopularGym> popularGyms;
  final EngagementMetrics engagement;

  const AnalyticsData({
    required this.overview,
    required this.userGrowthTrend,
    required this.subscriptionGrowthTrend,
    required this.visitsTrend,
    required this.acquisitionSources,
    required this.geographicDistribution,
    required this.visitAnalytics,
    required this.subscriptionAnalytics,
    required this.popularGyms,
    required this.engagement,
  });
}