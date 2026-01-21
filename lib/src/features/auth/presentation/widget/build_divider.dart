import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';

class BuildDivider extends StatelessWidget {
  const BuildDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.borderDark,
          )
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "OR CONTINUE WITH",
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: AppColors.borderDark,
              )
              )
      ],
    );
  }
}