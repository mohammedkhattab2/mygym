import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_colors.dart';
import '../luxury_theme_extension.dart';

/// Premium Container with elegant styling
/// 
/// A container with subtle gradient, clean borders, and refined shadows.
class LuxuryContainer extends StatelessWidget {
  const LuxuryContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.useGoldAccent = false,
    this.elevation = 1,
    this.width,
    this.height,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final bool useGoldAccent;
  final double elevation;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? luxury.surfaceElevated : colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
        border: Border.all(
          color: useGoldAccent
              ? luxury.borderGold
              : (isDark ? colorScheme.outline : AppColors.border),
          width: 1,
        ),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: isDark
                      ? luxury.cardShadow.withValues(alpha: 0.08 * elevation)
                      : AppColors.cardShadowLight.withValues(alpha: 0.5 * elevation),
                  blurRadius: isDark ? 8 * elevation : 12 * elevation,
                  offset: Offset(0, isDark ? 2 * elevation : 4 * elevation),
                  spreadRadius: isDark ? 0 : 0.5 * elevation,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

/// Glass Card with subtle transparency effect
class LuxuryGlassCard extends StatelessWidget {
  const LuxuryGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.intensity = 0.08,
    this.width,
    this.height,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final double intensity;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: intensity)
            : AppColors.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
        border: Border.all(
          color: isDark
              ? luxury.glassBorder
              : AppColors.borderLight,
          width: 1,
        ),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: AppColors.cardShadowLight,
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Premium Card with refined styling
class LuxuryCard extends StatelessWidget {
  const LuxuryCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.isPremium = false,
    this.isHighlighted = false,
    this.width,
    this.height,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final VoidCallback? onTap;
  final bool isPremium;
  final bool isHighlighted;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    final effectiveRadius = borderRadius ?? 16.r;
    
    final card = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: isDark ? luxury.surfaceElevated : colorScheme.surface,
        borderRadius: BorderRadius.circular(effectiveRadius),
        border: Border.all(
          color: _getBorderColor(colorScheme, luxury, isDark),
          width: isPremium ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? luxury.cardShadow.withValues(alpha: 0.15)
                : AppColors.cardShadowLight,
            blurRadius: isDark ? 12.r : 16.r,
            offset: Offset(0, isDark ? 4.h : 6.h),
            spreadRadius: isDark ? 0 : 1,
          ),
          if (!isDark)
            BoxShadow(
              color: AppColors.cardShadowLight.withValues(alpha: 0.5),
              blurRadius: 4.r,
              offset: Offset(0, 1.h),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(effectiveRadius),
        child: Padding(
          padding: padding ?? EdgeInsets.all(16.w),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(effectiveRadius),
          splashColor: isDark
              ? AppColors.glassWhite
              : AppColors.primary.withValues(alpha: 0.06),
          highlightColor: isDark
              ? AppColors.glassWhiteLight
              : AppColors.primary.withValues(alpha: 0.03),
          child: card,
        ),
      );
    }

    return card;
  }

  Color _getBorderColor(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
  ) {
    if (isPremium) {
      return luxury.borderGold;
    }
    if (isHighlighted) {
      return colorScheme.primary.withValues(alpha: isDark ? 0.4 : 0.3);
    }
    return isDark
        ? colorScheme.outline
        : AppColors.border;
  }
}

