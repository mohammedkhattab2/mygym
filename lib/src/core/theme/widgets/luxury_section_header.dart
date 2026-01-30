import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Premium Luxury Section Header - Unified Design System
///
/// A refined, elegant section header that:
/// - Provides clear visual hierarchy
/// - Features a subtle accent bar
/// - Includes optional "See all" action
/// - Maintains consistent styling across all sections
/// - Full Light/Dark mode compliance
/// - NO animations
class LuxurySectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAllTap;
  final String seeAllText;
  final bool showAccentBar;
  final Color? accentColor;

  const LuxurySectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onSeeAllTap,
    this.seeAllText = 'See all',
    this.showAccentBar = true,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    final effectiveAccentColor = accentColor ?? colorScheme.primary;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title section
          Expanded(
            child: Row(
              children: [
                // Accent bar
                if (showAccentBar)
                  Container(
                    width: 3.5.w,
                    height: 24.h,
                    margin: EdgeInsets.only(right: 14.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                                effectiveAccentColor,
                                effectiveAccentColor.withValues(alpha: 0.4),
                              ]
                            : [
                                effectiveAccentColor,
                                effectiveAccentColor.withValues(alpha: 0.6),
                              ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(2.r),
                      boxShadow: !isDark ? [
                        BoxShadow(
                          color: effectiveAccentColor.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ] : null,
                    ),
                  ),
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? colorScheme.onSurface
                              : AppColors.textPrimary,
                          letterSpacing: -0.4,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 3.h),
                        Text(
                          subtitle!,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? colorScheme.onSurface.withValues(alpha: 0.5)
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          // See all action
          if (onSeeAllTap != null)
            GestureDetector(
              onTap: onSeeAllTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 14.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? colorScheme.primary.withValues(alpha: 0.1)
                      : AppColors.primaryLight.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                  border: !isDark ? Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    width: 1,
                  ) : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      seeAllText,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12.sp,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Luxury Section Header with Badge
/// 
/// Extended version with an optional badge indicator
class LuxurySectionHeaderWithBadge extends StatelessWidget {
  final String title;
  final String? badgeText;
  final Color? badgeColor;
  final VoidCallback? onSeeAllTap;

  const LuxurySectionHeaderWithBadge({
    super.key,
    required this.title,
    this.badgeText,
    this.badgeColor,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title with badge
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 3.5.w,
                  height: 24.h,
                  margin: EdgeInsets.only(right: 14.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withValues(alpha: isDark ? 0.4 : 0.6),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(2.r),
                    boxShadow: !isDark ? [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ] : null,
                  ),
                ),
                Flexible(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? colorScheme.onSurface
                          : AppColors.textPrimary,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                if (badgeText != null) ...[
                  SizedBox(width: 12.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: (badgeColor ?? luxury.success).withValues(alpha: isDark ? 0.15 : 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: !isDark ? Border.all(
                        color: (badgeColor ?? luxury.success).withValues(alpha: 0.15),
                        width: 1,
                      ) : null,
                    ),
                    child: Text(
                      badgeText!,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: badgeColor ?? luxury.success,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // See all action
          if (onSeeAllTap != null)
            GestureDetector(
              onTap: onSeeAllTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 14.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? colorScheme.primary.withValues(alpha: 0.1)
                      : AppColors.primaryLight.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                  border: !isDark ? Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    width: 1,
                  ) : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'See all',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12.sp,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}