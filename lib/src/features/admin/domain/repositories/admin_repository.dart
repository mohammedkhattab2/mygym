import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/admin_gym.dart';

/// Admin repository interface
/// Defines the contract for admin-related operations
abstract class AdminRepository {
  /// Get dashboard overview statistics
  Future<Either<Failure, AdminDashboardStats>> getDashboardStats();

  /// Get paginated list of gyms with filters
  Future<Either<Failure, PaginatedGyms>> getGyms(AdminGymFilter filter);

  /// Get single gym by ID
  Future<Either<Failure, AdminGym>> getGymById(String gymId);

  /// Add new gym
  Future<Either<Failure, AdminGym>> addGym(GymFormData formData);

  /// Update existing gym
  Future<Either<Failure, AdminGym>> updateGym(String gymId, GymFormData formData);

  /// Delete gym
  Future<Either<Failure, void>> deleteGym(String gymId);

  /// Change gym status (activate, block, suspend)
  Future<Either<Failure, AdminGym>> changeGymStatus(String gymId, GymStatus status);

  /// Get available cities for dropdown
  Future<Either<Failure, List<AvailableCity>>> getAvailableCities();

  /// Get available facilities for selection
  Future<Either<Failure, List<AvailableFacility>>> getAvailableFacilities();

  /// Upload gym images
  Future<Either<Failure, List<String>>> uploadGymImages(List<String> localPaths);

  /// Get gym revenue report
  Future<Either<Failure, GymRevenueReport>> getGymRevenueReport(
    String gymId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Export gyms data to CSV
  Future<Either<Failure, String>> exportGymsToCSV(AdminGymFilter filter);

  /// Bulk update gym statuses
  Future<Either<Failure, int>> bulkUpdateGymStatus(
    List<String> gymIds,
    GymStatus status,
  );
}

/// Gym revenue report entity
class GymRevenueReport {
  final String gymId;
  final String gymName;
  final DateTime startDate;
  final DateTime endDate;
  final double totalRevenue;
  final double platformShare;
  final double gymShare;
  final int totalVisits;
  final int uniqueVisitors;
  final List<DailyRevenue> dailyBreakdown;
  final List<BundleRevenue> bundleBreakdown;

  const GymRevenueReport({
    required this.gymId,
    required this.gymName,
    required this.startDate,
    required this.endDate,
    required this.totalRevenue,
    required this.platformShare,
    required this.gymShare,
    required this.totalVisits,
    required this.uniqueVisitors,
    this.dailyBreakdown = const [],
    this.bundleBreakdown = const [],
  });
}

/// Daily revenue entry
class DailyRevenue {
  final DateTime date;
  final double revenue;
  final int visits;

  const DailyRevenue({
    required this.date,
    required this.revenue,
    required this.visits,
  });
}

/// Revenue by bundle type
class BundleRevenue {
  final String bundleName;
  final BundleTier tier;
  final double revenue;
  final int subscriptionCount;

  const BundleRevenue({
    required this.bundleName,
    required this.tier,
    required this.revenue,
    required this.subscriptionCount,
  });
}