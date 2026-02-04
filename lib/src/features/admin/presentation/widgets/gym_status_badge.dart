import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/admin/domain/entities/admin_gym.dart';

class GymStatusBadge extends StatelessWidget {
  final GymStatus status;
  final bool showIcon;
  final bool isCompact;

  const GymStatusBadge({
    super.key,
    required this.status,
    this.showIcon = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final config = _getStatusConfig(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 10.w : 14.w,
        vertical: isCompact ? 5.h : 7.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isCompact ? 10.r : 14.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            config.color.withValues(alpha: isDark ? 0.2 : 0.12),
            config.secondaryColor.withValues(alpha: isDark ? 0.1 : 0.06),
          ],
        ),
        border: Border.all(
          color: config.color.withValues(alpha: isDark ? 0.45 : 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: config.color.withValues(alpha: isDark ? 0.2 : 0.1),
            blurRadius: 8,
            spreadRadius: -2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Container(
              padding: EdgeInsets.all(isCompact ? 3.r : 4.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    config.color.withValues(alpha: isDark ? 0.35 : 0.25),
                    config.secondaryColor.withValues(alpha: isDark ? 0.2 : 0.15),
                  ],
                ),
              ),
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [config.color, config.secondaryColor],
                ).createShader(bounds),
                child: Icon(
                  config.icon,
                  color: Colors.white,
                  size: isCompact ? 10.sp : 12.sp,
                ),
              ),
            ),
            SizedBox(width: isCompact ? 6.w : 8.w),
          ],
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [config.color, config.secondaryColor],
            ).createShader(bounds),
            child: Text(
              status.displayName,
              style: GoogleFonts.inter(
                fontSize: isCompact ? 10.sp : 12.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(GymStatus status) {
    switch (status) {
      case GymStatus.active:
        return _StatusConfig(
          color: AppColors.success,
          secondaryColor: const Color(0xFF34D399),
          icon: Icons.check_circle_rounded,
        );
      case GymStatus.pending:
        return _StatusConfig(
          color: AppColors.warning,
          secondaryColor: const Color(0xFFFBBF24),
          icon: Icons.schedule_rounded,
        );
      case GymStatus.blocked:
        return _StatusConfig(
          color: AppColors.error,
          secondaryColor: const Color(0xFFF87171),
          icon: Icons.block_rounded,
        );
      case GymStatus.suspended:
        return _StatusConfig(
          color: AppColors.grey500,
          secondaryColor: const Color(0xFFA3A3A3),
          icon: Icons.pause_circle_rounded,
        );
    }
  }
}

class _StatusConfig {
  final Color color;
  final Color secondaryColor;
  final IconData icon;

  const _StatusConfig({
    required this.color,
    required this.secondaryColor,
    required this.icon,
  });
}
