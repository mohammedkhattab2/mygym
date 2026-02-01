// lib/src/features/partner/presentation/views/partner_settings_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mygym/src/features/partner/domain/entities/partner_entities.dart';
import 'package:mygym/src/features/partner/presentation/cubit/partner_settings_cubit.dart';
import 'package:mygym/src/features/partner/presentation/cubit/partner_settings_state.dart';
import 'package:mygym/src/features/partner/presentation/widget/setting/blocked_users_section.dart';
import 'package:mygym/src/features/partner/presentation/widget/setting/capacity_section.dart';
import 'package:mygym/src/features/partner/presentation/widget/setting/edit_hours_bottom_sheet.dart';
import 'package:mygym/src/features/partner/presentation/widget/setting/gym_info_section.dart';
import 'package:mygym/src/features/partner/presentation/widget/setting/network_settings_section.dart';
import 'package:mygym/src/features/partner/presentation/widget/setting/revenue_share_card.dart';
import 'package:mygym/src/features/partner/presentation/widget/setting/support_section.dart';
import 'package:mygym/src/features/partner/presentation/widget/setting/visit_limits_section.dart';
import 'package:mygym/src/features/partner/presentation/widget/setting/working_hours_section.dart';
import 'package:mygym/src/features/partner/presentation/widget/setting/edit_capacity_bottom_sheet.dart';

