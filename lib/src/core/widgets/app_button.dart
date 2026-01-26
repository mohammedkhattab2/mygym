import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/responsive/responsive_utils.dart';

/// ============================================
/// PRIMARY BUTTON - Clean Gradient
/// ============================================

/// Primary elevated button with gradient background
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    this.gradient,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.borderRadius,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double? height;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? icon;
  final IconPosition iconPosition;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = !isDisabled && !isLoading;
    final effectiveGradient = gradient ?? AppColors.primaryGradient;
    final effectiveBorderRadius = borderRadius ?? ResponsiveSizes.radiusLg;
    final effectiveHeight = height ?? ResponsiveSizes.buttonHeight;

    return Container(
      width: width ?? double.infinity,
      height: effectiveHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        gradient: isEnabled ? effectiveGradient : null,
        color: isEnabled ? null : (isDark ? AppColors.grey700 : AppColors.grey300),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          splashColor: AppColors.white.withValues(alpha: 0.15),
          highlightColor: AppColors.white.withValues(alpha: 0.08),
          child: Center(
            child: isLoading
                ? _LoadingIndicator(color: textColor ?? AppColors.white)
                : _ButtonContent(
                    text: text,
                    icon: icon,
                    iconPosition: iconPosition,
                    textColor: textColor ?? AppColors.white,
                    isDisabled: isDisabled,
                  ),
          ),
        ),
      ),
    );
  }
}

/// ============================================
/// OUTLINED BUTTON
/// ============================================

/// Outlined button with clean border
class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    this.borderColor,
    this.textColor,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.borderRadius,
    this.borderWidth,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double? height;
  final Color? borderColor;
  final Color? textColor;
  final Widget? icon;
  final IconPosition iconPosition;
  final double? borderRadius;
  final double? borderWidth;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = !isDisabled && !isLoading;
    final effectiveColor = textColor ?? AppColors.primary;
    final effectiveBorderRadius = borderRadius ?? ResponsiveSizes.radiusLg;
    final effectiveHeight = height ?? ResponsiveSizes.buttonHeight;
    final effectiveBorderWidth = borderWidth ?? 1.5.w;

    return Container(
      width: width ?? double.infinity,
      height: effectiveHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: Border.all(
          color: isEnabled
              ? (borderColor ?? effectiveColor)
              : (isDark ? AppColors.grey600 : AppColors.grey300),
          width: effectiveBorderWidth,
        ),
        color: Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          splashColor: effectiveColor.withValues(alpha: 0.12),
          highlightColor: effectiveColor.withValues(alpha: 0.06),
          child: Center(
            child: isLoading
                ? _LoadingIndicator(color: effectiveColor)
                : _ButtonContent(
                    text: text,
                    icon: icon,
                    iconPosition: iconPosition,
                    textColor: isEnabled
                        ? effectiveColor
                        : (isDark ? AppColors.grey500 : AppColors.grey400),
                    isDisabled: isDisabled,
                  ),
          ),
        ),
      ),
    );
  }
}

/// ============================================
/// TEXT BUTTON
/// ============================================

/// Simple text button with optional icon
class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.underline = false,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;
  final Widget? icon;
  final IconPosition iconPosition;
  final bool underline;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? AppColors.primary;

    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      ),
      child: isLoading
          ? _LoadingIndicator(color: color, size: 18.sp)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null && iconPosition == IconPosition.left) ...[
                  icon!,
                  RGap.w8,
                ],
                Text(
                  text,
                  style: AppTextStyles.buttonText.copyWith(
                    color: color,
                    fontSize: ResponsiveFontSizes.buttonSmall,
                    decoration: underline ? TextDecoration.underline : null,
                    decorationColor: color,
                  ),
                ),
                if (icon != null && iconPosition == IconPosition.right) ...[
                  RGap.w8,
                  icon!,
                ],
              ],
            ),
    );
  }
}

/// ============================================
/// ICON BUTTON
/// ============================================

