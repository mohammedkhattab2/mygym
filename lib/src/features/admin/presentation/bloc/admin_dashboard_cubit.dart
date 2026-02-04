import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/admin_gym.dart';
import '../../domain/repositories/admin_repository.dart';

part 'admin_dashboard_cubit.freezed.dart';

@injectable
class AdminCubit extends Cubit<AdminState> {
  final AdminRepository _repository;

  AdminCubit(this._repository) : super(const AdminState.initial());

  // Current filter
  AdminGymFilter _currentFilter = const AdminGymFilter();

  // Cached data
  List<AvailableCity> _cities = [];
  List<AvailableFacility> _facilities = [];

  AdminGymFilter get currentFilter => _currentFilter;
  List<AvailableCity> get cities => _cities;
  List<AvailableFacility> get facilities => _facilities;

  /// Load initial data (dashboard stats + gyms)
  Future<void> loadInitial() async {
    emit(const AdminState.loading());

    final statsResult = await _repository.getDashboardStats();
    final gymsResult = await _repository.getGyms(_currentFilter);

    statsResult.fold(
      (failure) => emit(AdminState.error(failure.message)),
      (stats) {
        gymsResult.fold(
          (failure) => emit(AdminState.error(failure.message)),
          (paginatedGyms) => emit(AdminState.loaded(
            stats: stats,
            gyms: paginatedGyms.gyms,
            totalGyms: paginatedGyms.totalCount,
            currentPage: paginatedGyms.currentPage,
            totalPages: paginatedGyms.totalPages,
            hasMore: paginatedGyms.hasMore,
            filter: _currentFilter,
          )),
        );
      },
    );
  }

  /// Refresh dashboard stats only
  Future<void> refreshStats() async {
    final currentState = state;
    if (currentState is! _Loaded) return;

    final result = await _repository.getDashboardStats();
    result.fold(
      (failure) => null, // Keep current state on error
      (stats) => emit(currentState.copyWith(stats: stats)),
    );
  }

  /// Load gyms with filter
  Future<void> loadGyms({AdminGymFilter? filter}) async {
    final currentState = state;
    if (filter != null) _currentFilter = filter;

    if (currentState is _Loaded) {
      emit(currentState.copyWith(isLoadingMore: true));
    }

    final result = await _repository.getGyms(_currentFilter);

    result.fold(
      (failure) {
        if (currentState is _Loaded) {
          emit(currentState.copyWith(isLoadingMore: false));
        } else {
          emit(AdminState.error(failure.message));
        }
      },
      (paginatedGyms) {
        if (currentState is _Loaded) {
          emit(currentState.copyWith(
            gyms: paginatedGyms.gyms,
            totalGyms: paginatedGyms.totalCount,
            currentPage: paginatedGyms.currentPage,
            totalPages: paginatedGyms.totalPages,
            hasMore: paginatedGyms.hasMore,
            filter: _currentFilter,
            isLoadingMore: false,
          ));
        } else {
          // Need to load stats too
          loadInitial();
        }
      },
    );
  }

  /// Load next page
  Future<void> loadNextPage() async {
    final currentState = state;
    if (currentState is! _Loaded || !currentState.hasMore || currentState.isLoadingMore) {
      return;
    }

    _currentFilter = _currentFilter.copyWith(page: _currentFilter.page + 1);
    emit(currentState.copyWith(isLoadingMore: true));

    final result = await _repository.getGyms(_currentFilter);

    result.fold(
      (failure) => emit(currentState.copyWith(isLoadingMore: false)),
      (paginatedGyms) => emit(currentState.copyWith(
        gyms: [...currentState.gyms, ...paginatedGyms.gyms],
        currentPage: paginatedGyms.currentPage,
        hasMore: paginatedGyms.hasMore,
        isLoadingMore: false,
      )),
    );
  }

  /// Search gyms
  Future<void> searchGyms(String query) async {
    _currentFilter = _currentFilter.copyWith(
      searchQuery: query.isEmpty ? null : query,
      page: 1,
    );
    await loadGyms();
  }

  /// Filter by status
  Future<void> filterByStatus(GymStatus? status) async {
    _currentFilter = _currentFilter.copyWith(status: status, page: 1);
    await loadGyms();
  }

  /// Filter by city
  Future<void> filterByCity(String? city) async {
    _currentFilter = _currentFilter.copyWith(city: city, page: 1);
    await loadGyms();
  }

