import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/features/support/presentation/cubit/support_cubit.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text(
          "About",
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.surfaceDark,
      ),
      body: BlocBuilder<SupportCubit, SupportState>(
        builder: (context, state) {
          final info = state.aboutInfo;
          if (state.isLoading && info == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (info == null) {
            return Center(
              child: Text(
                "No about info available",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
            );
          }
          return ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              Text(
                info.appName,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w700,
                ) ,
              ),SizedBox(height: 4.h,),
              Text(
                'v${info.version} (${info.buildNumber})',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
              SizedBox(height: 16.h,),
              Text(
                info.websiteUrl,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary
                ),
              ),
              SizedBox(height: 24.h,),
              Text(
                "Contact",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h,),
              Text(
                'Email: ${info.contactEmail}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondaryDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h,),
              Text(
                'Website: ${info.websiteUrl}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondaryDark,
                  fontWeight: FontWeight.bold,
                  ),
              ),
              SizedBox(height:  24.h),
              Text(
                info.copyright,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondaryDark,
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
