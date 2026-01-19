import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/admin_gym.dart';

/// Admin dashboard statistics cards widget
class AdminStatsCards extends StatelessWidget {
  final AdminDashboardStats stats;

  const AdminStatsCards({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary stats row
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Total Gyms',
                value: stats.totalGyms.toString(),
                icon: Icons.store,
                color: AppColors.primary,
                subtitle: '+${stats.pendingGyms} pending',
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _StatCard(
                title: 'Active Gyms',
                value: stats.activeGyms.toString(),
                icon: Icons.check_circle,
                color: AppColors.success,
                subtitle: '${_percentOf(stats.activeGyms, stats.totalGyms)}% of total',
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _StatCard(
                title: 'Total Users',
                value: _formatNumber(stats.totalUsers),
                icon: Icons.people,
                color: AppColors.info,
                subtitle: '${stats.activeSubscriptions} active subscriptions',
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _StatCard(
                title: 'Total Revenue',
                value: '\$${_formatCurrency(stats.totalRevenue)}',
                icon: Icons.attach_money,
                color: AppColors.warning,
                subtitle: '\$${_formatCurrency(stats.revenueThisMonth)} this month',
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        
        // Secondary stats row
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Visits Today',
                value: _formatNumber(stats.totalVisitsToday),
                icon: Icons.qr_code_scanner,
                color: AppColors.secondary,
                subtitle: '${_formatNumber(stats.totalVisitsThisWeek)} this week',
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _StatCard(
                title: 'Monthly Visits',
                value: _formatNumber(stats.totalVisitsThisMonth),
                icon: Icons.calendar_month,
                color: AppColors.tertiary,
                subtitle: 'Across all gyms',
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _StatCard(
                title: 'Pending Approvals',
                value: stats.pendingGyms.toString(),
                icon: Icons.pending_actions,
                color: stats.pendingGyms > 0 ? AppColors.error : AppColors.success,
                subtitle: stats.pendingGyms > 0 ? 'Needs attention' : 'All clear',
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _StatCard(
                title: 'Blocked Gyms',
                value: stats.blockedGyms.toString(),
                icon: Icons.block,
                color: AppColors.textSecondary,
                subtitle: 'Currently inactive',
              ),
            ),
          ],
        ),
        
        // City breakdown section
        if (stats.cityBreakdown.isNotEmpty) ...[
          SizedBox(height: 24.h),
          _CityBreakdownCard(cities: stats.cityBreakdown),
        ],
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(2);
  }

  int _percentOf(int part, int total) {
    if (total == 0) return 0;
    return ((part / total) * 100).round();
  }
}

/// Individual stat card widget
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:  0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha:  0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: color, size: 24.sp),
              ),
              Icon(
                Icons.trending_up,
                color: AppColors.success,
                size: 20.sp,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 8.h),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// City breakdown card with mini chart
class _CityBreakdownCard extends StatelessWidget {
  final List<CityStats> cities;

  const _CityBreakdownCard({required this.cities});

  @override
  Widget build(BuildContext context) {
    final maxGymCount = cities.map((c) => c.gymCount).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gyms by City',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to detailed city report
                },
                child: const Text('View Details'),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...cities.take(5).map((city) => _CityRow(
            city: city,
            maxCount: maxGymCount,
          )),
        ],
      ),
    );
  }
}

/// Single city row in breakdown
class _CityRow extends StatelessWidget {
  final CityStats city;
  final int maxCount;

  const _CityRow({
    required this.city,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    final progress = maxCount > 0 ? city.gymCount / maxCount : 0.0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                city.city,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${city.gymCount} gyms • ${city.userCount} users',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 6.h,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ],
      ),
    );
  }
}