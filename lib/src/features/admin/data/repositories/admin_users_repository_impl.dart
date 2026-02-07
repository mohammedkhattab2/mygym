import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/repositories/admin_users_repository.dart';
import '../models/admin_user_model.dart';

@LazySingleton(as: AdminUsersRepository)
class AdminUsersRepositoryImpl implements AdminUsersRepository {
  final DioClient _dioClient;
  final NetworkInfo _networkInfo;

  AdminUsersRepositoryImpl(this._dioClient, this._networkInfo);

  /// Check if we should use mock data (development mode or API unavailable)
  bool get _useMockData => AppConfig.instance.isDebug;

  /// Generate mock users for development
  List<AdminUserModel> _generateMockUsers() {
    final now = DateTime.now();
    return [
      AdminUserModel(
        id: '1',
        name: 'Ahmed Hassan',
        email: 'ahmed.hassan@example.com',
        phone: '+201234567890',
        avatarUrl: null,
        role: UserRole.member,
        status: UserStatus.active,
        subscriptionStatus: UserSubscriptionStatus.active,
        subscriptionTier: 'Premium',
        createdAt: now.subtract(const Duration(days: 120)),
        lastActiveAt: now.subtract(const Duration(hours: 2)),
        totalVisits: 45,
        totalSpent: 1500.0,
        city: 'Cairo',
      ),
      AdminUserModel(
        id: '2',
        name: 'Sara Mohamed',
        email: 'sara.mohamed@example.com',
        phone: '+201098765432',
        avatarUrl: null,
        role: UserRole.member,
        status: UserStatus.active,
        subscriptionStatus: UserSubscriptionStatus.active,
        subscriptionTier: 'Basic',
        createdAt: now.subtract(const Duration(days: 90)),
        lastActiveAt: now.subtract(const Duration(days: 1)),
        totalVisits: 28,
        totalSpent: 800.0,
        city: 'Alexandria',
      ),
      AdminUserModel(
        id: '3',
        name: 'Mohamed Ali',
        email: 'mohamed.ali@example.com',
        phone: '+201112223344',
        avatarUrl: null,
        role: UserRole.partner,
        status: UserStatus.active,
        subscriptionStatus: UserSubscriptionStatus.none,
        subscriptionTier: null,
        createdAt: now.subtract(const Duration(days: 200)),
        lastActiveAt: now.subtract(const Duration(hours: 5)),
        totalVisits: 0,
        totalSpent: 0,
        city: 'Giza',
        linkedGymId: 'gym_001',
      ),
      AdminUserModel(
        id: '4',
        name: 'Fatma Ibrahim',
        email: 'fatma.ibrahim@example.com',
        phone: '+201555666777',
        avatarUrl: null,
        role: UserRole.member,
        status: UserStatus.suspended,
        subscriptionStatus: UserSubscriptionStatus.expired,
        subscriptionTier: 'Premium',
        createdAt: now.subtract(const Duration(days: 60)),
        lastActiveAt: now.subtract(const Duration(days: 15)),
        totalVisits: 12,
        totalSpent: 500.0,
        city: 'Cairo',
      ),
      AdminUserModel(
        id: '5',
        name: 'Omar Khaled',
        email: 'omar.khaled@example.com',
        phone: '+201999888777',
        avatarUrl: null,
        role: UserRole.admin,
        status: UserStatus.active,
        subscriptionStatus: UserSubscriptionStatus.none,
        subscriptionTier: null,
        createdAt: now.subtract(const Duration(days: 365)),
        lastActiveAt: now,
        totalVisits: 0,
        totalSpent: 0,
        city: 'Cairo',
      ),
      AdminUserModel(
        id: '6',
        name: 'Nour Ahmed',
        email: 'nour.ahmed@example.com',
        phone: '+201777888999',
        avatarUrl: null,
        role: UserRole.member,
        status: UserStatus.blocked,
        subscriptionStatus: UserSubscriptionStatus.cancelled,
        subscriptionTier: 'Basic',
        createdAt: now.subtract(const Duration(days: 45)),
        lastActiveAt: now.subtract(const Duration(days: 30)),
        totalVisits: 5,
        totalSpent: 200.0,
        city: 'Mansoura',
      ),
      AdminUserModel(
        id: '7',
        name: 'Youssef Mahmoud',
        email: 'youssef.m@example.com',
        phone: '+201666555444',
        avatarUrl: null,
        role: UserRole.member,
        status: UserStatus.active,
        subscriptionStatus: UserSubscriptionStatus.active,
        subscriptionTier: 'Premium Plus',
        createdAt: now.subtract(const Duration(days: 30)),
        lastActiveAt: now.subtract(const Duration(hours: 12)),
        totalVisits: 22,
        totalSpent: 2500.0,
        city: 'Cairo',
      ),
      AdminUserModel(
        id: '8',
        name: 'Layla Hassan',
        email: 'layla.h@example.com',
        phone: '+201333222111',
        avatarUrl: null,
        role: UserRole.partner,
        status: UserStatus.active,
        subscriptionStatus: UserSubscriptionStatus.none,
        subscriptionTier: null,
        createdAt: now.subtract(const Duration(days: 150)),
        lastActiveAt: now.subtract(const Duration(hours: 1)),
        totalVisits: 0,
        totalSpent: 0,
        city: 'Alexandria',
        linkedGymId: 'gym_002',
      ),
    ];
  }

