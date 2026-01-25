import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// ============================================
/// LOADING OVERLAY
/// ============================================

/// Full screen loading overlay with glassmorphism effect
class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.useGlass = true,
  });

  final bool isLoading;
  final Widget child;
  final String? message;
  final bool useGlass;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: useGlass ? _GlassOverlay(message: message) : _SolidOverlay(message: message),
          ),
      ],
    );
  }
}

class _GlassOverlay extends StatelessWidget {
  const _GlassOverlay({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        color: AppColors.glassOverlay,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            decoration: BoxDecoration(
              color: AppColors.glassWhiteStrong,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
              border: Border.all(color: AppColors.glassBorder, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLoadingIndicator(size: 40),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    message!,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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

class _SolidOverlay extends StatelessWidget {
  const _SolidOverlay({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: (isDark ? AppColors.backgroundDark : AppColors.background).withValues(alpha: 0.9),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLoadingIndicator(size: 40),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: TextStyle(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// ============================================
/// LOADING SCREEN
/// ============================================

/// Full screen loading indicator
class AppLoadingScreen extends StatelessWidget {
  const AppLoadingScreen({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLoadingIndicator(size: 48),
            if (message != null) ...[
              const SizedBox(height: 24),
              Text(
                message!,
                style: TextStyle(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// ============================================
/// LOADING INDICATOR
/// ============================================

/// Circular loading indicator with optional gradient
class AppLoadingIndicator extends StatefulWidget {
  const AppLoadingIndicator({
    super.key,
    this.size = 24,
    this.strokeWidth = 3,
    this.color,
    this.useGradient = true,
  });

  final double size;
  final double strokeWidth;
  final Color? color;
  final bool useGradient;

  @override
  State<AppLoadingIndicator> createState() => _AppLoadingIndicatorState();
}

class _AppLoadingIndicatorState extends State<AppLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.useGradient) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: CircularProgressIndicator(
          strokeWidth: widget.strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.color ?? AppColors.primary,
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * 3.14159,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: _GradientCircularProgressPainter(
                strokeWidth: widget.strokeWidth,
                gradient: AppColors.primaryGradient,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GradientCircularProgressPainter extends CustomPainter {
  _GradientCircularProgressPainter({
    required this.strokeWidth,
    required this.gradient,
  });

  final double strokeWidth;
  final Gradient gradient;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      3.14159 * 1.5,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ============================================
/// SHIMMER LOADING
/// ============================================

/// Shimmer loading effect for skeleton loaders
class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

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
      duration: widget.duration,
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
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
        (isDark ? AppColors.surfaceDark : AppColors.grey100);

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

/// Rectangular skeleton placeholder
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

/// Circular skeleton placeholder
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

/// Line skeleton placeholder
class SkeletonLine extends StatelessWidget {
  const SkeletonLine({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
  });

  final double? width;
  final double height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceElevatedDark : AppColors.grey200,
        borderRadius: BorderRadius.circular(borderRadius ?? 4),
      ),
    );
  }
}

/// ============================================
/// SKELETON COMPONENTS
/// ============================================

/// Skeleton for list items
class SkeletonListItem extends StatelessWidget {
  const SkeletonListItem({
    super.key,
    this.hasLeading = true,
    this.hasTrailing = false,
    this.lines = 2,
  });

  final bool hasLeading;
  final bool hasTrailing;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            if (hasLeading) ...[
              const SkeletonCircle(size: 48),
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
                      height: index == 0 ? 16 : 14,
                    ),
                  );
                }),
              ),
            ),
            if (hasTrailing) ...[
              const SizedBox(width: 16),
              const SkeletonBox(width: 60, height: 32),
            ],
          ],
        ),
      ),
    );
  }
}

/// Skeleton for cards
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    super.key,
    this.height = 200,
    this.hasImage = true,
    this.imageHeight = 120,
  });

  final double height;
  final bool hasImage;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ShimmerLoading(
      child: Container(
        height: height,
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
            if (hasImage)
              Container(
                height: imageHeight,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceElevatedDark : AppColors.grey200,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppTheme.kBorderRadiusLarge),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonLine(height: 18),
                  const SizedBox(height: 8),
                  SkeletonLine(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 14,
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

/// Skeleton for gym cards
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
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceElevatedDark : AppColors.grey200,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppTheme.kBorderRadiusLarge),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonLine(height: 20),
                  const SizedBox(height: 10),
                  SkeletonLine(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 14,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const SkeletonBox(width: 60, height: 28, borderRadius: 6),
                      const SizedBox(width: 8),
                      const SkeletonBox(width: 60, height: 28, borderRadius: 6),
                      const SizedBox(width: 8),
                      const SkeletonBox(width: 60, height: 28, borderRadius: 6),
                    ],
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

/// Skeleton for profile header
class SkeletonProfileHeader extends StatelessWidget {
  const SkeletonProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SkeletonCircle(size: 100),
            const SizedBox(height: 16),
            const SkeletonLine(width: 150, height: 24),
            const SizedBox(height: 8),
            const SkeletonLine(width: 100, height: 16),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                return Column(
                  children: const [
                    SkeletonBox(width: 50, height: 28),
                    SizedBox(height: 4),
                    SkeletonLine(width: 40, height: 12),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================
/// LOADING LIST
/// ============================================

/// List of skeleton items for loading states
class SkeletonListView extends StatelessWidget {
  const SkeletonListView({
    super.key,
    this.itemCount = 5,
    this.itemBuilder,
    this.padding,
    this.separator,
  });

  final int itemCount;
  final Widget Function(BuildContext, int)? itemBuilder;
  final EdgeInsetsGeometry? padding;
  final Widget? separator;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding ?? const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (_, _) => separator ?? const SizedBox(height: 12),
      itemBuilder: itemBuilder ?? (_, _) => const SkeletonListItem(),
    );
  }
}

/// Grid of skeleton cards for loading states
class SkeletonGridView extends StatelessWidget {
  const SkeletonGridView({
    super.key,
    this.itemCount = 4,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.75,
    this.itemBuilder,
    this.padding,
  });

  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;
  final Widget Function(BuildContext, int)? itemBuilder;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding ?? const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder ?? (_, _) => const SkeletonCard(),
    );
  }
}

/// ============================================
/// PULSING DOT INDICATOR
/// ============================================

/// Animated pulsing dots indicator
class PulsingDotsIndicator extends StatefulWidget {
  const PulsingDotsIndicator({
    super.key,
    this.color,
    this.size = 10,
    this.count = 3,
  });

  final Color? color;
  final double size;
  final int count;

  @override
  State<PulsingDotsIndicator> createState() => _PulsingDotsIndicatorState();
}

class _PulsingDotsIndicatorState extends State<PulsingDotsIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.count, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delay = index * 0.2;
            final animValue = ((_controller.value - delay) % 1.0).clamp(0.0, 1.0);
            final scale = 0.5 + (0.5 * (1 - (2 * animValue - 1).abs()));
            final opacity = 0.3 + (0.7 * (1 - (2 * animValue - 1).abs()));

            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.size * 0.3),
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}