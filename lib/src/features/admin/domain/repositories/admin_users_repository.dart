import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/admin_user.dart';

/// Admin Users Repository Interface
abstract class AdminUsersRepository {
  /// Get paginated list of users with filters
  Future<Either<Failure, PaginatedUsers>> getUsers(AdminUserFilter filter);

  /// Get single user by ID
  Future<Either<Failure, AdminUser>> getUserById(String userId);

  /// Get users statistics
  Future<Either<Failure, UsersStats>> getUsersStats();

  /// Update user status (activate, suspend, block)
  Future<Either<Failure, AdminUser>> updateUserStatus(String userId, UserStatus status);

  /// Update user role
  Future<Either<Failure, AdminUser>> updateUserRole(String userId, UserRole role);

  /// Delete user
  Future<Either<Failure, void>> deleteUser(String userId);

  /// Bulk update user status
  Future<Either<Failure, int>> bulkUpdateStatus(List<String> userIds, UserStatus status);

  /// Export users to CSV
  Future<Either<Failure, String>> exportUsersToCSV(AdminUserFilter filter);

  /// Send notification to user
  Future<Either<Failure, void>> sendNotificationToUser(String userId, String title, String message);

  /// Send bulk notification
  Future<Either<Failure, int>> sendBulkNotification(List<String> userIds, String title, String message);
}