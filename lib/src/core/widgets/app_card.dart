import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/responsive/responsive_utils.dart';

/// ============================================
/// BASE APP CARD
/// ============================================

/// Standard app card with clean, consistent styling
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBorderRadius = borderRadius ?? ResponsiveSizes.radiusLg;
    final effectiveBgColor = backgroundColor ??
        (isDark ? AppColors.surfaceDark : AppColors.surfaceElevated);
    final effectiveBorderColor = borderColor ??
        (isDark ? AppColors.borderDark : AppColors.borderLight);
    final effectiveBorderWidth = borderWidth ?? (isDark ? 1 : 0.8);

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
            ? isDark
                ? [
                    BoxShadow(
                      color: AppColors.cardShadowDark.withValues(alpha: 0.2),
                      blurRadius: 12.r,
                      offset: Offset(0, 4.h),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.cardShadowLight,
                      blurRadius: 16.r,
                      offset: Offset(0, 4.h),
                    ),
                    BoxShadow(
                      color: AppColors.cardShadowLightMedium,
                      blurRadius: 6.r,
                      offset: Offset(0, 2.h),
                    ),
                  ]
            : !isDark
                ? [
                    BoxShadow(
                      color: AppColors.cardShadowLight,
                      blurRadius: 8.r,
                      offset: Offset(0, 2.h),
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
                  splashColor: isDark
                      ? AppColors.white.withValues(alpha: 0.08)
                      : AppColors.primary.withValues(alpha: 0.08),
                  highlightColor: isDark
                      ? AppColors.white.withValues(alpha: 0.04)
                      : AppColors.primary.withValues(alpha: 0.04),
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
/// GLASS CARD
/// ============================================

/// Card with subtle glass effect for dark theme
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.blur = 8,
    this.opacity = 0.08,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBorderRadius = borderRadius ?? ResponsiveSizes.radiusLg;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: Border.all(
          color: isDark ? AppColors.glassBorder : AppColors.borderLight,
          width: isDark ? 1 : 0.8,
        ),
        boxShadow: !isDark
            ? [
                BoxShadow(
                  color: AppColors.cardShadowLight,
                  blurRadius: 12.r,
                  offset: Offset(0, 4.h),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: opacity)
                  : AppColors.surfacePremium.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
            child: Material(
              color: Colors.transparent,
              child: onTap != null
                  ? InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(effectiveBorderRadius),
                      splashColor: isDark
                          ? AppColors.white.withValues(alpha: 0.1)
                          : AppColors.primary.withValues(alpha: 0.08),
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
  });

  final Widget child;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? ResponsiveSizes.radiusLg;
    final effectiveGradient = gradient ?? AppColors.primaryGradient;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: effectiveGradient,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        child: Material(
          color: Colors.transparent,
          child: onTap != null
              ? InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(effectiveBorderRadius),
                  splashColor: Colors.white.withValues(alpha: 0.15),
                  highlightColor: Colors.white.withValues(alpha: 0.08),
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
      enableShadow: true,
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
                  color: isDark ? AppColors.surfaceElevatedDark : AppColors.backgroundSecondary,
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
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isOpen ? AppColors.gymOpen : AppColors.gymClosed,
                    borderRadius: BorderRadius.circular(ResponsiveSizes.radiusRound),
                    boxShadow: !isDark
                        ? [
                            BoxShadow(
                              color: (isOpen ? AppColors.gymOpen : AppColors.gymClosed)
                                  .withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
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
                      SizedBox(width: 6.w),
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
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceDark.withValues(alpha: 0.95)
                          : AppColors.surfacePremium,
                      borderRadius: BorderRadius.circular(ResponsiveSizes.radiusSm),
                      border: !isDark
                          ? Border.all(
                              color: AppColors.borderLight,
                              width: 0.5,
                            )
                          : null,
                      boxShadow: !isDark
                          ? [
                              BoxShadow(
                                color: AppColors.cardShadowLight,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 14.sp,
                          color: AppColors.accent,
                        ),
                        SizedBox(width: 4.w),
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
                              ? AppColors.surfaceDark.withValues(alpha: 0.95)
                              : AppColors.surfacePremium,
                          shape: BoxShape.circle,
                          border: !isDark
                              ? Border.all(
                                  color: AppColors.borderLight,
                                  width: 0.5,
                                )
                              : null,
                          boxShadow: !isDark
                              ? [
                                  BoxShadow(
                                    color: AppColors.cardShadowLight,
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFavorite ? AppColors.error : (isDark ? AppColors.textPrimaryDark : AppColors.textSecondary),
                          size: 20.sp,
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
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                SizedBox(height: 8.h),
                
                // Address and distance
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : AppColors.primaryLight.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Icon(
                        Icons.location_on_outlined,
                        size: 14.sp,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 8.w),
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
                      SizedBox(width: 10.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.primary.withValues(alpha: 0.15)
                              : AppColors.primaryLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(ResponsiveSizes.radiusSm),
                          border: !isDark
                              ? Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.15),
                                  width: 0.5,
                                )
                              : null,
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
                  SizedBox(height: 12.h),
                  _CrowdLevelIndicator(level: crowdLevel!),
                ],
                
                // Facilities
                if (facilities.isNotEmpty) ...[
                  SizedBox(height: 12.h),
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
        size: 40.sp,
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
        Row(
          children: List.generate(3, (index) {
            final isFilled = index < _filledBars;
            return Container(
              width: 4.w,
              height: (10 + (index * 4)).h,
              margin: EdgeInsets.only(right: 3.w),
              decoration: BoxDecoration(
                color: isFilled ? _color : _color.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(2.r),
              ),
            );
          }),
        ),
        SizedBox(width: 8.w),
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
                color: isDark
                    ? AppColors.surfaceElevatedDark
                    : AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(8.r),
                border: !isDark
                    ? Border.all(
                        color: AppColors.borderLight,
                        width: 0.5,
                      )
                    : null,
              ),
              child: Icon(
                _getIcon(facility),
                size: 16.sp,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            )),
        if (remaining > 0)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceElevatedDark
                  : AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(8.r),
              border: !isDark
                  ? Border.all(
                      color: AppColors.borderLight,
                      width: 0.5,
                    )
                  : null,
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
      return _buildHighlightedCard(context, isDark);
    }

    return _buildNormalCard(context, isDark);
  }

  Widget _buildHighlightedCard(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: _tierGradient,
        borderRadius: BorderRadius.circular(ResponsiveSizes.radiusXl),
      ),
      padding: EdgeInsets.all(1.5.w),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          borderRadius: BorderRadius.circular(ResponsiveSizes.radiusXl - 1.5.r),
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
      borderRadius: BorderRadius.circular(ResponsiveSizes.radiusXl - 1.5.r),
      child: Padding(
        padding: ResponsivePadding.cardLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    gradient: _tierGradient,
                    borderRadius: BorderRadius.circular(ResponsiveSizes.radiusMd),
                  ),
                  child: Icon(
                    _tierIcon,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 14.w),
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
            
            SizedBox(height: 20.h),
            
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
                SizedBox(width: 2.w),
                Text(
                  price.toStringAsFixed(0),
                  style: AppTextStyles.priceLarge.copyWith(
                    fontSize: ResponsiveFontSizes.numberLarge,
                    color: _tierColor,
                  ),
                ),
                SizedBox(width: 4.w),
                Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Text(
                    '/$period',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: ResponsiveFontSizes.bodyMedium,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ),
                if (originalPrice != null) ...[
                  SizedBox(width: 8.w),
                  Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
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
            
            SizedBox(height: 20.h),
            
            // Divider
            Container(
              height: 1.h,
              color: isDark ? AppColors.borderDark : AppColors.border,
            ),
            
            SizedBox(height: 20.h),
            
            // Features
            ...features.map((feature) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    children: [
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          size: 12.sp,
                          color: AppColors.success,
                        ),
                      ),
                      SizedBox(width: 12.w),
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
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    gradient: iconGradient,
                    color: iconGradient == null
                        ? (iconColor ?? AppColors.primary).withValues(alpha: 0.12)
                        : null,
                    borderRadius: BorderRadius.circular(ResponsiveSizes.radiusMd),
                  ),
                  child: Icon(
                    icon,
                    size: 20.sp,
                    color: iconGradient != null
                        ? Colors.white
                        : (iconColor ?? AppColors.primary),
                  ),
                ),
                SizedBox(width: 12.w),
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
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: (trendUp == true ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(ResponsiveSizes.radiusSm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trendUp == true
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        size: 12.sp,
                        color: trendUp == true ? AppColors.success : AppColors.error,
                      ),
                      SizedBox(width: 4.w),
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
          
          SizedBox(height: 14.h),
          
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
            SizedBox(height: 4.h),
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

    return AppCard(
      padding: ResponsivePadding.cardLarge,
      child: Column(
        children: [
          // QR Code
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ResponsiveSizes.radiusLg),
            ),
            child: qrWidget,
          ),
          
          SizedBox(height: 20.h),
          
          // Gym name
          Text(
            gymName,
            style: AppTextStyles.titleMedium.copyWith(
              fontSize: ResponsiveFontSizes.titleMedium,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          
          SizedBox(height: 14.h),
          
          // Countdown
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.timer_outlined,
                size: 18.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: 8.w),
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
            SizedBox(height: 14.h),
            TextButton.icon(
              onPressed: onRefresh,
              icon: Icon(Icons.refresh_rounded, size: 18.sp),
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
              width: 72.w,
              height: 72.w,
              color: isDark ? AppColors.surfaceElevatedDark : AppColors.grey200,
              child: imageUrl != null
                  ? Image.network(imageUrl!, fit: BoxFit.cover)
                  : Icon(
                      Icons.fitness_center_rounded,
                      color: isDark ? AppColors.grey600 : AppColors.grey400,
                      size: 28.sp,
                    ),
            ),
          ),
          
          SizedBox(width: 14.w),
          
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
                SizedBox(height: 3.h),
                Text(
                  'with $instructor',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: ResponsiveFontSizes.bodySmall,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 12.sp,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                    SizedBox(width: 4.w),
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
              SizedBox(height: 6.h),
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
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
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