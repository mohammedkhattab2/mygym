import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/admin_gym.dart';
import '../../domain/repositories/admin_repository.dart';

/// Admin dashboard state
class AdminDashboardState {
  final AdminDashboardStats? stats;
  final PaginatedGyms? gyms;
  final AdminGymFilter filter;
  final List<AvailableCity> cities;
  final List<AvailableFacility> facilities;
  final bool isLoadingStats;
  final bool isLoadingGyms;
  final bool isLoadingForm;
  final String? error;
  final String? successMessage;
  final AdminGym? selectedGym;
  final bool isFormOpen;

  const AdminDashboardState({
    this.stats,
    this.gyms,
    this.filter = const AdminGymFilter(),
    this.cities = const [],
    this.facilities = const [],
    this.isLoadingStats = false,
    this.isLoadingGyms = false,
    this.isLoadingForm = false,
    this.error,
    this.successMessage,
    this.selectedGym,
    this.isFormOpen = false,
  });

  AdminDashboardState copyWith({
    AdminDashboardStats? stats,
    PaginatedGyms? gyms,
    AdminGymFilter? filter,
    List<AvailableCity>? cities,
    List<AvailableFacility>? facilities,
    bool? isLoadingStats,
    bool? isLoadingGyms,
    bool? isLoadingForm,
    String? error,
    String? successMessage,
    AdminGym? selectedGym,
    bool? isFormOpen,
  }) {
    return AdminDashboardState(
      stats: stats ?? this.stats,
      gyms: gyms ?? this.gyms,
      filter: filter ?? this.filter,
      cities: cities ?? this.cities,
      facilities: facilities ?? this.facilities,
      isLoadingStats: isLoadingStats ?? this.isLoadingStats,
      isLoadingGyms: isLoadingGyms ?? this.isLoadingGyms,
      isLoadingForm: isLoadingForm ?? this.isLoadingForm,
      error: error,
      successMessage: successMessage,
      selectedGym: selectedGym,
      isFormOpen: isFormOpen ?? this.isFormOpen,
    );
  }
}

