import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/gym.dart';

/// Repository interface for gym operations
/// 
/// Defines contract for gym data access, including
/// fetching, searching, and filtering gyms.
abstract class GymRepository {
  /// Get list of gyms with optional filters
  /// 
  /// [latitude] and [longitude] are user's current location for distance calculation
  /// [filter] contains optional filter parameters
  Future<Either<Failure, List<Gym>>> getGyms({
    required double latitude,
    required double longitude,
    GymFilter? filter,
    int page = 1,
    int limit = 20,
  });

  /// Get single gym by ID
  Future<Either<Failure, Gym>> getGymById(String id);

  /// Search gyms by name or location
  Future<Either<Failure, List<Gym>>> searchGyms({
    required String query,
    double? latitude,
    double? longitude,
    int limit = 10,
  });

  /// Get nearby gyms within radius
  Future<Either<Failure, List<Gym>>> getNearbyGyms({
    required double latitude,
    required double longitude,
    double radiusKm = 5.0,
    int limit = 10,
  });

  /// Get gyms in a specific city
  Future<Either<Failure, List<Gym>>> getGymsByCity({
    required String cityId,
    GymFilter? filter,
    int page = 1,
    int limit = 20,
  });

  /// Get favorite gyms for current user
  Future<Either<Failure, List<Gym>>> getFavoriteGyms();

  /// Add gym to favorites
  Future<Either<Failure, void>> addToFavorites(String gymId);

  /// Remove gym from favorites
  Future<Either<Failure, void>> removeFromFavorites(String gymId);

  /// Check if gym is in favorites
  Future<bool> isFavorite(String gymId);

  /// Get gym reviews
  Future<Either<Failure, List<GymReview>>> getGymReviews({
    required String gymId,
    int page = 1,
    int limit = 20,
  });

  /// Submit a review for a gym
  Future<Either<Failure, GymReview>> submitReview({
    required String gymId,
    required int rating,
    String? comment,
  });

  /// Get real-time crowd data for a gym
  Future<Either<Failure, CrowdData>> getCrowdData(String gymId);

  /// Report crowd level at a gym (user contribution)
  Future<Either<Failure, void>> reportCrowdLevel({
    required String gymId,
    required String level, // 'low', 'medium', 'high'
  });
}

/// Gym review entity
class GymReview {
  final String id;
  final String gymId;
  final String userId;
  final String? userName;
  final String? userPhotoUrl;
  final int rating;
  final String? comment;
  final DateTime createdAt;
  final bool isVerified; // User has visited this gym

  const GymReview({
    required this.id,
    required this.gymId,
    required this.userId,
    this.userName,
    this.userPhotoUrl,
    required this.rating,
    this.comment,
    required this.createdAt,
    this.isVerified = false,
  });
}

/// Real-time crowd data
class CrowdData {
  final String gymId;
  final int currentOccupancy;
  final int maxCapacity;
  final String level; // 'low', 'medium', 'high'
  final DateTime lastUpdated;
  final List<HourlyOccupancy>? hourlyForecast;

  const CrowdData({
    required this.gymId,
    required this.currentOccupancy,
    required this.maxCapacity,
    required this.level,
    required this.lastUpdated,
    this.hourlyForecast,
  });

  /// Get occupancy percentage
  int get percentage => maxCapacity > 0 
      ? ((currentOccupancy / maxCapacity) * 100).round() 
      : 0;

  /// Check if gym is crowded (> 70%)
  bool get isCrowded => percentage > 70;
}

/// Hourly occupancy forecast
class HourlyOccupancy {
  final int hour; // 0-23
  final int expectedOccupancy;
  final String level;

  const HourlyOccupancy({
    required this.hour,
    required this.expectedOccupancy,
    required this.level,
  });
}