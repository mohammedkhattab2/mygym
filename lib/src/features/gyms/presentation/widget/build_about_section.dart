import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/features/gyms/domain/entities/gym.dart';

class BuildAboutSection extends StatelessWidget {
  final Gym gym;
  const BuildAboutSection({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    if (gym.description == null || gym.description!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About",
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600 , 
          ),
        ),
        SizedBox(height: 8.h,),
        Text(
          gym.description!,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondaryDark,
            height: 1.5,
          ),
        )
      ],
    );
  }
}
