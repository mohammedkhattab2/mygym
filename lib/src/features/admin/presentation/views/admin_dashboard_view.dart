import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/admin/domain/entities/admin_gym.dart';
import 'package:mygym/src/features/admin/presentation/bloc/admin_dashboard_cubit.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().loadInitial();
  }

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        return state.when(
          initial: () => _buildLoadingState(context),
          loading: () => _buildLoadingState(context),
          error: (message) => _buildErrorState(context, message),
          loaded:
              (
                stats,
                gyms,
                totalGyms,
                currentPage,
                totalPages,
                hasMore,
                filter,
                isLoadingMore,
                selectedIds,
              ) {
                return RefreshIndicator(
                  onRefresh: () => context.read<AdminCubit>().loadInitial(),
                  color: luxury.gold,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(24.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [_buildWelcomeSection(context, stats)],
                    ),
                  ),
                );
              },
        );
      },
    );
  }

  Widget _buildWelcomeSection(BuildContext context, AdminDashboardStats stats) {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            luxury.gold.withValues(alpha: 0.15),
            luxury.gold.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: luxury.gold.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome back , admin! 👋",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Here\'s what\'s happening with MyGym today.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 16.h),
                Wrap(
                  spacing: 24.w,
                  runSpacing: 12.h,
                  children: [
                    _buildMinStat(
                      context,
                      '${stats.totalVisitsToday}',
                      "Visits Today",
                      Icons.directions_walk_rounded,
                    ),
                    _buildMinStat(
                      context,
                      '${stats.pendingGyms}',
                      'Pending Approval',
                      Icons.pending_actions_rounded,
                      isWarning: stats.pendingGyms > 0,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (MediaQuery.of(context).size.width>600 )
                Container(
                  width: 120.r,
                  height: 12.r,
                  decoration: BoxDecoration(
                    gradient: luxury.goldGradient,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: luxury.gold.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8)
                      )
                    ] 
                  ),
                  child: Icon(
                    Icons.fitness_center_rounded,
                    color: Colors.white,
                    size: 56.sp,
                  ),
                )
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: context.luxury.gold,
              strokeWidth: 3,
            ),
            SizedBox(height: 16.h),
            Text(
              "Loading dashboard...",
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return SizedBox.expand(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.sp,
              color: AppColors.error,
            ),
            SizedBox(height: 16.h),
            Text(
              "Failed to load dashboard",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () => context.read<AdminCubit>().loadInitial(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: luxury.gold,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinStat(
    BuildContext context,
    String value,
    String label,
    IconData icon, {
    bool isWarning = false,
  }) {
    final luxury = context.luxury;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: isWarning
                ? AppColors.warning.withValues(alpha: 0.15)
                : luxury.gold.withValues(alpha: 0.15)
          ),
          child: Icon(
            icon, 
            color: isWarning ? AppColors.warning : luxury.gold ,
            size: 20.sp,
          ),
        ),
        SizedBox(width: 12.w,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: isWarning ? AppColors.warning : colorScheme.onSurface
              ) ,
            ),
            Text(
              label ,
              style: TextStyle(
                fontSize: 12.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            )
          ],
        )
      ],

    );
  }
}
