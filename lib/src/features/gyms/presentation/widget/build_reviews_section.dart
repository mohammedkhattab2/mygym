import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/features/gyms/domain/repositories/gym_repository.dart';
import 'package:mygym/src/features/gyms/presentation/bloc/gyms_bloc.dart';
import 'package:mygym/src/features/gyms/presentation/views/show_add_review_bottom_sheet.dart';

class BuildReviewsSection extends StatelessWidget {
  final BuildContext context;
  final GymsState state;
  const BuildReviewsSection({
    super.key,
    required this.context,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final reviewStatus = state.reviewStatus;
    final reviews = state.reviews;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Reviews",
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        if (reviewStatus == GymsStatus.loading)
          const Center(child: CircularProgressIndicator())
        else if (reviews.isEmpty)
          Text(
            'No reviews yet. Be the first to review!',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          )
        else
          Column(
            children: reviews.take(3).map((r) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: _buildReviewItem(r),
              );
            }).toList(),
          ),
        SizedBox(height: 12.h),
        _buildAddReviewButton(context),
      ],
    );
  }

  Widget _buildReviewItem(GymReview review) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14.r,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                child: Text(
                  (review.userName?.isNotEmpty == true
                          ? review.userName![0]
                          : "U")
                      .toUpperCase(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  review.userName ?? "User",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.star_rounded, color: AppColors.warning, size: 16.sp),
              SizedBox(width: 4.w),
              Text(
                review.rating.toString(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          if (review.comment != null && review.comment!.isNotEmpty)
            Text(
              review.comment!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddReviewButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        showAddReviewBottomSheet(context);
      },
      child: Text(
        "Write a review",
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
