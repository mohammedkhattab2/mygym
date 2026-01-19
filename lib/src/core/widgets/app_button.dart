import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';

/// ============================================
/// PRIMARY BUTTON - Gradient with Glow
/// ============================================

/// Primary elevated button with gradient background and glow effect
class AppButton extends StatefulWidget {
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
    this.enableGlow = true,
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
  final bool enableGlow;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isDisabled && !widget.isLoading) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = !widget.isDisabled && !widget.isLoading;
    final effectiveGradient = widget.gradient ?? AppColors.primaryGradient;
    final effectiveBorderRadius =
        widget.borderRadius ?? AppTheme.borderRadiusLarge;
    final effectiveHeight = widget.height ?? AppTheme.buttonHeight;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: Container(
        width: widget.width ?? double.infinity,
        height: effectiveHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          gradient: isEnabled ? effectiveGradient : null,
          color: isEnabled ? null : (isDark ? AppColors.grey700 : AppColors.grey300),
          boxShadow: isEnabled && widget.enableGlow && isDark
              ? [
                  BoxShadow(
                    color: AppColors.primaryGlow,
                    blurRadius: _isPressed ? 20 : 16,
                    spreadRadius: _isPressed ? 2 : 0,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? widget.onPressed : null,
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            splashColor: AppColors.white.withValues(alpha: 0.2),
            highlightColor: AppColors.white.withValues(alpha: 0.1),
            child: Center(
              child: widget.isLoading
                  ? _LoadingIndicator(color: widget.textColor ?? AppColors.white)
                  : _ButtonContent(
                      text: widget.text,
                      icon: widget.icon,
                      iconPosition: widget.iconPosition,
                      textColor: widget.textColor ?? AppColors.white,
                      isDisabled: widget.isDisabled,
                    ),
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

/// Outlined button with optional gradient border
class AppOutlinedButton extends StatefulWidget {
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
    this.borderWidth = 2,
    this.useGradientBorder = false,
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
  final double borderWidth;
  final bool useGradientBorder;

  @override
  State<AppOutlinedButton> createState() => _AppOutlinedButtonState();
}

class _AppOutlinedButtonState extends State<AppOutlinedButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = !widget.isDisabled && !widget.isLoading;
    final effectiveColor = widget.textColor ?? AppColors.primary;
    final effectiveBorderRadius =
        widget.borderRadius ?? AppTheme.borderRadiusLarge;
    final effectiveHeight = widget.height ?? AppTheme.buttonHeight;

    Widget button = Container(
      width: widget.width ?? double.infinity,
      height: effectiveHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: widget.useGradientBorder
            ? null
            : Border.all(
                color: isEnabled
                    ? (widget.borderColor ?? effectiveColor)
                    : (isDark ? AppColors.grey600 : AppColors.grey300),
                width: widget.borderWidth,
              ),
        color: _isHovered ? effectiveColor.withValues(alpha: 0.1) : Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? widget.onPressed : null,
          onHover: (hovering) => setState(() => _isHovered = hovering),
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          splashColor: effectiveColor.withValues(alpha: 0.2),
          highlightColor: effectiveColor.withValues(alpha: 0.1),
          child: Center(
            child: widget.isLoading
                ? _LoadingIndicator(color: effectiveColor)
                : _ButtonContent(
                    text: widget.text,
                    icon: widget.icon,
                    iconPosition: widget.iconPosition,
                    textColor: isEnabled
                        ? effectiveColor
                        : (isDark ? AppColors.grey500 : AppColors.grey400),
                    isDisabled: widget.isDisabled,
                  ),
          ),
        ),
      ),
    );

    // Wrap with gradient border if needed
    if (widget.useGradientBorder && isEnabled) {
      button = _GradientBorderWrapper(
        borderRadius: effectiveBorderRadius,
        borderWidth: widget.borderWidth,
        gradient: AppColors.primaryGradient,
        child: button,
      );
    }

    return button;
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: isLoading
          ? _LoadingIndicator(color: color, size: 20)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null && iconPosition == IconPosition.left) ...[
                  icon!,
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: AppTextStyles.buttonText.copyWith(
                    color: color,
                    decoration: underline ? TextDecoration.underline : null,
                    decorationColor: color,
                  ),
                ),
                if (icon != null && iconPosition == IconPosition.right) ...[
                  const SizedBox(width: 8),
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
    this.size = 48,
    this.iconSize = 24,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius,
    this.border,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? borderRadius;
  final BoxBorder? border;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBgColor = backgroundColor ??
        (isDark ? AppColors.surfaceElevatedDark : AppColors.grey100);
    final effectiveIconColor = iconColor ??
        (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary);
    final effectiveBorderRadius =
        borderRadius ?? AppTheme.borderRadiusMedium;

    Widget button = Container(
      width: size,
      height: size,
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
              size: iconSize,
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
      height: AppTheme.buttonHeight,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: effectiveBgColor,
          foregroundColor: effectiveTextColor,
          side: BorderSide(color: effectiveBorderColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: isLoading
            ? _LoadingIndicator(color: effectiveTextColor)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: 12),
                  Text(
                    text,
                    style: AppTextStyles.button.copyWith(
                      color: effectiveTextColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// ============================================
/// GLASS BUTTON (Glassmorphism)
/// ============================================

/// Button with glassmorphism effect for dark theme
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
    final effectiveBorderRadius =
        borderRadius ?? AppTheme.borderRadiusLarge;
    final effectiveHeight = height ?? AppTheme.buttonHeight;

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
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
      ),
    );
  }
}

/// ============================================
/// GRADIENT BORDER BUTTON
/// ============================================

/// Button with animated gradient border
class GradientBorderButton extends StatelessWidget {
  const GradientBorderButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.gradient,
    this.borderWidth = 2,
    this.icon,
    this.iconPosition = IconPosition.left,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final Gradient? gradient;
  final double borderWidth;
  final Widget? icon;
  final IconPosition iconPosition;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveHeight = height ?? AppTheme.buttonHeight;
    final effectiveGradient = gradient ?? AppColors.primaryGradient;

    return _GradientBorderWrapper(
      borderRadius: AppTheme.borderRadiusLarge,
      borderWidth: borderWidth,
      gradient: effectiveGradient,
      child: Container(
        width: width ?? double.infinity,
        height: effectiveHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge - borderWidth),
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge - borderWidth),
            child: Center(
              child: isLoading
                  ? _LoadingIndicator(color: AppColors.primary)
                  : _ButtonContent(
                      text: text,
                      icon: icon,
                      iconPosition: iconPosition,
                      textColor: AppColors.primary,
                      isDisabled: false,
                    ),
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
            data: IconThemeData(color: textColor, size: 20),
            child: icon!,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: AppTextStyles.button.copyWith(color: textColor),
        ),
        if (icon != null && iconPosition == IconPosition.right) ...[
          const SizedBox(width: 8),
          IconTheme(
            data: IconThemeData(color: textColor, size: 20),
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
    this.size = 24,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

class _GradientBorderWrapper extends StatelessWidget {
  const _GradientBorderWrapper({
    required this.child,
    required this.borderRadius,
    required this.borderWidth,
    required this.gradient,
  });

  final Widget child;
  final double borderRadius;
  final double borderWidth;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: gradient,
      ),
      padding: EdgeInsets.all(borderWidth),
      child: child,
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
      height: AppTheme.buttonHeightSmall,
      borderRadius: AppTheme.borderRadiusMedium,
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
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusRound),
        gradient: isSelected ? AppColors.primaryGradient : null,
        color: isSelected
            ? null
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
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusRound),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      size: 18,
                    ),
                    child: icon!,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: AppTextStyles.labelMedium.copyWith(
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