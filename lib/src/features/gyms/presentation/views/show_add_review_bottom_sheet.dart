import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/features/gyms/presentation/bloc/gyms_bloc.dart';

/// Shows a bottom sheet for adding a gym review.
void showAddReviewBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surfaceDark,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    isScrollControlled: true,
    builder: (ctx) {
      return _AddReviewContent(parentContext: context);
    },
  );
}

class _AddReviewContent extends StatefulWidget {
  final BuildContext parentContext;

  const _AddReviewContent({required this.parentContext});

  @override
  State<_AddReviewContent> createState() => _AddReviewContentState();
}

class _AddReviewContentState extends State<_AddReviewContent> {
  final _formKey = GlobalKey<FormState>();
  int _rating = 5;
  String? _comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.w,
        right: 16.w,
        top: 16.h,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.borderDark,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            Text(
              "Write a review",
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                final isSelected = starIndex <= _rating;
                return IconButton(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    setState(() {
                      _rating = starIndex;
                    });
                  },
                  icon: Icon(
                    Icons.star_rounded,
                    color: isSelected
                        ? AppColors.warning
                        : AppColors.borderDark,
                    size: 28.sp,
                  ),
                );
              }),
            ),
            SizedBox(height: 8.h),
            TextFormField(
              maxLines: 3,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimaryDark,
              ),
              decoration: InputDecoration(
                hintText: 'Share your experience...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiaryDark,
                ),
                filled: true,
                fillColor: AppColors.surfaceElevatedDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.borderDark),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.borderDark),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              onChanged: (value) => _comment = value,
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  "Submit",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  void _submitReview() {
    final bloc = widget.parentContext.read<GymsBloc>();
    final selectedGymId = bloc.state.selectedGym?.id;
    if (selectedGymId == null) {
      Navigator.of(context).pop();
      return;
    }
    bloc.add(
      GymsEvent.submitReview(
        gymId: selectedGymId,
        rating: _rating,
        comment: _comment?.trim().isEmpty == true ? null : _comment?.trim(),
      ),
    );
    Navigator.of(context).pop();
  }
}
