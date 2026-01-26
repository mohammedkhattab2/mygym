import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/home/presentation/widget/build_bannar.dart';
import 'package:mygym/src/features/home/presentation/widget/build_explore_gyms.dart';
import 'package:mygym/src/features/home/presentation/widget/build_header.dart';
import 'package:mygym/src/features/home/presentation/widget/build_nearby_gyms.dart';
import 'package:mygym/src/features/home/presentation/widget/build_newly_added_gyms.dart';
import 'package:mygym/src/features/home/presentation/widget/build_popular_classes.dart';
import 'package:mygym/src/features/home/presentation/widget/build_search_bar.dart';

/// Premium Luxury Home View
///
/// Features:
/// - Refined dark mode background with minimal visual noise
/// - Deep, solid premium tones
/// - Clear content focus
/// - Premium gym sections with unified design
/// - Full Light/Dark mode compliance
/// - NO animations (static luxury design)
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          // Refined luxury background - minimal and focused
          color: isDark ? const Color(0xFF0A0A0C) : colorScheme.surface,
          gradient: isDark
              ? const LinearGradient(
                  colors: [
                    Color(0xFF0A0A0C),
                    Color(0xFF0D0D10),
                    Color(0xFF0A0A0C),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.5, 1.0],
                )
              : LinearGradient(
                  colors: [
                    colorScheme.surface,
                    colorScheme.surface.withValues(alpha: 0.98),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BuildHeader(userName: "Ahmed"),
                SizedBox(height: 16.h),
                const BuildSearchBar(),
                SizedBox(height: 24.h),
                const BuildBannar(),
                SizedBox(height: 32.h),
                // Explore Gyms - Large premium cards
                const BuildExploreGyms(),
                SizedBox(height: 32.h),
                // Nearby Gyms - Medium cards
                const BuildNearbyGyms(),
                SizedBox(height: 32.h),
                // Newly Added Gyms - Medium cards with NEW badge
                const BuildNewlyAddedGyms(),
                SizedBox(height: 32.h),
                // Popular Classes
                const BuildPopularClasses(),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
