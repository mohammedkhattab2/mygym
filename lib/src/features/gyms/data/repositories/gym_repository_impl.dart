import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/gym.dart';
import '../../domain/repositories/gym_repository.dart';

/// Implementation of [GymRepository]
@LazySingleton(as: GymRepository)
class GymRepositoryImpl implements GymRepository {
  final DioClient _dioClient;
  final NetworkInfo _networkInfo;
  
  // Local cache for favorites
  final Set<String> _favoriteIds = {};

  GymRepositoryImpl(this._dioClient, this._networkInfo);

  @override
  Future<Either<Failure, List<Gym>>> getGyms({
    required double latitude,
    required double longitude,
    GymFilter? filter,
    int page = 1,
    int limit = 20,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final queryParams = <String, dynamic>{
        'latitude': latitude,
        'longitude': longitude,
        'page': page,
        'limit': limit,
        ...?filter?.toQueryParams(),
      };

      final response = await _dioClient.dio.get(
        ApiEndpoints.gyms,
        queryParameters: queryParams,
      );

      final gyms = (response.data['data'] as List)
          .map((json) => _parseGym(json))
          .toList();

      return Right(gyms);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch gyms'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Gym>> getGymById(String id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.get('${ApiEndpoints.gyms}/$id');
      return Right(_parseGym(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch gym'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Gym>>> searchGyms({
    required String query,
    double? latitude,
    double? longitude,
    int limit = 10,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final queryParams = <String, dynamic>{
        'q': query,
        'limit': limit,
      };
      if (latitude != null) queryParams['latitude'] = latitude;
      if (longitude != null) queryParams['longitude'] = longitude;

      final response = await _dioClient.dio.get(
        '${ApiEndpoints.gyms}/search',
        queryParameters: queryParams,
      );

      final gyms = (response.data['data'] as List)
          .map((json) => _parseGym(json))
          .toList();

      return Right(gyms);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to search gyms'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Gym>>> getNearbyGyms({
    required double latitude,
    required double longitude,
    double radiusKm = 5.0,
    int limit = 10,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.get(
        '${ApiEndpoints.gyms}/nearby',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'radius': radiusKm,
          'limit': limit,
        },
      );

      final gyms = (response.data['data'] as List)
          .map((json) => _parseGym(json))
          .toList();

      return Right(gyms);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch nearby gyms'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Gym>>> getGymsByCity({
    required String cityId,
    GymFilter? filter,
    int page = 1,
    int limit = 20,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final queryParams = <String, dynamic>{
        'city_id': cityId,
        'page': page,
        'limit': limit,
        ...?filter?.toQueryParams(),
      };

      final response = await _dioClient.dio.get(
        ApiEndpoints.gyms,
        queryParameters: queryParams,
      );

      final gyms = (response.data['data'] as List)
          .map((json) => _parseGym(json))
          .toList();

      return Right(gyms);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch gyms by city'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Gym>>> getFavoriteGyms() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.get('${ApiEndpoints.gyms}/favorites');

      final gyms = (response.data['data'] as List)
          .map((json) => _parseGym(json))
          .toList();
      
      // Update local cache
      _favoriteIds.clear();
      for (final gym in gyms) {
        _favoriteIds.add(gym.id);
      }

      return Right(gyms);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch favorite gyms'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToFavorites(String gymId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _dioClient.dio.post('${ApiEndpoints.gyms}/$gymId/favorite');
      _favoriteIds.add(gymId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to add to favorites'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String gymId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _dioClient.dio.delete('${ApiEndpoints.gyms}/$gymId/favorite');
      _favoriteIds.remove(gymId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to remove from favorites'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<bool> isFavorite(String gymId) async {
    return _favoriteIds.contains(gymId);
  }

  @override
  Future<Either<Failure, List<GymReview>>> getGymReviews({
    required String gymId,
    int page = 1,
    int limit = 20,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.get(
        '${ApiEndpoints.gyms}/$gymId/reviews',
        queryParameters: {'page': page, 'limit': limit},
      );

      final reviews = (response.data['data'] as List)
          .map((json) => _parseReview(json))
          .toList();

      return Right(reviews);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch reviews'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GymReview>> submitReview({
    required String gymId,
    required int rating,
    String? comment,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.post(
        '${ApiEndpoints.gyms}/$gymId/reviews',
        data: {
          'rating': rating,
          if (comment != null) 'comment': comment,
        },
      );

      return Right(_parseReview(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to submit review'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CrowdData>> getCrowdData(String gymId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.get('${ApiEndpoints.gyms}/$gymId/crowd');
      return Right(_parseCrowdData(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to get crowd data'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> reportCrowdLevel({
    required String gymId,
    required String level,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _dioClient.dio.post(
        '${ApiEndpoints.gyms}/$gymId/crowd',
        data: {'level': level},
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to report crowd level'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Helper methods for parsing

  Gym _parseGym(Map<String, dynamic> json) {
    return Gym(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      description: json['description'],
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      city: json['city'] ?? '',
      images: (json['images'] as List?)?.cast<String>() ?? [],
      facilities: (json['facilities'] as List?)?.cast<String>() ?? [],
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      crowdLevel: json['crowd_level'],
      currentOccupancy: json['current_occupancy'],
      maxCapacity: json['max_capacity'],
      workingHours: _parseWorkingHours(json['working_hours']),
      isOpen: json['is_open'] ?? false,
      isPartner: json['is_partner'] ?? false,
      partnerSince: json['partner_since'],
      status: _parseGymStatus(json['status']),
      rules: (json['rules'] as List?)?.cast<String>(),
      contactInfo: json['contact_info'] != null 
          ? _parseContactInfo(json['contact_info']) 
          : null,
      distance: json['distance']?.toDouble(),
    );
  }

  WorkingHours _parseWorkingHours(Map<String, dynamic>? json) {
    if (json == null) {
      return const WorkingHours();
    }
    return WorkingHours(
      monday: _parseDayHours(json['monday']),
      tuesday: _parseDayHours(json['tuesday']),
      wednesday: _parseDayHours(json['wednesday']),
      thursday: _parseDayHours(json['thursday']),
      friday: _parseDayHours(json['friday']),
      saturday: _parseDayHours(json['saturday']),
      sunday: _parseDayHours(json['sunday']),
    );
  }

  DayHours? _parseDayHours(Map<String, dynamic>? json) {
    if (json == null) return null;
    if (json['is_closed'] == true) return DayHours.closed();
    
    return DayHours(
      openTime: TimeOfDay(
        hour: json['open_hour'] ?? 0,
        minute: json['open_minute'] ?? 0,
      ),
      closeTime: TimeOfDay(
        hour: json['close_hour'] ?? 0,
        minute: json['close_minute'] ?? 0,
      ),
    );
  }

  GymStatus _parseGymStatus(String? status) {
    switch (status) {
      case 'pending':
        return GymStatus.pending;
      case 'active':
        return GymStatus.active;
      case 'suspended':
        return GymStatus.suspended;
      case 'blocked':
        return GymStatus.blocked;
      default:
        return GymStatus.active;
    }
  }

  ContactInfo _parseContactInfo(Map<String, dynamic> json) {
    return ContactInfo(
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      whatsapp: json['whatsapp'],
      socialMedia: (json['social_media'] as Map<String, dynamic>?)?.cast<String, String>(),
    );
  }

  GymReview _parseReview(Map<String, dynamic> json) {
    return GymReview(
      id: json['id'] ?? '',
      gymId: json['gym_id'] ?? '',
      userId: json['user_id'] ?? '',
      userName: json['user_name'],
      userPhotoUrl: json['user_photo_url'],
      rating: json['rating'] ?? 0,
      comment: json['comment'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      isVerified: json['is_verified'] ?? false,
    );
  }

  CrowdData _parseCrowdData(Map<String, dynamic> json) {
    return CrowdData(
      gymId: json['gym_id'] ?? '',
      currentOccupancy: json['current_occupancy'] ?? 0,
      maxCapacity: json['max_capacity'] ?? 100,
      level: json['level'] ?? 'low',
      lastUpdated: DateTime.tryParse(json['last_updated'] ?? '') ?? DateTime.now(),
      hourlyForecast: (json['hourly_forecast'] as List?)
          ?.map((h) => HourlyOccupancy(
                hour: h['hour'] ?? 0,
                expectedOccupancy: h['expected_occupancy'] ?? 0,
                level: h['level'] ?? 'low',
              ))
          .toList(),
    );
  }
}