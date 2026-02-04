import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

class PopupMenuItemContent extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const PopupMenuItemContent({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    // Generate secondary color for gradient
    final secondaryColor = HSLColor.fromColor(color)
        .withLightness((HSLColor.fromColor(color).lightness + 0.15).clamp(0.0, 1.0))
        .toColor();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: isDark ? 0.25 : 0.15),
                  secondaryColor.withValues(alpha: isDark ? 0.15 : 0.08),
                ],
              ),
              border: Border.all(
                color: color.withValues(alpha: isDark ? 0.3 : 0.2),
                width: 1,
              ),
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [color, secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Icon(
                icon,
                color: Colors.white,
                size: 16.sp,
              ),
            ),
          ),
          SizedBox(width: 14.w),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [color, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}