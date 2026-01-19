import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';

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
    this.borderWidth = 1,
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
  final double borderWidth;
  final VoidCallback? onTap;
  final bool enableShadow;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBorderRadius = borderRadius ?? AppTheme.borderRadiusLarge;
    final effectiveBgColor = backgroundColor ??
        (isDark ? AppColors.surfaceDark : AppColors.surface);
    final effectiveBorderColor = borderColor ??
        (isDark ? AppColors.borderDark : AppColors.border);

    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: Border.all(
          color: effectiveBorderColor,
          width: borderWidth,
        ),
        boxShadow: enableShadow
            ? [
                BoxShadow(
                  color: shadowColor ?? AppColors.cardShadowDark,
                  blurRadius: 16,
                  offset: const Offset(0, 4),
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
                    padding: padding ?? const EdgeInsets.all(16),
                    child: child,
                  ),
                )
              : Padding(
                  padding: padding ?? const EdgeInsets.all(16),
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
    final effectiveBorderRadius = borderRadius ?? AppTheme.borderRadiusLarge;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: Border.all(
          color: AppColors.glassBorder,
          width: 1,
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
                        padding: padding ?? const EdgeInsets.all(16),
                        child: child,
                      ),
                    )
                  : Padding(
                      padding: padding ?? const EdgeInsets.all(16),
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
    final effectiveBorderRadius = borderRadius ?? AppTheme.borderRadiusLarge;
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
                  blurRadius: 20,
                  offset: const Offset(0, 8),
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
                    padding: padding ?? const EdgeInsets.all(16),
                    child: child,
                  ),
                )
              : Padding(
                  padding: padding ?? const EdgeInsets.all(16),
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
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppTheme.borderRadiusLarge - 1),
                ),
                child: Container(
                  height: 160,
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
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isOpen ? AppColors.gymOpen : AppColors.gymClosed,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusRound),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isOpen ? 'Open' : 'Closed',
                        style: AppTextStyles.badge,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Rating badge
              if (rating != null)
                Positioned(
                  top: 12,
                  right: onFavorite != null ? 52 : 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceDark.withValues(alpha: 0.9)
                          : Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating!.toStringAsFixed(1),
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                          ),
                        ),
                        if (reviewCount != null) ...[
                          Text(
                            ' ($reviewCount)',
                            style: AppTextStyles.caption.copyWith(
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
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onFavorite,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusRound),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.surfaceDark.withValues(alpha: 0.9)
                              : Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFavorite ? AppColors.error : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          
          // Info section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  name,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                // Address and distance
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        address,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (distance != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                        ),
                        child: Text(
                          distance!,
                          style: AppTextStyles.caption.copyWith(
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
                  const SizedBox(height: 12),
                  _CrowdLevelIndicator(level: crowdLevel!),
                ],
                
                // Facilities
                if (facilities.isNotEmpty) ...[
                  const SizedBox(height: 12),
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
        size: 48,
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
              width: 4,
              height: 12 + (index * 4).toDouble(),
              margin: const EdgeInsets.only(right: 3),
              decoration: BoxDecoration(
                color: isFilled ? _color : _color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
        const SizedBox(width: 8),
        Text(
          _label,
          style: AppTextStyles.caption.copyWith(
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
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceElevatedDark : AppColors.grey100,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
              ),
              child: Icon(
                _getIcon(facility),
                size: 18,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            )),
        if (remaining > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceElevatedDark : AppColors.grey100,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
            ),
            child: Text(
              '+$remaining',
              style: AppTextStyles.caption.copyWith(
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
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
        boxShadow: [
          BoxShadow(
            color: _tierColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge - 2),
        ),
        child: _buildCardContent(context, isDark),
      ),
    );
  }

  Widget _buildNormalCard(BuildContext context, bool isDark) {
    return AppCard(
      borderRadius: AppTheme.borderRadiusXLarge,
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: _buildCardContent(context, isDark),
    );
  }

  Widget _buildCardContent(BuildContext context, bool isDark) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge - 2),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                // Tier icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: _tierGradient,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  ),
                  child: Icon(
                    _tierIcon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.titleLarge.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        ),
                      ),
                      if (isPopular)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                          ),
                          child: Text(
                            'MOST POPULAR',
                            style: AppTextStyles.badge.copyWith(fontSize: 9),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Price
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currency,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: _tierColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  price.toStringAsFixed(0),
                  style: AppTextStyles.priceLarge.copyWith(
                    color: _tierColor,
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '/$period',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ),
                if (originalPrice != null) ...[
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '$currency${originalPrice!.toStringAsFixed(0)}',
                      style: AppTextStyles.priceOriginal,
                    ),
                  ),
                ],
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Divider
            Container(
              height: 1,
              color: isDark ? AppColors.borderDark : AppColors.border,
            ),
            
            const SizedBox(height: 24),
            
            // Features
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          feature,
                          style: AppTextStyles.bodyMedium.copyWith(
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
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: iconGradient,
                    color: iconGradient == null
                        ? (iconColor ?? AppColors.primary).withValues(alpha: 0.1)
                        : null,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: iconGradient != null
                        ? Colors.white
                        : (iconColor ?? AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (trendUp == true ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trendUp == true
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        size: 14,
                        color: trendUp == true ? AppColors.success : AppColors.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trend!,
                        style: AppTextStyles.caption.copyWith(
                          color: trendUp == true ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Value
          Text(
            value,
            style: AppTextStyles.numberMedium.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          
          // Subtitle
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: AppTextStyles.caption.copyWith(
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
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // QR Code
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGlow,
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: qrWidget,
          ),
          
          const SizedBox(height: 24),
          
          // Gym name
          Text(
            gymName,
            style: AppTextStyles.titleMedium.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Countdown
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.timer_outlined,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Refreshes in ',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
              Text(
                '${secondsRemaining}s',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          
          if (onRefresh != null) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh_rounded, size: 20),
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
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            child: Container(
              width: 80,
              height: 80,
              color: isDark ? AppColors.surfaceElevatedDark : AppColors.grey200,
              child: imageUrl != null
                  ? Image.network(imageUrl!, fit: BoxFit.cover)
                  : Icon(
                      Icons.fitness_center_rounded,
                      color: isDark ? AppColors.grey600 : AppColors.grey400,
                    ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'with $instructor',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$time • $duration',
                      style: AppTextStyles.caption.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
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
                    color: spotsLeft! <= 3 ? AppColors.warning : AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              const SizedBox(height: 8),
              if (onBook != null)
                Container(
                  decoration: BoxDecoration(
                    gradient: isBooked ? null : AppColors.primaryGradient,
                    color: isBooked ? AppColors.success : null,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: isBooked ? null : onBook,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          isBooked ? 'Booked' : 'Book',
                          style: AppTextStyles.buttonSmall,
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