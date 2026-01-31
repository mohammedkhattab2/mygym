import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/partner/presentation/cubit/partner_dashboard_cubit.dart';
import 'package:mygym/src/features/partner/presentation/widget/dashboard/daily_stats_chart.dart';
import 'package:mygym/src/features/partner/presentation/widget/dashboard/peak_hours_section.dart';
import 'package:mygym/src/features/partner/presentation/widget/dashboard/period_selector.dart';
import 'package:mygym/src/features/partner/presentation/widget/dashboard/revenue_card.dart';
import 'package:mygym/src/features/partner/presentation/widget/dashboard/stats_overview.dart';
import 'package:mygym/src/features/partner/presentation/widget/dashboard/user_retention_card.dart';

class PartnerDashboardView extends StatelessWidget {
  const PartnerDashboardView({super.key});

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
                onRefresh: () =>
                    context.read<PartnerDashboardCubit>().loadInitial(),
                color: luxury.gold,
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
                      else if (state.currentReport != null)...[
                        SliverToBoxAdapter(
                          child: PeriodSelector(
                            selectedPeriod: state.selectedPeriod, 
                            onPeriodChanged: (period){
                              context.read<PartnerDashboardCubit>().loadReport(period);
                            }
                            ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 20.h,),),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: StatsOverview(report: state.currentReport!),
                            ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 24.h,),),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: RevenueCard(
                              revenue: state.currentReport!.revenueSummary,
                              ) ,
                            ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 24.h,),),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: DailyStatsChart(
                              dailyStats: state.currentReport!.dailyStats
                            ) ,
                            ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 24.h,),),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: PeakHoursSection(
                              peakHours : state.currentReport!.peakHours,
                            ) ,
                            ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 24.h,),),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: UserRetentionCard(
                              retention: state.currentReport!.userRetention
                              ),
                            ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 100.h,),),
                      ]
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget? _buildAppBar(BuildContext context, PartnerDashboardState state) {
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
                  "Partner ",
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  state.currentReport?.gymName ?? "Dashboard",
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
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () => context.go(RoutePaths.partnerSettings),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.settings_rounded,
                size: 20.sp,
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildErrorState(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child:  Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.sp,
              color: colorScheme.error,
            ),
            SizedBox(height: 16.h,),
            Text(
              "Something went wrong",
              style: GoogleFonts.playfairDisplay(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h,),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24.h,),
            FilledButton.icon(
              onPressed: () => context.read<PartnerDashboardCubit>().loadInitial(),
              icon: const Icon(Icons.refresh), 
              label: const Text("Retry"),
              )
          ],
        ),
        ),

    );
  }
}
