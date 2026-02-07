import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/admin_subscription.dart';
import '../../domain/repositories/admin_subscriptions_repository.dart';
import '../models/admin_subscription_model.dart';

@LazySingleton(as: AdminSubscriptionsRepository)
@Environment('prod') // للـ Production فقط
class AdminSubscriptionsRepositoryImpl implements AdminSubscriptionsRepository {
  final DioClient _dioClient;
  final NetworkInfo _networkInfo;

  AdminSubscriptionsRepositoryImpl(this._dioClient, this._networkInfo);

  @override
  Future<Either<Failure, PaginatedSubscriptions>> getSubscriptions(
    AdminSubscriptionFilter filter,
  ) async {
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
      if (filter.status != null) queryParams['status'] = filter.status!.name;
      if (filter.tier != null) queryParams['tier'] = filter.tier!.name;
      if (filter.duration != null) queryParams['duration'] = filter.duration!.name;
      if (filter.expiringOnly == true) queryParams['expiring_only'] = true;

      final response = await _dioClient.dio.get(
        '${ApiEndpoints.admin}/subscriptions',
        queryParameters: queryParams,
      );

      final subscriptions = (response.data['data'] as List)
          .map((json) => AdminSubscriptionModel.fromJson(json))
          .toList();

      return Right(PaginatedSubscriptions(
        subscriptions: subscriptions,
        totalCount: response.data['total'] ?? subscriptions.length,
        currentPage: filter.page,
        totalPages: response.data['total_pages'] ?? 1,
        hasMore: response.data['has_more'] ?? false,
      ));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch subscriptions'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminSubscription>> getSubscriptionById(
    String subscriptionId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.get(
        '${ApiEndpoints.admin}/subscriptions/$subscriptionId',
      );
      return Right(AdminSubscriptionModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch subscription'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubscriptionsStats>> getSubscriptionsStats() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.get(
        '${ApiEndpoints.admin}/subscriptions/stats',
      );
      return Right(SubscriptionsStatsModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch stats'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminSubscription>> cancelSubscription(
    String subscriptionId,
    String reason,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.post(
        '${ApiEndpoints.admin}/subscriptions/$subscriptionId/cancel',
        data: {'reason': reason},
      );
      return Right(AdminSubscriptionModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to cancel subscription'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminSubscription>> pauseSubscription(
    String subscriptionId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.post(
        '${ApiEndpoints.admin}/subscriptions/$subscriptionId/pause',
      );
      return Right(AdminSubscriptionModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to pause subscription'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminSubscription>> resumeSubscription(
    String subscriptionId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.post(
        '${ApiEndpoints.admin}/subscriptions/$subscriptionId/resume',
      );
      return Right(AdminSubscriptionModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to resume subscription'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminSubscription>> extendSubscription(
    String subscriptionId,
    int days,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.post(
        '${ApiEndpoints.admin}/subscriptions/$subscriptionId/extend',
        data: {'days': days},
      );
      return Right(AdminSubscriptionModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to extend subscription'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportSubscriptionsToCSV(
    AdminSubscriptionFilter filter,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final queryParams = <String, dynamic>{};
      if (filter.status != null) queryParams['status'] = filter.status!.name;
      if (filter.tier != null) queryParams['tier'] = filter.tier!.name;

      final response = await _dioClient.dio.get(
        '${ApiEndpoints.admin}/subscriptions/export',
        queryParameters: queryParams,
      );
      return Right(response.data['download_url']);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to export'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> sendRenewalReminders(
    List<String> subscriptionIds,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.post(
        '${ApiEndpoints.admin}/subscriptions/send-reminders',
        data: {'subscription_ids': subscriptionIds},
      );
      return Right(response.data['sent_count'] ?? subscriptionIds.length);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to send reminders'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}