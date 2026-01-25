import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/gyms/presentation/bloc/gyms_bloc.dart';

/// Shows a bottom sheet for adding a gym review.
void showAddReviewBottomSheet(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  showModalBottomSheet(
    context: context,
    backgroundColor: colorScheme.surface,
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
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final textTheme = Theme.of(context).textTheme;
    const warningColor = Color(0xFFFFB020);

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
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            Text(
              "Write a review",
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
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
                        ? warningColor
                        : colorScheme.outline.withValues(alpha: 0.3),
                    size: 28.sp,
                  ),
                );
              }),
            ),
            SizedBox(height: 8.h),
            TextFormField(
              maxLines: 3,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Share your experience...',
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: luxury.textTertiary,
                ),
                filled: true,
                fillColor: luxury.surfaceElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: colorScheme.primary),
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
                  backgroundColor: colorScheme.primary,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  "Submit",
                  style: textTheme.bodyMedium?.copyWith(
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
