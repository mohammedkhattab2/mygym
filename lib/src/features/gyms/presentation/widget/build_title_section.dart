import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/features/gyms/domain/entities/gym.dart';

class BuildTitleSection extends StatelessWidget {
  final Gym gym; 
  const BuildTitleSection({super.key,required this.gym});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                gym.name,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimaryDark,fontWeight: FontWeight.w700
                ),
              )
              ),
              if (gym.formattedDistance != null)...[
                SizedBox(width: 8.w,),
                Icon(
                  Icons.location_on_rounded,
                  color: AppColors.primary,
                  size: 18.sp,
                ),
                Text(gym.formattedDistance!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
                )
              ]
          ],
        ),
        SizedBox(height: 8.h,),
        Row(
          children: [
            Icon(
              Icons.star_rounded,
              color: AppColors.warning,
              size: 18.sp,
            ),SizedBox(width: 4.w,),
            Text(
              gym.rating.toStringAsFixed(1),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),SizedBox(width: 4.w,),
            Text(
              '(${gym.reviewCount} reviews)',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondaryDark,
              ) ,
            )
          ],
        ),
        SizedBox(height: 8.h,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.place_outlined,
              color: AppColors.textSecondaryDark,
              size: 18.sp,
            ),
            SizedBox(width: 4.w,),
            Expanded(
              child: Text(
                gym.address,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondaryDark,
                ) ,
              )
              )
          ],
        )
      ],
    );
  }
}
