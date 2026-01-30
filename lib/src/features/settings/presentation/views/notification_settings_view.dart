import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/profile/domain/entities/user_profile.dart';
import 'package:mygym/src/features/settings/presentation/cubit/settings_cubit.dart';

class NotificationSettingsView extends StatelessWidget {
  const NotificationSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.surface,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final prefs = state.notificationPreferences;
          return ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              Text(
                "Channels",
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              _NotificationSwitchTile(
                title: "Push notifications",
                value: prefs.pushEnabled,
                onChanged: (v) => _updatePrefs(context, prefs.copyWith(pushEnabled: v)),
              ),
              _NotificationSwitchTile(
                title: 'Email notifications',
                value: prefs.emailEnabled,
                onChanged: (v) => _updatePrefs(context, prefs.copyWith(emailEnabled: v)),
              ),
              _NotificationSwitchTile(
                title: 'SMS notifications',
                value: prefs.smsEnabled,
                onChanged: (v) => _updatePrefs(context, prefs.copyWith(smsEnabled: v)),
              ),
              SizedBox(height: 16.h),
              Text(
                "Types",
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              _NotificationSwitchTile(
                title: "Class Reminders",
                value: prefs.classReminders,
                onChanged: (v) => _updatePrefs(context, prefs.copyWith(classReminders: v)),
              ),
              _NotificationSwitchTile(
                title: 'Promotional offers',
                value: prefs.promotionalOffers,
                onChanged: (v) => _updatePrefs(context, prefs.copyWith(promotionalOffers: v)),
              ),
              _NotificationSwitchTile(
                title: 'Subscription alerts',
                value: prefs.subscriptionAlerts,
                onChanged: (v) => _updatePrefs(context, prefs.copyWith(subscriptionAlerts: v)),
              ),
              _NotificationSwitchTile(
                title: 'Visit reminders',
                value: prefs.visitReminders,
                onChanged: (v) => _updatePrefs(context, prefs.copyWith(visitReminders: v)),
              ),
              _NotificationSwitchTile(
                title: 'Weekly digest',
                value: prefs.weeklyDigest,
                onChanged: (v) => _updatePrefs(context, prefs.copyWith(weeklyDigest: v)),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _updatePrefs(
    BuildContext context,
    NotificationPreferences prefs,
  ) async {
    await context.read<SettingsCubit>().updateNotificationPreferences(prefs);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preferences updated")),
      );
    }
  }
}

class _NotificationSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationSwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeTrackColor: colorScheme.primary.withValues(alpha: 0.5),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return null;
        }),
      ),
    );
  }
}
