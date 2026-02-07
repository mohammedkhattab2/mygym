import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/admin_user.dart';

class UserRoleBadge extends StatelessWidget {
  final UserRole role;

  const UserRoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final config = _getRoleConfig(role);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha:  0.12),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: config.color.withValues(alpha:  0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 14.sp, color: config.color),
          SizedBox(width: 6.w),
          Text(
            role.displayName,
            style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w600, color: config.color),
          ),
        ],
      ),
    );
  }

  _RoleConfig _getRoleConfig(UserRole role) {
    switch (role) {
      case UserRole.member:
        return _RoleConfig(color: AppColors.info, icon: Icons.person_rounded);
      case UserRole.partner:
        return _RoleConfig(color: AppColors.warning, icon: Icons.store_rounded);
      case UserRole.admin:
        return _RoleConfig(color: AppColors.primary, icon: Icons.admin_panel_settings_rounded);
    }
  }
}

class _RoleConfig {
  final Color color;
  final IconData icon;
  const _RoleConfig({required this.color, required this.icon});
}