import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/features/home/data/datasources/home_dummy_data_source.dart';
import 'package:mygym/src/features/home/domain/entities/gym_entity.dart';

class BuildNearbyGyms extends StatelessWidget {
  const BuildNearbyGyms({super.key});

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
                "Nearby Gyms",
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () => _onSeeAllGyms(context),
                child: Text(
                  "See all",
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
        SizedBox(
          height: 180.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            itemCount: HomeDummyDataSource.gyms.length,
            itemBuilder: (itemContext, index) {
              final gym = HomeDummyDataSource.gyms[index];
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: _buildGymCard(itemContext, gym),
              );
            },
          ),
        ),
      ],
    );
  }

  void _onSeeAllGyms(BuildContext context) {
    context.go(RoutePaths.gymsList);
  }
  
  void onGymTap(BuildContext context, GymEntity gym) {
    context.go('${RoutePaths.gyms}/${gym.id}');
  }

  Widget _buildGymCard(BuildContext context, GymEntity gym) {
    return GestureDetector(
      onTap: () => onGymTap(context, gym),
      child: Container(
        width: 160.w,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.borderDark)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 80.h,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevatedDark,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  gym.emoji,
                  style: TextStyle(fontSize: 36.sp),
                ),
              ),
            ),
            SizedBox(height: 12.h,),
            Text(
              gym.name,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.w600
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h,),
            Text(
              gym.location,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondaryDark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: AppColors.warning,
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w,),
                    Text(
                      gym.rating.toString(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimaryDark,
                        fontWeight: FontWeight.w600
                      ),
                    )
                  ],
                ),
                Text(
                  gym.distance,
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
