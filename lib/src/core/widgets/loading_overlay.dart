import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';

/// ============================================
/// FULL SCREEN LOADING
/// ============================================

/// Full screen loading indicator with optional message
class AppLoadingScreen extends StatelessWidget {
  const AppLoadingScreen({
    super.key,
    this.message,
    this.useGradient = true,
  });

  final String? message;
  final bool useGradient;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: useGradient && isDark ? AppColors.backgroundGradientDark : null,
          color: useGradient ? null : (isDark ? AppColors.backgroundDark : AppColors.background),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated loading indicator
              const _PulsingLoader(),
              
              if (message != null) ...[
                const SizedBox(height: 24),
                Text(
                  message!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// ============================================
/// LOADING OVERLAY
/// ============================================

/// Loading overlay with blur effect
class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.blur = 5,
    this.opacity = 0.5,
  });

  final bool isLoading;
  final Widget child;
  final String? message;
  final double blur;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: _BlurredOverlay(
              blur: blur,
              opacity: opacity,
              message: message,
            ),
          ),
      ],
    );
  }
}

class _BlurredOverlay extends StatelessWidget {
  const _BlurredOverlay({
    required this.blur,
    required this.opacity,
    this.message,
  });

  final double blur;
  final double opacity;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: Container(
        color: (isDark ? Colors.black : Colors.white).withValues(alpha:  opacity),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surface,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.border,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadowDark,
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _PulsingLoader(size: 48),
                if (message != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    message!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ============================================
/// LOADING INDICATORS
/// ============================================

/// Simple loading indicator
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.size = 24,
    this.strokeWidth = 2.5,
    this.color,
  });

  final double size;
  final double strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.primary,
        ),
      ),
    );
  }
}

/// Pulsing loader with glow effect
class _PulsingLoader extends StatefulWidget {
  const _PulsingLoader({this.size = 56});

  final double size;

  @override
  State<_PulsingLoader> createState() => _PulsingLoaderState();
}

class _PulsingLoaderState extends State<_PulsingLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
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
        return Stack(
          alignment: Alignment.center,
          children: [
            // Glow effect
            Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: widget.size * 1.5,
                height: widget.size * 1.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha:  _opacityAnimation.value * 0.5),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
            // Main loader
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Gradient spinning loader
class GradientLoader extends StatefulWidget {
  const GradientLoader({
    super.key,
    this.size = 48,
  });

  final double size;

  @override
  State<GradientLoader> createState() => _GradientLoaderState();
}

class _GradientLoaderState extends State<GradientLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
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
        return Transform.rotate(
          angle: _controller.value * 2 * 3.14159,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  AppColors.primary.withValues(alpha:  0),
                  AppColors.primary,
                ],
              ),
            ),
            child: Center(
              child: Container(
                width: widget.size - 8,
                height: widget.size - 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.backgroundDark
                      : AppColors.background,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// ============================================
/// SHIMMER LOADING
/// ============================================

/// Shimmer/Skeleton loading effect
class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = widget.baseColor ??
        (isDark ? AppColors.surfaceElevatedDark : AppColors.grey200);
    final highlightColor = widget.highlightColor ??
        (isDark ? AppColors.borderLightDark : AppColors.grey100);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
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
/// SKELETON SHAPES
/// ============================================

/// Skeleton box placeholder
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  final double width;
  final double height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceElevatedDark : AppColors.grey200,
        borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.borderRadiusSmall),
      ),
    );
  }
}

/// Skeleton circle placeholder
class SkeletonCircle extends StatelessWidget {
  const SkeletonCircle({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceElevatedDark : AppColors.grey200,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Skeleton line placeholder
class SkeletonLine extends StatelessWidget {
  const SkeletonLine({
    super.key,
    this.width,
    this.height = 16,
  });

  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceElevatedDark : AppColors.grey200,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}

/// ============================================
/// SKELETON CARDS
/// ============================================

/// Skeleton list item
class SkeletonListItem extends StatelessWidget {
  const SkeletonListItem({
    super.key,
    this.hasImage = true,
    this.imageSize = 56,
    this.lines = 2,
  });

  final bool hasImage;
  final double imageSize;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            if (hasImage) ...[
              SkeletonBox(
                width: imageSize,
                height: imageSize,
                borderRadius: AppTheme.borderRadiusMedium,
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(lines, (index) {
                  return Padding(
                    padding: EdgeInsets.only(top: index > 0 ? 8 : 0),
                    child: SkeletonLine(
                      width: index == 0 ? null : MediaQuery.of(context).size.width * 0.5,
                      height: index == 0 ? 18 : 14,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton gym card
class SkeletonGymCard extends StatelessWidget {
  const SkeletonGymCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ShimmerLoading(
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.border,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            SkeletonBox(
              width: double.infinity,
              height: 160,
              borderRadius: AppTheme.borderRadiusLarge,
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonLine(height: 20),
                  const SizedBox(height: 12),
                  SkeletonLine(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 14,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: List.generate(4, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: SkeletonBox(
                          width: 36,
                          height: 36,
                          borderRadius: AppTheme.borderRadiusSmall,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton subscription card
class SkeletonSubscriptionCard extends StatelessWidget {
  const SkeletonSubscriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ShimmerLoading(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.border,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                SkeletonBox(
                  width: 48,
                  height: 48,
                  borderRadius: AppTheme.borderRadiusMedium,
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(height: 20),
                      SizedBox(height: 8),
                      SkeletonLine(width: 80, height: 14),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Price
            const SkeletonLine(width: 150, height: 36),
            
            const SizedBox(height: 24),
            
            // Divider
            Container(
              height: 1,
              color: isDark ? AppColors.borderDark : AppColors.border,
            ),
            
            const SizedBox(height: 24),
            
            // Features
            ...List.generate(4, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    const SkeletonCircle(size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SkeletonLine(
                        width: MediaQuery.of(context).size.width * (0.5 + (index * 0.1)),
                        height: 14,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// Skeleton stats card
class SkeletonStatsCard extends StatelessWidget {
  const SkeletonStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ShimmerLoading(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.border,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SkeletonBox(
                  width: 44,
                  height: 44,
                  borderRadius: AppTheme.borderRadiusMedium,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: SkeletonLine(height: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SkeletonLine(width: 100, height: 32),
            const SizedBox(height: 8),
            const SkeletonLine(width: 80, height: 12),
          ],
        ),
      ),
    );
  }
}

/// ============================================
/// SKELETON LISTS
/// ============================================

/// Generate a list of skeleton items
class SkeletonList extends StatelessWidget {
  const SkeletonList({
    super.key,
    required this.itemCount,
    this.itemBuilder,
    this.padding,
    this.separatorHeight = 0,
  });

  final int itemCount;
  final Widget Function(BuildContext, int)? itemBuilder;
  final EdgeInsetsGeometry? padding;
  final double separatorHeight;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding ?? const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (_, _) => SizedBox(height: separatorHeight),
      itemBuilder: (context, index) {
        return itemBuilder?.call(context, index) ?? const SkeletonListItem();
      },
    );
  }
}

/// Generate a grid of skeleton cards
class SkeletonGrid extends StatelessWidget {
  const SkeletonGrid({
    super.key,
    required this.itemCount,
    this.crossAxisCount = 2,
    this.itemBuilder,
    this.padding,
    this.spacing = 16,
  });

  final int itemCount;
  final int crossAxisCount;
  final Widget Function(BuildContext, int)? itemBuilder;
  final EdgeInsetsGeometry? padding;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding ?? const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: 0.75,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return itemBuilder?.call(context, index) ?? const SkeletonGymCard();
      },
    );
  }
}