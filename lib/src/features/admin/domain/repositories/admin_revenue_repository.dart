import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/admin_revenue.dart';

abstract class AdminRevenueRepository {
  Future<Either<Failure, RevenueData>> getRevenueData(RevenueFilter filter);
  Future<Either<Failure, RevenueOverview>> getRevenueOverview(RevenueFilter filter);
  Future<Either<Failure, List<RevenuePeriodData>>> getChartData(RevenueFilter filter);
  Future<Either<Failure, List<RevenueByGym>>> getRevenueByGym(RevenueFilter filter);
  Future<Either<Failure, List<RevenueTransaction>>> getTransactions(RevenueFilter filter, {int page = 1, int pageSize = 20});
  Future<Either<Failure, List<GymPayout>>> getPendingPayouts();
  Future<Either<Failure, GymPayout>> processGymPayout(String payoutId);
  Future<Either<Failure, String>> exportRevenueReport(RevenueFilter filter, String format);
}