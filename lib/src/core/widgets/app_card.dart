import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/responsive/responsive_utils.dart';

/// ============================================
/// BASE APP CARD
/// ============================================

/// Standard app card with consistent styling
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.onTap,
    this.enableShadow = false,
    this.shadowColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final VoidCallback? onTap;
  final bool enableShadow;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBorderRadius = borderRadius ?? ResponsiveSizes.radiusLg;
    final effectiveBgColor = backgroundColor ??
        (isDark ? AppColors.surfaceDark : AppColors.surface);
    final effectiveBorderColor = borderColor ??
        (isDark ? AppColors.borderDark : AppColors.border);
    final effectiveBorderWidth = borderWidth ?? 1.w;

    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: Border.all(
          color: effectiveBorderColor,
          width: effectiveBorderWidth,
        ),
        boxShadow: enableShadow
            ? [
                BoxShadow(
                  color: shadowColor ?? AppColors.cardShadowDark,
                  blurRadius: 16.r,
                  offset: Offset(0, 4.h),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        child: Material(
          color: Colors.transparent,
          child: onTap != null
              ? InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(effectiveBorderRadius),
                  child: Padding(
                    padding: padding ?? ResponsivePadding.card,
                    child: child,
                  ),
                )
              : Padding(
                  padding: padding ?? ResponsivePadding.card,
                  child: child,
                ),
        ),
      ),
    );

    return card;
  }
}

/// ============================================
/// GLASS CARD (Glassmorphism)
/// ============================================

/// Card with glassmorphism effect for dark theme
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.blur = 10,
    this.opacity = 0.1,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final VoidCallback? onTap;
  final double blur;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? ResponsiveSizes.radiusLg;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: Border.all(
          color: AppColors.glassBorder,
          width: 1.w,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: opacity),
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
            child: Material(
              color: Colors.transparent,
              child: onTap != null
                  ? InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(effectiveBorderRadius),
                      child: Padding(
                        padding: padding ?? ResponsivePadding.card,
                        child: child,
                      ),
                    )
                  : Padding(
                      padding: padding ?? ResponsivePadding.card,
                      child: child,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ============================================
/// GRADIENT CARD
/// ============================================

/// Card with gradient background
class GradientCard extends StatelessWidget {
  const GradientCard({
    super.key,
    required this.child,
    this.gradient,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.enableGlow = true,
  });

  final Widget child;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final VoidCallback? onTap;
  final bool enableGlow;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? ResponsiveSizes.radiusLg;
    final effectiveGradient = gradient ?? AppColors.primaryGradient;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: effectiveGradient,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        boxShadow: enableGlow
            ? [
                BoxShadow(
                  color: AppColors.primaryGlow,
                  blurRadius: 20.r,
                  offset: Offset(0, 8.h),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        child: Material(
          color: Colors.transparent,
          child: onTap != null
              ? InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(effectiveBorderRadius),
                  splashColor: Colors.white.withValues(alpha: 0.2),
                  highlightColor: Colors.white.withValues(alpha: 0.1),
                  child: Padding(
                    padding: padding ?? ResponsivePadding.card,
                    child: child,
                  ),
                )
              : Padding(
                  padding: padding ?? ResponsivePadding.card,
                  child: child,
                ),
        ),
      ),
    );
  }
}

/// ============================================
/// GYM CARD
/// ============================================

/// Gym card for displaying gym information
class GymCard extends StatelessWidget {
  const GymCard({
    super.key,
    required this.name,
    required this.address,
    this.imageUrl,
    this.rating,
    this.reviewCount,
    this.distance,
    this.isOpen = true,
    this.crowdLevel,
    this.facilities = const [],
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
  });

