import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/home/presentation/widget/build_bannar.dart';
import 'package:mygym/src/features/home/presentation/widget/build_explore_gyms.dart';
import 'package:mygym/src/features/home/presentation/widget/build_header.dart';
import 'package:mygym/src/features/home/presentation/widget/build_nearby_gyms.dart';
import 'package:mygym/src/features/home/presentation/widget/build_newly_added_gyms.dart';
import 'package:mygym/src/features/home/presentation/widget/build_popular_classes.dart';
import 'package:mygym/src/features/home/presentation/widget/build_search_bar.dart';
import 'package:mygym/src/features/home/presentation/widget/build_subscription_promo.dart';

/// Premium Clean Home View - Compact Edition
///
/// Features:
/// - Clean background without glow effects
/// - Compact stats row
/// - Optimized spacing
/// - Full Light/Dark mode compliance
/// - NO animations, NO glow
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              const BuildHeader(userName: "Ahmed"),
              SizedBox(height: 12.h),
              const BuildSearchBar(),
              SizedBox(height: 16.h),
              _CompactStatsRow(),
              SizedBox(height: 16.h),
              const BuildBannar(),
              SizedBox(height: 16.h),
              const BuildSubscriptionPromo(),
              SizedBox(height: 20.h),
              const BuildExploreGyms(),
              SizedBox(height: 20.h),
              const BuildNearbyGyms(),
              SizedBox(height: 20.h),
              const BuildNewlyAddedGyms(),
              SizedBox(height: 20.h),
              const BuildPopularClasses(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact Stats Row - Minimal magical design
class _CompactStatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    final colorScheme = context.colorScheme;
    final isDark = context.isDarkMode;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: _MiniStatChip(
              icon: Icons.local_fire_department_rounded,
              value: "12",
              label: "Workouts",
              color: luxury.success,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _MiniStatChip(
              icon: Icons.stars_rounded,
              value: "450",
              label: "Points",
              color: luxury.gold,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _MiniStatChip(
              icon: Icons.fitness_center_rounded,
              value: "3",
              label: "Gyms",
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _MiniStatChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    final colorScheme = context.colorScheme;
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: isDark ? luxury.surfaceElevated : colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withOpacity(isDark ? 0.2 : 0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: color, size: 14.sp),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
                Text(
                  label,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: luxury.textMuted,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
