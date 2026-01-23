import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/qr_token.dart';
import '../../domain/repositories/qr_repository.dart';

/// Implementation of [QrRepository]
@LazySingleton(as: QrRepository)
class QrRepositoryImpl implements QrRepository {
  final DioClient _dioClient;
  final NetworkInfo _networkInfo;

  QrRepositoryImpl(this._dioClient, this._networkInfo);

  @override
  Future<Either<Failure, QrToken>> generateToken({String? gymId}) async {
    // Return dummy token for development (no backend available)
    final dummyToken = _generateDummyToken(gymId: gymId);
    return Right(dummyToken);

    // TODO: Uncomment when backend is available
    // if (!await _networkInfo.isConnected) {
    //   return const Left(NetworkFailure());
    // }
    //
    // try {
    //   final response = await _dioClient.dio.post(
    //     ApiEndpoints.generateQR,
    //     data: {
    //       if (gymId != null) 'gym_id': gymId,
    //     },
    //   );
    //
    //   return Right(_parseQrToken(response.data));
    // } on DioException catch (e) {
    //   return Left(ServerFailure(e.message ?? 'Failed to generate QR token'));
    // } catch (e) {
    //   return Left(UnexpectedFailure(e.toString()));
    // }
  }

  /// Generates a dummy QR token for development when no backend is available
  QrToken _generateDummyToken({String? gymId}) {
    final now = DateTime.now();
    final expiresAt = now.add(const Duration(seconds: 60));
    final nonce = 'nonce_${now.millisecondsSinceEpoch}';
    
    return QrToken(
      token: 'dummy_token_${now.millisecondsSinceEpoch}',
      userId: 'demo_user_123',
      gymId: gymId,
      issuedAt: now,
      expiresAt: expiresAt,
      nonce: nonce,
      status: QrTokenStatus.valid,
      remainingVisits: 10,
      subscriptionId: 'sub_demo_001',
    );
  }

