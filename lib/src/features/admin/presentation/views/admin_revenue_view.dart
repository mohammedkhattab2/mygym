import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mygym/src/features/admin/presentation/bloc/admin_revenue_cubit.dart';

import '../../../../core/theme/luxury_theme_extension.dart';
import '../../domain/entities/admin_revenue.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// LUXURY ADMIN REVENUE VIEW - REDESIGNED
/// A premium revenue dashboard with elegant cards and sophisticated design
/// No animations - Pure elegance and clarity
/// ═══════════════════════════════════════════════════════════════════════════

class AdminRevenueView extends StatefulWidget {
  const AdminRevenueView({super.key});

  @override
  State<AdminRevenueView> createState() => _AdminRevenueViewState();
}

class _AdminRevenueViewState extends State<AdminRevenueView> {
  @override
  void initState() {
    super.initState();
    context.read<AdminRevenueCubit>().loadRevenueData();
  }

  @override
  Widget build(BuildContext context) {
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
                    const Color(0xFF0A0A1A),
                    const Color(0xFF1A1A2E),
                    const Color(0xFF16213E),
                  ]
                : [
                    const Color(0xFFFAFBFC),
                    const Color(0xFFF4F6F8),
                    const Color(0xFFEEF2F7),
                  ],
          ),
        ),
        child: BlocBuilder<AdminRevenueCubit, AdminRevenueState>(
          builder: (context, state) {
            return state.when(
              initial: () => _buildLoadingState(context),
              loading: () => _buildLoadingState(context),
              error: (msg) => _buildErrorState(context, msg),
              loaded: (data, filter) => _buildContent(context, data, filter),
            );
          },
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOADING STATE - Elegant and Simple
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildLoadingState(BuildContext context) {
    final isDark = context.isDarkMode;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFD700),
                  Color(0xFFD4A574),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
                strokeCap: StrokeCap.round,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Loading Revenue Data...',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white.withValues(alpha: 0.9) : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait while we gather the insights',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ERROR STATE - Clean and Actionable
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildErrorState(BuildContext context, String msg) {
    final isDark = context.isDarkMode;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFEF4444).withValues(alpha: 0.2),
                    const Color(0xFFEF4444).withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Color(0xFFEF4444),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              msg,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.read<AdminRevenueCubit>().loadRevenueData(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                'Try Again',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                shadowColor: const Color(0xFFFFD700).withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN CONTENT - Luxurious Layout
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildContent(BuildContext context, RevenueData data, RevenueFilter filter) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Mobile-Optimized Header
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          sliver: SliverToBoxAdapter(
            child: _buildHeader(context, data.overview, filter),
          ),
        ),

        // Mobile Stat Cards
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          sliver: SliverToBoxAdapter(
            child: _buildStatCards(context, data.overview),
          ),
        ),

        // Mobile Chart Section
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
          sliver: SliverToBoxAdapter(
            child: _buildChartSection(context, data.chartData, filter),
          ),
        ),

        // Mobile Analytics Grid
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
          sliver: SliverToBoxAdapter(
            child: _buildAnalyticsGrid(context, data),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MOBILE-OPTIMIZED HEADER - Perfect for phones
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildHeader(BuildContext context, RevenueOverview overview, RevenueFilter filter) {
    final isDark = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  const Color(0xFF1E1E2E).withValues(alpha: 0.95),
                  const Color(0xFF2A2A40).withValues(alpha: 0.85),
                ]
              : [
                  Colors.white,
                  const Color(0xFFF8F9FA).withValues(alpha: 0.95),
                ],
        ),
        border: Border.all(
          color: const Color(0xFFFFD700).withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : const Color(0xFFFFD700).withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        children: [
          // ═══ Top Row: Icon + Title ═══
          Row(
            children: [
              // Golden Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFD700),
                      Color(0xFFD4A574),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              
              // Title Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Revenue Dashboard',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black87,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      'Financial Overview',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.6)
                            : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ═══ Growth Indicator ═══
          _buildMobileGrowthIndicator(overview.revenueGrowthPercent, isDark),

          const SizedBox(height: 16),

          // ═══ Controls - Stacked for mobile ═══
          Column(
            children: [
              // Period Selector - Full Width
              _buildMobilePeriodSelector(context, filter, isDark),
              const SizedBox(height: 10),
              // Export Button - Full Width
              _buildMobileExportButton(context, isDark),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MOBILE-SPECIFIC COMPONENTS - Optimized for phones
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildMobileGrowthIndicator(double percent, bool isDark) {
    final isPositive = percent >= 0;
    final color = isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: isDark ? 0.2 : 0.1),
            color.withValues(alpha: isDark ? 0.1 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
              size: 16,
              color: color,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${isPositive ? '+' : ''}${percent.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              Text(
                'vs previous period',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobilePeriodSelector(BuildContext context, RevenueFilter filter, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<RevenuePeriod>(
          value: filter.period,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: isDark ? Colors.white.withValues(alpha: 0.7) : Colors.black54,
          ),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
          dropdownColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          items: RevenuePeriod.values
              .map((p) => DropdownMenuItem(
                    value: p,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 16,
                          color: Color(0xFFFFD700),
                        ),
                        const SizedBox(width: 10),
                        Text(p.displayName),
                      ],
                    ),
                  ))
              .toList(),
          onChanged: (period) {
            if (period != null) {
              context.read<AdminRevenueCubit>().changePeriod(period);
            }
          },
        ),
      ),
    );
  }

  Widget _buildMobileExportButton(BuildContext context, bool isDark) {
    return PopupMenuButton<String>(
      onSelected: (format) async {
        final cubit = context.read<AdminRevenueCubit>();
        final messenger = ScaffoldMessenger.of(context);
        final url = await cubit.exportReport(format);
        if (url != null && mounted) {
          messenger.showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 10),
                  Text(
                    'Report exported successfully',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      itemBuilder: (ctx) => [
        _buildExportMenuItem('csv', 'Export CSV', Icons.table_chart_rounded),
        _buildExportMenuItem('pdf', 'Export PDF', Icons.picture_as_pdf_rounded),
        _buildExportMenuItem('xlsx', 'Export Excel', Icons.grid_on_rounded),
      ],
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFFFD700),
              Color(0xFFD4A574),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.download_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'Export Report',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildExportMenuItem(String value, String label, IconData icon) {
    final isDark = context.isDarkMode;

    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFFFFD700)),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MOBILE STAT CARDS - 2x2 Grid Layout
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStatCards(BuildContext context, RevenueOverview overview) {
    return Column(
      children: [
        // First Row
        Row(
          children: [
            Expanded(
              child: _buildMobileStatCard(
                context,
                title: 'Total Revenue',
                value: overview.totalRevenue,
                subtitle: '${overview.totalTransactions} transactions',
                icon: Icons.account_balance_wallet_rounded,
                color: const Color(0xFFFFD700),
                isMain: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMobileStatCard(
                context,
                title: 'Platform Fees',
                value: overview.totalPlatformFees,
                subtitle: '${(overview.totalPlatformFees / overview.totalRevenue * 100).toStringAsFixed(1)}% fee',
                icon: Icons.toll_rounded,
                color: const Color(0xFF10B981),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Second Row
        Row(
          children: [
            Expanded(
              child: _buildMobileStatCard(
                context,
                title: 'Gym Payouts',
                value: overview.totalGymPayouts,
                subtitle: 'To partners',
                icon: Icons.storefront_rounded,
                color: const Color(0xFF8B5CF6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMobileStatCard(
                context,
                title: 'Pending',
                value: overview.pendingPayouts,
                subtitle: 'Processing',
                icon: Icons.schedule_rounded,
                color: const Color(0xFFF59E0B),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileStatCard(
    BuildContext context, {
    required String title,
    required double value,
    required String subtitle,
    required IconData icon,
    required Color color,
    bool isMain = false,
  }) {
    final isDark = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.05),
                ]
              : [
                  Colors.white,
                  Colors.white.withValues(alpha: 0.8),
                ],
        ),
        border: Border.all(
          color: isMain
              ? color.withValues(alpha: 0.6)
              : isDark
                  ? Colors.white.withValues(alpha: 0.15)
                  : const Color(0xFFE5E7EB),
          width: isMain ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isMain
                ? color.withValues(alpha: 0.2)
                : isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.04),
            blurRadius: isMain ? 16 : 12,
            offset: const Offset(0, 4),
            spreadRadius: isMain ? 0 : -2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white.withValues(alpha: 0.8) : Colors.black54,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Value
          Text(
            'EGP ${_formatNumber(value)}',
            style: TextStyle(
              fontSize: isMain ? 16 : 14,
              fontWeight: FontWeight.w700,
              color: isMain
                  ? color
                  : isDark
                      ? Colors.white
                      : Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),

          const SizedBox(height: 4),

          // Subtitle
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 9,
              color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.black45,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SOPHISTICATED CHART SECTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildChartSection(BuildContext context, List<RevenuePeriodData> chartData, RevenueFilter filter) {
    final isDark = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.white.withValues(alpha: 0.12),
                  Colors.white.withValues(alpha: 0.08),
                ]
              : [
                  Colors.white,
                  Colors.white.withValues(alpha: 0.7),
                ],
        ),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.2)
              : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Compact Chart Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: Color(0xFFFFD700),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Revenue Trends',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              // Compact Legend
              _buildCompactLegendItem('Revenue', const Color(0xFFFFD700)),
              const SizedBox(width: 8),
              _buildCompactLegendItem('Fees', const Color(0xFF10B981)),
            ],
          ),

          const SizedBox(height: 16),

          // Compact Chart
          _buildMobileChart(context, chartData),
        ],
      ),
    );
  }

  Widget _buildCompactLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileChart(BuildContext context, List<RevenuePeriodData> chartData) {
    final isDark = context.isDarkMode;

    if (chartData.isEmpty) {
      return Container(
        height: 120,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart_outlined,
              size: 32,
              color: isDark ? Colors.white.withValues(alpha: 0.3) : Colors.black26,
            ),
            const SizedBox(height: 8),
            Text(
              'No chart data',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.black54,
              ),
            ),
          ],
        ),
      );
    }

    // Show only last 7 data points for mobile
    final displayData = chartData.length > 7 ? chartData.sublist(chartData.length - 7) : chartData;
    final maxRevenue = displayData.map((d) => d.revenue).reduce((a, b) => a > b ? a : b);
    
    return SizedBox(
      height: 160,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: displayData.map((data) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: _buildMobileChartBar(context, data, maxRevenue),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMobileChartBar(BuildContext context, RevenuePeriodData data, double maxRevenue) {
    final isDark = context.isDarkMode;
    final heightPercent = maxRevenue > 0 ? data.revenue / maxRevenue : 0.0;
    final feePercent = maxRevenue > 0 ? data.platformFees / maxRevenue : 0.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Revenue Bar - Compact
        if (heightPercent > 0)
          Container(
            height: (120 * heightPercent).clamp(8.0, 120.0),
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xFFFFD700),
                  Color(0xFFFFD700),
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
            ),
          ),
        
        // Fee Bar - Compact
        if (feePercent > 0)
          Container(
            height: (20 * feePercent).clamp(2.0, 20.0),
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF10B981),
              borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
            ),
          ),

        // Compact Label
        Text(
          data.label.length > 3 ? data.label.substring(0, 3) : data.label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.black45,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ANALYTICS GRID - Clean and Organized
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildAnalyticsGrid(BuildContext context, RevenueData data) {
    return Column(
      children: [
        // Revenue by Tier - Full Width
        _buildFullWidthAnalyticsCard(
          context,
          title: 'Revenue by Tier',
          icon: Icons.diamond_outlined,
          color: const Color(0xFF8B5CF6),
          child: _buildEnhancedTiersList(context, data.byTier),
        ),

        const SizedBox(height: 20),

        // Pending Payouts - Full Width
        _buildFullWidthAnalyticsCard(
          context,
          title: 'Pending Payouts',
          icon: Icons.schedule_outlined,
          color: const Color(0xFFF59E0B),
          child: _buildEnhancedPayoutsList(context, data.pendingPayouts),
        ),

        const SizedBox(height: 20),

        // Top Gyms - Full Width
        _buildFullWidthAnalyticsCard(
          context,
          title: 'Top Gyms',
          icon: Icons.fitness_center_outlined,
          color: const Color(0xFF10B981),
          child: _buildEnhancedGymsList(context, data.byGym),
        ),

        const SizedBox(height: 20),

        // Recent Transactions - Full Width
        _buildFullWidthAnalyticsCard(
          context,
          title: 'Recent Transactions',
          icon: Icons.receipt_long_outlined,
          color: const Color(0xFFEC4899),
          child: _buildEnhancedTransactionsList(context, data.recentTransactions),
        ),
      ],
    );
  }

  Widget _buildFullWidthAnalyticsCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    final isDark = context.isDarkMode;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.08),
                ]
              : [
                  Colors.white,
                  Colors.white.withValues(alpha: 0.8),
                ],
        ),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Header with gradient background
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  color.withValues(alpha: 0.1),
                  color.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color,
                        color.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        'Detailed Analysis',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white.withValues(alpha: 0.7) : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Content
          child,
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ENHANCED LIST COMPONENTS - Full Width for Mobile
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildEnhancedTiersList(BuildContext context, List<RevenueByTier> tiers) {
    final isDark = context.isDarkMode;

    if (tiers.isEmpty) {
      return _buildEmptyState('No tier data available', Icons.diamond_outlined);
    }

    return Column(
      children: tiers.take(5).map((tier) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color(0xFF8B5CF6).withValues(alpha: isDark ? 0.1 : 0.05),
                const Color(0xFF8B5CF6).withValues(alpha: isDark ? 0.05 : 0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Tier Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF8B5CF6),
                      Color(0xFF8B5CF6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.diamond,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tier.tierName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      '${tier.subscriptionsCount} subscriptions',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white.withValues(alpha: 0.7) : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'EGP ${_formatNumber(tier.revenue)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8B5CF6),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${tier.percentageOfTotal.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8B5CF6),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEnhancedPayoutsList(BuildContext context, List<GymPayout> payouts) {
    final isDark = context.isDarkMode;

    if (payouts.isEmpty) {
      return _buildEmptyState('No pending payouts', Icons.check_circle_outlined);
    }

    return Column(
      children: payouts.take(5).map((payout) {
        final statusColor = _getStatusColor(payout.status);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                statusColor.withValues(alpha: isDark ? 0.1 : 0.05),
                statusColor.withValues(alpha: isDark ? 0.05 : 0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: statusColor.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Status Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      statusColor,
                      statusColor.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.schedule,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payout.gymName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            payout.status.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${payout.transactionsCount} txns',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white.withValues(alpha: 0.7) : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                'EGP ${_formatNumber(payout.amount)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEnhancedGymsList(BuildContext context, List<RevenueByGym> gyms) {
    final isDark = context.isDarkMode;

    if (gyms.isEmpty) {
      return _buildEmptyState('No gym data available', Icons.fitness_center_outlined);
    }

    return Column(
      children: gyms.take(5).map((gym) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color(0xFF10B981).withValues(alpha: isDark ? 0.1 : 0.05),
                const Color(0xFF10B981).withValues(alpha: isDark ? 0.05 : 0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF10B981).withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Gym Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF10B981),
                      Color(0xFF10B981),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gym.gymName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      gym.city,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white.withValues(alpha: 0.7) : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'EGP ${_formatNumber(gym.totalRevenue)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${gym.revenueSharePercent.toStringAsFixed(0)}% share',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEnhancedTransactionsList(BuildContext context, List<RevenueTransaction> transactions) {
    final isDark = context.isDarkMode;

    if (transactions.isEmpty) {
      return _buildEmptyState('No recent transactions', Icons.receipt_long_outlined);
    }

    return Column(
      children: transactions.take(5).map((txn) {
        final isRefund = txn.type == 'refund';
        final statusColor = _getStatusColor(txn.status);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                statusColor.withValues(alpha: isDark ? 0.1 : 0.05),
                statusColor.withValues(alpha: isDark ? 0.05 : 0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: statusColor.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Transaction Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      statusColor,
                      statusColor.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isRefund ? Icons.remove_circle : Icons.add_circle,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      txn.userName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      DateFormat('MMM d, yyyy • HH:mm').format(txn.createdAt),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white.withValues(alpha: 0.7) : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isRefund ? '-' : '+'}EGP ${txn.amount.abs().toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isRefund ? 'REFUND' : 'PAYMENT',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    final isDark = context.isDarkMode;

    return Container(
      height: 120,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: isDark ? Colors.white.withValues(alpha: 0.3) : Colors.black26,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return const Color(0xFF10B981);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'failed':
        return const Color(0xFFEF4444);
      case 'processing':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _formatNumber(double n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toStringAsFixed(0);
  }
}