import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Premium Clean Gym Card - Luxury Edition
///
/// A modern, clean, luxury gym card featuring:
/// - Full-bleed cinematic imagery with sophisticated overlays
/// - Floating logo avatar
/// - Clean rating badge
/// - Subtle depth through shadows (no glow)
/// - Elegant floating info panel
/// - NO animations, NO glow effects
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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width,
        height: size.totalHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size.borderRadius),
          // Clean shadow system - no glow
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: -4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size.borderRadius),
          child: Stack(
            children: [
              // Layer 1: Clean background
              _buildCleanBackground(colorScheme, luxury, isDark),
              
              // Layer 2: Gradient overlay
              _buildGradientOverlay(colorScheme, luxury, isDark),
              
              // Layer 3: Clean border
              _buildCleanBorder(colorScheme, luxury, isDark),
              
              // Layer 4: Content
              _buildContent(colorScheme, luxury, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCleanBackground(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
  ) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          // Clean gradient background
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xFF12121A),
                    const Color(0xFF1A1A24),
                    const Color(0xFF12121A),
                  ]
                : [
                    colorScheme.surface,
                    colorScheme.surfaceContainerHighest,
                    colorScheme.surface,
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 50.h),
            child: emoji != null
                ? Text(
                    emoji!,
                    style: TextStyle(fontSize: size.emojiSize),
                  )
                : Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.1),
                    ),
                    child: Icon(
                      Icons.fitness_center_rounded,
                      size: 30.sp,
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientOverlay(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
  ) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.transparent,
              (isDark ? const Color(0xFF0A0A0E) : colorScheme.surface)
                  .withValues(alpha: 0.6),
              (isDark ? const Color(0xFF0A0A0E) : colorScheme.surface)
                  .withValues(alpha: 0.95),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.3, 0.6, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildCleanBorder(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
  ) {
    final borderColor = isPremium
        ? luxury.gold
        : (isNew ? luxury.success : colorScheme.primary);

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size.borderRadius),
          border: Border.all(
            width: isPremium || isNew ? 1.5 : 1,
            color: borderColor.withValues(alpha: isDark ? 0.3 : 0.2),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
  ) {
    return Column(
      children: [
        // Top badges row
        Padding(
          padding: EdgeInsets.all(size.contentPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status badge (NEW or PREMIUM)
              if (isNew)
                _buildStatusBadge('NEW', luxury.success, colorScheme, luxury, isDark)
              else if (isPremium)
                _buildStatusBadge('PREMIUM', luxury.gold, colorScheme, luxury, isDark)
              else
                const SizedBox.shrink(),
              const Spacer(),
              // Rating badge
              _buildRatingBadge(colorScheme, luxury, isDark),
            ],
          ),
        ),
        
        const Spacer(),
        
        // Bottom info panel
        _buildInfoPanel(colorScheme, luxury, isDark),
      ],
    );
  }

  Widget _buildStatusBadge(
    String text,
    Color color,
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            text == 'NEW' ? Icons.auto_awesome_rounded : Icons.workspace_premium_rounded,
            size: 11.sp,
            color: Colors.white,
          ),
          SizedBox(width: 4.w),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBadge(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.5)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.08),
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
          SizedBox(width: 4.w),
          Text(
            rating.toStringAsFixed(1),
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPanel(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
  ) {
    final accentColor = isPremium
        ? luxury.gold
        : (isNew ? luxury.success : colorScheme.primary);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(size.contentPadding),
      padding: EdgeInsets.all(size.contentPadding),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.6)
            : Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Accent line
          Container(
            width: 40.w,
            height: 3.h,
            margin: EdgeInsets.only(bottom: 10.h),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          
          // Gym name
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: size.titleSize,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : colorScheme.onSurface,
              height: 1.2,
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 6.h),
          
          // Location with icon
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: isDark ? 0.15 : 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  size: 12.sp,
                  color: accentColor,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  location,
                  style: GoogleFonts.inter(
                    fontSize: size.subtitleSize,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.6)
                        : colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          
          // Distance badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: isDark ? 0.15 : 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.near_me_rounded,
                  size: 12.sp,
                  color: accentColor,
                ),
                SizedBox(width: 4.w),
                Text(
                  distance,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
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

/// Size variants for the luxury gym card
enum LuxuryGymCardSize {
  small,
  medium,
  large,
}

extension LuxuryGymCardSizeExtension on LuxuryGymCardSize {
  double get width {
    switch (this) {
      case LuxuryGymCardSize.small:
        return 170.w;
      case LuxuryGymCardSize.medium:
        return 210.w;
      case LuxuryGymCardSize.large:
        return 280.w;
    }
  }

  double get totalHeight {
    switch (this) {
      case LuxuryGymCardSize.small:
        return 240.h;
      case LuxuryGymCardSize.medium:
        return 280.h;
      case LuxuryGymCardSize.large:
        return 340.h;
    }
  }

  double get borderRadius {
    switch (this) {
      case LuxuryGymCardSize.small:
        return 18.r;
      case LuxuryGymCardSize.medium:
        return 20.r;
      case LuxuryGymCardSize.large:
        return 24.r;
    }
  }

  double get contentPadding {
    switch (this) {
      case LuxuryGymCardSize.small:
        return 12.w;
      case LuxuryGymCardSize.medium:
        return 14.w;
      case LuxuryGymCardSize.large:
        return 16.w;
    }
  }

  double get titleSize {
    switch (this) {
      case LuxuryGymCardSize.small:
        return 14.sp;
      case LuxuryGymCardSize.medium:
        return 15.sp;
      case LuxuryGymCardSize.large:
        return 17.sp;
    }
  }

  double get subtitleSize {
    switch (this) {
      case LuxuryGymCardSize.small:
        return 11.sp;
      case LuxuryGymCardSize.medium:
        return 12.sp;
      case LuxuryGymCardSize.large:
        return 13.sp;
    }
  }

  double get emojiSize {
    switch (this) {
      case LuxuryGymCardSize.small:
        return 48.sp;
      case LuxuryGymCardSize.medium:
        return 56.sp;
      case LuxuryGymCardSize.large:
        return 68.sp;
    }
  }
}