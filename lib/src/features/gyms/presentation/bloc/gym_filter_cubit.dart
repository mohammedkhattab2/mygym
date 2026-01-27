import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/gym.dart';
import 'gym_filter_state.dart';
import 'gyms_bloc.dart';

/// ViewModel for Gym Filter Screen
/// 
/// Manages temporary filter state until user applies or cancels.
/// Communicates with GymsBloc to apply final filter.
@injectable
class GymFilterCubit extends Cubit<GymFilterState> {
  final GymsBloc _gymsBloc;

  GymFilterCubit(this._gymsBloc) : super(const GymFilterState()) {
    _loadCurrentFilter();
  }

  /// Load current filter from GymsBloc
  void _loadCurrentFilter() {
    final currentFilter = _gymsBloc.state.currentFilter;
    emit(GymFilterState.fromGymFilter(currentFilter));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DISTANCE
  // ═══════════════════════════════════════════════════════════════════════════

  void updateMaxDistance(double? distance) {
    emit(state.copyWith(maxDistance: distance));
  }

  void clearMaxDistance() {
    emit(state.copyWith(maxDistance: null));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RATING
  // ═══════════════════════════════════════════════════════════════════════════

  void updateMinRating(double? rating) {
    emit(state.copyWith(minRating: rating != null && rating > 0 ? rating : null));
  }

  void clearMinRating() {
    emit(state.copyWith(minRating: null));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // OPEN NOW
  // ═══════════════════════════════════════════════════════════════════════════

  void toggleOpenNow(bool value) {
    emit(state.copyWith(openNow: value));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CROWD LEVEL
  // ═══════════════════════════════════════════════════════════════════════════

  void updateCrowdLevel(String? level) {
    emit(state.copyWith(crowdLevel: level));
  }

  void clearCrowdLevel() {
    emit(state.copyWith(crowdLevel: null));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SORT BY
  // ═══════════════════════════════════════════════════════════════════════════

  void updateSortBy(String? sortBy) {
    emit(state.copyWith(sortBy: sortBy));
  }

  void clearSortBy() {
    emit(state.copyWith(sortBy: null));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FACILITIES
  // ═══════════════════════════════════════════════════════════════════════════

  void toggleFacility(String facilityId) {
    final currentFacilities = List<String>.from(state.selectedFacilities);
    
    if (currentFacilities.contains(facilityId)) {
      currentFacilities.remove(facilityId);
    } else {
      currentFacilities.add(facilityId);
    }
    
    emit(state.copyWith(selectedFacilities: currentFacilities));
  }

  void clearFacilities() {
    emit(state.copyWith(selectedFacilities: []));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Clear all filters
  void clearAllFilters() {
    emit(const GymFilterState());
  }

  /// Reset to current applied filter
  void resetToCurrentFilter() {
    _loadCurrentFilter();
  }

  /// Apply filter to GymsBloc
  void applyFilter() {
    emit(state.copyWith(isApplying: true));
    
    final filter = state.toGymFilter();
    _gymsBloc.add(GymsEvent.applyFilter(filter));
    
    emit(state.copyWith(isApplying: false));
  }

  /// Clear filters and apply to GymsBloc
  void clearAndApply() {
    emit(const GymFilterState());
    _gymsBloc.add(const GymsEvent.clearFilters());
  }
}