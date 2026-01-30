import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Premium Magical Hero Banner - Compact Edition
///
/// Features:
/// - Compact cosmic gradient with sparkle effects
/// - Refined decorative orbs
/// - Elegant glass badge
/// - Full Light/Dark mode compliance
/// - NO animations
class BuildBannar extends StatelessWidget {
  const BuildBannar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: double.infinity,
        height: 155.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha:  isDark ? 0.3 : 0.2),
              blurRadius: 25,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withValues(alpha:  0.85),
                      colorScheme.secondary.withValues(alpha:  0.7),
                      luxury.gold.withValues(alpha:  isDark ? 0.4 : 0.3),
                    ],
                    stops: const [0.0, 0.35, 0.65, 1.0],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              // Decorative orb
              Positioned(
                top: -30.h,
                right: -20.w,
                child: Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha:  0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Sparkles
              Positioned(
                top: 20.h,
                right: 50.w,
                child: _Sparkle(size: 3, color: Colors.white.withValues(alpha:  0.6)),
              ),
              Positioned(
                top: 50.h,
                right: 25.w,
                child: _Sparkle(size: 2, color: luxury.gold.withValues(alpha:  0.5)),
              ),

              // Border
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: luxury.gold.withValues(alpha:  isDark ? 0.25 : 0.15),
                    width: 1,
                  ),
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(18.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Badge
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha:  0.2),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: Colors.white.withValues(alpha:  0.25)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5.w,
                                  height: 5.w,
                                  decoration: BoxDecoration(
                                    color: luxury.gold,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  'LIMITED',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8.h),

                          // Headline
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [Colors.white, luxury.goldLight],
                            ).createShader(bounds),
                            child: Text(
                              'Get 20% Off',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),

                          Text(
                            "First month subscription",
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              color: Colors.white.withValues(alpha:  0.8),
                            ),
                          ),
                          SizedBox(height: 8.h),

                          // CTA
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [colorScheme.primary, luxury.gold],
                                  ).createShader(bounds),
                                  child: Text(
                                    'Claim',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [colorScheme.primary, luxury.gold],
                                  ).createShader(bounds),
                                  child: Icon(Icons.arrow_forward_rounded, size: 12.sp, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Icon
                    Container(
                      width: 70.w,
                      height: 70.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: luxury.gold.withValues(alpha: 0.3)),
                      ),
                      child: Center(
                        child: Text('💎', style: TextStyle(fontSize: 36.sp)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Sparkle extends StatelessWidget {
  final double size;
  final Color color;

  const _Sparkle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w * 2,
      height: size.w * 2,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: size * 2)],
      ),
    );
  }
}
