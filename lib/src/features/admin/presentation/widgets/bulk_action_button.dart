import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

class BulkActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const BulkActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    // Generate secondary color for gradient
    final secondaryColor = HSLColor.fromColor(color)
        .withLightness((HSLColor.fromColor(color).lightness + 0.15).clamp(0.0, 1.0))
        .toColor();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: isDark ? 0.2 : 0.12),
                color.withValues(alpha: isDark ? 0.1 : 0.06),
              ],
            ),
            border: Border.all(
              color: color.withValues(alpha: isDark ? 0.4 : 0.25),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: isDark ? 0.2 : 0.1),
                blurRadius: 10,
                spreadRadius: -2,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: isDark ? 0.3 : 0.2),
                      secondaryColor.withValues(alpha: isDark ? 0.2 : 0.12),
                    ],
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
                    size: 14.sp,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [color, secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
