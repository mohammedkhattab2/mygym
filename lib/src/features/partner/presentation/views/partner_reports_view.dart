import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/partner/presentation/cubit/partner_dashboard_cubit.dart';
import 'package:mygym/src/features/partner/presentation/widget/dashboard/period_selector.dart';
import 'package:mygym/src/features/partner/presentation/widget/reports/daily_breakdown_card.dart';
import 'package:mygym/src/features/partner/presentation/widget/reports/export_option.dart';
import 'package:mygym/src/features/partner/presentation/widget/reports/report_summary_card.dart';
import 'package:mygym/src/features/partner/presentation/widget/reports/revenue_bundle_card.dart';
import 'package:mygym/src/features/partner/presentation/widget/reports/revenue_report_card.dart';
import 'package:mygym/src/features/partner/presentation/widget/reports/subscription_breakdown_card.dart';
import 'package:mygym/src/features/partner/presentation/widget/reports/visit_report_card.dart';

class PartnerReportsView extends StatelessWidget {
  const PartnerReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(gradient: luxury.backgroundGradient),
        child: SafeArea(
          child: BlocBuilder<PartnerDashboardCubit, PartnerDashboardState>(
            builder: (context, state) {
              return RefreshIndicator(
                color: luxury.gold,
                onRefresh: () =>
                    context.read<PartnerDashboardCubit>().loadInitial(),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildAppBar(context, state)),
                    if (state.isLoading && state.currentReport == null)
                      const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (state.errorMessage != null &&
                        state.currentReport == null)
                      SliverFillRemaining(
                        child: _buildErrorState(context, state.errorMessage!),
                      )
                    else if (state.currentReport != null) ...[
                      SliverToBoxAdapter(
                        child: PeriodSelector(
                          selectedPeriod: state.selectedPeriod,
                          onPeriodChanged: (period) {
                            context.read<PartnerDashboardCubit>().loadReport(
                              period,
                            );
                          },
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 20.h,),),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: ReportSummaryCard(
                            report: state.currentReport!,
                            period: state.selectedPeriod,
                          ),
                          ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: VisitReportCard(
                            visitSummary: state.currentReport!.visitSummary,
                          ),
                          ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: RevenueReportCard(
                            revenue: state.currentReport!.revenueSummary,
                          ),
                          ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: DailyBreakdownCard(
                            dailystats: state.currentReport!.dailyStats,
                          ),
                          ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 20.h)),

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: SubscriptionBreakdownCard(
                            visitsByType: state.currentReport!.visitSummary.visitsBySubscriptionType,
                          ),
                          ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: RevenueBundleCard(
                            revenueByBundle: state.currentReport!.revenueSummary.revenueByBundle,
                            currency: state.currentReport!.revenueSummary.currency,
                          ) ,
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
    );
  }

  Widget _buildAppBar(BuildContext context, PartnerDashboardState state) {
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
                  "ANALYSTICS",
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  "Reprots",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.read<PartnerDashboardCubit>().loadInitial(),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: luxury.surfaceElevated,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: luxury.gold.withValues(alpha: 0.15)),
              ),
              child: Icon(
                Icons.refresh_rounded,
                size: 20.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(width: 83.w),
          GestureDetector(
            onTap: () => _showExportOptions(context),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.download_rounded,
                size: 20.sp,
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExportOptions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    showModalBottomSheet(
      context: context,
      backgroundColor: luxury.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Export Report",
              style: GoogleFonts.playfairDisplay(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.h),
            ExportOption(
              icon: Icons.share_rounded,
              title: "Share Report",
              subtitle: "Send via email or message",
              color: Colors.blue,
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Share coming soon")),
                );
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
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
              "Faild to load reports",
              style: GoogleFonts.playfairDisplay(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24.h),
            FilledButton.icon(
              onPressed: () =>
                  context.read<PartnerDashboardCubit>().loadInitial(),
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
