import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/admin_gym.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_local_data_source.dart';

/// Mock implementation of [AdminRepository] using local data
/// Used for development when backend is not available
@LazySingleton(as: AdminRepository, env: [Environment.dev])
class AdminRepositoryMock implements AdminRepository {
  final AdminLocalDataSource _localDataSource;

  AdminRepositoryMock(this._localDataSource);

  @override
  Future<Either<Failure, AdminDashboardStats>> getDashboardStats() async {
    try {
      final stats = await _localDataSource.getDashboardStats();
      return Right(stats);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedGyms>> getGyms(AdminGymFilter filter) async {
    try {
      final gyms = await _localDataSource.getGyms(filter);
      return Right(gyms);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminGym>> getGymById(String gymId) async {
    try {
      final gym = await _localDataSource.getGymById(gymId);
      if (gym != null) {
        return Right(gym);
      }
      return const Left(NotFoundFailure('Gym not found'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminGym>> addGym(GymFormData formData) async {
    // Mock implementation - just return a new gym with generated ID
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final newGym = AdminGym(
        id: 'gym_${DateTime.now().millisecondsSinceEpoch}',
        name: formData.name,
        city: formData.city,
        address: formData.address,
        latitude: formData.latitude,
        longitude: formData.longitude,
        status: GymStatus.pending,
        dateAdded: DateTime.now(),
        imageUrls: formData.imageUrls,
        facilities: formData.facilityIds
            .map((id) => AdminFacility(id: id, name: id))
            .toList(),
        customBundles: formData.customBundles,
        settings: formData.settings,
        stats: const AdminGymStats(),
        partnerEmail: formData.partnerEmail,
        partnerPhone: formData.partnerPhone,
        notes: formData.notes,
      );
      return Right(newGym);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminGym>> updateGym(String gymId, GymFormData formData) async {
    try {
      final existingGym = await _localDataSource.getGymById(gymId);
      if (existingGym == null) {
        return const Left(NotFoundFailure('Gym not found'));
      }
      
      await Future.delayed(const Duration(milliseconds: 500));
      final updatedGym = existingGym.copyWith(
        name: formData.name,
        city: formData.city,
        address: formData.address,
        latitude: formData.latitude,
        longitude: formData.longitude,
        imageUrls: formData.imageUrls,
        facilities: formData.facilityIds
            .map((id) => AdminFacility(id: id, name: id))
            .toList(),
        customBundles: formData.customBundles,
        settings: formData.settings,
        partnerEmail: formData.partnerEmail,
        partnerPhone: formData.partnerPhone,
        notes: formData.notes,
        lastUpdated: DateTime.now(),
      );
      return Right(updatedGym);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGym(String gymId) async {
    try {
      final existingGym = await _localDataSource.getGymById(gymId);
      if (existingGym == null) {
        return const Left(NotFoundFailure('Gym not found'));
      }
      await Future.delayed(const Duration(milliseconds: 500));
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminGym>> changeGymStatus(String gymId, GymStatus status) async {
    try {
      final existingGym = await _localDataSource.getGymById(gymId);
      if (existingGym == null) {
        return const Left(NotFoundFailure('Gym not found'));
      }
      
      await Future.delayed(const Duration(milliseconds: 500));
      final updatedGym = existingGym.copyWith(
        status: status,
        lastUpdated: DateTime.now(),
      );
      return Right(updatedGym);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AvailableCity>>> getAvailableCities() async {
    try {
      final cities = await _localDataSource.getAvailableCities();
      return Right(cities);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AvailableFacility>>> getAvailableFacilities() async {
    try {
      final facilities = await _localDataSource.getAvailableFacilities();
      return Right(facilities);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> uploadGymImages(List<String> localPaths) async {
    // Mock implementation - return the same paths as URLs
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      final urls = localPaths
          .map((path) => 'https://picsum.photos/seed/${path.hashCode}/800/600')
          .toList();
      return Right(urls);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GymRevenueReport>> getGymRevenueReport(
    String gymId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final report = await _localDataSource.getGymRevenueReport(gymId, startDate, endDate);
      return Right(report);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportGymsToCSV(AdminGymFilter filter) async {
    // Mock implementation - return a fake download URL
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return const Right('https://example.com/exports/gyms_export.csv');
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> bulkUpdateGymStatus(
    List<String> gymIds,
    GymStatus status,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return Right(gymIds.length);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}

/// NotFoundFailure for when resources are not found
class NotFoundFailure extends Failure {
  const NotFoundFailure(String message) : super(message: message, code: 'NOT_FOUND');
}