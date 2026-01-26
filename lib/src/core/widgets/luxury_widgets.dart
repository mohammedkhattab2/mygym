import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/responsive/responsive_utils.dart';

/// ============================================
/// LUXURY SHIMMER WIDGET
/// ============================================

/// Premium shimmer loading effect
class LuxuryShimmer extends StatelessWidget {
  const LuxuryShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.enabled = true,
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return Shimmer.fromColors(
      baseColor: baseColor ?? AppColors.surfaceElevatedDark,
      highlightColor: highlightColor ?? AppColors.borderLightDark,
      child: child,
    );
  }
}

/// Gold shimmer for premium elements
class GoldShimmer extends StatefulWidget {
  const GoldShimmer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 2000),
  });

  final Widget child;
  final Duration duration;

  @override
  State<GoldShimmer> createState() => _GoldShimmerState();
}

class _GoldShimmerState extends State<GoldShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                AppColors.gold.withValues(alpha: 0.0),
                AppColors.goldShimmer.withValues(alpha: 0.6),
                AppColors.gold.withValues(alpha: 0.0),
              ],
              stops: [
                (_controller.value - 0.3).clamp(0.0, 1.0),
                _controller.value,
                (_controller.value + 0.3).clamp(0.0, 1.0),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}

/// ============================================
/// LUXURY GLASSMORPHISM CARD
/// ============================================

/// Premium glass card with enhanced blur and borders
class LuxuryGlassCard extends StatelessWidget {
  const LuxuryGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = 15,
    this.opacity = 0.08,
    this.borderOpacity = 0.15,
    this.onTap,
    this.gradient,
    this.enableGlow = false,
    this.glowColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final double blur;
  final double opacity;
  final double borderOpacity;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final bool enableGlow;
  final Color? glowColor;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? ResponsiveSizes.radiusLg;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(effectiveRadius),
        boxShadow: enableGlow
            ? [
                BoxShadow(
                  color: glowColor ?? AppColors.primaryGlowLight,
                  blurRadius: 20.r,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(effectiveRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              gradient: gradient ??
                  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: opacity),
                      Colors.white.withValues(alpha: opacity * 0.5),
                    ],
                  ),
              borderRadius: BorderRadius.circular(effectiveRadius),
              border: Border.all(
                color: Colors.white.withValues(alpha: borderOpacity),
                width: 1.w,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: onTap != null
                  ? InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(effectiveRadius),
                      splashColor: AppColors.glassWhiteStrong,
                      highlightColor: AppColors.glassWhiteLight,
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
/// LUXURY GRADIENT BUTTON
/// ============================================

/// Premium button with gradient, glow, and press animation
class LuxuryButton extends StatefulWidget {
  const LuxuryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradient,
    this.width,
    this.height,
    this.borderRadius,
    this.icon,
    this.isLoading = false,
    this.enableGlow = true,
    this.glowIntensity = 0.4,
    this.textStyle,
  });

  final String text;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Widget? icon;
  final bool isLoading;
  final bool enableGlow;
  final double glowIntensity;
  final TextStyle? textStyle;

  @override
  State<LuxuryButton> createState() => _LuxuryButtonState();
}

