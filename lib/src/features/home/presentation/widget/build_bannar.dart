import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Premium Luxury Hero Banner
///
/// Features:
/// - Multi-layer gradient with gold accents
/// - Animated shimmer effect on badge
/// - Glassmorphism icon container
/// - Multiple glow layers for depth
/// - Press animation
class BuildBannar extends StatefulWidget {
  const BuildBannar({super.key});

  @override
  State<BuildBannar> createState() => _BuildBannarState();
}

class _BuildBannarState extends State<BuildBannar>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(22.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primary.withValues(alpha: 0.8),
                  colorScheme.secondary,
                  luxury.gold.withValues(alpha: 0.4),
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: luxury.gold.withValues(alpha: 0.25),
                width: 1,
              ),
              boxShadow: [
                // Primary glow
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.4),
                  blurRadius: 30,
                  spreadRadius: 0,
                  offset: Offset(0, 12.h),
                ),
                // Gold accent glow
                BoxShadow(
                  color: luxury.gold.withValues(alpha: 0.15),
                  blurRadius: 40,
                  spreadRadius: 0,
                  offset: Offset(0, 8.h),
                ),
                // Deep shadow
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: Offset(0, 15.h),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background decorative elements
                Positioned(
                  top: -20.h,
                  right: -20.w,
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30.h,
                  left: 50.w,
                  child: Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: luxury.gold.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                // Main content
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Animated badge with shimmer
                          AnimatedBuilder(
                            animation: _shimmerController,
                            builder: (context, child) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      luxury.gold.withValues(alpha: 0.3),
                                      luxury.gold.withValues(alpha: 0.5),
                                      luxury.gold.withValues(alpha: 0.3),
                                    ],
                                    stops: [
                                      (_shimmerController.value - 0.3)
                                          .clamp(0.0, 1.0),
                                      _shimmerController.value,
                                      (_shimmerController.value + 0.3)
                                          .clamp(0.0, 1.0),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: luxury.gold.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '✨',
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      'EXCLUSIVE OFFER',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 14.h),
                          // Main headline
                          ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                colors: [
                                  Colors.white,
                                  luxury.goldLight,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            child: Text(
                              'Get 20% Off',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          // Subtitle
                          Text(
                            "On your first month subscription",
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.85),
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          // CTA button
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) {
                                    return LinearGradient(
                                      colors: [
                                        colorScheme.primary,
                                        luxury.gold,
                                      ],
                                    ).createShader(bounds);
                                  },
                                  child: Text(
                                    'Claim Now',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                ShaderMask(
                                  shaderCallback: (bounds) {
                                    return LinearGradient(
                                      colors: [
                                        colorScheme.primary,
                                        luxury.gold,
                                      ],
                                    ).createShader(bounds);
                                  },
                                  child: Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Icon container with glassmorphism
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.2),
                            Colors.white.withValues(alpha: 0.08),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: luxury.gold.withValues(alpha: 0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: luxury.gold.withValues(alpha: 0.15),
                            blurRadius: 20,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '💎',
                          style: TextStyle(fontSize: 40.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
