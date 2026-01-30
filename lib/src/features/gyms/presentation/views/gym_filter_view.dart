import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/gym.dart';
import '../bloc/gym_filter_cubit.dart';
import '../bloc/gym_filter_state.dart';

/// Gym Filter View - Stateless (follows MVVM)
/// 
/// All state management is handled by GymFilterCubit.
/// This view only renders UI based on state.
class GymFilterView extends StatelessWidget {
  const GymFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GymFilterCubit, GymFilterState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context, state),
          body: _buildBody(context, state),
          bottomNavigationBar: _buildApplyButton(context, state),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // APP BAR
  // ═══════════════════════════════════════════════════════════════════════════

  PreferredSizeWidget _buildAppBar(BuildContext context, GymFilterState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      title: const Text('Filter Gyms'),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => context.pop(),
      ),
      actions: [
        if (state.hasActiveFilters)
          TextButton(
            onPressed: () => context.read<GymFilterCubit>().clearAllFilters(),
            child: Text(
              'Clear All',
              style: TextStyle(color: colorScheme.error),
            ),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BODY
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildBody(BuildContext context, GymFilterState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sort By
          _SectionTitle(title: 'Sort By'),
          const SizedBox(height: 12),
          _SortBySection(
            selectedSort: state.sortBy,
            onSortChanged: (sort) =>
                context.read<GymFilterCubit>().updateSortBy(sort),
          ),
          const SizedBox(height: 24),

          // Distance
          _SectionTitle(title: 'Maximum Distance'),
          const SizedBox(height: 8),
          _DistanceSection(
            maxDistance: state.maxDistance,
            onDistanceChanged: (distance) =>
                context.read<GymFilterCubit>().updateMaxDistance(distance),
            onClear: () =>
                context.read<GymFilterCubit>().clearMaxDistance(),
          ),
          const SizedBox(height: 24),

          // Rating
          _SectionTitle(title: 'Minimum Rating'),
          const SizedBox(height: 8),
          _RatingSection(
            minRating: state.minRating,
            onRatingChanged: (rating) =>
                context.read<GymFilterCubit>().updateMinRating(rating),
            onClear: () =>
                context.read<GymFilterCubit>().clearMinRating(),
          ),
          const SizedBox(height: 24),

          // Open Now
          _SectionTitle(title: 'Availability'),
          const SizedBox(height: 12),
          _OpenNowSection(
            openNow: state.openNow,
            onChanged: (value) =>
                context.read<GymFilterCubit>().toggleOpenNow(value),
          ),
          const SizedBox(height: 24),

          // Crowd Level
          _SectionTitle(title: 'Crowd Level'),
          const SizedBox(height: 12),
          _CrowdLevelSection(
            selectedLevel: state.crowdLevel,
            onLevelChanged: (level) =>
                context.read<GymFilterCubit>().updateCrowdLevel(level),
          ),
          const SizedBox(height: 24),

          // Facilities
          _SectionTitle(title: 'Facilities'),
          const SizedBox(height: 12),
          _FacilitiesSection(
            selectedFacilities: state.selectedFacilities,
            onFacilityToggled: (id) =>
                context.read<GymFilterCubit>().toggleFacility(id),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // APPLY BUTTON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildApplyButton(BuildContext context, GymFilterState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:  0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (state.hasActiveFilters) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${state.activeFilterCount} active',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: FilledButton.icon(
                onPressed: state.isApplying
                    ? null
                    : () {
                        context.read<GymFilterCubit>().applyFilter();
                        context.pop();
                      },
                icon: state.isApplying
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check),
                label: const Text('Apply Filters'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// PRIVATE WIDGETS (Dumb/Presentational Components)
// ═══════════════════════════════════════════════════════════════════════════════

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SORT BY SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _SortBySection extends StatelessWidget {
  final String? selectedSort;
  final ValueChanged<String?> onSortChanged;

  const _SortBySection({
    required this.selectedSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      ('distance', 'Nearest', Icons.near_me),
      ('rating', 'Top Rated', Icons.star),
      ('popularity', 'Popular', Icons.trending_up),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: sortOptions.map((option) {
        final isSelected = selectedSort == option.$1;
        return FilterChip(
          selected: isSelected,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                option.$3,
                size: 18,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(option.$2),
            ],
          ),
          onSelected: (selected) {
            onSortChanged(selected ? option.$1 : null);
          },
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DISTANCE SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _DistanceSection extends StatelessWidget {
  final double? maxDistance;
  final ValueChanged<double?> onDistanceChanged;
  final VoidCallback onClear;

  const _DistanceSection({
    required this.maxDistance,
    required this.onDistanceChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final distance = maxDistance ?? 10.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              maxDistance != null ? '${distance.toStringAsFixed(1)} km' : 'Any',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            if (maxDistance != null)
              TextButton(onPressed: onClear, child: const Text('Clear')),
          ],
        ),
        Slider(
          value: distance,
          min: 0.5,
          max: 20.0,
          divisions: 39,
          label: '${distance.toStringAsFixed(1)} km',
          onChanged: onDistanceChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0.5 km', style: Theme.of(context).textTheme.bodySmall),
            Text('20 km', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RATING SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _RatingSection extends StatelessWidget {
  final double? minRating;
  final ValueChanged<double?> onRatingChanged;
  final VoidCallback onClear;

  const _RatingSection({
    required this.minRating,
    required this.onRatingChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final rating = minRating ?? 0.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 24,
                  );
                }),
                const SizedBox(width: 8),
                Text(
                  minRating != null ? '${rating.toStringAsFixed(1)}+' : 'Any',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            if (minRating != null)
              TextButton(onPressed: onClear, child: const Text('Clear')),
          ],
        ),
        Slider(
          value: rating,
          min: 0.0,
          max: 5.0,
          divisions: 10,
          label: rating.toStringAsFixed(1),
          onChanged: onRatingChanged,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// OPEN NOW SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _OpenNowSection extends StatelessWidget {
  final bool openNow;
  final ValueChanged<bool> onChanged;

  const _OpenNowSection({
    required this.openNow,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SwitchListTile(
        title: const Text('Open Now'),
        subtitle: const Text('Show only gyms currently open'),
        secondary: Icon(
          Icons.access_time,
          color: openNow
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        value: openNow,
        onChanged: onChanged,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CROWD LEVEL SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _CrowdLevelSection extends StatelessWidget {
  final String? selectedLevel;
  final ValueChanged<String?> onLevelChanged;

  const _CrowdLevelSection({
    required this.selectedLevel,
    required this.onLevelChanged,
  });

  @override
  Widget build(BuildContext context) {
    final crowdOptions = [
      ('low', 'Not Busy', Colors.green, Icons.sentiment_satisfied),
      ('medium', 'Moderate', Colors.orange, Icons.sentiment_neutral),
      ('high', 'Crowded', Colors.red, Icons.sentiment_dissatisfied),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: crowdOptions.map((option) {
        final isSelected = selectedLevel == option.$1;
        return FilterChip(
          selected: isSelected,
          selectedColor: option.$3.withValues(alpha:  0.2),
          checkmarkColor: option.$3,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(option.$4, size: 18, color: isSelected ? option.$3 : Colors.grey),
              const SizedBox(width: 6),
              Text(option.$2),
            ],
          ),
          onSelected: (selected) {
            onLevelChanged(selected ? option.$1 : null);
          },
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FACILITIES SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _FacilitiesSection extends StatelessWidget {
  final List<String> selectedFacilities;
  final ValueChanged<String> onFacilityToggled;

  const _FacilitiesSection({
    required this.selectedFacilities,
    required this.onFacilityToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AvailableFacilities.facilities.map((facility) {
        final isSelected = selectedFacilities.contains(facility.id);
        return FilterChip(
          selected: isSelected,
          avatar: _getFacilityIcon(context, facility.id, isSelected),
          label: Text(facility.name),
          onSelected: (_) => onFacilityToggled(facility.id),
        );
      }).toList(),
    );
  }

  Widget _getFacilityIcon(BuildContext context, String facilityId, bool isSelected) {
    final iconMap = {
      'weights': Icons.fitness_center,
      'machines': Icons.precision_manufacturing,
      'cardio': Icons.directions_run,
      'pool': Icons.pool,
      'sauna': Icons.hot_tub,
      'steam': Icons.cloud,
      'jacuzzi': Icons.bathtub,
      'locker': Icons.lock,
      'shower': Icons.shower,
      'parking': Icons.local_parking,
      'wifi': Icons.wifi,
      'trainer': Icons.sports,
      'classes': Icons.groups,
      'cafe': Icons.local_cafe,
      'towel': Icons.dry_cleaning,
      'women': Icons.woman,
    };

    return Icon(
      iconMap[facilityId] ?? Icons.check_circle,
      size: 18,
      color: isSelected
          ? Theme.of(context).colorScheme.onPrimaryContainer
          : Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }
}