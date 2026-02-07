import 'dart:math';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/admin_analytics.dart';
import '../../domain/repositories/admin_analytics_repository.dart';

@LazySingleton(as: AdminAnalyticsRepository)
class MockAdminAnalyticsRepository implements AdminAnalyticsRepository {
  final _random = Random();

  @override
  Future<Either<Failure, AnalyticsData>> getAnalyticsData(AnalyticsRange range) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    try {
      final overview = (await getOverview(range)).getOrElse(() => const AnalyticsOverview());
      final userGrowth = (await getUserGrowthTrend(range)).getOrElse(() => []);
      final subGrowth = (await getSubscriptionTrend(range)).getOrElse(() => []);
      final visits = (await getVisitsTrend(range)).getOrElse(() => []);
      final geo = (await getGeographicData()).getOrElse(() => []);
      final visitAnalytics = (await getVisitAnalytics(range)).getOrElse(() => const VisitAnalytics());
      final subAnalytics = (await getSubscriptionAnalytics(range)).getOrElse(() => const SubscriptionAnalytics());
      final popular = (await getPopularGyms()).getOrElse(() => []);
      final engagement = (await getEngagementMetrics()).getOrElse(() => const EngagementMetrics());

      return Right(AnalyticsData(
        overview: overview,
        userGrowthTrend: userGrowth,
        subscriptionGrowthTrend: subGrowth,
        visitsTrend: visits,
        acquisitionSources: _generateAcquisitionSources(),
        geographicDistribution: geo,
        visitAnalytics: visitAnalytics,
        subscriptionAnalytics: subAnalytics,
        popularGyms: popular,
        engagement: engagement,
      ));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AnalyticsOverview>> getOverview(AnalyticsRange range) async {
    await Future.delayed(const Duration(milliseconds: 400));

    return const Right(AnalyticsOverview(
      totalUsers: 1250,
      newUsersThisPeriod: 85,
      userGrowthPercent: 12.5,
      activeSubscriptions: 342,
      newSubscriptionsThisPeriod: 28,
      subscriptionGrowthPercent: 8.3,
      totalVisits: 15680,
      visitsThisPeriod: 2340,
      visitsGrowthPercent: 15.2,
      totalGyms: 45,
      activeGyms: 42,
      averageRating: 4.3,
      retentionRate: 78.5,
      churnRate: 5.2,
      conversionRate: 32.4,
    ));
  }

  @override
  Future<Either<Failure, List<GrowthDataPoint>>> getUserGrowthTrend(AnalyticsRange range) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(_generateGrowthTrend(range, baseValue: 1100, growthRate: 0.02));
  }

