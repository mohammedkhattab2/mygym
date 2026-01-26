import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Premium Luxury Hero Banner
///
/// Features:
/// - Multi-layer gradient with gold accents
/// - Static premium badge design
/// - Glassmorphism icon container
/// - Multiple glow layers for depth
/// - Full Light/Dark mode compliance
/// - NO animations (static luxury design)
class BuildBannar extends StatelessWidget {
  const BuildBannar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(22.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary,
              colorScheme.primary.withValues(alpha: 0.85),
              colorScheme.secondary,
              luxury.gold.withValues(alpha: isDark ? 0.4 : 0.3),
            ],
            stops: const [0.0, 0.4, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: luxury.gold.withValues(alpha: isDark ? 0.25 : 0.2),
            width: 1,
          ),
          boxShadow: [
            // Primary glow
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: isDark ? 0.4 : 0.3),
              blurRadius: 30,
              spreadRadius: 0,
              offset: Offset(0, 12.h),
            ),
            // Gold accent glow
            BoxShadow(
              color: luxury.gold.withValues(alpha: isDark ? 0.15 : 0.1),
              blurRadius: 40,
              spreadRadius: 0,
              offset: Offset(0, 8.h),
            ),
            // Deep shadow
            BoxShadow(
              color: luxury.cardShadow.withValues(alpha: isDark ? 0.4 : 0.2),
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
                  color: colorScheme.onPrimary.withValues(alpha: 0.05),
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
                      // Static premium badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              luxury.gold.withValues(alpha: 0.4),
                              luxury.gold.withValues(alpha: 0.25),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
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
                                color: colorScheme.onPrimary,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 14.h),
                      // Main headline with gradient text
                      ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: [
                              colorScheme.onPrimary,
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
                            color: colorScheme.onPrimary,
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
                          color: colorScheme.onPrimary.withValues(alpha: 0.85),
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
                          color: colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: luxury.cardShadow.withValues(alpha: 0.3),
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
                                  color: colorScheme.onPrimary,
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
                                color: colorScheme.onPrimary,
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
                        colorScheme.onPrimary.withValues(alpha: 0.2),
                        colorScheme.onPrimary.withValues(alpha: 0.08),
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
    );
  }
}