/// Icon button with background
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size,
    this.iconSize,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius,
    this.border,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double? size;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? borderRadius;
  final BoxBorder? border;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveSize = size ?? 44.w;
    final effectiveIconSize = iconSize ?? 22.sp;
    final effectiveBgColor = backgroundColor ??
        (isDark ? AppColors.surfaceElevatedDark : AppColors.grey100);
    final effectiveIconColor = iconColor ??
        (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary);
    final effectiveBorderRadius = borderRadius ?? ResponsiveSizes.radiusMd;

    Widget button = Container(
      width: effectiveSize,
      height: effectiveSize,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: border ??
            (isDark
                ? Border.all(color: AppColors.borderDark, width: 1)
                : null),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          child: Center(
            child: Icon(
              icon,
              size: effectiveIconSize,
              color: effectiveIconColor,
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}

/// ============================================
/// SOCIAL BUTTON
/// ============================================

/// Social login button (Google, Apple, etc.)
class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  final String text;
  final VoidCallback? onPressed;
  final Widget icon;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBgColor = backgroundColor ??
        (isDark ? AppColors.surfaceElevatedDark : AppColors.white);
    final effectiveTextColor = textColor ??
        (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary);
    final effectiveBorderColor = borderColor ??
        (isDark ? AppColors.borderDark : AppColors.border);

    return SizedBox(
      width: double.infinity,
      height: ResponsiveSizes.buttonHeight,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: effectiveBgColor,
          foregroundColor: effectiveTextColor,
          side: BorderSide(color: effectiveBorderColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveSizes.radiusLg),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
        ),
        child: isLoading
            ? _LoadingIndicator(color: effectiveTextColor)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  RGap.w12,
                  Text(
                    text,
                    style: AppTextStyles.button.copyWith(
                      color: effectiveTextColor,
                      fontSize: ResponsiveFontSizes.button,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// ============================================
/// GLASS BUTTON
/// ============================================

/// Button with subtle glass effect for dark theme
class GlassButton extends StatelessWidget {
  const GlassButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.borderRadius,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final Widget? icon;
  final IconPosition iconPosition;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? ResponsiveSizes.radiusLg;
    final effectiveHeight = height ?? ResponsiveSizes.buttonHeight;

    return Container(
      width: width ?? double.infinity,
      height: effectiveHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        color: AppColors.glassWhite,
        border: Border.all(
          color: AppColors.glassBorder,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          splashColor: AppColors.glassWhiteStrong,
          highlightColor: AppColors.glassWhiteLight,
          child: Center(
            child: isLoading
                ? _LoadingIndicator(color: AppColors.white)
                : _ButtonContent(
                    text: text,
                    icon: icon,
                    iconPosition: iconPosition,
                    textColor: AppColors.white,
                    isDisabled: false,
                  ),
          ),
        ),
      ),
    );
  }
}

/// ============================================
/// BUTTON SIZE VARIANTS
/// ============================================

/// Small button variant
class AppButtonSmall extends StatelessWidget {
  const AppButtonSmall({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.gradient,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      gradient: gradient,
      backgroundColor: backgroundColor,
      textColor: textColor,
      icon: icon,
      height: ResponsiveSizes.buttonHeightSmall,
      borderRadius: ResponsiveSizes.radiusMd,
    );
  }
}

/// Chip-style button (for filters, tags)
class AppChipButton extends StatelessWidget {
  const AppChipButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSelected = false,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isSelected;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveSizes.radiusRound),
        color: isSelected
            ? AppColors.primary
            : (isDark ? AppColors.surfaceElevatedDark : AppColors.grey100),
        border: isSelected
            ? null
            : Border.all(
                color: isDark ? AppColors.borderDark : AppColors.border,
                width: 1,
              ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(ResponsiveSizes.radiusRound),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  IconTheme(
                    data: IconThemeData(
                      color: isSelected
                          ? AppColors.white
                          : (isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimary),
                      size: 16.sp,
                    ),
                    child: icon!,
                  ),
                  SizedBox(width: 6.w),
                ],
                Text(
                  text,
                  style: AppTextStyles.labelMedium.copyWith(
                    fontSize: ResponsiveFontSizes.labelMedium,
                    color: isSelected
                        ? AppColors.white
                        : (isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary),
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

/// ============================================
/// HELPER WIDGETS
/// ============================================

enum IconPosition { left, right }

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.text,
    required this.textColor,
    required this.isDisabled,
    this.icon,
    this.iconPosition = IconPosition.left,
  });

  final String text;
  final Widget? icon;
  final IconPosition iconPosition;
  final Color textColor;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null && iconPosition == IconPosition.left) ...[
          IconTheme(
            data: IconThemeData(color: textColor, size: 18.sp),
            child: icon!,
          ),
          RGap.w8,
        ],
        Flexible(
          child: Text(
            text,
            style: AppTextStyles.button.copyWith(
              color: textColor,
              fontSize: ResponsiveFontSizes.button,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (icon != null && iconPosition == IconPosition.right) ...[
          RGap.w8,
          IconTheme(
            data: IconThemeData(color: textColor, size: 18.sp),
            child: icon!,
          ),
        ],
      ],
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({
    required this.color,
    this.size,
  });

  final Color color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size ?? 22.sp;
    return SizedBox(
      width: effectiveSize,
      height: effectiveSize,
      child: CircularProgressIndicator(
        strokeWidth: 2.w,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}