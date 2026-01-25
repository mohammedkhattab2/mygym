import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/luxury_theme_extension.dart';
import '../cubit/partner_dashboard_cubit.dart';

class PartnerReportsView extends StatelessWidget {
  const PartnerReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final luxury = context.luxury;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Reports',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.surface,
      ),
      body: BlocBuilder<PartnerDashboardCubit, PartnerDashboardState>(
        builder: (context, state) {
          final report = state.currentReport;
          if (state.isLoading && report == null) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }
          if (report == null) {
            return Center(
              child: Text(
                'No report data available',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }

          final stats = report.dailyStats;

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              final d = stats[index];
              final dateStr =
                  '${d.date.day}/${d.date.month}/${d.date.year}';
              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: luxury.surfaceElevated,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateStr,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Visits: ${d.visits} • Revenue: ${d.revenue.toStringAsFixed(0)} EGP',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'New users: ${d.newUsers} • Occupancy: ${(d.averageOccupancy * 100).toStringAsFixed(0)}%',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}