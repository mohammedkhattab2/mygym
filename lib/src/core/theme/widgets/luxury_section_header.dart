import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final luxury = context.luxury;
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
                    width: 3.w,
                    height: 22.h,
                    margin: EdgeInsets.only(right: 12.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          effectiveAccentColor,
                          effectiveAccentColor.withValues(alpha: 0.4),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(2.r),
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
                          color: colorScheme.onSurface,
                          letterSpacing: -0.3,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 2.h),
                        Text(
                          subtitle!,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
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
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      seeAllText,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? colorScheme.onSurface.withValues(alpha: 0.7)
                            : colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12.sp,
                      color: isDark
                          ? colorScheme.onSurface.withValues(alpha: 0.5)
                          : colorScheme.primary.withValues(alpha: 0.7),
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
          Row(
            children: [
              Container(
                width: 3.w,
                height: 22.h,
                margin: EdgeInsets.only(right: 12.w),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                  letterSpacing: -0.3,
                ),
              ),
              if (badgeText != null) ...[
                SizedBox(width: 10.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: (badgeColor ?? luxury.success).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    badgeText!,
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: badgeColor ?? luxury.success,
                    ),
                  ),
                ),
              ],
            ],
          ),
          // See all action
          if (onSeeAllTap != null)
            GestureDetector(
              onTap: onSeeAllTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'See all',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? colorScheme.onSurface.withValues(alpha: 0.7)
                            : colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12.sp,
                      color: isDark
                          ? colorScheme.onSurface.withValues(alpha: 0.5)
                          : colorScheme.primary.withValues(alpha: 0.7),
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