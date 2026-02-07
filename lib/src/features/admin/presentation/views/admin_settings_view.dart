import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

class AdminSettingsView extends StatefulWidget {
  const AdminSettingsView({super.key});

  @override
  State<AdminSettingsView> createState() => _AdminSettingsViewState();
}

class _AdminSettingsViewState extends State<AdminSettingsView> {
  // Settings State
  bool _maintenanceMode = false;
  bool _allowNewRegistrations = true;
  bool _requireEmailVerification = true;
  bool _enablePushNotifications = true;
  bool _enableEmailNotifications = true;
  bool _enableSMSNotifications = false;
  bool _twoFactorAuth = false;
  bool _autoBackup = true;
  String _selectedCurrency = 'EGP';
  String _selectedLanguage = 'English';
  String _selectedTimezone = 'Africa/Cairo';
  int _sessionTimeout = 30;
  int _maxLoginAttempts = 5;
  double _platformFeePercent = 30.0;

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF0A0A0F),
                    const Color(0xFF0F0F18),
                    const Color(0xFF0A0A0F),
                  ]
                : [
                    const Color(0xFFFFFBF8),
                    const Color(0xFFF8F5FF),
                    const Color(0xFFFFFBF8),
                  ],
          ),
        ),
        child: Stack(
          children: [
            // Background magical orbs
            ..._buildBackgroundOrbs(isDark),
            // Main content
            SingleChildScrollView(
              padding: EdgeInsets.all(24.r),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 900.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      SizedBox(height: 32.h),
                      _buildSettingsSection(
                        context,
                        title: 'General Settings',
                        icon: Icons.settings_rounded,
                        color: AppColors.primary,
                        children: [
                          _buildToggleSetting(
                            context,
                            title: 'Maintenance Mode',
                            subtitle: 'Temporarily disable the app for all users',
                            icon: Icons.construction_rounded,
                            value: _maintenanceMode,
                            isDestructive: true,
                            onChanged: (v) => setState(() => _maintenanceMode = v),
                          ),
                          _buildGradientDivider(context),
                          _buildToggleSetting(
                            context,
                            title: 'Allow New Registrations',
                            subtitle: 'Enable new users to create accounts',
                            icon: Icons.person_add_rounded,
                            value: _allowNewRegistrations,
                            onChanged: (v) =>
                                setState(() => _allowNewRegistrations = v),
                          ),
                          _buildGradientDivider(context),
                          _buildToggleSetting(
                            context,
                            title: 'Require Email Verification',
                            subtitle:
                                'Users must verify email before accessing features',
                            icon: Icons.mark_email_read_rounded,
                            value: _requireEmailVerification,
                            onChanged: (v) =>
                                setState(() => _requireEmailVerification = v),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      _buildSettingsSection(
                        context,
                        title: 'Platform Settings',
                        icon: Icons.tune_rounded,
                        color: AppColors.info,
                        children: [
                          _buildDropdownSetting(
                            context,
                            title: 'Default Currency',
                            subtitle: 'Currency used for all transactions',
                            icon: Icons.attach_money_rounded,
                            value: _selectedCurrency,
                            items: ['EGP', 'USD', 'EUR', 'SAR', 'AED'],
                            onChanged: (v) => setState(() => _selectedCurrency = v!),
                          ),
                          _buildGradientDivider(context),
                          _buildDropdownSetting(
                            context,
                            title: 'Default Language',
                            subtitle: 'Default language for new users',
                            icon: Icons.language_rounded,
                            value: _selectedLanguage,
                            items: ['English', 'Arabic', 'French'],
                            onChanged: (v) => setState(() => _selectedLanguage = v!),
                          ),
                          _buildGradientDivider(context),
                          _buildDropdownSetting(
                            context,
                            title: 'Timezone',
                            subtitle: 'Default timezone for the platform',
                            icon: Icons.schedule_rounded,
                            value: _selectedTimezone,
                            items: [
                              'Africa/Cairo',
                              'Asia/Riyadh',
                              'Europe/London',
                              'America/New_York',
                            ],
                            onChanged: (v) => setState(() => _selectedTimezone = v!),
                          ),
                          _buildGradientDivider(context),
                          _buildSliderSetting(
                            context,
                            title: 'Platform Fee',
                            subtitle: 'Percentage taken from each subscription',
                            icon: Icons.percent_rounded,
                            value: _platformFeePercent,
                            min: 0,
                            max: 50,
                            suffix: '%',
                            onChanged: (v) => setState(() => _platformFeePercent = v),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      _buildSettingsSection(
                        context,
                        title: 'Notifications',
                        icon: Icons.notifications_rounded,
                        color: luxury.gold,
                        children: [
                          _buildToggleSetting(
                            context,
                            title: 'Push Notifications',
                            subtitle: 'Send push notifications to users',
                            icon: Icons.phone_android_rounded,
                            value: _enablePushNotifications,
                            onChanged: (v) =>
                                setState(() => _enablePushNotifications = v),
                          ),
                          _buildGradientDivider(context),
                          _buildToggleSetting(
                            context,
                            title: 'Email Notifications',
                            subtitle: 'Send email notifications for important events',
                            icon: Icons.email_rounded,
                            value: _enableEmailNotifications,
                            onChanged: (v) =>
                                setState(() => _enableEmailNotifications = v),
                          ),
                          _buildGradientDivider(context),
                          _buildToggleSetting(
                            context,
                            title: 'SMS Notifications',
                            subtitle:
                                'Send SMS for critical alerts (additional cost)',
                            icon: Icons.sms_rounded,
                            value: _enableSMSNotifications,
                            onChanged: (v) =>
                                setState(() => _enableSMSNotifications = v),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      _buildSettingsSection(
                        context,
                        title: 'Security',
                        icon: Icons.security_rounded,
                        color: AppColors.success,
                        children: [
                          _buildToggleSetting(
                            context,
                            title: 'Two-Factor Authentication',
                            subtitle: 'Require 2FA for admin accounts',
                            icon: Icons.phonelink_lock_rounded,
                            value: _twoFactorAuth,
                            onChanged: (v) => setState(() => _twoFactorAuth = v),
                          ),
                          _buildGradientDivider(context),
                          _buildSliderSetting(
                            context,
                            title: 'Session Timeout',
                            subtitle: 'Auto logout after inactivity',
                            icon: Icons.timer_rounded,
                            value: _sessionTimeout.toDouble(),
                            min: 5,
                            max: 120,
                            divisions: 23,
                            suffix: ' min',
                            onChanged: (v) =>
                                setState(() => _sessionTimeout = v.toInt()),
                          ),
                          _buildGradientDivider(context),
                          _buildSliderSetting(
                            context,
                            title: 'Max Login Attempts',
                            subtitle: 'Lock account after failed attempts',
                            icon: Icons.lock_clock_rounded,
                            value: _maxLoginAttempts.toDouble(),
                            min: 3,
                            max: 10,
                            divisions: 7,
                            suffix: ' attempts',
                            onChanged: (v) =>
                                setState(() => _maxLoginAttempts = v.toInt()),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      _buildSettingsSection(
                        context,
                        title: 'Backup & Data',
                        icon: Icons.backup_rounded,
                        color: AppColors.warning,
                        children: [
                          _buildToggleSetting(
                            context,
                            title: 'Automatic Backup',
                            subtitle: 'Daily backup of all data to cloud storage',
                            icon: Icons.cloud_upload_rounded,
                            value: _autoBackup,
                            onChanged: (v) => setState(() => _autoBackup = v),
                          ),
                          _buildGradientDivider(context),
                          _buildActionSetting(
                            context,
                            title: 'Export All Data',
                            subtitle: 'Download complete data export (CSV/JSON)',
                            icon: Icons.download_rounded,
                            actionLabel: 'Export',
                            onTap: () => _handleExport(context),
                          ),
                          _buildGradientDivider(context),
                          _buildActionSetting(
                            context,
                            title: 'Clear Cache',
                            subtitle: 'Clear temporary files and cached data',
                            icon: Icons.cleaning_services_rounded,
                            actionLabel: 'Clear',
                            onTap: () => _handleClearCache(context),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      _buildSettingsSection(
                        context,
                        title: 'Danger Zone',
                        icon: Icons.warning_rounded,
                        color: AppColors.error,
                        isDanger: true,
                        children: [
                          _buildActionSetting(
                            context,
                            title: 'Reset All Settings',
                            subtitle: 'Restore all settings to default values',
                            icon: Icons.restore_rounded,
                            actionLabel: 'Reset',
                            isDestructive: true,
                            onTap: () => _handleResetSettings(context),
                          ),
                          _buildGradientDivider(context, isDanger: true),
                          _buildActionSetting(
                            context,
                            title: 'Delete All Data',
                            subtitle: 'Permanently delete all platform data',
                            icon: Icons.delete_forever_rounded,
                            actionLabel: 'Delete',
                            isDestructive: true,
                            onTap: () => _handleDeleteAllData(context),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      _buildAboutSection(context),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBackgroundOrbs(bool isDark) {
    return [
      Positioned(
        top: -80.r,
        right: -40.r,
        child: Container(
          width: 250.r,
          height: 250.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: isDark
                  ? [
                      AppColors.primary.withValues(alpha: 0.12),
                      AppColors.primary.withValues(alpha: 0.04),
                      Colors.transparent,
                    ]
                  : [
                      AppColors.primary.withValues(alpha: 0.06),
                      AppColors.primary.withValues(alpha: 0.02),
                      Colors.transparent,
                    ],
            ),
          ),
        ),
      ),
      Positioned(
        top: 400.r,
        left: -100.r,
        child: Container(
          width: 200.r,
          height: 200.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: isDark
                  ? [
                      AppColors.gold.withValues(alpha: 0.1),
                      AppColors.gold.withValues(alpha: 0.03),
                      Colors.transparent,
                    ]
                  : [
                      AppColors.gold.withValues(alpha: 0.05),
                      AppColors.gold.withValues(alpha: 0.015),
                      Colors.transparent,
                    ],
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 100.r,
        right: -60.r,
        child: Container(
          width: 180.r,
          height: 180.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: isDark
                  ? [
                      AppColors.secondary.withValues(alpha: 0.08),
                      AppColors.secondary.withValues(alpha: 0.02),
                      Colors.transparent,
                    ]
                  : [
                      AppColors.secondary.withValues(alpha: 0.04),
                      AppColors.secondary.withValues(alpha: 0.01),
                      Colors.transparent,
                    ],
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background decorative layer
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            const Color(0xFF2D2A5E).withValues(alpha: 0.9),
                            const Color(0xFF1E1B4B).withValues(alpha: 0.95),
                          ]
                        : [
                            Colors.white.withValues(alpha: 0.95),
                            const Color(0xFFF5F0FF).withValues(alpha: 0.9),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
            ),
          ),
        ),
        // Main container
        Container(
          padding: EdgeInsets.all(28.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              width: 2,
              color: Colors.transparent,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                luxury.gold.withValues(alpha: 0.15),
                Colors.transparent,
                luxury.gold.withValues(alpha: 0.08),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              width: 1.5,
              color: luxury.gold.withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with breadcrumb and actions
              Wrap(
                spacing: 12.w,
                runSpacing: 8.h,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Breadcrumb trail
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: luxury.gold.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.dashboard_rounded,
                          size: 14.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Admin',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Icon(
                            Icons.chevron_right_rounded,
                            size: 16.sp,
                            color: luxury.gold.withValues(alpha: 0.6),
                          ),
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [luxury.gold, luxury.gold.withValues(alpha: 0.8)],
                          ).createShader(bounds),
                          child: Text(
                            'Settings',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status indicator
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.success.withValues(alpha: 0.15),
                          AppColors.success.withValues(alpha: 0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.success.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.success.withValues(alpha: 0.5),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'All Systems Operational',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              // Main content row
              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 600;
                  if (isCompact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon and Title row
                        Row(
                          children: [
                            // Icon with decorative ring
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 60.r,
                                  height: 60.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: SweepGradient(
                                      colors: [
                                        luxury.gold.withValues(alpha: 0.4),
                                        luxury.gold.withValues(alpha: 0.1),
                                        luxury.gold.withValues(alpha: 0.4),
                                        luxury.gold.withValues(alpha: 0.1),
                                        luxury.gold.withValues(alpha: 0.4),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 52.r,
                                  height: 52.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: isDark
                                          ? [const Color(0xFF2D2A5E), const Color(0xFF1E1B4B)]
                                          : [Colors.white, const Color(0xFFF5F0FF)],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: luxury.gold.withValues(alpha: 0.3),
                                        blurRadius: 20,
                                        spreadRadius: -5,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.r),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [luxury.gold, const Color(0xFFD4A574)],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: luxury.gold.withValues(alpha: 0.5),
                                        blurRadius: 16,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.settings_suggest_rounded,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: [
                                        colorScheme.onSurface,
                                        colorScheme.onSurface.withValues(alpha: 0.9),
                                      ],
                                    ).createShader(bounds),
                                    child: Text(
                                      "Admin Settings",
                                      style: GoogleFonts.cormorantGaramond(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    "Platform Configuration Center",
                                    style: GoogleFonts.raleway(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color: luxury.gold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        // Description
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.04)
                                : Colors.black.withValues(alpha: 0.02),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: luxury.gold.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  color: luxury.gold.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.info_outline_rounded,
                                  size: 16.sp,
                                  color: luxury.gold,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  "Manage platform preferences, security settings, notifications, and system configurations.",
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: colorScheme.onSurfaceVariant,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Action buttons
                        Wrap(
                          spacing: 12.w,
                          runSpacing: 8.h,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [luxury.gold, const Color(0xFFD4A574)],
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: luxury.gold.withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _handleSaveSettings(context),
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.save_rounded, color: Colors.white, size: 16.sp),
                                        SizedBox(width: 8.w),
                                        Text(
                                          "Save",
                                          style: GoogleFonts.inter(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.06)
                                    : Colors.black.withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _handleResetSettings(context),
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.refresh_rounded,
                                          color: colorScheme.onSurfaceVariant,
                                          size: 16.sp,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          "Reset",
                                          style: GoogleFonts.inter(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon with decorative ring
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer decorative ring
                          Container(
                            width: 80.r,
                            height: 80.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: SweepGradient(
                                colors: [
                                  luxury.gold.withValues(alpha: 0.4),
                                  luxury.gold.withValues(alpha: 0.1),
                                  luxury.gold.withValues(alpha: 0.4),
                                  luxury.gold.withValues(alpha: 0.1),
                                  luxury.gold.withValues(alpha: 0.4),
                                ],
                              ),
                            ),
                          ),
                          // Inner circle
                          Container(
                            width: 70.r,
                            height: 70.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isDark
                                    ? [
                                        const Color(0xFF2D2A5E),
                                        const Color(0xFF1E1B4B),
                                      ]
                                    : [
                                        Colors.white,
                                        const Color(0xFFF5F0FF),
                                      ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: luxury.gold.withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  spreadRadius: -5,
                                ),
                              ],
                            ),
                          ),
                          // Icon container
                          Container(
                            padding: EdgeInsets.all(14.r),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  luxury.gold,
                                  const Color(0xFFD4A574),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: luxury.gold.withValues(alpha: 0.5),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.settings_suggest_rounded,
                              color: Colors.white,
                              size: 26.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 24.w),
                      // Title and description
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title with decorative line
                            Row(
                              children: [
                                Container(
                                  width: 4.w,
                                  height: 32.h,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        luxury.gold,
                                        luxury.gold.withValues(alpha: 0.3),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(2.r),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ShaderMask(
                                        shaderCallback: (bounds) => LinearGradient(
                                          colors: [
                                            colorScheme.onSurface,
                                            colorScheme.onSurface.withValues(alpha: 0.9),
                                          ],
                                        ).createShader(bounds),
                                        child: Text(
                                          "Admin Settings",
                                          style: GoogleFonts.cormorantGaramond(
                                            fontSize: 32.sp,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        "Platform Configuration Center",
                                        style: GoogleFonts.raleway(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                          color: luxury.gold,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            // Description with icon
                            Container(
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.04)
                                    : Colors.black.withValues(alpha: 0.02),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: luxury.gold.withValues(alpha: 0.1),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.r),
                                    decoration: BoxDecoration(
                                      color: luxury.gold.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(
                                      Icons.info_outline_rounded,
                                      size: 16.sp,
                                      color: luxury.gold,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Text(
                                      "Manage platform preferences, security settings, notifications, and system configurations from this central hub.",
                                      style: GoogleFonts.inter(
                                        fontSize: 13.sp,
                                        color: colorScheme.onSurfaceVariant,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 24.w),
                      // Action buttons column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Primary save button
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  luxury.gold,
                                  const Color(0xFFD4A574),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14.r),
                              boxShadow: [
                                BoxShadow(
                                  color: luxury.gold.withValues(alpha: 0.4),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _handleSaveSettings(context),
                                borderRadius: BorderRadius.circular(14.r),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 16.h),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(6.r),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(6.r),
                                        ),
                                        child: Icon(
                                          Icons.save_rounded,
                                          color: Colors.white,
                                          size: 16.sp,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        "Save All Changes",
                                        style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          // Secondary reset button
                          Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.06)
                                  : Colors.black.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _handleResetSettings(context),
                                borderRadius: BorderRadius.circular(12.r),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.refresh_rounded,
                                        color: colorScheme.onSurfaceVariant,
                                        size: 16.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        "Reset to Default",
                                        style: GoogleFonts.inter(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 20.h),
              // Bottom decorative divider with stats
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      luxury.gold.withValues(alpha: isDark ? 0.08 : 0.05),
                      Colors.transparent,
                      luxury.gold.withValues(alpha: isDark ? 0.08 : 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: luxury.gold.withValues(alpha: 0.15),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHeaderStat(
                        context,
                        icon: Icons.tune_rounded,
                        label: 'Settings',
                        value: '24',
                      ),
                      SizedBox(width: 16.w),
                      _buildHeaderStatDivider(context),
                      SizedBox(width: 16.w),
                      _buildHeaderStat(
                        context,
                        icon: Icons.security_rounded,
                        label: 'Security Level',
                        value: 'High',
                        valueColor: AppColors.success,
                      ),
                      SizedBox(width: 16.w),
                      _buildHeaderStatDivider(context),
                      SizedBox(width: 16.w),
                      _buildHeaderStat(
                        context,
                        icon: Icons.update_rounded,
                        label: 'Last Modified',
                        value: 'Today',
                      ),
                      SizedBox(width: 16.w),
                      _buildHeaderStatDivider(context),
                      SizedBox(width: 16.w),
                      _buildHeaderStat(
                        context,
                        icon: Icons.backup_rounded,
                        label: 'Backup Status',
                        value: 'Active',
                        valueColor: AppColors.success,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Corner decorative elements
        Positioned(
          top: -8.r,
          right: 40.w,
          child: Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  luxury.gold.withValues(alpha: 0.3),
                  luxury.gold.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -12.r,
          left: 60.w,
          child: Container(
            width: 30.r,
            height: 30.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.25),
                  AppColors.primary.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderStat(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: luxury.gold.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 16.sp,
            color: luxury.gold,
          ),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: valueColor ?? colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderStatDivider(BuildContext context) {
    final luxury = context.luxury;
    return Container(
      width: 1,
      height: 36.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            luxury.gold.withValues(alpha: 0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  void _handleSaveSettings(BuildContext context) {
    final luxury = context.luxury;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20.sp),
            SizedBox(width: 12.w),
            Text(
              'Settings saved successfully',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.r),
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
    bool isDanger = false,
  }) {
    final isDark = context.isDarkMode;

    final accentColor = isDanger ? AppColors.error : color;
    final secondaryColor = HSLColor.fromColor(accentColor)
        .withLightness((HSLColor.fromColor(accentColor).lightness + 0.15).clamp(0.0, 1.0))
        .toColor();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1E1B4B).withValues(alpha: 0.9),
                  const Color(0xFF312E81).withValues(alpha: 0.75),
                ]
              : [
                  Colors.white.withValues(alpha: 0.95),
                  const Color(0xFFF5F0FF).withValues(alpha: 0.9),
                ],
        ),
        border: Border.all(
          color: accentColor.withValues(alpha: isDark ? 0.3 : 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: isDark ? 0.12 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: accentColor.withValues(alpha: isDark ? 0.2 : 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withValues(alpha: isDark ? 0.25 : 0.15),
                        accentColor.withValues(alpha: isDark ? 0.12 : 0.08),
                      ],
                    ),
                    border: Border.all(
                      color: accentColor.withValues(alpha: isDark ? 0.4 : 0.25),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: isDark ? 0.2 : 0.1),
                        blurRadius: 8,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [accentColor, secondaryColor],
                    ).createShader(bounds),
                    child: Icon(icon, color: Colors.white, size: 18.sp),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: isDark
                          ? [Colors.white, const Color(0xFFE8E0FF)]
                          : [const Color(0xFF1A1A2E), const Color(0xFF312E81)],
                    ).createShader(bounds),
                    child: Text(
                      title,
                      style: GoogleFonts.raleway(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Section Content
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSetting(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
    bool isDestructive = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    final activeColor = isDestructive ? AppColors.error : luxury.gold;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Row(
        children: [
          // Gradient icon container
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDestructive
                    ? [
                        AppColors.error.withValues(alpha: 0.2),
                        AppColors.error.withValues(alpha: 0.1),
                      ]
                    : value
                        ? [
                            luxury.gold.withValues(alpha: 0.2),
                            luxury.gold.withValues(alpha: 0.1),
                          ]
                        : [
                            colorScheme.surfaceContainerHighest,
                            colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          ],
              ),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isDestructive
                    ? AppColors.error.withValues(alpha: 0.3)
                    : value
                        ? luxury.gold.withValues(alpha: 0.3)
                        : Colors.transparent,
                width: 1,
              ),
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: isDestructive
                    ? [AppColors.error, AppColors.error.withValues(alpha: 0.8)]
                    : value
                        ? [luxury.gold, luxury.gold.withValues(alpha: 0.8)]
                        : [colorScheme.onSurfaceVariant, colorScheme.onSurfaceVariant],
              ).createShader(bounds),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDestructive
                        ? AppColors.error
                        : colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Custom styled switch
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: value
                  ? [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: activeColor,
              activeTrackColor: activeColor.withValues(alpha: 0.3),
              inactiveThumbColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              inactiveTrackColor: colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientDivider(BuildContext context, {bool isDanger = false}) {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              isDanger
                  ? AppColors.error.withValues(alpha: 0.2)
                  : luxury.gold.withValues(alpha: isDark ? 0.15 : 0.1),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownSetting<T>(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required T value,
    required List<T> items,
    required Function(T?) onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Row(
        children: [
          // Gradient icon container
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  luxury.gold.withValues(alpha: 0.2),
                  luxury.gold.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: luxury.gold.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [luxury.gold, luxury.gold.withValues(alpha: 0.8)],
              ).createShader(bounds),
              child: Icon(icon, color: Colors.white, size: 20.sp),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Styled dropdown
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Colors.white.withValues(alpha: 0.08),
                        Colors.white.withValues(alpha: 0.04),
                      ]
                    : [
                        Colors.white,
                        Colors.grey.shade50,
                      ],
              ),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: luxury.gold.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: luxury.gold.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                items: items
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item.toString(),
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                dropdownColor: isDark
                    ? luxury.surfaceElevated
                    : colorScheme.surface,
                borderRadius: BorderRadius.circular(12.r),
                icon: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [luxury.gold, luxury.gold.withValues(alpha: 0.8)],
                  ).createShader(bounds),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSetting(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required double value,
    required double min,
    required double max,
    int? divisions,
    required String suffix,
    required Function(double) onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Column(
        children: [
          Row(
            children: [
              // Gradient icon container
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      luxury.gold.withValues(alpha: 0.2),
                      luxury.gold.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: luxury.gold.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [luxury.gold, luxury.gold.withValues(alpha: 0.8)],
                  ).createShader(bounds),
                  child: Icon(icon, color: Colors.white, size: 20.sp),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Value badge with gradient
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      luxury.gold.withValues(alpha: 0.2),
                      luxury.gold.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: luxury.gold.withValues(alpha: 0.4),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: luxury.gold.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [luxury.gold, luxury.gold.withValues(alpha: 0.9)],
                  ).createShader(bounds),
                  child: Text(
                    '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)}$suffix',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Custom styled slider
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: luxury.gold,
              inactiveTrackColor: luxury.gold.withValues(alpha: 0.2),
              thumbColor: luxury.gold,
              overlayColor: luxury.gold.withValues(alpha: 0.15),
              trackHeight: 8.h,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 12.r,
                elevation: 4,
              ),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 24.r),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: luxury.gold.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: divisions,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSetting(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String actionLabel,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final accentColor = isDestructive ? AppColors.error : luxury.gold;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Row(
        children: [
          // Gradient icon container
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor.withValues(alpha: 0.2),
                  accentColor.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [accentColor, accentColor.withValues(alpha: 0.8)],
              ).createShader(bounds),
              child: Icon(icon, color: Colors.white, size: 20.sp),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDestructive
                        ? AppColors.error
                        : colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Gradient action button
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDestructive
                    ? [
                        AppColors.error.withValues(alpha: 0.2),
                        AppColors.error.withValues(alpha: 0.1),
                      ]
                    : [
                        luxury.gold.withValues(alpha: 0.2),
                        luxury.gold.withValues(alpha: 0.1),
                      ],
              ),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.4),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(10.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [accentColor, accentColor.withValues(alpha: 0.8)],
                    ).createShader(bounds),
                    child: Text(
                      actionLabel,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleClearCache(BuildContext context) {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? luxury.surfaceElevated : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(
            color: luxury.gold.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [luxury.gold, luxury.gold.withValues(alpha: 0.8)],
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.cleaning_services_rounded, color: Colors.white, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Text(
              "Clear Cache",
              style: GoogleFonts.cormorantGaramond(
                fontWeight: FontWeight.w700,
                fontSize: 22.sp,
              ),
            ),
          ],
        ),
        content: Text(
          "This will clear all cached data. Continue?",
          style: GoogleFonts.inter(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Cancel",
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [luxury.gold, luxury.gold.withValues(alpha: 0.85)],
              ),
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: luxury.gold.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle_rounded, color: Colors.white, size: 20.sp),
                          SizedBox(width: 12.w),
                          Text(
                            'Cache cleared successfully',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      margin: EdgeInsets.all(16.r),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(10.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  child: Text(
                    "Clear",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleExport(BuildContext context) {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? luxury.surfaceElevated : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(
            color: luxury.gold.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [luxury.gold, luxury.gold.withValues(alpha: 0.8)],
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.download_rounded, color: Colors.white, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Text(
              "Export Data",
              style: GoogleFonts.cormorantGaramond(
                fontWeight: FontWeight.w700,
                fontSize: 22.sp,
              ),
            ),
          ],
        ),
        content: Text(
          "Choose export format:",
          style: GoogleFonts.inter(fontSize: 14.sp),
        ),
        actions: [
          _buildExportFormatButton(context, ctx, 'CSV', luxury),
          SizedBox(width: 8.w),
          _buildExportFormatButton(context, ctx, 'JSON', luxury),
          SizedBox(width: 8.w),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Cancel",
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportFormatButton(
    BuildContext context,
    BuildContext dialogContext,
    String format,
    LuxuryThemeExtension luxury,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            luxury.gold.withValues(alpha: 0.2),
            luxury.gold.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(dialogContext);
            _performExport(format);
          },
          borderRadius: BorderRadius.circular(10.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [luxury.gold, luxury.gold.withValues(alpha: 0.8)],
              ).createShader(bounds),
              child: Text(
                format,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _performExport(String format) {
    final luxury = context.luxury;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20.sp,
              height: 20.sp,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Exporting data as $format...',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: luxury.gold,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.r),
      ),
    );
  }

  void _handleResetSettings(BuildContext context) {
    _showDangerDialog(
      context,
      title: 'Reset Settings',
      message:
          'This will restore all settings to their default values. This action cannot be undone.',
      confirmLabel: 'Reset',
      onConfirm: () {
        setState(() {
          _maintenanceMode = false;
          _allowNewRegistrations = true;
          _requireEmailVerification = true;
          _enablePushNotifications = true;
          _enableEmailNotifications = true;
          _enableSMSNotifications = false;
          _twoFactorAuth = false;
          _autoBackup = true;
          _selectedCurrency = 'EGP';
          _selectedLanguage = 'English';
          _selectedTimezone = 'Africa/Cairo';
          _sessionTimeout = 30;
          _maxLoginAttempts = 5;
          _platformFeePercent = 30.0;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white, size: 20.sp),
                SizedBox(width: 12.w),
                Text(
                  'Settings reset to defaults',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            margin: EdgeInsets.all(16.r),
          ),
        );
      },
    );
  }

  void _handleDeleteAllData(BuildContext context) {
    _showDangerDialog(
      context,
      title: 'Delete All Data',
      message:
          'This will permanently delete ALL platform data including users, gyms, subscriptions, and payments. This action CANNOT be undone!',
      confirmLabel: 'Delete Everything',
      onConfirm: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.info_rounded, color: Colors.white, size: 20.sp),
                SizedBox(width: 12.w),
                Text(
                  'This action is disabled for safety',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            backgroundColor: AppColors.warning,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            margin: EdgeInsets.all(16.r),
          ),
        );
      },
    );
  }

  void _showDangerDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required VoidCallback onConfirm,
  }) {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? luxury.surfaceElevated : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(
            color: AppColors.error.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.error, AppColors.error.withValues(alpha: 0.8)],
                ),
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.error.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.warning_rounded, color: Colors.white, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: GoogleFonts.cormorantGaramond(
                fontWeight: FontWeight.w700,
                fontSize: 22.sp,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: GoogleFonts.inter(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.error, AppColors.error.withValues(alpha: 0.85)],
              ),
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.error.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pop(ctx);
                  onConfirm();
                },
                borderRadius: BorderRadius.circular(10.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  child: Text(
                    confirmLabel,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main container
        ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF2D2A5E).withValues(alpha: 0.95),
                          const Color(0xFF1E1B4B).withValues(alpha: 0.98),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.98),
                          const Color(0xFFF5F0FF).withValues(alpha: 0.95),
                        ],
                ),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: luxury.gold.withValues(alpha: 0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: luxury.gold.withValues(alpha: isDark ? 0.25 : 0.15),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header section with gradient
                  Container(
                    padding: EdgeInsets.all(24.r),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          luxury.gold.withValues(alpha: isDark ? 0.2 : 0.12),
                          luxury.gold.withValues(alpha: isDark ? 0.08 : 0.04),
                        ],
                      ),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                      border: Border(
                        bottom: BorderSide(
                          color: luxury.gold.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Logo with decorative rings
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer glow ring
                            Container(
                              width: 100.r,
                              height: 100.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    luxury.gold.withValues(alpha: 0.2),
                                    luxury.gold.withValues(alpha: 0),
                                  ],
                                ),
                              ),
                            ),
                            // Sweep gradient ring
                            Container(
                              width: 85.r,
                              height: 85.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: SweepGradient(
                                  colors: [
                                    luxury.gold.withValues(alpha: 0.5),
                                    luxury.gold.withValues(alpha: 0.1),
                                    luxury.gold.withValues(alpha: 0.5),
                                    luxury.gold.withValues(alpha: 0.1),
                                    luxury.gold.withValues(alpha: 0.5),
                                  ],
                                ),
                              ),
                            ),
                            // Inner background
                            Container(
                              width: 75.r,
                              height: 75.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: isDark
                                      ? [const Color(0xFF2D2A5E), const Color(0xFF1E1B4B)]
                                      : [Colors.white, const Color(0xFFF5F0FF)],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: luxury.gold.withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    spreadRadius: -3,
                                  ),
                                ],
                              ),
                            ),
                            // Logo icon
                            Container(
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    luxury.gold,
                                    const Color(0xFFD4A574),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: luxury.gold.withValues(alpha: 0.6),
                                    blurRadius: 20,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.fitness_center_rounded,
                                color: Colors.white,
                                size: 28.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 24.w),
                        // Title and tagline
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4.w,
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          luxury.gold,
                                          luxury.gold.withValues(alpha: 0.3),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(2.r),
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ShaderMask(
                                          shaderCallback: (bounds) => LinearGradient(
                                            colors: [
                                              luxury.gold,
                                              const Color(0xFFD4A574),
                                              luxury.gold,
                                            ],
                                          ).createShader(bounds),
                                          child: Text(
                                            'MyGym',
                                            style: GoogleFonts.cormorantGaramond(
                                              fontSize: 36.sp,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'ADMIN PANEL',
                                          style: GoogleFonts.raleway(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: colorScheme.onSurfaceVariant,
                                            letterSpacing: 4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              // Tagline
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.05)
                                      : Colors.black.withValues(alpha: 0.03),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: luxury.gold.withValues(alpha: 0.15),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.auto_awesome_rounded,
                                      size: 16.sp,
                                      color: luxury.gold,
                                    ),
                                    SizedBox(width: 10.w),
                                    Flexible(
                                      child: Text(
                                        'Premium Fitness Management Platform',
                                        style: GoogleFonts.inter(
                                          fontSize: 13.sp,
                                          color: colorScheme.onSurfaceVariant,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Stats row
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildAboutStat(
                            context,
                            icon: Icons.rocket_launch_rounded,
                            value: 'v1.0.0',
                            label: 'Current Version',
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 20.w),
                          _buildAboutStatDivider(context),
                          SizedBox(width: 20.w),
                          _buildAboutStat(
                            context,
                            icon: Icons.build_circle_rounded,
                            value: 'Build 100',
                            label: 'Release Build',
                            color: AppColors.info,
                          ),
                          SizedBox(width: 20.w),
                          _buildAboutStatDivider(context),
                          SizedBox(width: 20.w),
                          _buildAboutStat(
                            context,
                            icon: Icons.update_rounded,
                            value: 'Jan 2024',
                            label: 'Last Update',
                            color: AppColors.success,
                          ),
                          SizedBox(width: 20.w),
                          _buildAboutStatDivider(context),
                          SizedBox(width: 20.w),
                          _buildAboutStat(
                            context,
                            icon: Icons.verified_rounded,
                            value: 'Stable',
                            label: 'Release Channel',
                            color: luxury.gold,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Divider
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24.w),
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          luxury.gold.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  // Links and info section
                  Padding(
                    padding: EdgeInsets.all(24.r),
                    child: Column(
                      children: [
                        // Quick links row
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildAboutLinkCard(
                                context,
                                icon: Icons.menu_book_rounded,
                                title: 'Documentation',
                                subtitle: 'API & Guides',
                                color: AppColors.primary,
                                onTap: () {},
                              ),
                              SizedBox(width: 16.w),
                              _buildAboutLinkCard(
                                context,
                                icon: Icons.support_agent_rounded,
                                title: 'Support Center',
                                subtitle: '24/7 Help',
                                color: AppColors.success,
                                onTap: () {},
                              ),
                              SizedBox(width: 16.w),
                              _buildAboutLinkCard(
                                context,
                                icon: Icons.bug_report_rounded,
                                title: 'Report Issue',
                                subtitle: 'Bug Tracker',
                                color: AppColors.warning,
                                onTap: () {},
                              ),
                              SizedBox(width: 16.w),
                              _buildAboutLinkCard(
                                context,
                                icon: Icons.lightbulb_rounded,
                                title: 'Feature Request',
                                subtitle: 'Ideas Portal',
                                color: AppColors.info,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        // Footer with copyright and social
                        Container(
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                luxury.gold.withValues(alpha: isDark ? 0.08 : 0.05),
                                Colors.transparent,
                                luxury.gold.withValues(alpha: isDark ? 0.08 : 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: luxury.gold.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Copyright
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.copyright_rounded,
                                          size: 16.sp,
                                          color: luxury.gold.withValues(alpha: 0.7),
                                        ),
                                        SizedBox(width: 8.w),
                                        Flexible(
                                          child: Text(
                                            '2024 MyGym Technologies',
                                            style: GoogleFonts.inter(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w600,
                                              color: colorScheme.onSurface,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      'All rights reserved. Made with ❤️ for fitness enthusiasts.',
                                      style: GoogleFonts.inter(
                                        fontSize: 11.sp,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Social links
                              Row(
                                children: [
                                  _buildSocialIcon(context, Icons.language_rounded, luxury.gold),
                                  SizedBox(width: 12.w),
                                  _buildSocialIcon(context, Icons.alternate_email_rounded, AppColors.info),
                                  SizedBox(width: 12.w),
                                  _buildSocialIcon(context, Icons.code_rounded, AppColors.primary),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Decorative corner elements
        Positioned(
          top: -10.r,
          right: 50.w,
          child: Container(
            width: 50.r,
            height: 50.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  luxury.gold.withValues(alpha: 0.35),
                  luxury.gold.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -15.r,
          left: 80.w,
          child: Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.3),
                  AppColors.primary.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 60.h,
          left: -20.w,
          child: Container(
            width: 35.r,
            height: 35.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.info.withValues(alpha: 0.25),
                  AppColors.info.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutStat(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: isDark ? 0.15 : 0.1),
            color.withValues(alpha: isDark ? 0.08 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.8)],
              ),
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 18.sp),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutStatDivider(BuildContext context) {
    final luxury = context.luxury;
    return Container(
      width: 1,
      height: 50.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            luxury.gold.withValues(alpha: 0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildAboutLinkCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  color.withValues(alpha: 0.12),
                  color.withValues(alpha: 0.06),
                ]
              : [
                  Colors.white,
                  color.withValues(alpha: 0.08),
                ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color, color.withValues(alpha: 0.8)],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 22.sp),
                ),
                SizedBox(height: 12.h),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(BuildContext context, IconData icon, Color color) {
    final isDark = context.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(10.r),
          child: Padding(
            padding: EdgeInsets.all(10.r),
            child: Icon(icon, color: color, size: 18.sp),
          ),
        ),
      ),
    );
  }
}
