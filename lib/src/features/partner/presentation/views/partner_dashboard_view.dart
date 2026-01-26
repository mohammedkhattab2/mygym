import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/luxury_theme_extension.dart';
import '../../domain/entities/partner_entities.dart';
import '../cubit/partner_dashboard_cubit.dart';

/// Premium Luxury Partner Dashboard View
///
/// Features:
/// - Static layered glowing orbs background
/// - Premium glassmorphism dashboard cards
/// - Gold gradient accents and elegant typography
/// - Full Light/Dark mode compliance
/// - NO animations (static luxury design)
class PartnerDashboardView extends StatefulWidget {
  const PartnerDashboardView({super.key});

  @override
  State<PartnerDashboardView> createState() => _PartnerDashboardViewState();
}

class _PartnerDashboardViewState extends State<PartnerDashboardView> {

  void _setSystemUI(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _setSystemUI(context);
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surface.withValues(alpha: 0.95),
              luxury.surfaceElevated,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Custom luxury app bar
                  _buildLuxuryAppBar(colorScheme, luxury),

                  // Dashboard content
                  Expanded(
                    child: BlocBuilder<PartnerDashboardCubit, PartnerDashboardState>(
                      builder: (context, state) {
                        if (state.isLoading && state.currentReport == null) {
                          return _buildLoadingState(colorScheme, luxury);
                        }

                        if (state.errorMessage != null && state.currentReport == null) {
                          return _buildErrorState(colorScheme, state.errorMessage!);
                        }

                        final report = state.currentReport;
                        final settings = state.settings;

                        if (report == null) {
                          return _buildEmptyState(colorScheme, luxury);
                        }

                        return RefreshIndicator(
                          onRefresh: () => context.read<PartnerDashboardCubit>().loadReport(
                                state.selectedPeriod,
                              ),
                          color: luxury.gold,
                          backgroundColor: luxury.surfaceElevated,
                          child: ListView(
                              physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                            children: [
                              _LuxuryHeaderSection(report: report, settings: settings),
                              SizedBox(height: 20.h),
                              _LuxuryPeriodSelector(state: state),
                              SizedBox(height: 24.h),
                              _LuxuryVisitSummaryCard(summary: report.visitSummary),
                              SizedBox(height: 16.h),
                              _LuxuryRevenueSummaryCard(summary: report.revenueSummary),
                              SizedBox(height: 16.h),
                              _LuxuryPeakHoursCard(peakHours: report.peakHours),
                              SizedBox(height: 40.h),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLuxuryAppBar(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          // Back button
          _LuxuryIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.of(context).pop(),
          ),
          SizedBox(width: 16.w),
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PARTNER',
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Dashboard',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          // Reports button
          _LuxuryIconButton(
            icon: Icons.analytics_outlined,
            onTap: () {
              // Navigate to reports
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50.w,
            height: 50.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(luxury.gold),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading dashboard...',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ColorScheme colorScheme, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.error.withValues(alpha: 0.15),
                  colorScheme.error.withValues(alpha: 0.05),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 48.sp,
              color: colorScheme.error,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [luxury.textTertiary, luxury.gold.withValues(alpha: 0.5)],
              ).createShader(bounds);
            },
            child: Icon(
              Icons.dashboard_outlined,
              color: colorScheme.onPrimary,
              size: 48.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'No data available',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// LUXURY ICON BUTTON
// ============================================================================

class _LuxuryIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _LuxuryIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              luxury.surfaceElevated,
              colorScheme.surface,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: luxury.gold.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                colorScheme.onSurface,
                luxury.gold.withValues(alpha: 0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: Icon(
            icon,
            color: colorScheme.onPrimary,
            size: 20.sp,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// LUXURY HEADER SECTION
// ============================================================================

class _LuxuryHeaderSection extends StatelessWidget {
  final PartnerReport report;
  final PartnerSettings? settings;

  const _LuxuryHeaderSection({required this.report, this.settings});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.15),
            luxury.gold.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Gym avatar
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withValues(alpha: 0.25),
                  luxury.gold.withValues(alpha: 0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: luxury.gold.withValues(alpha: 0.25),
                width: 2,
              ),
            ),
            child: Center(
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [colorScheme.primary, luxury.gold],
                  ).createShader(bounds);
                },
                child: Text(
                  report.gymName.isNotEmpty ? report.gymName[0].toUpperCase() : 'G',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),

          // Gym info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.gymName,
                  style: GoogleFonts.inter(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (settings != null) ...[
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      _LuxuryInfoChip(
                        icon: Icons.people_alt_rounded,
                        label: '${settings!.maxCapacity}',
                        colors: [colorScheme.primary, colorScheme.secondary],
                      ),
                      SizedBox(width: 8.w),
                      _LuxuryInfoChip(
                        icon: Icons.percent_rounded,
                        label: '${settings!.revenueSharePercentage.toStringAsFixed(0)}%',
                        colors: [luxury.gold, luxury.goldLight],
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LuxuryInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> colors;

  const _LuxuryInfoChip({
    required this.icon,
    required this.label,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors[0].withValues(alpha: 0.15),
            colors[1].withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: colors[0].withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(colors: colors).createShader(bounds);
            },
            child: Icon(
              icon,
              color: colorScheme.onPrimary,
              size: 14.sp,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: colors[0],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// LUXURY PERIOD SELECTOR
// ============================================================================

class _LuxuryPeriodSelector extends StatelessWidget {
  final PartnerDashboardState state;

  const _LuxuryPeriodSelector({required this.state});

  String _label(ReportPeriod p) {
    switch (p) {
      case ReportPeriod.daily:
        return 'Today';
      case ReportPeriod.weekly:
        return 'Week';
      case ReportPeriod.monthly:
        return 'Month';
      default:
        return p.toString().split('.').last;
    }
  }

  IconData _icon(ReportPeriod p) {
    switch (p) {
      case ReportPeriod.daily:
        return Icons.today_rounded;
      case ReportPeriod.weekly:
        return Icons.date_range_rounded;
      case ReportPeriod.monthly:
        return Icons.calendar_month_rounded;
      default:
        return Icons.schedule_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    final periods = [
      ReportPeriod.daily,
      ReportPeriod.weekly,
      ReportPeriod.monthly,
    ];

    return Row(
      children: periods.map((p) {
        final selected = state.selectedPeriod == p;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: p != ReportPeriod.monthly ? 10.w : 0),
            child: GestureDetector(
              onTap: () {
                if (!selected) {
                  context.read<PartnerDashboardCubit>().loadReport(p);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: selected
                      ? LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.secondary,
                          ],
                        )
                      : LinearGradient(
                          colors: [
                            luxury.surfaceElevated,
                            colorScheme.surface,
                          ],
                        ),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: selected
                        ? luxury.gold.withValues(alpha: 0.3)
                        : colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _icon(p),
                      size: 16.sp,
                      color: selected ? colorScheme.onPrimary : luxury.textTertiary,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      _label(p),
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                        color: selected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ============================================================================
// LUXURY VISIT SUMMARY CARD
// ============================================================================

class _LuxuryVisitSummaryCard extends StatelessWidget {
  final VisitSummary summary;

  const _LuxuryVisitSummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            luxury.surfaceElevated,
            colorScheme.surface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.2),
                      colorScheme.secondary.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [colorScheme.primary, colorScheme.secondary],
                    ).createShader(bounds);
                  },
                  child: Icon(
                    Icons.directions_walk_rounded,
                    color: colorScheme.onPrimary,
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Visits',
                style: GoogleFonts.montserrat(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),

          // Stats grid
          Row(
            children: [
              _LuxuryStatItem(
                label: 'Total visits',
                value: summary.totalVisits.toString(),
                colors: [colorScheme.primary, colorScheme.secondary],
              ),
              SizedBox(width: 14.w),
              _LuxuryStatItem(
                label: 'Unique visitors',
                value: summary.uniqueVisitors.toString(),
                colors: [luxury.gold, luxury.goldLight],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _LuxuryStatItem(
                label: 'Avg visits/user',
                value: summary.averageVisitsPerUser.toStringAsFixed(1),
                colors: [colorScheme.secondary, colorScheme.primary],
              ),
              SizedBox(width: 14.w),
              _LuxuryStatItem(
                label: 'Growth',
                value: '${summary.growthPercentage >= 0 ? '+' : ''}${summary.growthPercentage.toStringAsFixed(1)}%',
                colors: summary.isGrowthPositive
                    ? [luxury.success, luxury.success.withValues(alpha: 0.7)]
                    : [colorScheme.error, colorScheme.error.withValues(alpha: 0.7)],
                isGrowth: true,
                positive: summary.isGrowthPositive,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// LUXURY REVENUE SUMMARY CARD
// ============================================================================

class _LuxuryRevenueSummaryCard extends StatelessWidget {
  final RevenueSummary summary;

  const _LuxuryRevenueSummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            luxury.surfaceElevated,
            colorScheme.surface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      luxury.gold.withValues(alpha: 0.25),
                      luxury.goldLight.withValues(alpha: 0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: luxury.gold.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [luxury.gold, luxury.goldLight],
                    ).createShader(bounds);
                  },
                  child: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: colorScheme.onPrimary,
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Revenue',
                style: GoogleFonts.montserrat(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),

          // Stats grid
          Row(
            children: [
              _LuxuryStatItem(
                label: 'Total revenue',
                value: summary.formattedTotalRevenue,
                colors: [luxury.gold, luxury.goldLight],
                isLarge: true,
              ),
              SizedBox(width: 14.w),
              _LuxuryStatItem(
                label: 'Your share',
                value: summary.formattedNetRevenue,
                colors: [colorScheme.primary, colorScheme.secondary],
                isLarge: true,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _LuxuryStatItem(
                label: 'Growth',
                value: '${summary.growthPercentage >= 0 ? '+' : ''}${summary.growthPercentage.toStringAsFixed(1)}%',
                colors: summary.isGrowthPositive
                    ? [luxury.success, luxury.success.withValues(alpha: 0.7)]
                    : [colorScheme.error, colorScheme.error.withValues(alpha: 0.7)],
                isGrowth: true,
                positive: summary.isGrowthPositive,
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// LUXURY STAT ITEM
// ============================================================================

class _LuxuryStatItem extends StatelessWidget {
  final String label;
  final String value;
  final List<Color> colors;
  final bool isGrowth;
  final bool? positive;
  final bool isLarge;

  const _LuxuryStatItem({
    required this.label,
    required this.value,
    required this.colors,
    this.isGrowth = false,
    this.positive,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colors[0].withValues(alpha: 0.08),
              colors[1].withValues(alpha: 0.04),
            ],
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: colors[0].withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: luxury.textTertiary,
              ),
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                if (isGrowth && positive != null)
                  Icon(
                    positive! ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                    size: 16.sp,
                    color: colors[0],
                  ),
                if (isGrowth && positive != null) SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    value,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: isLarge ? 16.sp : 15.sp,
                      fontWeight: FontWeight.w700,
                      color: isGrowth ? colors[0] : colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// LUXURY PEAK HOURS CARD
// ============================================================================

class _LuxuryPeakHoursCard extends StatelessWidget {
  final List<PeakHourData> peakHours;

  const _LuxuryPeakHoursCard({required this.peakHours});

  @override
  Widget build(BuildContext context) {
    if (peakHours.isEmpty) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            luxury.surfaceElevated,
            colorScheme.surface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.secondary.withValues(alpha: 0.2),
                      colorScheme.primary.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colorScheme.secondary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [colorScheme.secondary, colorScheme.primary],
                    ).createShader(bounds);
                  },
                  child: Icon(
                    Icons.schedule_rounded,
                    color: colorScheme.onPrimary,
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Peak Hours',
                style: GoogleFonts.montserrat(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Peak hours list
          ...peakHours.asMap().entries.map((entry) {
            final index = entry.key;
            final p = entry.value;
            return _LuxuryPeakHourItem(
              data: p,
              index: index,
              isLast: index == peakHours.length - 1,
            );
          }),
        ],
      ),
    );
  }
}

class _LuxuryPeakHourItem extends StatelessWidget {
  final PeakHourData data;
  final int index;
  final bool isLast;

  const _LuxuryPeakHourItem({
    required this.data,
    required this.index,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    // Alternate colors for visual interest
    final accentColors = [
      [colorScheme.primary, colorScheme.secondary],
      [luxury.gold, luxury.goldLight],
      [colorScheme.secondary, colorScheme.primary],
    ];
    final colors = accentColors[index % accentColors.length];

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors[0].withValues(alpha: 0.06),
            colors[1].withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: colors[0].withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Time indicator
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors[0].withValues(alpha: 0.15),
                  colors[1].withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(colors: colors).createShader(bounds);
              },
              child: Icon(
                Icons.access_time_filled_rounded,
                color: colorScheme.onPrimary,
                size: 18.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Day and time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.dayLabel,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  data.timeLabel,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: luxury.textTertiary,
                  ),
                ),
              ],
            ),
          ),

          // Visits count
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${data.averageVisits.toStringAsFixed(0)}',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                'visits',
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: luxury.textTertiary,
                ),
              ),
            ],
          ),

          // Promo badge
          if (data.isRecommendedPromo) ...[
            SizedBox(width: 10.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    luxury.gold.withValues(alpha: 0.2),
                    luxury.goldLight.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: luxury.gold.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                'PROMO',
                style: GoogleFonts.montserrat(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w700,
                  color: luxury.gold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}