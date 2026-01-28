import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
                : Colors.black.withValues(alpha: 0.04),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  accentColor.withValues(alpha: 0.06),
                  accentColor.withValues(alpha: 0.02),
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
                    color: accentColor.withValues(alpha: 0.4),
                  ),
          ),
          // Badge row
          Positioned(
            top: 8.h,
            left: 8.w,
            right: 8.w,
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
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 8.sp,
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
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.6)
            : Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 10.sp, color: luxury.gold),
          SizedBox(width: 2.w),
          Text(
            rating.toStringAsFixed(1),
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : colorScheme.onSurface,
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
      padding: EdgeInsets.all(size.contentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gym name
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: size.titleSize,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          // Location
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 11.sp,
                color: luxury.textMuted,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  location,
                  style: GoogleFonts.inter(
                    fontSize: size.subtitleSize,
                    fontWeight: FontWeight.w400,
                    color: luxury.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // Distance chip
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: isDark ? 0.12 : 0.08),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.near_me_rounded, size: 10.sp, color: accentColor),
                SizedBox(width: 4.w),
                Text(
                  distance,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
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