import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

class PaginationButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const PaginationButton({
    super.key,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    final activeColors = [AppColors.gold, AppColors.goldLight];
    final disabledColors = [Colors.grey, Colors.grey.shade400];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: enabled
                  ? [
                      AppColors.gold.withValues(alpha: isDark ? 0.2 : 0.12),
                      AppColors.gold.withValues(alpha: isDark ? 0.1 : 0.06),
                    ]
                  : [
                      Colors.grey.withValues(alpha: isDark ? 0.15 : 0.08),
                      Colors.grey.withValues(alpha: isDark ? 0.08 : 0.04),
                    ],
            ),
            border: Border.all(
              color: enabled
                  ? AppColors.gold.withValues(alpha: isDark ? 0.4 : 0.25)
                  : Colors.grey.withValues(alpha: isDark ? 0.2 : 0.15),
              width: 1.5,
            ),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: isDark ? 0.25 : 0.12),
                      blurRadius: 12,
                      spreadRadius: -2,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: enabled ? activeColors : disabledColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Icon(
              icon,
              color: Colors.white,
              size: 22.sp,
            ),
          ),
        ),
      ),
    );
  }
}