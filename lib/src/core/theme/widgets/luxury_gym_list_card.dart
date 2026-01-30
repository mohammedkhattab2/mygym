import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Premium Clean List Card - Luxury Edition
///
/// A modern, clean, luxury gym card for list views featuring:
/// - Clean design without glow effects
/// - Subtle shadows for depth
/// - Premium typography
/// - NO animations, NO glow effects
class LuxuryGymListCard extends StatelessWidget {
  final String id;
  final String name;
  final String address;
  final double rating;
  final int reviewCount;
  final String? formattedDistance;
  final String? crowdLevel;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const LuxuryGymListCard({
    super.key,
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.reviewCount,
    this.formattedDistance,
    this.crowdLevel,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          // Clean surface background
          color: isDark ? luxury.surfaceElevated : colorScheme.surface,
          borderRadius: BorderRadius.circular(18.r),
          // Clean border
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : AppColors.border,
            width: 1,
          ),
          // Elegant shadow for light mode
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : AppColors.cardShadowLight,
              blurRadius: isDark ? 16 : 20,
              offset: Offset(0, isDark ? 6 : 8),
              spreadRadius: isDark ? -4 : 0,
            ),
            if (!isDark)
              BoxShadow(
                color: AppColors.cardShadowLight.withValues(alpha: 0.5),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gym avatar
            _buildGymAvatar(colorScheme, luxury, isDark),
            SizedBox(width: 14.w),
            // Gym info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name row
                  _buildNameRow(colorScheme, luxury, isDark),
                  SizedBox(height: 8.h),
                  // Address row
                  _buildAddressRow(colorScheme, luxury, isDark),
                  SizedBox(height: 12.h),
                  // Info row with rating and crowd
                  _buildInfoRow(colorScheme, luxury, isDark),
                ],
              ),
            ),
            // Favorite button
            if (onFavoriteTap != null)
              _buildFavoriteButton(colorScheme, luxury, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildGymAvatar(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
  ) {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        // Elegant gradient background
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF1E1E2A),
                  const Color(0xFF18181F),
                ]
              : [
                  AppColors.primaryLight.withValues(alpha: 0.15),
                  AppColors.primary.withValues(alpha: 0.08),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : colorScheme.primary.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: !isDark ? [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : "G",
          style: GoogleFonts.inter(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildNameRow(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (formattedDistance != null) ...[
          SizedBox(width: 10.w),
          // Distance badge - elegant style
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(8.r),
              border: !isDark ? Border.all(
                color: colorScheme.primary.withValues(alpha: 0.12),
                width: 1,
              ) : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.near_me_rounded,
                  color: colorScheme.primary,
                  size: 12.sp,
                ),
                SizedBox(width: 5.w),
                Text(
                  formattedDistance!,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAddressRow(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            color: isDark
                ? colorScheme.primary.withValues(alpha: 0.12)
                : AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(6.r),
            border: !isDark ? Border.all(
              color: AppColors.borderLight,
              width: 1,
            ) : null,
          ),
          child: Icon(
            Icons.location_on_rounded,
            size: 12.sp,
            color: isDark
                ? colorScheme.primary.withValues(alpha: 0.8)
                : AppColors.textTertiary,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            address,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.55)
                  : AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
  ) {
    return Row(
      children: [
        // Rating container
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : AppColors.borderLight,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star_rounded,
                size: 14.sp,
                color: luxury.gold,
              ),
              SizedBox(width: 5.w),
              Text(
                rating.toStringAsFixed(1),
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                '($reviewCount)',
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.45)
                      : AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        if (crowdLevel != null) ...[
          SizedBox(width: 12.w),
          // Divider
          Container(
            width: 1,
            height: 16.h,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : AppColors.borderLight,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          SizedBox(width: 12.w),
          // Crowd level
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.people_alt_rounded,
                size: 14.sp,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.45)
                    : AppColors.textTertiary,
              ),
              SizedBox(width: 5.w),
              Text(
                crowdLevel!,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.55)
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildFavoriteButton(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: onFavoriteTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: isFavorite
              ? colorScheme.error.withValues(alpha: isDark ? 0.15 : 0.08)
              : (isDark ? Colors.transparent : AppColors.surfaceElevated),
          borderRadius: BorderRadius.circular(12.r),
          border: !isFavorite && !isDark ? Border.all(
            color: AppColors.borderLight,
            width: 1,
          ) : null,
        ),
        child: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          size: 22.sp,
          color: isFavorite
              ? colorScheme.error
              : (isDark
                  ? Colors.white.withValues(alpha: 0.35)
                  : AppColors.textTertiary),
        ),
      ),
    );
  }
}