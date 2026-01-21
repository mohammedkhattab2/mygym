import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';

class BuildHeader extends StatelessWidget {
  const BuildHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            gradient: AppColors.premiumGradient,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 30,
                spreadRadius: 5,
              )
            ]
          ),
          child: Icon(
            Icons.fitness_center_rounded,
            size: 40.sp,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 24.h,),
        Text(
          "Welcome Back",
          style: AppTextStyles.headlineLarge.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.h,),
        Text(
          "Sign in to continue your fitness journey",
          style: AppTextStyles.badgeLarge.copyWith(
            color: AppColors.textSecondaryDark,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}