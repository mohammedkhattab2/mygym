import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text(
          "Settings",
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.surfaceDark,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
        children: [
          Text(
            "General",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimaryDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h,),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceElevatedDark,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language_rounded, color: AppColors.primary,),
                  title:  Text("Language",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                  
                  
                  ),
                  subtitle: Text(
                    "Change app language",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                  onTap: (){
                    context.go(RoutePaths.languageSettings);
                  },
                ),
                const Divider(height: 1,),
                ListTile(
                  leading: const Icon(Icons.notifications_rounded, color: AppColors.primary,),
                  title: Text("Notifications",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w600,
                  )),
                  subtitle: Text(
                    "Manage notifications perference",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),),
                    onTap: () {
                      context.go(RoutePaths.notificationSettings);
                    },

                ),
                
              ],
            ),
          ),
          SizedBox(height: 24.h,),
          Text(
            "Support",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimaryDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h,),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceElevatedDark,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.borderDark)
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.help_outline_rounded,color: AppColors.primary,),
                  title: Text("Help & Support",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w600,
                  ),),
                  subtitle: Text(
                    "FAQ , contact support , about app",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondaryDark,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  onTap: (){
                    context.go('${RoutePaths.settings}/support');
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}