class PartnerSettingsView extends StatelessWidget {
  const PartnerSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final cubit = context.read<PartnerSettingsCubit>();
        if (cubit.state.hasUnsavedChanges) {
          final shouldPop = await _showUnsavedChangesDialog(context);
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: Container(
          decoration: BoxDecoration(gradient: luxury.backgroundGradient),
          child: SafeArea(
            child: BlocConsumer<PartnerSettingsCubit, PartnerSettingsState>(
              listener: (context, state) {
                if (state.successMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 12.w),
                          Text(state.successMessage!),
                        ],
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                  context.read<PartnerSettingsCubit>().clearMessages();
                }
                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.white),
                          SizedBox(width: 12.w),
                          Expanded(child: Text(state.errorMessage!)),
                        ],
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                  context.read<PartnerSettingsCubit>().clearMessages();
                }
              },
              builder: (context, state) {
                return RefreshIndicator(
                  onRefresh: () =>
                      context.read<PartnerSettingsCubit>().loadSettings(),
                  color: luxury.gold,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(child: _buildAppBar(context, state)),
                      if (state.isLoading && state.settings == null)
                        const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (state.loadStatus ==
                              PartnerSettingsStatus.failure &&
                          state.settings == null)
                        SliverFillRemaining(child: _buildErrorState(context))
                      else if (state.settings != null) ...[
                        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: RevenueShareCard(
                              percentage: state.settings!.revenueSharePercentage,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: GymInfoSection(settings: state.settings!),
                          ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: _buildCapacitySection(context, state),
                          ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: _buildVisitLimitsSection(context, state),
                          ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: WorkingHoursSection(
                              workingHours:
                                  state.editingWorkingHours ??
                                  state.settings!.workingHours,
                              onDayTap: (dayOfWeek) {
                                _showEditHoursDialog(
                                  context,
                                  dayOfWeek,
                                  (state.editingWorkingHours ?? state.settings!.workingHours)
                                      .schedule[dayOfWeek],
                                );
                              },
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: _buildNetworkSettingsSection(context, state),
                          ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: _buildBlockedUsersSection(context, state),
                          ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: const SupportSection(),
                          ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: _buildSignOutSection(context),
                          ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 100.h)),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        floatingActionButton: BlocBuilder<PartnerSettingsCubit, PartnerSettingsState>(
          builder: (context, state) {
            if (!state.hasUnsavedChanges) return const SizedBox.shrink();
            return _buildSaveButton(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, PartnerSettingsState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "GYM",
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  "settings",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          if (state.hasUnsavedChanges) ...[
            GestureDetector(
              onTap: () => _showDiscardDialog(context),
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha:  0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.red.withValues(alpha:  0.3)),
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 20.sp,
                  color: Colors.red,
                ),
              ),
            ),
            SizedBox(width: 8.w),
          ],
          GestureDetector(
            onTap: () => context.read<PartnerSettingsCubit>().loadSettings(),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: luxury.surfaceElevated,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: luxury.gold.withValues(alpha:  0.15)),
              ),
              child: state.isLoading
                  ? SizedBox(
                      width: 20.sp,
                      height: 20.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: luxury.gold,
                      ),
                    )
                  : Icon(
                      Icons.refresh_rounded,
                      size: 20.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapacitySection(BuildContext context, PartnerSettingsState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final cubit = context.read<PartnerSettingsCubit>();

    return _SettingsCard(
      title: 'Capacity & Occupancy',
      icon: Icons.people_alt_rounded,
      children: [
        _SettingsRow(
          icon: Icons.group_rounded,
          title: 'Max Capacity',
          subtitle: '${state.currentMaxCapacity} people',
          trailing: GestureDetector(
            onTap: () {
              showEditCapacityBottomSheet(
                context: context,
                currentCapacity: state.currentMaxCapacity,
                onSave: (newCapacity) => cubit.updateMaxCapacity(newCapacity),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: luxury.gold.withValues(alpha:  0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: luxury.gold.withValues(alpha:  0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_rounded, size: 14.sp, color: luxury.gold),
                  SizedBox(width: 4.w),
                  Text(
                    'Edit',
                    style: GoogleFonts.montserrat(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: luxury.gold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(color: colorScheme.outlineVariant.withValues(alpha:  0.3), height: 24.h),
        _SettingsRow(
          icon: Icons.sensors_rounded,
          title: 'Auto-update Occupancy',
          subtitle: 'Automatically track gym occupancy',
          trailing: Switch(
            value: state.currentAutoUpdateOccupancy,
            onChanged: (value) => cubit.toggleAutoUpdateOccupancy(value),
            activeThumbColor: luxury.gold,
          ),
        ),
      ],
    );
  }

  Widget _buildVisitLimitsSection(BuildContext context, PartnerSettingsState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<PartnerSettingsCubit>();

    return _SettingsCard(
      title: 'Visit Limits',
      icon: Icons.calendar_today_rounded,
      children: [
        _LimitSlider(
          title: 'Daily Visits per User',
          value: state.currentMaxDailyVisits,
          min: 1,
          max: 5,
          onChanged: (value) => cubit.updateMaxDailyVisits(value.round()),
        ),
        SizedBox(height: 16.h),
        _LimitSlider(
          title: 'Weekly Visits per User',
          value: state.currentMaxWeeklyVisits,
          min: 1,
          max: 21,
          onChanged: (value) => cubit.updateMaxWeeklyVisits(value.round()),
        ),
      ],
    );
  }

  Widget _buildNetworkSettingsSection(BuildContext context, PartnerSettingsState state) {
    final luxury = context.luxury;
    final cubit = context.read<PartnerSettingsCubit>();

    return _SettingsCard(
      title: 'Network Settings',
      icon: Icons.hub_rounded,
      children: [
        _SettingsRow(
          icon: Icons.public_rounded,
          title: 'Allow Network Subscriptions',
          subtitle: 'Accept members from other gyms in the network',
          trailing: Switch(
            value: state.currentAllowNetworkSubscriptions,
            onChanged: (value) => cubit.toggleAllowNetworkSubscriptions(value),
            activeThumbColor: luxury.gold,
          ),
        ),
      ],
    );
  }

  Widget _buildBlockedUsersSection(BuildContext context, PartnerSettingsState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final blockedCount = state.settings?.blockedUserIds.length ?? 0;

    return _SettingsCard(
      title: 'Blocked Users',
      icon: Icons.block_rounded,
      children: [
        _SettingsRow(
          icon: Icons.person_off_rounded,
          title: 'Manage Blocked Users',
          subtitle: '$blockedCount users blocked',
          trailing: GestureDetector(
            onTap: () => context.go(RoutePaths.partnerBlockedUsers),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha:  0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.red.withValues(alpha:  0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Manage',
                    style: GoogleFonts.montserrat(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.arrow_forward_ios_rounded, size: 12.sp, color: Colors.red),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignOutSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.withValues(alpha: 0.2),
                      Colors.red.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.logout_rounded, color: Colors.red, size: 18.sp),
              ),
              SizedBox(width: 12.w),
              Text(
                'Account',
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: () => _showSignOutDialog(context),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, color: Colors.red, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Sign Out',
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    final luxury = context.luxury;
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: luxury.surfaceElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.logout_rounded, color: Colors.red, size: 24.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Sign Out',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to sign out of your account?',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthCubit>().signOut();
              context.go(RoutePaths.login);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              'Sign Out',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, PartnerSettingsState state) {
    final luxury = context.luxury;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [luxury.gold, luxury.gold.withValues(alpha:  0.8)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: luxury.gold.withValues(alpha:  0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: state.isSaving
            ? null
            : () => context.read<PartnerSettingsCubit>().saveSettings(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: state.isSaving
            ? SizedBox(
                width: 20.sp,
                height: 20.sp,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.save_rounded, color: Colors.white),
        label: Text(
          state.isSaving ? 'Saving...' : 'Save Changes',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.sp,
              color: colorScheme.error,
            ),
            SizedBox(height: 16.h),
            Text(
              "Failed to load settings",
              style: GoogleFonts.playfairDisplay(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Please check your internet connection and try again",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24.h),
            FilledButton.icon(
              onPressed: () =>
                  context.read<PartnerSettingsCubit>().loadSettings(),
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditHoursDialog(
    BuildContext context,
    int dayOfWeek,
    DaySchedule? currentSchedule,
  ) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final dayName = days[dayOfWeek - 1];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => EditHoursBottomSheet(
        dayName: dayName,
        dayOfWeek: dayOfWeek,
        currentSchedule: currentSchedule,
        onSave: (schedule) {
          context.read<PartnerSettingsCubit>().updateDaySchedule(dayOfWeek, schedule);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  Future<bool> _showUnsavedChangesDialog(BuildContext context) async {
    final luxury = context.luxury;
    final colorScheme = Theme.of(context).colorScheme;

    return await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: luxury.surfaceElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha:  0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.warning_rounded, color: Colors.orange, size: 24.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Unsaved Changes',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'You have unsaved changes. Do you want to discard them?',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              context.read<PartnerSettingsCubit>().discardChanges();
              Navigator.pop(dialogContext, true);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              'Discard',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showDiscardDialog(BuildContext context) {
    final luxury = context.luxury;
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: luxury.surfaceElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha:  0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.delete_outline_rounded, color: Colors.red, size: 24.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Discard Changes',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to discard all unsaved changes?',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              context.read<PartnerSettingsCubit>().discardChanges();
              Navigator.pop(dialogContext);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              'Discard',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// HELPER WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

class _SettingsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: luxury.gold.withValues(alpha:  0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:  0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      luxury.gold.withValues(alpha:  0.2),
                      luxury.gold.withValues(alpha:  0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: luxury.gold, size: 18.sp),
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 20.sp, color: colorScheme.onSurfaceVariant),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 2.h),
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
        trailing,
      ],
    );
  }
}

class _LimitSlider extends StatelessWidget {
  final String title;
  final int value;
  final int min;
  final int max;
  final ValueChanged<double> onChanged;

  const _LimitSlider({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: luxury.gold.withValues(alpha:  0.15),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                '$value',
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: luxury.gold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: luxury.gold,
            inactiveTrackColor: luxury.gold.withValues(alpha:  0.2),
            thumbColor: luxury.gold,
            overlayColor: luxury.gold.withValues(alpha:  0.2),
            trackHeight: 4.h,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
          ),
          child: Slider(
            value: value.toDouble(),
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: max - min,
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$min',
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '$max',
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
