import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';

class BuildSearchBar extends StatelessWidget {
  const BuildSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: GestureDetector(
        onTap: _onSearchTab,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.borderDark)
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: AppColors.textSecondaryDark,
                size: 22.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  "search gyms , classes...",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTertiaryDark,
                  ),
                )
                ),
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r)
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: AppColors.primary,
                    size: 18.sp,
                  ),
                )
            ],
          ),
        ),
      ),
      );
  }
  void _onSearchTab() {
      // todo : navigate to search screen
    }
}