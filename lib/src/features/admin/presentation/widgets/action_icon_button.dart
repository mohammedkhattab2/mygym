import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

class ActionIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  const ActionIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
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

    return Tooltip(
      message: tooltip,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E1B4B), const Color(0xFF312E81)]
              : [Colors.white, const Color(0xFFF5F0FF)],
        ),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isDark ? 0.3 : 0.15),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      textStyle: TextStyle(
        color: isDark ? Colors.white : const Color(0xFF1A1A2E),
        fontSize: 12.sp,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(10.r),
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
                color: color.withValues(alpha: isDark ? 0.35 : 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: isDark ? 0.15 : 0.08),
                  blurRadius: 8,
                  spreadRadius: -2,
                  offset: const Offset(0, 2),
                ),
              ],
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
                size: 18.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}