class _LuxuryButtonState extends State<LuxuryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = widget.gradient ?? AppColors.primaryGradient;
    final effectiveRadius = widget.borderRadius ?? ResponsiveSizes.radiusLg;
    final effectiveHeight = widget.height ?? ResponsiveSizes.buttonHeight;
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        final glowValue = widget.enableGlow && isEnabled
            ? widget.glowIntensity + (_glowController.value * 0.2)
            : 0.0;

        return GestureDetector(
          onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
          onTapUp: isEnabled
              ? (_) {
                  setState(() => _isPressed = false);
                  widget.onPressed?.call();
                }
              : null,
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedScale(
            scale: _isPressed ? 0.97 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              width: widget.width ?? double.infinity,
              height: effectiveHeight,
              decoration: BoxDecoration(
                gradient: isEnabled ? effectiveGradient : null,
                color: isEnabled ? null : AppColors.grey700,
                borderRadius: BorderRadius.circular(effectiveRadius),
                boxShadow: isEnabled && widget.enableGlow
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: glowValue),
                          blurRadius: 20.r,
                          offset: Offset(0, 8.h),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: glowValue * 0.5),
                          blurRadius: 40.r,
                          offset: Offset(0, 16.h),
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5.w,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.white,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.icon != null) ...[
                            widget.icon!,
                            RGap.w8,
                          ],
                          Flexible(
                            child: Text(
                              widget.text,
                              style: widget.textStyle ??
                                  AppTextStyles.button.copyWith(
                                    fontSize: ResponsiveFontSizes.button,
                                    color: AppColors.white,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Gold luxury button for premium actions
class GoldButton extends StatelessWidget {
  const GoldButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.icon,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Widget? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return LuxuryButton(
      text: text,
      onPressed: onPressed,
      gradient: AppColors.goldGradient,
      width: width,
      height: height,
      icon: icon,
      isLoading: isLoading,
      glowIntensity: 0.3,
      textStyle: AppTextStyles.button.copyWith(
        fontSize: ResponsiveFontSizes.button,
        color: AppColors.backgroundDark,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

/// ============================================
/// LUXURY GLOW EFFECT
/// ============================================

/// Animated glow container for magical effects
class MagicalGlow extends StatefulWidget {
  const MagicalGlow({
    super.key,
    required this.child,
    this.glowColor,
    this.intensity = 0.4,
    this.blurRadius = 30,
    this.animate = true,
    this.duration = const Duration(milliseconds: 2000),
  });

  final Widget child;
  final Color? glowColor;
  final double intensity;
  final double blurRadius;
  final bool animate;
  final Duration duration;

  @override
  State<MagicalGlow> createState() => _MagicalGlowState();
}

class _MagicalGlowState extends State<MagicalGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final glowColor = widget.glowColor ?? AppColors.primary;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final animatedIntensity = widget.animate
            ? widget.intensity + (_controller.value * 0.2)
            : widget.intensity;

        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: glowColor.withValues(alpha: animatedIntensity * 0.3),
                blurRadius: widget.blurRadius.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// ============================================
/// LUXURY DIVIDER
/// ============================================

/// Elegant divider with gradient fade
class LuxuryDivider extends StatelessWidget {
  const LuxuryDivider({
    super.key,
    this.color,
    this.height,
    this.margin,
    this.useGradient = true,
  });

  final Color? color;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final bool useGradient;

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? 1.h;
    
    if (useGradient) {
      return Container(
        margin: margin ?? EdgeInsets.symmetric(vertical: 16.h),
        height: effectiveHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              (color ?? AppColors.borderDark).withValues(alpha: 0.5),
              color ?? AppColors.borderDark,
              (color ?? AppColors.borderDark).withValues(alpha: 0.5),
              Colors.transparent,
            ],
            stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
          ),
        ),
      );
    }

    return Container(
      margin: margin ?? EdgeInsets.symmetric(vertical: 16.h),
      height: effectiveHeight,
      color: color ?? AppColors.borderDark,
    );
  }
}

/// ============================================
/// LUXURY BADGE
/// ============================================

/// Premium badge with gradient background
class LuxuryBadge extends StatelessWidget {
  const LuxuryBadge({
    super.key,
    required this.text,
    this.gradient,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.padding,
  });

  final String text;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        gradient: gradient ?? (backgroundColor == null ? AppColors.primaryGradient : null),
        color: backgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveSizes.radiusRound),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 12.sp,
              color: textColor ?? AppColors.white,
            ),
            RGap.w4,
          ],
          Text(
            text,
            style: AppTextStyles.badge.copyWith(
              fontSize: ResponsiveFontSizes.labelSmall,
              color: textColor ?? AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Gold badge for premium/VIP status
class GoldBadge extends StatelessWidget {
  const GoldBadge({
    super.key,
    required this.text,
    this.icon,
  });

  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return LuxuryBadge(
      text: text,
      gradient: AppColors.goldGradient,
      textColor: AppColors.backgroundDark,
      icon: icon,
    );
  }
}

/// ============================================
/// ANIMATED FLOATING PARTICLES
/// ============================================

/// Floating particles background for magical atmosphere
class FloatingParticles extends StatefulWidget {
  const FloatingParticles({
    super.key,
    this.particleCount = 20,
    this.particleColor,
    this.minSize = 2,
    this.maxSize = 6,
  });

  final int particleCount;
  final Color? particleColor;
  final double minSize;
  final double maxSize;

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_ParticleData> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _initParticles();
  }

  void _initParticles() {
    final random = math.Random();
    _particles = List.generate(widget.particleCount, (index) {
      return _ParticleData(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: widget.minSize +
            random.nextDouble() * (widget.maxSize - widget.minSize),
        speed: 0.2 + random.nextDouble() * 0.5,
        opacity: 0.1 + random.nextDouble() * 0.3,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ParticlesPainter(
            particles: _particles,
            progress: _controller.value,
            color: widget.particleColor ?? AppColors.primary,
          ),
        );
      },
    );
  }
}

class _ParticleData {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;