  /// Generate mock stats
  UsersStatsModel _generateMockStats() {
    return const UsersStatsModel(
      totalUsers: 1250,
      activeUsers: 980,
      suspendedUsers: 45,
      blockedUsers: 25,
      totalMembers: 1180,
      totalPartners: 65,
      totalAdmins: 5,
      usersWithActiveSubscription: 720,
      newUsersThisMonth: 85,
      newUsersThisWeek: 23,
    );
  }

  @override
  Future<Either<Failure, PaginatedUsers>> getUsers(AdminUserFilter filter) async {
    // Use mock data in development mode
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      var users = _generateMockUsers();
      
      // Apply filters
      if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
        final query = filter.searchQuery!.toLowerCase();
        users = users.where((u) =>
          u.name.toLowerCase().contains(query) ||
          u.email.toLowerCase().contains(query)
        ).toList();
      }
      if (filter.role != null) {
        users = users.where((u) => u.role == filter.role).toList();
      }
      if (filter.status != null) {
        users = users.where((u) => u.status == filter.status).toList();
      }
      if (filter.subscriptionStatus != null) {
        users = users.where((u) => u.subscriptionStatus == filter.subscriptionStatus).toList();
      }
      if (filter.city != null) {
        users = users.where((u) => u.city == filter.city).toList();
      }
      
      // Apply sorting
      users.sort((a, b) {
        int comparison;
        switch (filter.sortBy) {
          case AdminUserSortBy.name:
            comparison = a.name.compareTo(b.name);
            break;
          case AdminUserSortBy.email:
            comparison = a.email.compareTo(b.email);
            break;
          case AdminUserSortBy.createdAt:
            comparison = a.createdAt.compareTo(b.createdAt);
            break;
          case AdminUserSortBy.lastActiveAt:
            comparison = (a.lastActiveAt ?? DateTime(1970)).compareTo(b.lastActiveAt ?? DateTime(1970));
            break;
          case AdminUserSortBy.totalVisits:
            comparison = a.totalVisits.compareTo(b.totalVisits);
            break;
          case AdminUserSortBy.totalSpent:
            comparison = a.totalSpent.compareTo(b.totalSpent);
            break;
        }
        return filter.sortAscending ? comparison : -comparison;
      });
      
      // Apply pagination
      final startIndex = (filter.page - 1) * filter.pageSize;
      final endIndex = startIndex + filter.pageSize;
      final paginatedUsers = users.length > startIndex
          ? users.sublist(startIndex, endIndex.clamp(0, users.length))
          : <AdminUserModel>[];
      
      return Right(PaginatedUsers(
        users: paginatedUsers,
        totalCount: users.length,
        currentPage: filter.page,
        totalPages: (users.length / filter.pageSize).ceil(),
        hasMore: endIndex < users.length,
      ));
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final queryParams = <String, dynamic>{
        'page': filter.page,
        'page_size': filter.pageSize,
        'sort_by': filter.sortBy.name,
        'sort_ascending': filter.sortAscending,
      };
      
