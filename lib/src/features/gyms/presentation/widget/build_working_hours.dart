import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/features/gyms/domain/entities/gym.dart';

class BuildWorkingHours extends StatelessWidget {
  final Gym gym;
  const BuildWorkingHours({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    final todayHours = gym.workingHours.todayHours;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Opening Hours",
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600
          ),
        ),
        SizedBox(height: 8.h,),
        if (todayHours != null)
        Text(
          'Today: ${todayHours.formatted}',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        )
        else Text(
          'Hours not available',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondaryDark
          ),
        )
      ],
    );
  }
}
