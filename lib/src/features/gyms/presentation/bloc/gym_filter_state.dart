import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/gym.dart';

part 'gym_filter_state.freezed.dart';

@freezed
class GymFilterState with _$GymFilterState {
  const factory GymFilterState({
    @Default(null) double? maxDistance,
    @Default([]) List<String> selectedFacilities,
    @Default(null) double? minRating,
    @Default(false) bool openNow,
    @Default(null) String? crowdLevel,
    @Default(null) String? sortBy,
    @Default(false) bool isApplying,
  }) = _GymFilterState;

  const GymFilterState._();

  /// Check if any filter is active
  bool get hasActiveFilters =>
      maxDistance != null ||
      selectedFacilities.isNotEmpty ||
      minRating != null ||
      openNow ||
      crowdLevel != null ||
      sortBy != null;

  /// Count active filters
  int get activeFilterCount {
    int count = 0;
    if (maxDistance != null) count++;
    if (selectedFacilities.isNotEmpty) count++;
    if (minRating != null) count++;
    if (openNow) count++;
    if (crowdLevel != null) count++;
    if (sortBy != null) count++;
    return count;
  }

  /// Convert state to GymFilter entity
  GymFilter toGymFilter() {
    return GymFilter(
      maxDistance: maxDistance,
      facilities: selectedFacilities.isNotEmpty ? selectedFacilities : null,
      minRating: minRating,
      openNow: openNow ? true : null,
      crowdLevel: crowdLevel,
      sortBy: sortBy,
    );
  }

  /// Create state from existing GymFilter
  factory GymFilterState.fromGymFilter(GymFilter? filter) {
    if (filter == null) return const GymFilterState();
    return GymFilterState(
      maxDistance: filter.maxDistance,
      selectedFacilities: filter.facilities ?? [],
      minRating: filter.minRating,
      openNow: filter.openNow ?? false,
      crowdLevel: filter.crowdLevel,
      sortBy: filter.sortBy,
    );
  }
}