      if (filter.searchQuery != null) queryParams['search'] = filter.searchQuery;
      if (filter.role != null) queryParams['role'] = filter.role!.name;
      if (filter.status != null) queryParams['status'] = filter.status!.name;
      if (filter.subscriptionStatus != null) {
        queryParams['subscription_status'] = filter.subscriptionStatus!.name;
      }
      if (filter.city != null) queryParams['city'] = filter.city;

      final response = await _dioClient.dio.get(
        '${ApiEndpoints.admin}/users',
        queryParameters: queryParams,
      );

      final users = (response.data['data'] as List)
          .map((json) => AdminUserModel.fromJson(json))
          .toList();

      return Right(PaginatedUsers(
        users: users,
        totalCount: response.data['total'] ?? users.length,
        currentPage: filter.page,
        totalPages: response.data['total_pages'] ?? 1,
        hasMore: response.data['has_more'] ?? false,
      ));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch users'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminUser>> getUserById(String userId) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      final users = _generateMockUsers();
      final user = users.where((u) => u.id == userId).firstOrNull;
      if (user != null) {
        return Right(user);
      }
      return const Left(ServerFailure('User not found'));
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.get(
        '${ApiEndpoints.admin}/users/$userId',
      );
      return Right(AdminUserModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch user'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UsersStats>> getUsersStats() async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      return Right(_generateMockStats());
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.get(
        '${ApiEndpoints.admin}/users/stats',
      );
      return Right(UsersStatsModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch user stats'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminUser>> updateUserStatus(
    String userId,
    UserStatus status,
  ) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      final users = _generateMockUsers();
      final user = users.where((u) => u.id == userId).firstOrNull;
      if (user != null) {
        return Right(user.copyWith(status: status) as AdminUserModel);
      }
      return const Left(ServerFailure('User not found'));
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.patch(
        '${ApiEndpoints.admin}/users/$userId/status',
        data: {'status': status.name},
      );
      return Right(AdminUserModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to update user status'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminUser>> updateUserRole(
    String userId,
    UserRole role,
  ) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      final users = _generateMockUsers();
      final user = users.where((u) => u.id == userId).firstOrNull;
      if (user != null) {
        return Right(user.copyWith(role: role) as AdminUserModel);
      }
      return const Left(ServerFailure('User not found'));
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.patch(
        '${ApiEndpoints.admin}/users/$userId/role',
        data: {'role': role.name},
      );
      return Right(AdminUserModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to update user role'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String userId) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      return const Right(null);
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _dioClient.dio.delete('${ApiEndpoints.admin}/users/$userId');
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to delete user'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> bulkUpdateStatus(
    List<String> userIds,
    UserStatus status,
  ) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return Right(userIds.length);
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.patch(
        '${ApiEndpoints.admin}/users/bulk-status',
        data: {
          'user_ids': userIds,
          'status': status.name,
        },
      );
      return Right(response.data['updated_count'] ?? userIds.length);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to bulk update users'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportUsersToCSV(AdminUserFilter filter) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return const Right('mock://export/users.csv');
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final queryParams = <String, dynamic>{};
      if (filter.role != null) queryParams['role'] = filter.role!.name;
      if (filter.status != null) queryParams['status'] = filter.status!.name;

      final response = await _dioClient.dio.get(
        '${ApiEndpoints.admin}/users/export',
        queryParameters: queryParams,
      );
      return Right(response.data['download_url']);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to export users'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendNotificationToUser(
    String userId,
    String title,
    String message,
  ) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      return const Right(null);
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _dioClient.dio.post(
        '${ApiEndpoints.admin}/users/$userId/notify',
        data: {'title': title, 'message': message},
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to send notification'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> sendBulkNotification(
    List<String> userIds,
    String title,
    String message,
  ) async {
    if (_useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return Right(userIds.length);
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.post(
        '${ApiEndpoints.admin}/users/bulk-notify',
        data: {
          'user_ids': userIds,
          'title': title,
          'message': message,
        },
      );
      return Right(response.data['sent_count'] ?? userIds.length);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to send notifications'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}