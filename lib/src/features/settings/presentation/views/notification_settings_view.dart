import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/features/profile/domain/entities/user_profile.dart';
import 'package:mygym/src/features/settings/presentation/cubit/settings_cubit.dart';

class NotificationSettingsView extends StatelessWidget {
  const NotificationSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text(
          "Notification",
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.surfaceDark,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final prefs = state.notificationPreferences;
          return ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              Text(
                "Channels",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              _buildSwitchTile(
                tile: "Push notifications",
                value: prefs.pushEnabled,
                onChanged: (v) =>
                    _updatPrefs(context, prefs.copyWith(pushEnabled: v)),
              ),
              _buildSwitchTile(
                tile: 'Email notifications', 
                value: prefs.emailEnabled, 
                onChanged: (v)=> _updatPrefs(context, prefs.copyWith(emailEnabled: v))
                ),
              _buildSwitchTile(
                tile: 'SMS notifications', 
                value: prefs.smsEnabled, 
                onChanged: (v)=> _updatPrefs(context, prefs.copyWith(smsEnabled: v))
                ),
                SizedBox(height: 8.h,),
                Text(
                  "Types",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h,),
                _buildSwitchTile(
                  tile: "Class Reminders", 
                  value: prefs.classReminders, 
                  onChanged: (v)=> _updatPrefs(context, prefs.copyWith(classReminders: v))
                  ),
                  _buildSwitchTile(
                    tile: 'Promotional offers', 
                    value: prefs.promotionalOffers, 
                    onChanged: (v)=> _updatPrefs(context, prefs.copyWith(promotionalOffers: v))
                  ),
                  _buildSwitchTile(
                    tile: 'Subscription alerts', 
                    value: prefs.subscriptionAlerts, 
                    onChanged: (v)=> _updatPrefs(context, prefs.copyWith(subscriptionAlerts: v))
                  ),
                  _buildSwitchTile(
                    tile: 'Visit reminders', 
                    value: prefs.visitReminders, 
                    onChanged: (v)=> _updatPrefs(context, prefs.copyWith(visitReminders: v))
                    ),
                  _buildSwitchTile(
                    tile: 'Weekly digest', 
                    value: prefs.weeklyDigest, 
                    onChanged: (v)=> _updatPrefs(context, prefs.copyWith(weeklyDigest: v))
                    )
                  

            ],
          );
        },
      ),
    );
  }

  Widget _buildSwitchTile({
    required String tile,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: SwitchListTile(
        title: Text(
          tile,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimaryDark,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
      ),
    );
  }

  Future<void> _updatPrefs(
    BuildContext context,
    NotificationPreferences prefs,
  ) async {
    await context.read<SettingsCubit>().updateNotificationPreferences(prefs);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("preferences updated")));
  }
}