/// Section Header with clean styling
class LuxurySectionHeader extends StatelessWidget {
  const LuxurySectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.onActionTap,
    this.padding,
  });

  final String title;
  final String? subtitle;
  final String? action;
  final VoidCallback? onActionTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = context.isDarkMode;

    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                    letterSpacing: -0.2,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 3.h),
                  Text(
                    subtitle!,
                    style: textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? colorScheme.onSurfaceVariant
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (action != null)
            GestureDetector(
              onTap: onActionTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? colorScheme.primary.withValues(alpha: 0.1)
                      : AppColors.primaryLight.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  action!,
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Simple divider with subtle styling
class LuxuryDivider extends StatelessWidget {
  const LuxuryDivider({
    super.key,
    this.height = 1,
    this.margin,
    this.useGoldAccent = false,
  });

  final double height;
  final EdgeInsetsGeometry? margin;
  final bool useGoldAccent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Container(
      height: height,
      margin: margin ?? EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: useGoldAccent
            ? luxury.gold.withValues(alpha: isDark ? 0.2 : 0.15)
            : (isDark ? colorScheme.outline : AppColors.borderLight),
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}

/// Badge with clean styling
class LuxuryBadge extends StatelessWidget {
  const LuxuryBadge({
    super.key,
    required this.label,
    this.color,
    this.textColor,
    this.icon,
    this.size = LuxuryBadgeSize.medium,
    this.isPremium = false,
  });

  final String label;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final LuxuryBadgeSize size;
  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    final bgColor = isPremium ? luxury.gold : (color ?? colorScheme.primary);
    final fgColor = isPremium
        ? (isDark ? AppColors.backgroundDark : AppColors.white)
        : (textColor ?? colorScheme.onPrimary);

    final fontSize = size == LuxuryBadgeSize.small
        ? 10.sp
        : size == LuxuryBadgeSize.large
            ? 13.sp
            : 11.sp;

    final paddingH = size == LuxuryBadgeSize.small
        ? 10.w
        : size == LuxuryBadgeSize.large
            ? 16.w
            : 12.w;

    final paddingV = size == LuxuryBadgeSize.small
        ? 5.h
        : size == LuxuryBadgeSize.large
            ? 8.h
            : 6.h;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100.r),
        boxShadow: !isDark ? [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.25),
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ] : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: fontSize + 2,
              color: fgColor,
            ),
            SizedBox(width: 5.w),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: fgColor,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

enum LuxuryBadgeSize { small, medium, large }

/// Icon Button with clean styling
class LuxuryIconButton extends StatelessWidget {
  const LuxuryIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 44,
    this.backgroundColor,
    this.iconColor,
    this.isPremium = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    final bgColor = backgroundColor ??
        (isDark ? luxury.surfaceElevated : AppColors.surfaceElevated);
    final fgColor = iconColor ?? colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        splashColor: isDark
            ? AppColors.glassWhite
            : AppColors.primary.withValues(alpha: 0.08),
        highlightColor: isDark
            ? AppColors.glassWhiteLight
            : AppColors.primary.withValues(alpha: 0.04),
        child: Container(
          width: size.w,
          height: size.w,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: isPremium
                  ? luxury.borderGold
                  : (isDark ? colorScheme.outline : AppColors.border),
              width: 1,
            ),
            boxShadow: !isDark ? [
              BoxShadow(
                color: AppColors.cardShadowLight,
                blurRadius: 6.r,
                offset: Offset(0, 2.h),
              ),
            ] : null,
          ),
          child: Center(
            child: Icon(
              icon,
              size: (size * 0.5).sp,
              color: fgColor,
            ),
          ),
        ),
      ),
    );
  }
}

/// Gradient Button with clean styling
class LuxuryGradientButton extends StatelessWidget {
  const LuxuryGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.gradient,
    this.height = 52,
    this.width,
    this.borderRadius,
    this.isLoading = false,
    this.isPremium = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Gradient? gradient;
  final double height;
  final double? width;
  final double? borderRadius;
  final bool isLoading;
  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    final buttonGradient = gradient ??
        (isPremium ? luxury.goldGradient : luxury.primaryGradient);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
        splashColor: Colors.white.withValues(alpha: 0.15),
        highlightColor: Colors.white.withValues(alpha: 0.08),
        child: Container(
          width: width ?? double.infinity,
          height: height.h,
          decoration: BoxDecoration(
            gradient: onPressed != null ? buttonGradient : null,
            color: onPressed == null
                ? (isDark ? luxury.surfaceElevated : AppColors.borderLight)
                : null,
            borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
            boxShadow: onPressed != null && !isDark ? [
              BoxShadow(
                color: (isPremium ? AppColors.gold : AppColors.primary).withValues(alpha: 0.25),
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ] : null,
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 22.w,
                    height: 22.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: isPremium
                          ? AppColors.backgroundDark
                          : colorScheme.onPrimary,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: 20.sp,
                          color: isPremium
                              ? AppColors.backgroundDark
                              : colorScheme.onPrimary,
                        ),
                        SizedBox(width: 10.w),
                      ],
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: onPressed != null
                              ? (isPremium
                                  ? AppColors.backgroundDark
                                  : colorScheme.onPrimary)
                              : (isDark
                                  ? colorScheme.onSurface.withValues(alpha: 0.5)
                                  : AppColors.textDisabled),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Background wrapper for screens
class LuxuryBackground extends StatelessWidget {
  const LuxuryBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: isDark ? AppColors.backgroundDark : AppColors.background,
      child: child,
    );
  }
}

/// Empty state widget with clean styling
class LuxuryEmptyState extends StatelessWidget {
  const LuxuryEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = context.isDarkMode;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceElevatedDark
                    : AppColors.surfaceElevated,
                shape: BoxShape.circle,
                border: !isDark ? Border.all(
                  color: AppColors.borderLight,
                  width: 1,
                ) : null,
              ),
              child: Icon(
                icon,
                size: 36.sp,
                color: isDark
                    ? colorScheme.onSurfaceVariant
                    : AppColors.textTertiary,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: 10.h),
              Text(
                subtitle!,
                style: textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? colorScheme.onSurfaceVariant
                      : AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null && onAction != null) ...[
              SizedBox(height: 28.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? colorScheme.primary.withValues(alpha: 0.1)
                      : AppColors.primaryLight.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: InkWell(
                  onTap: onAction,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Text(
                    action!,
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Info row for displaying key-value pairs
class LuxuryInfoRow extends StatelessWidget {
  const LuxuryInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = context.isDarkMode;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: isDark
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : AppColors.primaryLight.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                size: 16.sp,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? colorScheme.onSurfaceVariant
                    : AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: valueColor ?? colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}