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
              : (isDark ? colorScheme.outline : colorScheme.outline.withValues(alpha: 0.15)),
          width: 1,
        ),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: luxury.cardShadow.withValues(alpha: 0.08 * elevation),
                  blurRadius: 8 * elevation,
                  offset: Offset(0, 2 * elevation),
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
    final colorScheme = Theme.of(context).colorScheme;
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
            : colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
        border: Border.all(
          color: isDark
              ? luxury.glassBorder
              : colorScheme.outline.withValues(alpha: 0.12),
          width: 1,
        ),
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
            color: luxury.cardShadow.withValues(alpha: isDark ? 0.15 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
      return colorScheme.primary.withValues(alpha: 0.4);
    }
    return isDark
        ? colorScheme.outline
        : colorScheme.outline.withValues(alpha: 0.15);
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

    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
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
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle!,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (action != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                action!,
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
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
      margin: margin ?? EdgeInsets.symmetric(vertical: 12.h),
      color: useGoldAccent
          ? luxury.gold.withValues(alpha: 0.2)
          : (isDark ? colorScheme.outline : colorScheme.outline.withValues(alpha: 0.15)),
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

    final bgColor = isPremium ? luxury.gold : (color ?? colorScheme.primary);
    final fgColor = isPremium ? AppColors.backgroundDark : (textColor ?? colorScheme.onPrimary);

    final fontSize = size == LuxuryBadgeSize.small
        ? 10.sp
        : size == LuxuryBadgeSize.large
            ? 13.sp
            : 11.sp;

    final paddingH = size == LuxuryBadgeSize.small
        ? 8.w
        : size == LuxuryBadgeSize.large
            ? 14.w
            : 10.w;

    final paddingV = size == LuxuryBadgeSize.small
        ? 4.h
        : size == LuxuryBadgeSize.large
            ? 7.h
            : 5.h;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100.r),
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
            SizedBox(width: 4.w),
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
        (isDark ? luxury.surfaceElevated : colorScheme.surface);
    final fgColor = iconColor ?? colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size.w,
          height: size.w,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: isPremium
                  ? luxury.borderGold
                  : (isDark ? colorScheme.outline : colorScheme.outline.withValues(alpha: 0.15)),
              width: 1,
            ),
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
        child: Container(
          width: width ?? double.infinity,
          height: height.h,
          decoration: BoxDecoration(
            gradient: onPressed != null ? buttonGradient : null,
            color: onPressed == null
                ? (isDark ? luxury.surfaceElevated : colorScheme.outline)
                : null,
            borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 22.w,
                    height: 22.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
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
                        SizedBox(width: 8.w),
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
                              : colorScheme.onSurface.withValues(alpha: 0.5),
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
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceElevatedDark
                    : AppColors.grey100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: 8.h),
              Text(
                subtitle!,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null && onAction != null) ...[
              SizedBox(height: 24.h),
              TextButton(
                onPressed: onAction,
                child: Text(
                  action!,
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
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

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18.sp,
              color: colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 10.w),
          ],
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
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