  _ParticleData({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class _ParticlesPainter extends CustomPainter {
  final List<_ParticleData> particles;
  final double progress;
  final Color color;

  _ParticlesPainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      final animatedY = (particle.y - (progress * particle.speed)) % 1.0;
      final x = particle.x * size.width;
      final y = animatedY * size.height;

      final fadeMultiplier = animatedY < 0.1
          ? animatedY / 0.1
          : animatedY > 0.9
              ? (1.0 - animatedY) / 0.1
              : 1.0;

      paint.color = color.withValues(alpha: particle.opacity * fadeMultiplier);

      canvas.drawCircle(
        Offset(x, y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// ============================================
/// LUXURY SECTION HEADER
/// ============================================

/// Elegant section header with optional action
class LuxurySectionHeader extends StatelessWidget {
  const LuxurySectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.actionText,
    this.onActionPressed,
    this.useGoldAccent = false,
    this.padding,
  });

  final String title;
  final String? subtitle;
  final Widget? action;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final bool useGoldAccent;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontSize: ResponsiveFontSizes.titleLarge,
                    color: useGoldAccent
                        ? AppColors.gold
                        : AppColors.textPrimaryDark,
                  ),
                ),
                if (subtitle != null) ...[
                  RGap.h4,
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: ResponsiveFontSizes.bodySmall,
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) action!,
          if (actionText != null)
            TextButton(
              onPressed: onActionPressed,
              child: Text(
                actionText!,
                style: AppTextStyles.buttonText.copyWith(
                  fontSize: ResponsiveFontSizes.buttonSmall,
                  color: useGoldAccent ? AppColors.gold : AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// ============================================
/// LUXURY ICON CONTAINER
/// ============================================

/// Premium icon container with gradient and glow
class LuxuryIconContainer extends StatelessWidget {
  const LuxuryIconContainer({
    super.key,
    required this.icon,
    this.size,
    this.iconSize,
    this.gradient,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius,
    this.enableGlow = true,
    this.glowColor,
  });

  final IconData icon;
  final double? size;
  final double? iconSize;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? borderRadius;
  final bool enableGlow;
  final Color? glowColor;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size ?? 56.w;
    final effectiveIconSize = iconSize ?? 28.sp;
    final effectiveRadius = borderRadius ?? (effectiveSize / 3);

    return Container(
      width: effectiveSize,
      height: effectiveSize,
      decoration: BoxDecoration(
        gradient: gradient ?? (backgroundColor == null ? AppColors.primaryGradient : null),
        color: backgroundColor,
        borderRadius: BorderRadius.circular(effectiveRadius),
        boxShadow: enableGlow
            ? [
                BoxShadow(
                  color: glowColor ?? AppColors.primaryGlow,
                  blurRadius: 16.r,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Icon(
          icon,
          size: effectiveIconSize,
          color: iconColor ?? AppColors.white,
        ),
      ),
    );
  }
}

/// ============================================
/// ANIMATED GRADIENT BORDER
/// ============================================

/// Container with animated gradient border
class AnimatedGradientBorder extends StatefulWidget {
  const AnimatedGradientBorder({
    super.key,
    required this.child,
    this.borderWidth,
    this.borderRadius,
    this.gradient,
    this.duration = const Duration(seconds: 3),
  });

  final Widget child;
  final double? borderWidth;
  final double? borderRadius;
  final Gradient? gradient;
  final Duration duration;

  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = widget.borderRadius ?? ResponsiveSizes.radiusLg;
    final effectiveBorderWidth = widget.borderWidth ?? 2.w;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(effectiveRadius),
            gradient: SweepGradient(
              startAngle: _controller.value * 2 * math.pi,
              colors: const [
                AppColors.primary,
                AppColors.secondary,
                AppColors.gold,
                AppColors.primary,
              ],
            ),
          ),
          padding: EdgeInsets.all(effectiveBorderWidth),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(
                effectiveRadius - effectiveBorderWidth,
              ),
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// ============================================
/// RESPONSIVE SKELETON LOADERS
/// ============================================

/// Skeleton loader for cards
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
  });

  final double? height;
  final double? width;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return LuxuryShimmer(
      child: Container(
        height: height ?? 200.h,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceElevatedDark : AppColors.grey200,
          borderRadius: BorderRadius.circular(borderRadius ?? ResponsiveSizes.radiusLg),
        ),
      ),
    );
  }
}

/// Skeleton loader for text lines
class SkeletonText extends StatelessWidget {
  const SkeletonText({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  final double? width;
  final double? height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return LuxuryShimmer(
      child: Container(
        height: height ?? 16.h,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceElevatedDark : AppColors.grey200,
          borderRadius: BorderRadius.circular(borderRadius ?? ResponsiveSizes.radiusSm),
        ),
      ),
    );
  }
}

/// Skeleton loader for circular avatars
class SkeletonAvatar extends StatelessWidget {
  const SkeletonAvatar({
    super.key,
    this.size,
  });

  final double? size;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveSize = size ?? ResponsiveSizes.avatarMedium;
    
    return LuxuryShimmer(
      child: Container(
        height: effectiveSize,
        width: effectiveSize,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceElevatedDark : AppColors.grey200,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}