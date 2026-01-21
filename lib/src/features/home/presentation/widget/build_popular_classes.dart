import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/features/classes/domain/entities/fitness_class.dart';
import 'package:mygym/src/features/home/data/datasources/home_dummy_data_source.dart';
import 'package:mygym/src/features/home/domain/entities/fitness_class_entity.dart';

class BuildPopularClasses extends StatelessWidget {
  const BuildPopularClasses({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Classes',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: _onSeeAllClasses,
                child: Text(
                  "see All",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: HomeDummyDataSource.classes.map((FitnessClass) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _buildClassCard(FitnessClass),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _onSeeAllClasses() {
    // todo : navigate to classes screen
  }
  void onClassTap(FitnessClassEntity FitnessClass) {
    // todo : navigate to class details screen
  }

  Widget? _buildClassCard(FitnessClassEntity fitnessClass) {
    return GestureDetector(
      onTap: () => onClassTap(fitnessClass),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Row(
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevatedDark,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  fitnessClass.emoji,
                  style: TextStyle(fontSize: 28.sp),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fitnessClass.name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'by ${fitnessClass.instructor}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  fitnessClass.time,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h,),
                Text(
                  fitnessClass.duration,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
