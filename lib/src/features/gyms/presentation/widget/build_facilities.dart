import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/features/gyms/domain/entities/gym.dart';

class BuildFacilities extends StatelessWidget {
  final Gym gym;
  const BuildFacilities({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    if (gym.facilities.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Facilities",
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: gym.facilities.map((f) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevatedDark,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: Text(
                f,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimaryDark,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