  @override
  Future<Either<Failure, List<GrowthDataPoint>>> getSubscriptionTrend(AnalyticsRange range) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(_generateGrowthTrend(range, baseValue: 280, growthRate: 0.015));
  }

  @override
  Future<Either<Failure, List<GrowthDataPoint>>> getVisitsTrend(AnalyticsRange range) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(_generateGrowthTrend(range, baseValue: 400, growthRate: 0.03, isDaily: true));
  }

  List<GrowthDataPoint> _generateGrowthTrend(AnalyticsRange range, {required int baseValue, required double growthRate, bool isDaily = false}) {
    final now = DateTime.now();
    final points = <GrowthDataPoint>[];
    int cumulative = baseValue;
    
    int dataPoints;
    switch (range) {
      case AnalyticsRange.last7Days:
        dataPoints = 7;
        break;
      case AnalyticsRange.last30Days:
        dataPoints = 30;
        break;
      case AnalyticsRange.last90Days:
        dataPoints = 12; // weeks
        break;
      default:
        dataPoints = 12; // months
    }

    for (int i = dataPoints - 1; i >= 0; i--) {
      final date = range == AnalyticsRange.last7Days || range == AnalyticsRange.last30Days
          ? now.subtract(Duration(days: i))
          : now.subtract(Duration(days: i * (range == AnalyticsRange.last90Days ? 7 : 30)));
      
      final dailyValue = (baseValue * growthRate * (1 + _random.nextDouble() * 0.5)).round();
      cumulative += dailyValue;
      
      String label;
      if (range == AnalyticsRange.last7Days) {
        label = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1];
      } else if (range == AnalyticsRange.last30Days) {
        label = date.day.toString();
      } else {
        label = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][date.month - 1];
      }
      
      points.add(GrowthDataPoint(
        label: label,
        date: date,
        value: isDaily ? dailyValue * 10 : dailyValue,
        cumulativeValue: cumulative,
      ));
    }
    
    return points;
  }

  List<AcquisitionSource> _generateAcquisitionSources() {
    return const [
      AcquisitionSource(source: 'Organic Search', count: 450, percentage: 36, conversionRate: 28.5),
      AcquisitionSource(source: 'Social Media', count: 320, percentage: 25.6, conversionRate: 35.2),
      AcquisitionSource(source: 'Referral', count: 215, percentage: 17.2, conversionRate: 42.8),
      AcquisitionSource(source: 'Paid Ads', count: 165, percentage: 13.2, conversionRate: 22.1),
      AcquisitionSource(source: 'Direct', count: 100, percentage: 8, conversionRate: 18.5),
    ];
  }

  @override
  Future<Either<Failure, List<GeographicData>>> getGeographicData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return const Right([
      GeographicData(city: 'Cairo', usersCount: 580, gymsCount: 18, revenuePercent: 42.5, visitsCount: 6800),
      GeographicData(city: 'Giza', usersCount: 285, gymsCount: 12, revenuePercent: 22.3, visitsCount: 3200),
      GeographicData(city: 'Alexandria', usersCount: 195, gymsCount: 8, revenuePercent: 18.1, visitsCount: 2400),
      GeographicData(city: 'Mansoura', usersCount: 95, gymsCount: 4, revenuePercent: 8.5, visitsCount: 1100),
      GeographicData(city: 'Tanta', usersCount: 55, gymsCount: 2, revenuePercent: 5.2, visitsCount: 650),
      GeographicData(city: 'Other', usersCount: 40, gymsCount: 1, revenuePercent: 3.4, visitsCount: 530),
    ]);
  }

  @override
  Future<Either<Failure, VisitAnalytics>> getVisitAnalytics(AnalyticsRange range) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return const Right(VisitAnalytics(
      visitsByDayOfWeek: {
        'Mon': 2150,
        'Tue': 2380,
        'Wed': 2520,
        'Thu': 2450,
        'Fri': 2100,
        'Sat': 2850,
        'Sun': 1230,
      },
      visitsByHour: {
        '06': 180, '07': 420, '08': 680, '09': 520, '10': 380,
        '11': 290, '12': 250, '13': 320, '14': 380, '15': 450,
        '16': 620, '17': 850, '18': 920, '19': 780, '20': 540,
        '21': 320, '22': 180,
      },
      averageVisitDuration: 72.5,
      peakHour: 18,
      peakDay: 'Saturday',
      averageVisitsPerUser: 4.2,
    ));
  }

  @override
  Future<Either<Failure, SubscriptionAnalytics>> getSubscriptionAnalytics(AnalyticsRange range) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return Right(SubscriptionAnalytics(
      byTier: const {'Basic': 120, 'Plus': 145, 'Premium': 77},
      byDuration: const {'Monthly': 185, 'Quarterly': 98, 'Yearly': 59},
      averageLifetimeValue: 2850,
      averageSubscriptionLength: 4.8,
      churnTrend: _generateChurnTrend(),
      renewalRateByTier: const {'Basic': 62.5, 'Plus': 75.2, 'Premium': 85.8},
    ));
  }

  List<ChurnDataPoint> _generateChurnTrend() {
    final now = DateTime.now();
    return List.generate(6, (i) {
      final date = DateTime(now.year, now.month - 5 + i, 1);
      return ChurnDataPoint(
        label: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][date.month - 1],
        date: date,
        churnRate: 4.5 + _random.nextDouble() * 2,
        churned: 12 + _random.nextInt(8),
        total: 320 + _random.nextInt(30),
      );
    });
  }

  @override
  Future<Either<Failure, List<PopularGym>>> getPopularGyms({int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return const Right([
      PopularGym(id: 'gym_1', name: 'Gold\'s Gym Cairo', city: 'Cairo', visitsCount: 2450, subscribersCount: 85, rating: 4.7, reviewsCount: 124),
      PopularGym(id: 'gym_5', name: 'Wellness Hub Maadi', city: 'Cairo', visitsCount: 1890, subscribersCount: 68, rating: 4.8, reviewsCount: 98),
      PopularGym(id: 'gym_2', name: 'Fitness Plus Giza', city: 'Giza', visitsCount: 1650, subscribersCount: 62, rating: 4.5, reviewsCount: 87),
      PopularGym(id: 'gym_6', name: 'Elite Fitness Alex', city: 'Alexandria', visitsCount: 1320, subscribersCount: 48, rating: 4.4, reviewsCount: 65),
      PopularGym(id: 'gym_7', name: 'PowerZone Downtown', city: 'Cairo', visitsCount: 1180, subscribersCount: 42, rating: 4.3, reviewsCount: 52),
    ]);
  }

  @override
  Future<Either<Failure, EngagementMetrics>> getEngagementMetrics() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return const Right(EngagementMetrics(
      dailyActiveUsers: 245,
      weeklyActiveUsers: 680,
      monthlyActiveUsers: 985,
      dauWauRatio: 36.0,
      dauMauRatio: 24.9,
      averageSessionsPerWeek: 3,
      appOpenRate: 68.5,
    ));
  }

  @override
  Future<Either<Failure, String>> exportAnalyticsReport(AnalyticsRange range, String format) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return Right('https://example.com/exports/analytics_${range.name}_${DateTime.now().millisecondsSinceEpoch}.$format');
  }
}