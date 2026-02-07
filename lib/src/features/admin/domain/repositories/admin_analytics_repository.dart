import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/admin_analytics.dart';

abstract class AdminAnalyticsRepository {
  Future<Either<Failure, AnalyticsData>> getAnalyticsData(AnalyticsRange range);
  Future<Either<Failure, AnalyticsOverview>> getOverview(AnalyticsRange range);
  Future<Either<Failure, List<GrowthDataPoint>>> getUserGrowthTrend(AnalyticsRange range);
  Future<Either<Failure, List<GrowthDataPoint>>> getSubscriptionTrend(AnalyticsRange range);
  Future<Either<Failure, List<GrowthDataPoint>>> getVisitsTrend(AnalyticsRange range);
  Future<Either<Failure, List<GeographicData>>> getGeographicData();
  Future<Either<Failure, VisitAnalytics>> getVisitAnalytics(AnalyticsRange range);
  Future<Either<Failure, SubscriptionAnalytics>> getSubscriptionAnalytics(AnalyticsRange range);
  Future<Either<Failure, List<PopularGym>>> getPopularGyms({int limit = 10});
  Future<Either<Failure, EngagementMetrics>> getEngagementMetrics();
  Future<Either<Failure, String>> exportAnalyticsReport(AnalyticsRange range, String format);
}