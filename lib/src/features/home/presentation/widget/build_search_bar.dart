import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Premium Magical Search Bar - Compact Edition
///
/// Features:
/// - Compact glassmorphism container
/// - Gradient filter button
/// - Full Light/Dark mode compliance
/// - NO animations
class BuildSearchBar extends StatelessWidget {
  const BuildSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: GestureDetector(
        onTap: () => context.push(RoutePaths.search),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isDark ? luxury.surfaceElevated : colorScheme.surface,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isDark
                  ? luxury.gold.withValues(alpha: 0.1)
                  : colorScheme.outline.withValues(alpha: 0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: luxury.textTertiary,
                size: 20.sp,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  "Search gyms, classes...",
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: luxury.textMuted,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: isDark ? luxury.goldGradient : luxury.primaryGradient,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.tune_rounded,
                  color: isDark ? colorScheme.surface : Colors.white,
                  size: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}