  final String name;
  final String address;
  final String? imageUrl;
  final double? rating;
  final int? reviewCount;
  final String? distance;
  final bool isOpen;
  final CrowdLevel? crowdLevel;
  final List<String> facilities;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Stack(
            children: [
              // Gym image
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(ResponsiveSizes.radiusLg - 1.r),
                ),
                child: Container(
                  height: ResponsiveSizes.cardImageMedium,
                  width: double.infinity,
                  color: isDark ? AppColors.surfaceElevatedDark : AppColors.grey200,
                  child: imageUrl != null && imageUrl!.isNotEmpty
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(isDark),
                        )
                      : _buildPlaceholder(isDark),
                ),
              ),
              
              // Status badge
              Positioned(
                top: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isOpen ? AppColors.gymOpen : AppColors.gymClosed,
                    borderRadius: BorderRadius.circular(ResponsiveSizes.radiusRound),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      RGap.w4,
                      Text(
                        isOpen ? 'Open' : 'Closed',
                        style: AppTextStyles.badge.copyWith(
                          fontSize: ResponsiveFontSizes.labelSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Rating badge
              if (rating != null)
                Positioned(
                  top: 12.h,
                  right: onFavorite != null ? 52.w : 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceDark.withValues(alpha: 0.9)
                          : Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(ResponsiveSizes.radiusSm),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 16.sp,
                          color: AppColors.accent,
                        ),
                        RGap.w4,
                        Text(
                          rating!.toStringAsFixed(1),
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: ResponsiveFontSizes.labelMedium,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                          ),
                        ),
                        if (reviewCount != null) ...[
                          Text(
                            ' ($reviewCount)',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: ResponsiveFontSizes.caption,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              
              // Favorite button
              if (onFavorite != null)
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onFavorite,
                      borderRadius: BorderRadius.circular(ResponsiveSizes.radiusRound),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.surfaceDark.withValues(alpha: 0.9)
                              : Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFavorite ? AppColors.error : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
                          size: 22.sp,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          
          // Info section
          Padding(
            padding: ResponsivePadding.card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  name,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontSize: ResponsiveFontSizes.titleMedium,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                RGap.h8,
                
                // Address and distance
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16.sp,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                    RGap.w4,
                    Expanded(
                      child: Text(
                        address,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: ResponsiveFontSizes.bodySmall,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (distance != null) ...[
                      RGap.w8,
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(ResponsiveSizes.radiusSm),
                        ),
                        child: Text(
                          distance!,
                          style: AppTextStyles.caption.copyWith(
                            fontSize: ResponsiveFontSizes.caption,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                
                // Crowd level
                if (crowdLevel != null) ...[
                  RGap.h12,
                  _CrowdLevelIndicator(level: crowdLevel!),
                ],
                
                // Facilities
                if (facilities.isNotEmpty) ...[
                  RGap.h12,
                  _FacilitiesRow(facilities: facilities, isDark: isDark),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(bool isDark) {
    return Center(
      child: Icon(
        Icons.fitness_center_rounded,
        size: 48.sp,
        color: isDark ? AppColors.grey600 : AppColors.grey400,
      ),
    );
  }
}

/// Crowd level enum
enum CrowdLevel { low, moderate, busy }

class _CrowdLevelIndicator extends StatelessWidget {
  const _CrowdLevelIndicator({required this.level});

  final CrowdLevel level;

  String get _label {
    switch (level) {
      case CrowdLevel.low:
        return 'Not Busy';
      case CrowdLevel.moderate:
        return 'Moderate';
      case CrowdLevel.busy:
        return 'Busy';
    }
  }

  Color get _color {
    switch (level) {
      case CrowdLevel.low:
        return AppColors.gymLow;
      case CrowdLevel.moderate:
        return AppColors.gymModerate;
      case CrowdLevel.busy:
        return AppColors.gymBusy;
    }
  }

  int get _filledBars {
    switch (level) {
      case CrowdLevel.low:
        return 1;
      case CrowdLevel.moderate:
        return 2;
      case CrowdLevel.busy:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Bars indicator
        Row(
          children: List.generate(3, (index) {
            final isFilled = index < _filledBars;
            return Container(
              width: 4.w,
              height: (12 + (index * 4)).h,
              margin: EdgeInsets.only(right: 3.w),
              decoration: BoxDecoration(
                color: isFilled ? _color : _color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2.r),
              ),
            );
          }),
        ),
        RGap.w8,
        Text(
          _label,
          style: AppTextStyles.caption.copyWith(
            fontSize: ResponsiveFontSizes.caption,
            color: _color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _FacilitiesRow extends StatelessWidget {
  const _FacilitiesRow({
    required this.facilities,
    required this.isDark,
  });

  final List<String> facilities;
  final bool isDark;

  IconData _getIcon(String facility) {
    switch (facility.toLowerCase()) {
      case 'gym':
      case 'weights':
        return Icons.fitness_center_rounded;
      case 'pool':
      case 'swimming':
        return Icons.pool_rounded;
      case 'yoga':
        return Icons.self_improvement_rounded;
      case 'spa':
      case 'sauna':
        return Icons.spa_rounded;
      case 'parking':
        return Icons.local_parking_rounded;
      case 'shower':
        return Icons.shower_rounded;
      case 'locker':
        return Icons.lock_rounded;
      case 'wifi':
        return Icons.wifi_rounded;
      case 'cafe':
        return Icons.local_cafe_rounded;
      case 'trainer':
        return Icons.person_rounded;
      default:
        return Icons.check_circle_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayFacilities = facilities.take(4).toList();
    final remaining = facilities.length - 4;

    return Row(
      children: [
        ...displayFacilities.map((facility) => Container(
              margin: EdgeInsets.only(right: 8.w),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceElevatedDark : AppColors.grey100,
                borderRadius: BorderRadius.circular(ResponsiveSizes.radiusSm),
              ),
              child: Icon(
                _getIcon(facility),
                size: 18.sp,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            )),
        if (remaining > 0)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceElevatedDark : AppColors.grey100,
              borderRadius: BorderRadius.circular(ResponsiveSizes.radiusSm),
            ),
            child: Text(
              '+$remaining',
              style: AppTextStyles.caption.copyWith(
                fontSize: ResponsiveFontSizes.caption,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

/// ============================================
/// SUBSCRIPTION CARD
/// ============================================

/// Premium subscription bundle card
class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({
    super.key,
    required this.title,
    required this.price,
    required this.currency,
    required this.period,
    required this.features,
    this.originalPrice,
    this.isPopular = false,
    this.isSelected = false,
    this.tier = SubscriptionTier.basic,
    this.onTap,
  });

  final String title;
  final double price;
  final String currency;
  final String period;
  final List<String> features;
  final double? originalPrice;
  final bool isPopular;
  final bool isSelected;
  final SubscriptionTier tier;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isPopular || isSelected) {
      return _buildGradientCard(context, isDark);
    }

    return _buildNormalCard(context, isDark);
  }

  Widget _buildGradientCard(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: _tierGradient,
        borderRadius: BorderRadius.circular(ResponsiveSizes.radiusXl),
        boxShadow: [
          BoxShadow(
            color: _tierColor.withValues(alpha: 0.3),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      padding: EdgeInsets.all(2.w),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          borderRadius: BorderRadius.circular(ResponsiveSizes.radiusXl - 2.r),
        ),
        child: _buildCardContent(context, isDark),
      ),
    );
  }

  Widget _buildNormalCard(BuildContext context, bool isDark) {
    return AppCard(
      borderRadius: ResponsiveSizes.radiusXl,
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: _buildCardContent(context, isDark),
    );
  }

  Widget _buildCardContent(BuildContext context, bool isDark) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ResponsiveSizes.radiusXl - 2.r),
      child: Padding(
        padding: ResponsivePadding.cardLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                // Tier icon
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    gradient: _tierGradient,
                    borderRadius: BorderRadius.circular(ResponsiveSizes.radiusMd),
                  ),
                  child: Icon(
                    _tierIcon,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
                RGap.w16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.titleLarge.copyWith(
                          fontSize: ResponsiveFontSizes.titleLarge,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        ),
                      ),
                      if (isPopular)
                        Container(
                          margin: EdgeInsets.only(top: 4.h),
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(ResponsiveSizes.radiusSm),
                          ),
                          child: Text(
                            'MOST POPULAR',
                            style: AppTextStyles.badge.copyWith(fontSize: 9.sp),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            
            RGap.h24,
            
            // Price
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currency,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontSize: ResponsiveFontSizes.titleMedium,
                    color: _tierColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                RGap.w4,
                Text(
                  price.toStringAsFixed(0),
                  style: AppTextStyles.priceLarge.copyWith(
                    fontSize: ResponsiveFontSizes.numberLarge,
                    color: _tierColor,
                  ),
                ),
                RGap.w4,
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Text(
                    '/$period',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: ResponsiveFontSizes.bodyMedium,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ),
                if (originalPrice != null) ...[
                  RGap.w8,
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Text(
                      '$currency${originalPrice!.toStringAsFixed(0)}',
                      style: AppTextStyles.priceOriginal.copyWith(
                        fontSize: ResponsiveFontSizes.bodyMedium,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            
            RGap.h24,
            
            // Divider
            Container(
              height: 1.h,
              color: isDark ? AppColors.borderDark : AppColors.border,
            ),
            
            RGap.h24,
            
            // Features
            ...features.map((feature) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Row(
                    children: [
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          size: 14.sp,
                          color: AppColors.success,
                        ),
                      ),
                      RGap.w12,
                      Expanded(
                        child: Text(
                          feature,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: ResponsiveFontSizes.bodyMedium,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Gradient get _tierGradient {
    switch (tier) {
      case SubscriptionTier.basic:
        return const LinearGradient(
          colors: [Color(0xFF6B7280), Color(0xFF4B5563)],
        );
      case SubscriptionTier.plus:
        return AppColors.oceanGradient;
      case SubscriptionTier.premium:
        return AppColors.primaryGradient;
    }
  }

  Color get _tierColor {
    switch (tier) {
      case SubscriptionTier.basic:
        return AppColors.tierBasic;
      case SubscriptionTier.plus:
        return AppColors.tierPlus;
      case SubscriptionTier.premium:
        return AppColors.tierPremium;
    }
  }

  IconData get _tierIcon {
    switch (tier) {
      case SubscriptionTier.basic:
        return Icons.star_outline_rounded;
      case SubscriptionTier.plus:
        return Icons.star_half_rounded;
      case SubscriptionTier.premium:
        return Icons.star_rounded;
    }
  }
}

enum SubscriptionTier { basic, plus, premium }

/// ============================================
/// STATS CARD
/// ============================================

/// Stats card for dashboard
class StatsCard extends StatelessWidget {
  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.iconGradient,
    this.trend,
    this.trendUp,
    this.onTap,
  });

  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Gradient? iconGradient;
  final String? trend;
  final bool? trendUp;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    gradient: iconGradient,
                    color: iconGradient == null
                        ? (iconColor ?? AppColors.primary).withValues(alpha: 0.1)
                        : null,
                    borderRadius: BorderRadius.circular(ResponsiveSizes.radiusMd),
                  ),
                  child: Icon(
                    icon,
                    size: 22.sp,
                    color: iconGradient != null
                        ? Colors.white
                        : (iconColor ?? AppColors.primary),
                  ),
                ),
                RGap.w12,
              ],
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: ResponsiveFontSizes.bodySmall,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ),
              if (trend != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: (trendUp == true ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ResponsiveSizes.radiusSm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trendUp == true
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        size: 14.sp,
                        color: trendUp == true ? AppColors.success : AppColors.error,
                      ),
                      RGap.w4,
                      Text(
                        trend!,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: ResponsiveFontSizes.caption,
                          color: trendUp == true ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          
          RGap.h16,
          
          // Value
          Text(
            value,
            style: AppTextStyles.numberMedium.copyWith(
              fontSize: ResponsiveFontSizes.numberMedium,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          
          // Subtitle
          if (subtitle != null) ...[
            RGap.h4,
            Text(
              subtitle!,
              style: AppTextStyles.caption.copyWith(
                fontSize: ResponsiveFontSizes.caption,
                color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// ============================================
/// QR CARD
/// ============================================

/// Card for displaying QR code with countdown
class QrCard extends StatelessWidget {
  const QrCard({
    super.key,
    required this.qrWidget,
    required this.gymName,
    required this.secondsRemaining,
    this.onRefresh,
  });

  final Widget qrWidget;
  final String gymName;
  final int secondsRemaining;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      padding: ResponsivePadding.cardLarge,
      child: Column(
        children: [
          // QR Code
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ResponsiveSizes.radiusLg),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGlow,
                  blurRadius: 20.r,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: qrWidget,
          ),
          
          RGap.h24,
          
          // Gym name
          Text(
            gymName,
            style: AppTextStyles.titleMedium.copyWith(
              fontSize: ResponsiveFontSizes.titleMedium,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          
          RGap.h16,
          
          // Countdown
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.timer_outlined,
                size: 20.sp,
                color: AppColors.primary,
              ),
              RGap.w8,
              Text(
                'Refreshes in ',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: ResponsiveFontSizes.bodyMedium,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
              Text(
                '${secondsRemaining}s',
                style: AppTextStyles.titleMedium.copyWith(
                  fontSize: ResponsiveFontSizes.titleMedium,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          
          if (onRefresh != null) ...[
            RGap.h16,
            TextButton.icon(
              onPressed: onRefresh,
              icon: Icon(Icons.refresh_rounded, size: 20.sp),
              label: const Text('Refresh Now'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// ============================================
/// CLASS CARD
/// ============================================

/// Card for fitness class listings
class ClassCard extends StatelessWidget {
  const ClassCard({
    super.key,
    required this.name,
    required this.instructor,
    required this.time,
    required this.duration,
    this.imageUrl,
    this.spotsLeft,
    this.maxSpots,
    this.isBooked = false,
    this.onTap,
    this.onBook,
  });

  final String name;
  final String instructor;
  final String time;
  final String duration;
  final String? imageUrl;
  final int? spotsLeft;
  final int? maxSpots;
  final bool isBooked;
  final VoidCallback? onTap;
  final VoidCallback? onBook;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      padding: EdgeInsets.all(12.w),
      onTap: onTap,
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(ResponsiveSizes.radiusMd),
            child: Container(
              width: 80.w,
              height: 80.w,
              color: isDark ? AppColors.surfaceElevatedDark : AppColors.grey200,
              child: imageUrl != null
                  ? Image.network(imageUrl!, fit: BoxFit.cover)
                  : Icon(
                      Icons.fitness_center_rounded,
                      color: isDark ? AppColors.grey600 : AppColors.grey400,
                      size: 32.sp,
                    ),
            ),
          ),
          
          RGap.w16,
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontSize: ResponsiveFontSizes.titleSmall,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                RGap.h4,
                Text(
                  'with $instructor',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: ResponsiveFontSizes.bodySmall,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
                RGap.h8,
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14.sp,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                    RGap.w4,
                    Flexible(
                      child: Text(
                        '$time • $duration',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: ResponsiveFontSizes.caption,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Action
          Column(
            children: [
              if (spotsLeft != null && maxSpots != null)
                Text(
                  '$spotsLeft/$maxSpots',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: ResponsiveFontSizes.caption,
                    color: spotsLeft! <= 3 ? AppColors.warning : AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              RGap.h8,
              if (onBook != null)
                Container(
                  decoration: BoxDecoration(
                    gradient: isBooked ? null : AppColors.primaryGradient,
                    color: isBooked ? AppColors.success : null,
                    borderRadius: BorderRadius.circular(ResponsiveSizes.radiusSm),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: isBooked ? null : onBook,
                      borderRadius: BorderRadius.circular(ResponsiveSizes.radiusSm),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        child: Text(
                          isBooked ? 'Booked' : 'Book',
                          style: AppTextStyles.buttonSmall.copyWith(
                            fontSize: ResponsiveFontSizes.buttonSmall,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}