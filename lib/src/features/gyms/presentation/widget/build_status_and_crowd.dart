import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/features/gyms/domain/entities/gym.dart';

class BuildStatusAndCrowd extends StatelessWidget {
  final Gym gym;
  const BuildStatusAndCrowd({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    final crowdPercentage = gym.crowdPercentage;
    final crowdLevel = gym.crowdLevel;
    Color statuscolor;
    String statusText;
    if (!gym.isAvailable) {
      statuscolor = AppColors.error;
      statusText = "Closed";
    } else {
      statuscolor = AppColors.success;
      statusText = "Open now";
    }
    Color crowdColor = AppColors.textSecondaryDark;
    String crowdLable = "Not Available";
    if (crowdLevel == "low") {
      crowdColor = AppColors.success;
      crowdLable = "Low";
    } else if (crowdLevel == "medium") {
      crowdColor = AppColors.warning;
      crowdLable = "Medium";
    } else if (crowdLevel == "high") {
      crowdColor = AppColors.error;
      crowdLable = "High";
    }

    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: statuscolor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20.r)
          ),
          child: Row(
            children: [
              Icon(
                gym.isAvailable ? Icons.check_circle : Icons.cancel_outlined,
                color: statuscolor ,
                size: 16.sp,
              ),
              SizedBox(width: 6.w,),
              Text(
                statusText,
                style: AppTextStyles.bodySmall.copyWith(
                  color: statuscolor,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
        SizedBox(width: 12.w,),
        if (crowdLevel != null|| crowdPercentage != null )
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: crowdColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.people_alt_rounded,
                color: crowdColor,
                size: 16.sp,
              ),
              SizedBox(width: 6.w,),
              Text(
                crowdPercentage != null 
                ? '$crowdLable • $crowdPercentage%'
                : crowdLable,
                style:  AppTextStyles.bodySmall.copyWith(
                  color: crowdColor,
                  fontWeight: FontWeight.w600
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