  @override
  Future<Either<Failure, CheckInResult>> validateCheckIn({
    required QrToken token,
    required String gymId,
    double? userLatitude,
    double? userLongitude,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.validateQR,
        data: {
          'token': token.token,
          'gym_id': gymId,
          'nonce': token.nonce,
          if (userLatitude != null) 'user_latitude': userLatitude,
          if (userLongitude != null) 'user_longitude': userLongitude,
        },
      );

      return Right(_parseCheckInResult(response.data));
    } on DioException catch (e) {
      // Check for specific error responses
      if (e.response?.data != null) {
        return Right(_parseCheckInResult(e.response!.data));
      }
      return Left(ServerFailure(e.message ?? 'Failed to validate check-in'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VisitEntry>>> getVisitHistory({
    int page = 1,
    int limit = 20,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.visits,
        queryParameters: {'page': page, 'limit': limit},
      );

      final visits = (response.data['data'] as List)
          .map((json) => _parseVisitEntry(json))
          .toList();

      return Right(visits);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch visit history'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VisitEntry>>> getGymVisitHistory({
    required String gymId,
    int page = 1,
    int limit = 20,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.get(
        '${ApiEndpoints.gyms}/$gymId/visits',
        queryParameters: {'page': page, 'limit': limit},
      );

      final visits = (response.data['data'] as List)
          .map((json) => _parseVisitEntry(json))
          .toList();

      return Right(visits);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch gym visit history'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ScannerConfig>> getScannerConfig(String gymId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.get(
        '${ApiEndpoints.qr}/gyms/$gymId/scanner-config',
      );

      return Right(_parseScannerConfig(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch scanner config'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getTodayCheckInCount({required String gymId}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.get(
        '${ApiEndpoints.qr}/gyms/$gymId/today-count',
      );

      return Right(response.data['count'] ?? 0);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch check-in count'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VisitStats>> getVisitStats({
    required String gymId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.visitStats,
        queryParameters: {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        },
      );

      return Right(_parseVisitStats(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch visit stats'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> checkOut({required String visitId}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _dioClient.dio.post('${ApiEndpoints.visits}/$visitId/checkout');
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to check out'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Helper parsing methods

  QrToken _parseQrToken(Map<String, dynamic> json) {
    return QrToken(
      token: json['token'] ?? '',
      userId: json['user_id'] ?? '',
      gymId: json['gym_id'],
      issuedAt: DateTime.tryParse(json['issued_at'] ?? '') ?? DateTime.now(),
      expiresAt: DateTime.tryParse(json['expires_at'] ?? '') ?? 
          DateTime.now().add(const Duration(seconds: 60)),
      nonce: json['nonce'] ?? '',
      status: _parseTokenStatus(json['status']),
      remainingVisits: json['remaining_visits'],
      subscriptionId: json['subscription_id'],
    );
  }

  QrTokenStatus _parseTokenStatus(String? status) {
    switch (status) {
      case 'valid':
        return QrTokenStatus.valid;
      case 'used':
        return QrTokenStatus.used;
      case 'expired':
        return QrTokenStatus.expired;
      case 'invalid':
        return QrTokenStatus.invalid;
      case 'revoked':
        return QrTokenStatus.revoked;
      default:
        return QrTokenStatus.valid;
    }
  }

  CheckInResult _parseCheckInResult(Map<String, dynamic> json) {
    final isAllowed = json['is_allowed'] ?? false;
    final status = _parseCheckInStatus(json['status']);
    
    return CheckInResult(
      isAllowed: isAllowed,
      status: status,
      message: json['message'] ?? status.displayMessage,
      userName: json['user_name'],
      userPhotoUrl: json['user_photo_url'],
      remainingVisits: json['remaining_visits'],
      subscriptionType: json['subscription_type'],
      checkedInAt: json['checked_in_at'] != null 
          ? DateTime.tryParse(json['checked_in_at']) 
          : null,
      rejectionReason: json['rejection_reason'],
    );
  }

  CheckInStatus _parseCheckInStatus(String? status) {
    switch (status) {
      case 'allowed':
        return CheckInStatus.allowed;
      case 'no_active_subscription':
        return CheckInStatus.noActiveSubscription;
      case 'no_remaining_visits':
        return CheckInStatus.noRemainingVisits;
      case 'subscription_expired':
        return CheckInStatus.subscriptionExpired;
      case 'daily_limit_reached':
        return CheckInStatus.dailyLimitReached;
      case 'weekly_limit_reached':
        return CheckInStatus.weeklyLimitReached;
      case 'token_expired':
        return CheckInStatus.tokenExpired;
      case 'token_used':
        return CheckInStatus.tokenUsed;
      case 'token_invalid':
        return CheckInStatus.tokenInvalid;
      case 'gym_not_allowed':
        return CheckInStatus.gymNotAllowed;
      case 'user_blocked':
        return CheckInStatus.userBlocked;
      case 'geofence_violation':
        return CheckInStatus.geofenceViolation;
      default:
        return CheckInStatus.systemError;
    }
  }

  VisitEntry _parseVisitEntry(Map<String, dynamic> json) {
    return VisitEntry(
      id: json['id'] ?? '',
      gymId: json['gym_id'] ?? '',
      gymName: json['gym_name'] ?? '',
      checkInTime: DateTime.tryParse(json['check_in_time'] ?? '') ?? DateTime.now(),
      checkOutTime: json['check_out_time'] != null 
          ? DateTime.tryParse(json['check_out_time']) 
          : null,
      duration: json['duration_minutes'] != null 
          ? Duration(minutes: json['duration_minutes']) 
          : null,
      subscriptionId: json['subscription_id'],
      visitsAfter: json['visits_after'],
    );
  }

  ScannerConfig _parseScannerConfig(Map<String, dynamic> json) {
    return ScannerConfig(
      gymId: json['gym_id'] ?? '',
      gymName: json['gym_name'] ?? '',
      requireGeofence: json['require_geofence'] ?? false,
      geofenceLatitude: json['geofence_latitude']?.toDouble(),
      geofenceLongitude: json['geofence_longitude']?.toDouble(),
      geofenceRadiusMeters: json['geofence_radius_meters']?.toDouble() ?? 100,
      playSoundOnSuccess: json['play_sound_on_success'] ?? true,
      playSoundOnError: json['play_sound_on_error'] ?? true,
      vibrateOnScan: json['vibrate_on_scan'] ?? true,
      autoResetDelaySeconds: json['auto_reset_delay_seconds'] ?? 3,
    );
  }

  VisitStats _parseVisitStats(Map<String, dynamic> json) {
    return VisitStats(
      totalVisits: json['total_visits'] ?? 0,
      uniqueUsers: json['unique_users'] ?? 0,
      visitsByDay: (json['visits_by_day'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v as int)) ?? {},
      visitsByHour: (json['visits_by_hour'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(int.parse(k), v as int)) ?? {},
      averageVisitDuration: (json['average_visit_duration'] ?? 0).toDouble(),
      peakHours: (json['peak_hours'] as List?)
          ?.map((h) => PeakHour(
                hour: h['hour'] ?? 0,
                dayOfWeek: h['day_of_week'] ?? 1,
                averageOccupancy: (h['average_occupancy'] ?? 0).toDouble(),
              ))
          .toList() ?? [],
    );
  }
}