  /// Sort gyms
  Future<void> sortGyms(AdminGymSortBy sortBy, {bool? ascending}) async {
    final newAscending = ascending ?? 
        (sortBy == _currentFilter.sortBy ? !_currentFilter.sortAscending : false);
    _currentFilter = _currentFilter.copyWith(
      sortBy: sortBy,
      sortAscending: newAscending,
      page: 1,
    );
    await loadGyms();
  }

  /// Change gym status
  Future<bool> changeGymStatus(String gymId, GymStatus status) async {
    final result = await _repository.changeGymStatus(gymId, status);
    return result.fold(
      (failure) => false,
      (updatedGym) {
        final currentState = state;
        if (currentState is _Loaded) {
          final updatedGyms = currentState.gyms.map((g) {
            return g.id == gymId ? updatedGym : g;
          }).toList();
          emit(currentState.copyWith(gyms: updatedGyms));
          refreshStats();
        }
        return true;
      },
    );
  }

  /// Add new gym
  Future<bool> addGym(GymFormData formData) async {
    final result = await _repository.addGym(formData);
    return result.fold(
      (failure) => false,
      (newGym) {
        loadInitial(); // Refresh all data
        return true;
      },
    );
  }

  /// Update gym
  Future<bool> updateGym(String gymId, GymFormData formData) async {
    final result = await _repository.updateGym(gymId, formData);
    return result.fold(
      (failure) => false,
      (updatedGym) {
        final currentState = state;
        if (currentState is _Loaded) {
          final updatedGyms = currentState.gyms.map((g) {
            return g.id == gymId ? updatedGym : g;
          }).toList();
          emit(currentState.copyWith(gyms: updatedGyms));
        }
        return true;
      },
    );
  }

  /// Delete gym
  Future<bool> deleteGym(String gymId) async {
    final result = await _repository.deleteGym(gymId);
    return result.fold(
      (failure) => false,
      (_) {
        final currentState = state;
        if (currentState is _Loaded) {
          final updatedGyms = currentState.gyms.where((g) => g.id != gymId).toList();
          emit(currentState.copyWith(
            gyms: updatedGyms,
            totalGyms: currentState.totalGyms - 1,
          ));
          refreshStats();
        }
        return true;
      },
    );
  }

  /// Bulk update status
  Future<int> bulkUpdateStatus(List<String> gymIds, GymStatus status) async {
    final result = await _repository.bulkUpdateGymStatus(gymIds, status);
    return result.fold(
      (failure) => 0,
      (count) {
        loadInitial(); // Refresh all
        return count;
      },
    );
  }

  /// Load cities and facilities (for form dropdowns)
  Future<void> loadFormData() async {
    if (_cities.isEmpty) {
      final citiesResult = await _repository.getAvailableCities();
      citiesResult.fold(
        (_) => null,
        (cities) => _cities = cities,
      );
    }

    if (_facilities.isEmpty) {
      final facilitiesResult = await _repository.getAvailableFacilities();
      facilitiesResult.fold(
        (_) => null,
        (facilities) => _facilities = facilities,
      );
    }
  }

  /// Export gyms to CSV
  Future<String?> exportToCSV() async {
    final result = await _repository.exportGymsToCSV(_currentFilter);
    return result.fold(
      (failure) => null,
      (url) => url,
    );
  }

  /// Get single gym details
  Future<AdminGym?> getGymDetails(String gymId) async {
    final result = await _repository.getGymById(gymId);
    return result.fold(
      (failure) => null,
      (gym) => gym,
    );
  }

  /// Clear filters
  Future<void> clearFilters() async {
    _currentFilter = const AdminGymFilter();
    await loadGyms();
  }
}

@freezed
class AdminState with _$AdminState {
  const factory AdminState.initial() = AdminInitial;
  
  const factory AdminState.loading() = AdminLoading;
  
  const factory AdminState.loaded({
    required AdminDashboardStats stats,
    required List<AdminGym> gyms,
    required int totalGyms,
    required int currentPage,
    required int totalPages,
    required bool hasMore,
    required AdminGymFilter filter,
    @Default(false) bool isLoadingMore,
    @Default(<String>{}) Set<String> selectedGymIds,
  }) = _Loaded;
  
  const factory AdminState.error(String message) = _Error;
}