import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/admin_user.dart';

class UserStatusBadge extends StatelessWidget {
  final UserStatus status;

  const UserStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha:  0.12),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha:  0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 6.w),
          Text(
            status.displayName,
            style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(UserStatus status) {
    switch (status) {
      case UserStatus.active: return AppColors.success;
      case UserStatus.suspended: return AppColors.warning;
      case UserStatus.blocked: return AppColors.error;
    }
  }
}