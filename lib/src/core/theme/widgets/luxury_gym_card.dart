import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Compact Luxury Gym Card - Magical Edition
///
/// A refined, compact gym card featuring:
/// - Clean modern design with subtle elegance
/// - Floating emoji/icon avatar
/// - Elegant info layout
/// - Clean shadows (no glow)
/// - Full Light/Dark mode compliance
/// - NO animations
class LuxuryGymCard extends StatelessWidget {
  final String id;
  final String name;
  final String? imageUrl;
  final String? emoji;
  final String location;
  final double rating;
  final String distance;
  final bool isNew;
  final bool isPremium;
  final VoidCallback? onTap;
  final LuxuryGymCardSize size;

  const LuxuryGymCard({
    super.key,
    required this.id,
    required this.name,
    this.imageUrl,
    this.emoji,
    required this.location,
    required this.rating,
    required this.distance,
    this.isNew = false,
    this.isPremium = false,
    this.onTap,
    this.size = LuxuryGymCardSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    final accentColor = isPremium
        ? luxury.gold
        : (isNew ? luxury.success : colorScheme.primary);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          color: isDark ? luxury.surfaceElevated : colorScheme.surface,
          borderRadius: BorderRadius.circular(size.borderRadius),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : AppColors.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : AppColors.cardShadowLight,
              blurRadius: isDark ? 12 : 16,
              offset: Offset(0, isDark ? 4 : 6),
              spreadRadius: isDark ? 0 : 1,
            ),
            if (!isDark)
              BoxShadow(
                color: AppColors.cardShadowLight.withValues(alpha: 0.5),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top section with emoji/image
            _buildTopSection(colorScheme, luxury, isDark, accentColor),
            // Bottom info section
            _buildInfoSection(colorScheme, luxury, isDark, accentColor),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
    Color accentColor,
  ) {
    return Container(
      height: size.imageHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  accentColor.withValues(alpha: 0.08),
                  accentColor.withValues(alpha: 0.03),
                ]
              : [
                  AppColors.surfaceElevated,
                  accentColor.withValues(alpha: 0.04),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size.borderRadius),
          topRight: Radius.circular(size.borderRadius),
        ),
      ),
      child: Stack(
        children: [
          // Emoji/Icon center
          Center(
            child: emoji != null
                ? Text(emoji!, style: TextStyle(fontSize: size.emojiSize))
                : Icon(
                    Icons.fitness_center_rounded,
                    size: size.emojiSize * 0.6,
                    color: accentColor.withValues(alpha: isDark ? 0.4 : 0.3),
                  ),
          ),
          // Badge row
          Positioned(
            top: 10.h,
            left: 10.w,
            right: 10.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Status badge
                if (isNew || isPremium)
                  _buildBadge(
                    isNew ? 'NEW' : 'PREMIUM',
                    isNew ? luxury.success : luxury.gold,
                    isDark,
                  )
                else
                  const SizedBox.shrink(),
                // Rating badge
                _buildRatingBadge(colorScheme, luxury, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6.r),
        boxShadow: !isDark ? [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildRatingBadge(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.6)
            : Colors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: !isDark ? Border.all(
          color: AppColors.borderLight,
          width: 1,
        ) : null,
        boxShadow: !isDark ? [
          BoxShadow(
            color: AppColors.cardShadowLight,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ] : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 11.sp, color: luxury.gold),
          SizedBox(width: 3.w),
          Text(
            rating.toStringAsFixed(1),
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
    Color accentColor,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.contentPadding,
        vertical: size.contentPadding * 0.8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Gym name
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: size.titleSize,
              fontWeight: FontWeight.w600,
              color: isDark ? colorScheme.onSurface : AppColors.textPrimary,
              height: 1.2,
              letterSpacing: -0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 3.h),
          // Location
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 11.sp,
                color: isDark ? luxury.textMuted : AppColors.textTertiary,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  location,
                  style: GoogleFonts.inter(
                    fontSize: size.subtitleSize,
                    fontWeight: FontWeight.w400,
                    color: isDark ? luxury.textMuted : AppColors.textSecondary,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          // Distance chip
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: isDark ? 0.12 : 0.08),
              borderRadius: BorderRadius.circular(6.r),
              border: !isDark ? Border.all(
                color: accentColor.withValues(alpha: 0.15),
                width: 1,
              ) : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.near_me_rounded, size: 10.sp, color: accentColor),
                SizedBox(width: 4.w),
                Text(
                  distance,
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
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

/// Size variants for the luxury gym card - Compact sizes
enum LuxuryGymCardSize {
  small,
  medium,
  large,
}

extension LuxuryGymCardSizeExtension on LuxuryGymCardSize {
  double get width {
    switch (this) {
      case LuxuryGymCardSize.small:
        return 140.w;
      case LuxuryGymCardSize.medium:
        return 160.w;
      case LuxuryGymCardSize.large:
        return 200.w;
    }
  }

  double get imageHeight {
    switch (this) {
      case LuxuryGymCardSize.small:
        return 70.h;
      case LuxuryGymCardSize.medium:
        return 80.h;
      case LuxuryGymCardSize.large:
        return 100.h;
    }
  }

  double get borderRadius {
    switch (this) {
      case LuxuryGymCardSize.small:
        return 12.r;
      case LuxuryGymCardSize.medium:
        return 14.r;
      case LuxuryGymCardSize.large:
        return 16.r;
    }
  }

  double get contentPadding {
    switch (this) {
      case LuxuryGymCardSize.small:
        return 10.w;
      case LuxuryGymCardSize.medium:
        return 12.w;
      case LuxuryGymCardSize.large:
        return 14.w;
    }
  }

  double get titleSize {
    switch (this) {
      case LuxuryGymCardSize.small:
        return 12.sp;
      case LuxuryGymCardSize.medium:
        return 13.sp;
      case LuxuryGymCardSize.large:
        return 14.sp;
    }
  }

  double get subtitleSize {
    switch (this) {
      case LuxuryGymCardSize.small:
        return 10.sp;
      case LuxuryGymCardSize.medium:
        return 10.sp;
      case LuxuryGymCardSize.large:
        return 11.sp;
    }
  }

  double get emojiSize {
    switch (this) {
      case LuxuryGymCardSize.small:
        return 32.sp;
      case LuxuryGymCardSize.medium:
        return 38.sp;
      case LuxuryGymCardSize.large:
        return 48.sp;
    }
  }
}