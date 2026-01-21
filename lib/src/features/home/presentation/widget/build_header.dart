import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';

class BuildHeader extends StatelessWidget {
  final String userName;

  const BuildHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, $userName 👋",
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Ready to workout today?',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _onNotificationsTab,
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: Icon(
                Icons.notifications_outlined,
                color: AppColors.textPrimaryDark,
                size: 22.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w,),
          GestureDetector(
            onTap:_onProfileTab ,
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  userName[0].toUpperCase(),
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onNotificationsTab() {
    // todo : navigate to notifications screen
  }
  void _onProfileTab() {
      // todo : navigate to profile screen
    }
}
