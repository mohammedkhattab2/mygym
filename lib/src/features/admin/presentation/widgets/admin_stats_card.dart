import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

class TrendDate {
  final double value;
  final bool isPositive;

  const TrendDate({required this.value, required this.isPositive});
}

class AdminStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final TrendDate? trend;
  final VoidCallback? onTap;

  const AdminStatsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.iconColor,
    this.trend,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    // Generate secondary color for gradient
    final secondaryColor = HSLColor.fromColor(iconColor)
        .withLightness((HSLColor.fromColor(iconColor).lightness + 0.15).clamp(0.0, 1.0))
        .toColor();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24.r),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF1E1B4B).withValues(alpha: 0.95),
                      const Color(0xFF312E81).withValues(alpha: 0.85),
                      const Color(0xFF1E1B4B).withValues(alpha: 0.95),
                    ]
                  : [
                      const Color(0xFFFFFBF5),
                      const Color(0xFFF5F0FF),
                      const Color(0xFFFFFBF5),
                    ],
              stops: const [0.0, 0.5, 1.0],
            ),
            border: Border.all(
              width: 1.5,
              color: iconColor.withValues(alpha: isDark ? 0.35 : 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? iconColor.withValues(alpha: 0.2)
                    : iconColor.withValues(alpha: 0.08),
                blurRadius: 30,
                offset: const Offset(0, 12),
                spreadRadius: -6,
              ),
              BoxShadow(
                color: isDark
                    ? AppColors.gold.withValues(alpha: 0.1)
                    : AppColors.gold.withValues(alpha: 0.04),
                blurRadius: 40,
                offset: const Offset(0, 8),
                spreadRadius: -8,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Stack(
                children: [
                  // Magical glow orb in corner
                  Positioned(
                    top: -40.r,
                    right: -40.r,
                    child: Container(
                      width: 120.r,
                      height: 120.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: isDark
                              ? [
                                  iconColor.withValues(alpha: 0.35),
                                  iconColor.withValues(alpha: 0.15),
                                  Colors.transparent,
                                ]
                              : [
                                  iconColor.withValues(alpha: 0.15),
                                  iconColor.withValues(alpha: 0.05),
                                  Colors.transparent,
                                ],
                        ),
                      ),
                    ),
                  ),
                  // Secondary decorative orb
                  Positioned(
                    bottom: -30.r,
                    left: -30.r,
                    child: Container(
                      width: 80.r,
                      height: 80.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: isDark
                              ? [
                                  AppColors.gold.withValues(alpha: 0.2),
                                  AppColors.gold.withValues(alpha: 0.08),
                                  Colors.transparent,
                                ]
                              : [
                                  AppColors.gold.withValues(alpha: 0.1),
                                  AppColors.gold.withValues(alpha: 0.03),
                                  Colors.transparent,
                                ],
                        ),
                      ),
                    ),
                  ),
                  // Floating sparkles
                  ..._buildSparkles(isDark, iconColor),
                  // Main content
                  Padding(
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildLuxuryIcon(isDark, iconColor, secondaryColor),
                            if (trend != null) _buildTrendBadge(isDark, trend!),
                          ],
                        ),
                        const Spacer(),
                        // Value with gradient shader
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: isDark
                                ? [Colors.white, const Color(0xFFE8E0FF)]
                                : [const Color(0xFF1A1A2E), iconColor.withValues(alpha: 0.8)],
                          ).createShader(bounds),
                          child: Text(
                            value,
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.5,
                              height: 1.1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Title
                        Text(
                          title,
                          style: GoogleFonts.raleway(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? luxury.textTertiary : colorScheme.onSurfaceVariant,
                            letterSpacing: 0.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (subtitle != null) ...[
                          SizedBox(height: 6.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5.r,
                                height: 5.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: iconColor.withValues(alpha: 0.7),
                                  boxShadow: [
                                    BoxShadow(
                                      color: iconColor.withValues(alpha: 0.3),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Flexible(
                                child: Text(
                                  subtitle!,
                                  style: GoogleFonts.raleway(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? luxury.textMuted
                                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                    letterSpacing: 0.2,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSparkles(bool isDark, Color color) {
    final sparkles = [
      _SparklePosition(top: 50, right: 20, size: 3),
      _SparklePosition(top: 80, right: 50, size: 2),
      _SparklePosition(bottom: 40, left: 60, size: 2),
    ];

    return sparkles.map((sparkle) {
      return Positioned(
        top: sparkle.top?.r,
        bottom: sparkle.bottom?.r,
        left: sparkle.left?.r,
        right: sparkle.right?.r,
        child: Container(
          width: sparkle.size.r,
          height: sparkle.size.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? AppColors.gold.withValues(alpha: 0.6)
                : AppColors.gold.withValues(alpha: 0.4),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: isDark ? 0.5 : 0.3),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildLuxuryIcon(bool isDark, Color primaryColor, Color secondaryColor) {
    return Container(
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withValues(alpha: 0.9),
            secondaryColor.withValues(alpha: 0.7),
            primaryColor.withValues(alpha: 0.5),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: isDark ? 0.4 : 0.25),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF1E1B4B), const Color(0xFF312E81)]
                : [Colors.white, const Color(0xFFF5F0FF)],
          ),
        ),
        child: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [primaryColor, secondaryColor],
          ).createShader(bounds),
          child: Icon(
            icon,
            color: Colors.white,
            size: 22.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildTrendBadge(bool isDark, TrendDate trend) {
    final isPositive = trend.isPositive;
    final trendColor = isPositive ? AppColors.success : AppColors.error;
    final secondaryTrendColor = isPositive
        ? const Color(0xFF34D399)
        : const Color(0xFFF87171);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            trendColor.withValues(alpha: isDark ? 0.2 : 0.12),
            trendColor.withValues(alpha: isDark ? 0.1 : 0.06),
          ],
        ),
        border: Border.all(
          color: trendColor.withValues(alpha: isDark ? 0.4 : 0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: trendColor.withValues(alpha: isDark ? 0.15 : 0.08),
            blurRadius: 8,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [trendColor, secondaryTrendColor],
            ).createShader(bounds),
            child: Icon(
              isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
              color: Colors.white,
              size: 14.sp,
            ),
          ),
          SizedBox(width: 4.w),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [trendColor, secondaryTrendColor],
            ).createShader(bounds),
            child: Text(
              '${trend.value.toStringAsFixed(0)}%',
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SparklePosition {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double size;

  _SparklePosition({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.size,
  });
}
