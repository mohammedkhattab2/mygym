import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/features/settings/domain/entities/app_settings.dart';
import 'package:mygym/src/features/support/presentation/cubit/support_cubit.dart';

class FaqView extends StatelessWidget {
  const FaqView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text(
          "FAQ",
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.surfaceDark,
      ),
      body: BlocBuilder<SupportCubit, SupportState>(
        builder: (context, state) {
          if (state.isLoading && state.faqItems.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null && state.faqItems.isEmpty) {
            return Center(
              child: Text(
                state.errorMessage!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            );
          }
          final faq = state.faqItems;
          if (faq.isEmpty) {
            return Center(
              child: Text(
                "No faq available",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: faq.length,
            itemBuilder: (context, index) {
              final item = faq[index];
              return _buildFaqItem(item);
            },
          );
        },
      ),
    );
  }

  Widget _buildFaqItem(FaqItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderDark)
      ),
      child: ExpansionTile(
        title: Text(
          item.question,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              item.answer,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            )
        ],
        ),
    );
  }
}
