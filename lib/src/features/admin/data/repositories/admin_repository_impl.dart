import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/admin_gym.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_local_data_source.dart';

/// Implementation of [AdminRepository]
/// Uses real API calls in production environment
@LazySingleton(as: AdminRepository, env: [Environment.prod])
class AdminRepositoryImpl implements AdminRepository {
  final DioClient _dioClient;
  final NetworkInfo _networkInfo;
  final AdminLocalDataSource _localDataSource = AdminLocalDataSource();

  AdminRepositoryImpl(this._dioClient, this._networkInfo);

  /// Check if we should use local data (development mode)
  bool get _useLocalData => AppConfig.instance.isDebug;

  @override
  Future<Either<Failure, AdminDashboardStats>> getDashboardStats() async {
    // Use local data in development mode
    if (_useLocalData) {
      try {
        final stats = await _localDataSource.getDashboardStats();
        return Right(stats);
      } catch (e) {
        return Left(UnexpectedFailure(e.toString()));
      }
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.get(ApiEndpoints.adminStats);
      final stats = AdminDashboardStats(
        totalGyms: response.data['total_gyms'] ?? 0,
        activeGyms: response.data['active_gyms'] ?? 0,
        pendingGyms: response.data['pending_gyms'] ?? 0,
        blockedGyms: response.data['blocked_gyms'] ?? 0,
        totalUsers: response.data['total_users'] ?? 0,
        activeSubscriptions: response.data['active_subscriptions'] ?? 0,
        totalRevenue: (response.data['total_revenue'] ?? 0).toDouble(),
        revenueThisMonth: (response.data['revenue_this_month'] ?? 0).toDouble(),
        totalVisitsToday: response.data['total_visits_today'] ?? 0,
        totalVisitsThisWeek: response.data['total_visits_this_week'] ?? 0,
        totalVisitsThisMonth: response.data['total_visits_this_month'] ?? 0,
      );
      return Right(stats);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch dashboard stats'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedGyms>> getGyms(AdminGymFilter filter) async {
    // Use local data in development mode
    if (_useLocalData) {
      try {
        final gyms = await _localDataSource.getGyms(filter);
        return Right(gyms);
      } catch (e) {
        return Left(UnexpectedFailure(e.toString()));
      }
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final queryParams = <String, dynamic>{
        'page': filter.page,
        'page_size': filter.pageSize,
      };
      if (filter.status != null) queryParams['status'] = filter.status!.name;
      if (filter.city != null) queryParams['city'] = filter.city;
      if (filter.searchQuery != null) queryParams['search'] = filter.searchQuery;

      final response = await _dioClient.dio.get(
        ApiEndpoints.adminGyms,
        queryParameters: queryParams,
      );

      final gyms = (response.data['data'] as List)
          .map((json) => _parseAdminGym(json))
          .toList();

      return Right(PaginatedGyms(
        gyms: gyms,
        totalCount: response.data['total'] ?? gyms.length,
        currentPage: filter.page,
        totalPages: response.data['total_pages'] ?? 1,
        hasMore: response.data['has_more'] ?? false,
      ));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch gyms'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminGym>> getGymById(String gymId) async {
    // Use local data in development mode
    if (_useLocalData) {
      try {
        final gym = await _localDataSource.getGymById(gymId);
        if (gym != null) {
          return Right(gym);
        }
        return const Left(ServerFailure('Gym not found'));
      } catch (e) {
        return Left(UnexpectedFailure(e.toString()));
      }
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.get('${ApiEndpoints.adminGyms}/$gymId');
      return Right(_parseAdminGym(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch gym'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminGym>> addGym(GymFormData formData) async {
    // Use local data in development mode
    if (_useLocalData) {
      try {
        final gym = await _localDataSource.addGym(formData);
        return Right(gym);
      } catch (e) {
        return Left(UnexpectedFailure(e.toString()));
      }
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.adminAddGym,
        data: _formDataToJson(formData),
      );
      return Right(_parseAdminGym(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to add gym'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminGym>> updateGym(String gymId, GymFormData formData) async {
    // Use local data in development mode
    if (_useLocalData) {
      try {
        final gym = await _localDataSource.updateGym(gymId, formData);
        if (gym != null) {
          return Right(gym);
        }
        return const Left(ServerFailure('Gym not found'));
      } catch (e) {
        return Left(UnexpectedFailure(e.toString()));
      }
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.put(
        '${ApiEndpoints.adminGyms}/$gymId',
        data: _formDataToJson(formData),
      );
      return Right(_parseAdminGym(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to update gym'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGym(String gymId) async {
    // Use local data in development mode
    if (_useLocalData) {
      try {
        final success = await _localDataSource.deleteGym(gymId);
        if (success) {
          return const Right(null);
        }
        return const Left(ServerFailure('Gym not found'));
      } catch (e) {
        return Left(UnexpectedFailure(e.toString()));
      }
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _dioClient.dio.delete('${ApiEndpoints.adminGyms}/$gymId');
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to delete gym'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminGym>> changeGymStatus(String gymId, GymStatus status) async {
    // Use local data in development mode
    if (_useLocalData) {
      try {
        final gym = await _localDataSource.changeGymStatus(gymId, status);
        if (gym != null) {
          return Right(gym);
        }
        return const Left(ServerFailure('Gym not found'));
      } catch (e) {
        return Left(UnexpectedFailure(e.toString()));
      }
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.patch(
        '${ApiEndpoints.adminGyms}/$gymId/status',
        data: {'status': status.name},
      );
      return Right(_parseAdminGym(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to change gym status'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AvailableCity>>> getAvailableCities() async {
    // Use local data in development mode
    if (_useLocalData) {
      try {
        final cities = await _localDataSource.getAvailableCities();
        return Right(cities);
      } catch (e) {
        return Left(UnexpectedFailure(e.toString()));
      }
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.get('${ApiEndpoints.admin}/cities');
      final cities = (response.data as List)
          .map((json) => AvailableCity(
                id: json['id'],
                name: json['name'],
                country: json['country'] ?? 'Egypt',
              ))
          .toList();
      return Right(cities);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch cities'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AvailableFacility>>> getAvailableFacilities() async {
    // Use local data in development mode
    if (_useLocalData) {
      try {
        final facilities = await _localDataSource.getAvailableFacilities();
        return Right(facilities);
      } catch (e) {
        return Left(UnexpectedFailure(e.toString()));
      }
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.get('${ApiEndpoints.admin}/facilities');
      final facilities = (response.data as List)
          .map((json) => AvailableFacility(
                id: json['id'],
                name: json['name'],
                icon: json['icon'],
                category: json['category'] ?? 'General',
              ))
          .toList();
      return Right(facilities);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch facilities'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> uploadGymImages(List<String> localPaths) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final formData = FormData();
      for (final path in localPaths) {
        formData.files.add(MapEntry(
          'images',
          await MultipartFile.fromFile(path),
        ));
      }

      final response = await _dioClient.dio.post(
        '${ApiEndpoints.admin}/upload-images',
        data: formData,
      );

      final urls = (response.data['urls'] as List).cast<String>();
      return Right(urls);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to upload images'));
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
    // Use local data in development mode
    if (_useLocalData) {
      try {
        final report = await _localDataSource.getGymRevenueReport(gymId, startDate, endDate);
        return Right(report);
      } catch (e) {
        return Left(UnexpectedFailure(e.toString()));
      }
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.get(
        '${ApiEndpoints.adminGyms}/$gymId/revenue',
        queryParameters: {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        },
      );

      final report = GymRevenueReport(
        gymId: gymId,
        gymName: response.data['gym_name'],
        startDate: startDate,
        endDate: endDate,
        totalRevenue: (response.data['total_revenue'] ?? 0).toDouble(),
        platformShare: (response.data['platform_share'] ?? 0).toDouble(),
        gymShare: (response.data['gym_share'] ?? 0).toDouble(),
        totalVisits: response.data['total_visits'] ?? 0,
        uniqueVisitors: response.data['unique_visitors'] ?? 0,
      );
      return Right(report);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch revenue report'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportGymsToCSV(AdminGymFilter filter) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.get(
        '${ApiEndpoints.adminGyms}/export',
        queryParameters: {
          if (filter.status != null) 'status': filter.status!.name,
          if (filter.city != null) 'city': filter.city,
        },
      );
      return Right(response.data['download_url']);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to export gyms'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> bulkUpdateGymStatus(
    List<String> gymIds,
    GymStatus status,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _dioClient.dio.patch(
        '${ApiEndpoints.adminGyms}/bulk-status',
        data: {
          'gym_ids': gymIds,
          'status': status.name,
        },
      );
      return Right(response.data['updated_count'] ?? gymIds.length);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to bulk update gyms'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  AdminGym _parseAdminGym(Map<String, dynamic> json) {
    // Parse facilities
    final facilitiesList = <AdminFacility>[];
    if (json['facilities'] != null) {
      for (final f in json['facilities']) {
        if (f is Map<String, dynamic>) {
          facilitiesList.add(AdminFacility(
            id: f['id'] ?? '',
            name: f['name'] ?? '',
            icon: f['icon'],
            isAvailable: f['is_available'] ?? true,
          ));
        } else if (f is String) {
          facilitiesList.add(AdminFacility(id: f, name: f));
        }
      }
    }

    // Parse working hours
    final workingHoursList = <WorkingHoursEntry>[];
    if (json['working_hours'] != null && json['working_hours'] is List) {
      for (final wh in json['working_hours']) {
        workingHoursList.add(WorkingHoursEntry(
          dayOfWeek: wh['day_of_week'] ?? 1,
          openTime: wh['open_time'] ?? '06:00',
          closeTime: wh['close_time'] ?? '22:00',
          isClosed: wh['is_closed'] ?? false,
        ));
      }
    }

    // Parse bundles
    final bundlesList = <AdminBundle>[];
    if (json['custom_bundles'] != null) {
      for (final b in json['custom_bundles']) {
        bundlesList.add(AdminBundle(
          id: b['id'] ?? '',
          name: b['name'] ?? '',
          tier: BundleTier.values.firstWhere(
            (t) => t.name == b['tier'],
            orElse: () => BundleTier.basic,
          ),
          duration: BundleDuration.values.firstWhere(
            (d) => d.name == b['duration'],
            orElse: () => BundleDuration.monthly,
          ),
          price: (b['price'] ?? 0).toDouble(),
          visitLimit: b['visit_limit'],
          features: (b['features'] as List?)?.cast<String>() ?? [],
          isActive: b['is_active'] ?? true,
        ));
      }
    }

    return AdminGym(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      status: GymStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => GymStatus.pending,
      ),
      dateAdded: DateTime.tryParse(json['date_added'] ?? json['created_at'] ?? '') ?? DateTime.now(),
      lastUpdated: DateTime.tryParse(json['last_updated'] ?? json['updated_at'] ?? ''),
      imageUrls: (json['image_urls'] as List?)?.cast<String>() ?? [],
      facilities: facilitiesList,
      customBundles: bundlesList,
      settings: AdminGymSettings(
        dailyVisitLimit: json['settings']?['daily_visit_limit'] ?? 1,
        weeklyVisitLimit: json['settings']?['weekly_visit_limit'] ?? 7,
        revenueSharePercent: (json['settings']?['revenue_share_percent'] ?? 70).toDouble(),
        workingHours: workingHoursList,
        allowGuestCheckIn: json['settings']?['allow_guest_check_in'] ?? false,
        maxConcurrentVisitors: json['settings']?['max_concurrent_visitors'] ?? 100,
        requiresGeofence: json['settings']?['requires_geofence'] ?? false,
        geofenceRadius: json['settings']?['geofence_radius']?.toDouble(),
      ),
      stats: AdminGymStats(
        totalVisits: json['stats']?['total_visits'] ?? 0,
        visitsThisMonth: json['stats']?['visits_this_month'] ?? 0,
        activeSubscribers: json['stats']?['active_subscribers'] ?? 0,
        totalRevenue: (json['stats']?['total_revenue'] ?? 0).toDouble(),
        revenueThisMonth: (json['stats']?['revenue_this_month'] ?? 0).toDouble(),
        averageRating: (json['stats']?['average_rating'] ?? 0).toDouble(),
        totalReviews: json['stats']?['total_reviews'] ?? 0,
      ),
      partnerEmail: json['partner_email'],
      partnerPhone: json['partner_phone'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> _formDataToJson(GymFormData formData) {
    return {
      'name': formData.name,
      'city': formData.city,
      'address': formData.address,
      'latitude': formData.latitude,
      'longitude': formData.longitude,
      'image_urls': formData.imageUrls,
      'facility_ids': formData.facilityIds,
      'custom_bundles': formData.customBundles.map((b) => {
        'id': b.id,
        'name': b.name,
        'tier': b.tier.name,
        'duration': b.duration.name,
        'price': b.price,
        'visit_limit': b.visitLimit,
        'features': b.features,
        'is_active': b.isActive,
      }).toList(),
      'settings': {
        'daily_visit_limit': formData.settings.dailyVisitLimit,
        'weekly_visit_limit': formData.settings.weeklyVisitLimit,
        'revenue_share_percent': formData.settings.revenueSharePercent,
        'working_hours': formData.settings.workingHours.map((wh) => {
          'day_of_week': wh.dayOfWeek,
          'open_time': wh.openTime,
          'close_time': wh.closeTime,
          'is_closed': wh.isClosed,
        }).toList(),
        'allow_guest_check_in': formData.settings.allowGuestCheckIn,
        'max_concurrent_visitors': formData.settings.maxConcurrentVisitors,
        'requires_geofence': formData.settings.requiresGeofence,
        'geofence_radius': formData.settings.geofenceRadius,
      },
      if (formData.partnerEmail != null) 'partner_email': formData.partnerEmail,
      if (formData.partnerPhone != null) 'partner_phone': formData.partnerPhone,
      if (formData.notes != null) 'notes': formData.notes,
    };
  }
}