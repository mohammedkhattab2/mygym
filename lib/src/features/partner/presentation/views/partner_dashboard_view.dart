import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/luxury_theme_extension.dart';
import '../../domain/entities/partner_entities.dart';
import '../cubit/partner_dashboard_cubit.dart';

class PartnerDashboardView extends StatelessWidget {
  const PartnerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Partner Dashboard',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.surface,
      ),
      body: BlocBuilder<PartnerDashboardCubit, PartnerDashboardState>(
        builder: (context, state) {
          if (state.isLoading && state.currentReport == null) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }

          if (state.errorMessage != null && state.currentReport == null) {
            return Center(
              child: Text(
                state.errorMessage!,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            );
          }

          final report = state.currentReport;
          final settings = state.settings;

          if (report == null) {
            return Center(
              child: Text(
                'No data available.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                context.read<PartnerDashboardCubit>().loadReport(
                      state.selectedPeriod,
                    ),
            color: colorScheme.primary,
            child: ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                _HeaderSection(report: report, settings: settings),
                SizedBox(height: 16.h),
                _PeriodSelector(state: state),
                SizedBox(height: 16.h),
                _VisitSummaryCard(summary: report.visitSummary),
                SizedBox(height: 16.h),
                _RevenueSummaryCard(summary: report.revenueSummary),
                SizedBox(height: 16.h),
                _PeakHoursCard(peakHours: report.peakHours),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final PartnerReport report;
  final PartnerSettings? settings;

  const _HeaderSection({required this.report, this.settings});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          report.gymName,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4.h),
        if (settings != null)
          Text(
            'Max capacity: ${settings!.maxCapacity} • Revenue share: ${(settings!.revenueSharePercentage).toStringAsFixed(0)}%',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  final PartnerDashboardState state;

  const _PeriodSelector({required this.state});

  String _label(ReportPeriod p) {
    switch (p) {
      case ReportPeriod.daily:
        return 'Today';
      case ReportPeriod.weekly:
        return 'This week';
      case ReportPeriod.monthly:
        return 'This month';
      default:
        return p.toString().split('.').last;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final textTheme = Theme.of(context).textTheme;
    
    final periods = [
      ReportPeriod.daily,
      ReportPeriod.weekly,
      ReportPeriod.monthly,
    ];

    return Row(
      children: periods.map((p) {
        final selected = state.selectedPeriod == p;
        return Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: ChoiceChip(
            label: Text(
              _label(p),
              style: textTheme.bodySmall?.copyWith(
                color: selected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            selected: selected,
            selectedColor: colorScheme.primary,
            backgroundColor: luxury.surfaceElevated,
            onSelected: (v) {
              if (v) {
                context.read<PartnerDashboardCubit>().loadReport(p);
              }
            },
          ),
        );
      }).toList(),
    );
  }
}

class _VisitSummaryCard extends StatelessWidget {
  final VisitSummary summary;

  const _VisitSummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Visits',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              _StatItem(
                label: 'Total visits',
                value: summary.totalVisits.toString(),
              ),
              SizedBox(width: 12.w),
              _StatItem(
                label: 'Unique visitors',
                value: summary.uniqueVisitors.toString(),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              _StatItem(
                label: 'Avg visits/user',
                value: summary.averageVisitsPerUser.toStringAsFixed(1),
              ),
              SizedBox(width: 12.w),
              _StatItem(
                label: 'Growth',
                value: '${summary.growthPercentage.toStringAsFixed(1)}%',
                positive: summary.isGrowthPositive,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RevenueSummaryCard extends StatelessWidget {
  final RevenueSummary summary;

  const _RevenueSummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              _StatItem(
                label: 'Total',
                value: summary.formattedTotalRevenue,
              ),
              SizedBox(width: 12.w),
              _StatItem(
                label: 'Net (your share)',
                value: summary.formattedNetRevenue,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              _StatItem(
                label: 'Growth',
                value: '${summary.growthPercentage.toStringAsFixed(1)}%',
                positive: summary.isGrowthPositive,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PeakHoursCard extends StatelessWidget {
  final List<PeakHourData> peakHours;

  const _PeakHoursCard({required this.peakHours});

  @override
  Widget build(BuildContext context) {
    if (peakHours.isEmpty) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Peak hours',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          ...peakHours.map((p) {
            return Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Row(
                children: [
                  Text(
                    '${p.dayLabel} • ${p.timeLabel}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${p.averageVisits.toStringAsFixed(0)} visits',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (p.isRecommendedPromo)
                    Padding(
                      padding: EdgeInsets.only(left: 6.w),
                      child: Text(
                        'Promo',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final bool? positive;

  const _StatItem({
    required this.label,
    required this.value,
    this.positive,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final textTheme = Theme.of(context).textTheme;
    
    Color valueColor = colorScheme.onSurface;
    if (positive != null) {
      valueColor = positive! ? luxury.success : colorScheme.error;
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}