/// Admin dashboard cubit
@injectable
class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  final AdminRepository _adminRepository;

  AdminDashboardCubit(this._adminRepository) : super(const AdminDashboardState());

  /// Initialize dashboard - load all data
  Future<void> initialize() async {
    await Future.wait([
      loadDashboardStats(),
      loadGyms(),
      loadCities(),
      loadFacilities(),
    ]);
  }

  /// Load dashboard statistics
  Future<void> loadDashboardStats() async {
    emit(state.copyWith(isLoadingStats: true, error: null));

    final result = await _adminRepository.getDashboardStats();

    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingStats: false,
        error: failure.message,
      )),
      (stats) => emit(state.copyWith(
        isLoadingStats: false,
        stats: stats,
      )),
    );
  }

  /// Load gyms list with current filter
  Future<void> loadGyms() async {
    emit(state.copyWith(isLoadingGyms: true, error: null));

    final result = await _adminRepository.getGyms(state.filter);

    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingGyms: false,
        error: failure.message,
      )),
      (gyms) => emit(state.copyWith(
        isLoadingGyms: false,
        gyms: gyms,
      )),
    );
  }

  /// Load available cities
  Future<void> loadCities() async {
    final result = await _adminRepository.getAvailableCities();

    result.fold(
      (failure) => {}, // Silent fail for dropdown data
      (cities) => emit(state.copyWith(cities: cities)),
    );
  }

  /// Load available facilities
  Future<void> loadFacilities() async {
    final result = await _adminRepository.getAvailableFacilities();

    result.fold(
      (failure) => {}, // Silent fail for dropdown data
      (facilities) => emit(state.copyWith(facilities: facilities)),
    );
  }

  /// Update filter and reload gyms
  void updateFilter(AdminGymFilter filter) {
    emit(state.copyWith(filter: filter));
    loadGyms();
  }

  /// Search gyms by query
  void searchGyms(String query) {
    final newFilter = state.filter.copyWith(
      searchQuery: query.isEmpty ? null : query,
      page: 1,
    );
    updateFilter(newFilter);
  }

  /// Filter by status
  void filterByStatus(GymStatus? status) {
    final newFilter = state.filter.copyWith(status: status, page: 1);
    updateFilter(newFilter);
  }

  /// Filter by city
  void filterByCity(String? city) {
    final newFilter = state.filter.copyWith(city: city, page: 1);
    updateFilter(newFilter);
  }

  /// Sort gyms
  void sortGyms(AdminGymSortBy sortBy, {bool? ascending}) {
    final newFilter = state.filter.copyWith(
      sortBy: sortBy,
      sortAscending: ascending ?? !state.filter.sortAscending,
      page: 1,
    );
    updateFilter(newFilter);
  }

  /// Go to page
  void goToPage(int page) {
    final newFilter = state.filter.copyWith(page: page);
    updateFilter(newFilter);
  }

  /// Change page size
  void changePageSize(int pageSize) {
    final newFilter = state.filter.copyWith(pageSize: pageSize, page: 1);
    updateFilter(newFilter);
  }

  /// Open add gym form
  void openAddGymForm() {
    emit(state.copyWith(selectedGym: null, isFormOpen: true));
  }

  /// Open edit gym form
  void openEditGymForm(AdminGym gym) {
    emit(state.copyWith(selectedGym: gym, isFormOpen: true));
  }

  /// Close form
  void closeForm() {
    emit(state.copyWith(selectedGym: null, isFormOpen: false));
  }

  /// Add new gym
  Future<void> addGym(GymFormData formData) async {
    emit(state.copyWith(isLoadingForm: true, error: null));

    final result = await _adminRepository.addGym(formData);

    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingForm: false,
        error: failure.message,
      )),
      (gym) {
        emit(state.copyWith(
          isLoadingForm: false,
          isFormOpen: false,
          successMessage: 'Gym "${gym.name}" added successfully',
        ));
        loadGyms();
        loadDashboardStats();
      },
    );
  }

  /// Update existing gym
  Future<void> updateGym(String gymId, GymFormData formData) async {
    emit(state.copyWith(isLoadingForm: true, error: null));

    final result = await _adminRepository.updateGym(gymId, formData);

    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingForm: false,
        error: failure.message,
      )),
      (gym) {
        emit(state.copyWith(
          isLoadingForm: false,
          isFormOpen: false,
          successMessage: 'Gym "${gym.name}" updated successfully',
        ));
        loadGyms();
      },
    );
  }

  /// Delete gym
  Future<void> deleteGym(String gymId) async {
    emit(state.copyWith(isLoadingForm: true, error: null));

    final result = await _adminRepository.deleteGym(gymId);

    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingForm: false,
        error: failure.message,
      )),
      (_) {
        emit(state.copyWith(
          isLoadingForm: false,
          successMessage: 'Gym deleted successfully',
        ));
        loadGyms();
        loadDashboardStats();
      },
    );
  }

  /// Change gym status
  Future<void> changeGymStatus(String gymId, GymStatus status) async {
    emit(state.copyWith(isLoadingGyms: true, error: null));

    final result = await _adminRepository.changeGymStatus(gymId, status);

    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingGyms: false,
        error: failure.message,
      )),
      (gym) {
        emit(state.copyWith(
          isLoadingGyms: false,
          successMessage: 'Status changed to ${status.displayName}',
        ));
        loadGyms();
        loadDashboardStats();
      },
    );
  }

  /// Bulk update gym statuses
  Future<void> bulkUpdateStatus(List<String> gymIds, GymStatus status) async {
    emit(state.copyWith(isLoadingGyms: true, error: null));

    final result = await _adminRepository.bulkUpdateGymStatus(gymIds, status);

    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingGyms: false,
        error: failure.message,
      )),
      (count) {
        emit(state.copyWith(
          isLoadingGyms: false,
          successMessage: 'Updated $count gyms to ${status.displayName}',
        ));
        loadGyms();
        loadDashboardStats();
      },
    );
  }

  /// Export gyms to CSV
  Future<void> exportToCSV() async {
    final result = await _adminRepository.exportGymsToCSV(state.filter);

    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (filePath) => emit(state.copyWith(
        successMessage: 'Exported to $filePath',
      )),
    );
  }

  /// Clear messages
  void clearMessages() {
    emit(state.copyWith(error: null, successMessage: null));
  }
}