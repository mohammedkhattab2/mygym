import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          // Clean gradient background
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xFF161620),
                    const Color(0xFF12121A),
                  ]
                : [
                    colorScheme.surface,
                    colorScheme.surfaceContainerHighest,
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18.r),
          // Clean border
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
          // Simple shadow - no glow
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
              blurRadius: 16,
              offset: const Offset(0, 6),
              spreadRadius: -4,
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
                  SizedBox(height: 6.h),
                  // Address row
                  _buildAddressRow(colorScheme, luxury, isDark),
                  SizedBox(height: 10.h),
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
      width: 58.w,
      height: 58.w,
      decoration: BoxDecoration(
        // Clean gradient background
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF1E1E2A),
                  const Color(0xFF18181F),
                ]
              : [
                  colorScheme.primary.withValues(alpha: 0.12),
                  colorScheme.secondary.withValues(alpha: 0.08),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : colorScheme.primary.withValues(alpha: 0.15),
          width: 1,
        ),
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
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : colorScheme.onSurface,
              letterSpacing: -0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (formattedDistance != null) ...[
          SizedBox(width: 8.w),
          // Distance badge - clean style
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.near_me_rounded,
                  color: colorScheme.primary,
                  size: 11.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  formattedDistance!,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
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
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: isDark ? 0.12 : 0.08),
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Icon(
            Icons.location_on_rounded,
            size: 11.sp,
            color: colorScheme.primary.withValues(alpha: 0.8),
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            address,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.55)
                  : colorScheme.onSurface.withValues(alpha: 0.5),
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
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star_rounded,
                size: 13.sp,
                color: luxury.gold,
              ),
              SizedBox(width: 4.w),
              Text(
                rating.toStringAsFixed(1),
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : colorScheme.onSurface,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                '($reviewCount)',
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.45)
                      : colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
        if (crowdLevel != null) ...[
          SizedBox(width: 10.w),
          // Divider
          Container(
            width: 1,
            height: 14.h,
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : colorScheme.outline.withValues(alpha: 0.12),
          ),
          SizedBox(width: 10.w),
          // Crowd level
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.people_alt_rounded,
                size: 13.sp,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.45)
                    : colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              SizedBox(width: 4.w),
              Text(
                crowdLevel!,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.55)
                      : colorScheme.onSurface.withValues(alpha: 0.5),
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
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: isFavorite
              ? colorScheme.error.withValues(alpha: isDark ? 0.15 : 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          size: 22.sp,
          color: isFavorite
              ? colorScheme.error
              : (isDark
                  ? Colors.white.withValues(alpha: 0.35)
                  : colorScheme.onSurface.withValues(alpha: 0.3)),
        ),
      ),
    );
  }
}