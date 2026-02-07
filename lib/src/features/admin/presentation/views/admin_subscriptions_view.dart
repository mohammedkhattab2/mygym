import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mygym/src/features/admin/presentation/bloc/admin_subscriptions_cubit.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/luxury_theme_extension.dart';
import '../../domain/entities/admin_subscription.dart';

class AdminSubscriptionsView extends StatefulWidget {
  const AdminSubscriptionsView({super.key});

  @override
  State<AdminSubscriptionsView> createState() => _AdminSubscriptionsViewState();
}

class _AdminSubscriptionsViewState extends State<AdminSubscriptionsView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  SubscriptionStatus? _selectedStatus;
  SubscriptionTier? _selectedTier;
  bool _expiringOnly = false;

  @override
  void initState() {
    super.initState();
    context.read<AdminSubscriptionsCubit>().loadInitial();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool get _hasFilters =>
      _selectedStatus != null ||
      _selectedTier != null ||
      _expiringOnly ||
      _searchController.text.isNotEmpty;

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedStatus = null;
      _selectedTier = null;
      _expiringOnly = false;
    });
    context.read<AdminSubscriptionsCubit>().clearFilters();
  }

  String _fmtNum(double n) =>
      n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}K' : n.toStringAsFixed(0);

  Color _tierColor(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.basic:
        return AppColors.grey400;
      case SubscriptionTier.plus:
        return AppColors.primary;
      case SubscriptionTier.premium:
        return context.luxury.gold;
    }
  }

  Color _statusColor(SubscriptionStatus status) {
    switch (status) {
      case SubscriptionStatus.active:
        return AppColors.success;
      case SubscriptionStatus.expired:
        return AppColors.error;
      case SubscriptionStatus.cancelled:
        return AppColors.grey500;
      case SubscriptionStatus.paused:
        return AppColors.warning;
      case SubscriptionStatus.pendingPayment:
        return AppColors.info;
    }
  }

  IconData _statusIcon(SubscriptionStatus status) {
    switch (status) {
      case SubscriptionStatus.active:
        return Icons.check_circle_rounded;
      case SubscriptionStatus.expired:
        return Icons.cancel_rounded;
      case SubscriptionStatus.cancelled:
        return Icons.remove_circle_rounded;
      case SubscriptionStatus.paused:
        return Icons.pause_circle_rounded;
      case SubscriptionStatus.pendingPayment:
        return Icons.schedule_rounded;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Deep layered background
          Container(
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
          ),
          ..._buildBackgroundOrbs(isDark),

          // Content
          BlocBuilder<AdminSubscriptionsCubit, AdminSubscriptionsState>(
            builder: (context, state) {
              return state.when(
                initial: () => const SizedBox.shrink(),
                loading: () => _buildLoadingState(),
                error: (msg) => _buildErrorState(msg),
                loaded:
                    (
                      stats,
                      subs,
                      total,
                      page,
                      pages,
                      hasMore,
                      filter,
                      loading,
                    ) {
                      return CustomScrollView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(child: SizedBox(height: 12.h)),

                          // Hero Header
                          SliverToBoxAdapter(
                            child: _buildHeroHeader(stats, total),
                          ),

                          // Revenue & Tier Insights
                          SliverToBoxAdapter(child: _buildInsightsRow(stats)),

                          // Stat Chips Strip
                          SliverToBoxAdapter(
                            child: _buildStatChipsStrip(stats),
                          ),

                          // Search & Filters
                          SliverToBoxAdapter(child: _buildFiltersSection()),

                          // Section Header
                          if (subs.isNotEmpty)
                            SliverToBoxAdapter(
                              child: _buildSectionHeader(subs),
                            ),

                          // Subscription List
                          subs.isEmpty
                              ? SliverToBoxAdapter(child: _buildEmptyState())
                              : SliverPadding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                  ),
                                  sliver: SliverList.separated(
                                    itemCount: subs.length,
                                    separatorBuilder: (_, __) =>
                                        SizedBox(height: 14.h),
                                    itemBuilder: (_, i) =>
                                        _buildSubscriptionCard(subs[i]),
                                  ),
                                ),

                          if (loading)
                            SliverToBoxAdapter(child: _buildLoadingMore()),

                          if (pages > 1)
                            SliverToBoxAdapter(
                              child: _buildPagination(page, pages, hasMore),
                            ),

                          SliverToBoxAdapter(child: SizedBox(height: 48.h)),
                        ],
                      );
                    },
              );
            },
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // BACKGROUND ORBS
  // ═══════════════════════════════════════════════════════════════

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

  // ═══════════════════════════════════════════════════════════════
  // HERO HEADER — PREMIUM
  // ═══════════════════════════════════════════════════════════════

  Widget _buildHeroHeader(SubscriptionsStats stats, int total) {
    final cs = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;
    final tierTotal = (stats.basicCount + stats.plusCount + stats.premiumCount)
        .toDouble();

    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
      padding: EdgeInsets.fromLTRB(22.r, 22.r, 22.r, 18.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF141230).withValues(alpha: 0.97),
                  const Color(0xFF1E1B4B).withValues(alpha: 0.92),
                  const Color(0xFF251F5C).withValues(alpha: 0.88),
                ]
              : [
                  Colors.white.withValues(alpha: 0.97),
                  const Color(0xFFF8F4FF).withValues(alpha: 0.95),
                  const Color(0xFFF0EAFF).withValues(alpha: 0.92),
                ],
        ),
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          width: 1.5,
          color: isDark
              ? luxury.gold.withValues(alpha: 0.2)
              : luxury.gold.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : luxury.gold.withValues(alpha: 0.06),
            blurRadius: 32,
            offset: const Offset(0, 12),
            spreadRadius: -6,
          ),
          BoxShadow(
            color: luxury.gold.withValues(
              alpha: isDark ? 0.08 : 0.04,
            ),
            blurRadius: 60,
            offset: const Offset(0, 4),
            spreadRadius: -12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── TOP ROW: Icon + Title + Actions ──
          Row(
            children: [
              // Icon container
              Container(
                width: 52.r,
                height: 52.r,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      luxury.gold,
                      luxury.roseGold,
                      luxury.gold.withValues(alpha: 0.85),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: luxury.gold.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: luxury.roseGold.withValues(alpha: 0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 2),
                      spreadRadius: -4,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.card_membership_rounded,
                    size: 26.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 14.w),

              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Subscriptions',
                            style: GoogleFonts.raleway(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                              color: cs.onSurface,
                              letterSpacing: -0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        // Count badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: luxury.gold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: luxury.gold.withValues(alpha: 0.3),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            '$total',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: luxury.gold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Plans · Billing · Renewals',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // ── ACTION BUTTONS ROW ──
          Row(
            children: [
              const Spacer(),
              _buildHeaderAction(
                icon: Icons.refresh_rounded,
                label: 'Refresh',
                onTap: () => context
                    .read<AdminSubscriptionsCubit>()
                    .loadInitial(),
              ),
              SizedBox(width: 8.w),
              _buildExportButton(),
            ],
          ),

          SizedBox(height: 16.h),

          // ── DIVIDER ──
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  luxury.gold.withValues(alpha: 0.25),
                  luxury.roseGold.withValues(alpha: 0.2),
                  luxury.gold.withValues(alpha: 0.25),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // ── TIER DISTRIBUTION ──
          if (tierTotal > 0) _buildTierRow(stats, tierTotal),
        ],
      ),
    );
  }

  Widget _buildHeaderAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: luxury.gold.withValues(alpha: isDark ? 0.15 : 0.1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16.sp, color: luxury.gold),
              SizedBox(width: 6.w),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: luxury.gold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExportButton() {
    final luxury = context.luxury;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () async {
          final url = await context
              .read<AdminSubscriptionsCubit>()
              .exportSubscriptions();
          if (url != null && mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Export ready: $url')));
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [luxury.gold, luxury.roseGold],
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: luxury.gold.withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: luxury.roseGold.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 2),
                spreadRadius: -4,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.download_rounded, color: Colors.white, size: 15.sp),
              SizedBox(width: 6.w),
              Text(
                'Export',
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTierRow(SubscriptionsStats stats, double tierTotal) {
    final luxury = context.luxury;
    return Row(
      children: [
        Expanded(
          child: _buildTierItem(
            label: 'Basic',
            count: stats.basicCount,
            total: tierTotal,
            color: AppColors.grey400,
            icon: Icons.circle_outlined,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _buildTierItem(
            label: 'Plus',
            count: stats.plusCount,
            total: tierTotal,
            color: AppColors.primary,
            icon: Icons.add_circle_outline_rounded,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _buildTierItem(
            label: 'Premium',
            count: stats.premiumCount,
            total: tierTotal,
            color: luxury.gold,
            icon: Icons.diamond_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildTierItem({
    required String label,
    required int count,
    required double total,
    required Color color,
    required IconData icon,
  }) {
    final isDark = context.isDarkMode;
    final pct = total > 0 ? (count / total * 100) : 0.0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [color.withValues(alpha: 0.1), color.withValues(alpha: 0.04)]
              : [color.withValues(alpha: 0.08), color.withValues(alpha: 0.03)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withValues(alpha: isDark ? 0.2 : 0.12)),
      ),
      child: Column(
        children: [
          // Circular progress ring
          SizedBox(
            width: 40.r,
            height: 40.r,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 40.r,
                  height: 40.r,
                  child: CircularProgressIndicator(
                    value: pct / 100,
                    strokeWidth: 3,
                    backgroundColor: color.withValues(alpha: 0.12),
                    color: color,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Icon(icon, size: 16.sp, color: color),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '$count',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            '${pct.toStringAsFixed(0)}%',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: color.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // INSIGHTS ROW (Revenue + Renewal)
  // ═══════════════════════════════════════════════════════════════

  Widget _buildInsightsRow(SubscriptionsStats stats) {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
      child: Row(
        children: [
          Expanded(
            child: _buildInsightCard(
              icon: Icons.trending_up_rounded,
              iconGradient: [AppColors.success, AppColors.successDark],
              title: 'Monthly Revenue',
              value: 'EGP ${_fmtNum(stats.revenueThisMonth)}',
              subtitle: 'Platform: EGP ${_fmtNum(stats.platformEarnings)}',
              accentColor: AppColors.success,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildInsightCard(
              icon: Icons.autorenew_rounded,
              iconGradient: [AppColors.info, AppColors.infoDark],
              title: 'Renewal Rate',
              value: '${stats.renewalRate.toStringAsFixed(0)}%',
              subtitle:
                  'Avg value: EGP ${stats.averageSubscriptionValue.toStringAsFixed(0)}',
              accentColor: AppColors.info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard({
    required IconData icon,
    required List<Color> iconGradient,
    required String title,
    required String value,
    required String subtitle,
    required Color accentColor,
  }) {
    final cs = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
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
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: accentColor.withValues(alpha: isDark ? 0.2 : 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: isDark ? 0.08 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: iconGradient),
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: iconGradient[0].withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, size: 16.sp, color: Colors.white),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurfaceVariant,
                    letterSpacing: 0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              color: cs.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // STAT CHIPS STRIP
  // ═══════════════════════════════════════════════════════════════

  Widget _buildStatChipsStrip(SubscriptionsStats stats) {
    final luxury = context.luxury;
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 0, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildStatChip(
              icon: Icons.verified_rounded,
              value: '${stats.activeSubscriptions}',
              label: 'Active',
              color: AppColors.success,
              isAccent: true,
            ),
            SizedBox(width: 10.w),
            _buildStatChip(
              icon: Icons.timelapse_rounded,
              value: '${stats.expiringThisWeek}',
              label: 'Expiring',
              color: AppColors.warning,
            ),
            SizedBox(width: 10.w),
            _buildStatChip(
              icon: Icons.cancel_outlined,
              value: '${stats.expiredSubscriptions}',
              label: 'Expired',
              color: AppColors.error,
            ),
            SizedBox(width: 10.w),
            _buildStatChip(
              icon: Icons.block_rounded,
              value: '${stats.cancelledSubscriptions}',
              label: 'Cancelled',
              color: AppColors.grey500,
            ),
            SizedBox(width: 20.w),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    bool isAccent = false,
  }) {
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: isAccent
            ? LinearGradient(
                colors: [
                  color.withValues(alpha: isDark ? 0.2 : 0.15),
                  color.withValues(alpha: isDark ? 0.1 : 0.08),
                ],
              )
            : null,
        color: isAccent
            ? null
            : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isAccent
              ? color.withValues(alpha: 0.3)
              : (isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.06)),
        ),
        boxShadow: isAccent
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(icon, size: 14.sp, color: color),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: isAccent
                      ? color
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // FILTERS SECTION
  // ═══════════════════════════════════════════════════════════════

  Widget _buildFiltersSection() {
    final cs = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
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
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? AppColors.gold.withValues(alpha: 0.25)
              : AppColors.gold.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Field
          Container(
            height: 44.h,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: luxury.gold.withValues(alpha: 0.1)),
            ),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.inter(fontSize: 13.sp, color: cs.onSurface),
              decoration: InputDecoration(
                hintText: 'Search by name or email…',
                hintStyle: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 18.sp,
                  color: cs.onSurfaceVariant,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          size: 16.sp,
                          color: cs.onSurfaceVariant,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          context
                              .read<AdminSubscriptionsCubit>()
                              .searchSubscriptions('');
                          setState(() {});
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              onChanged: (v) {
                context.read<AdminSubscriptionsCubit>().searchSubscriptions(v);
                setState(() {});
              },
            ),
          ),
          SizedBox(height: 12.h),
          // Filter Chips Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Status
                _buildFilterChip<SubscriptionStatus?>(
                  value: _selectedStatus,
                  hint: 'Status',
                  icon: Icons.toggle_on_rounded,
                  color: AppColors.success,
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All Status'),
                    ),
                    ...SubscriptionStatus.values.map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text(s.displayName),
                      ),
                    ),
                  ],
                  onChanged: (v) {
                    setState(() => _selectedStatus = v);
                    context.read<AdminSubscriptionsCubit>().filterByStatus(v);
                  },
                ),
                SizedBox(width: 8.w),
                // Tier
                _buildFilterChip<SubscriptionTier?>(
                  value: _selectedTier,
                  hint: 'Tier',
                  icon: Icons.workspace_premium_rounded,
                  color: AppColors.primary,
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All Tiers'),
                    ),
                    ...SubscriptionTier.values.map(
                      (t) => DropdownMenuItem(
                        value: t,
                        child: Text(t.displayName),
                      ),
                    ),
                  ],
                  onChanged: (v) {
                    setState(() => _selectedTier = v);
                    context.read<AdminSubscriptionsCubit>().filterByTier(v);
                  },
                ),
                SizedBox(width: 8.w),
                // Expiring toggle
                _buildExpiringToggle(),
                // Clear
                if (_hasFilters) ...[
                  SizedBox(width: 8.w),
                  _buildClearFilterChip(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip<T>({
    required T value,
    required String hint,
    required IconData icon,
    required Color color,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
  }) {
    final cs = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Container(
      height: 36.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: value != null
            ? color.withValues(alpha: isDark ? 0.15 : 0.1)
            : (isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.03)),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: value != null
              ? color.withValues(alpha: 0.3)
              : (isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.sp,
            color: value != null ? color : cs.onSurfaceVariant,
          ),
          SizedBox(width: 6.w),
          DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              hint: Text(
                hint,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: cs.onSurfaceVariant,
                ),
              ),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: value != null ? color : cs.onSurfaceVariant,
                size: 16.sp,
              ),
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: value != null ? color : cs.onSurface,
              ),
              dropdownColor: isDark ? const Color(0xFF1E1B4B) : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiringToggle() {
    final isDark = context.isDarkMode;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: () {
          setState(() => _expiringOnly = !_expiringOnly);
          context.read<AdminSubscriptionsCubit>().filterExpiringOnly(
            _expiringOnly ? true : null,
          );
        },
        child: Container(
          height: 36.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: _expiringOnly
                ? AppColors.warning.withValues(alpha: isDark ? 0.18 : 0.12)
                : isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: _expiringOnly
                  ? AppColors.warning.withValues(alpha: 0.4)
                  : isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 14.sp,
                color: _expiringOnly
                    ? AppColors.warning
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 6.w),
              Text(
                'Expiring',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: _expiringOnly ? FontWeight.w600 : FontWeight.w500,
                  color: _expiringOnly
                      ? AppColors.warning
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClearFilterChip() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: _clearFilters,
        child: Container(
          height: 36.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.filter_alt_off_rounded,
                size: 14.sp,
                color: AppColors.error,
              ),
              SizedBox(width: 6.w),
              Text(
                'Clear',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // SECTION HEADER
  // ═══════════════════════════════════════════════════════════════

  Widget _buildSectionHeader(List<AdminSubscription> subs) {
    final luxury = context.luxury;
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: luxury.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 18.sp,
              color: luxury.gold,
            ),
          ),
          SizedBox(width: 12.w),
          Flexible(
            child: Text(
              'Active Subscriptions',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: luxury.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: BoxDecoration(
                    color: luxury.gold,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  '${subs.length} records',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // SUBSCRIPTION CARD - PREMIUM REDESIGN
  // ═══════════════════════════════════════════════════════════════

  Widget _buildSubscriptionCard(AdminSubscription sub) {
    final cs = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;
    final tierColor = _tierColor(sub.tier);
    final statusClr = _statusColor(sub.status);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: () => _showDetailsSheet(sub),
        child: Container(
          decoration: BoxDecoration(
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
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: sub.isExpiringSoon
                  ? AppColors.warning.withValues(alpha: 0.4)
                  : isDark
                  ? luxury.gold.withValues(alpha: 0.12)
                  : luxury.gold.withValues(alpha: 0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
                blurRadius: 16,
                offset: const Offset(0, 6),
                spreadRadius: -4,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Card content with left padding for accent stripe
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      // Top: Avatar + Name + Badges
                      Row(
                        children: [
                          _buildAvatar(sub),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sub.userName,
                                  style: GoogleFonts.inter(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: cs.onSurface,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  sub.userEmail,
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: cs.onSurfaceVariant,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildTierBadge(sub.tier),
                              SizedBox(height: 6.h),
                              _buildStatusBadge(sub.status),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 14.h),

                      // Bottom: Metadata row
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.03)
                              : const Color(0xFFF8F7FB),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth > 420;

                            if (isWide) {
                              return Row(
                                children: [
                                  _metaChip(
                                    Icons.payments_outlined,
                                    'EGP ${sub.price.toStringAsFixed(0)}',
                                    luxury.gold,
                                  ),
                                  SizedBox(width: 12.w),
                                  _metaChip(
                                    Icons.date_range_rounded,
                                    sub.duration.displayName,
                                    AppColors.info,
                                  ),
                                  SizedBox(width: 12.w),
                                  _buildDaysRemainingChip(sub),
                                  SizedBox(width: 12.w),
                                  _buildVisitsChip(sub),
                                  const Spacer(),
                                  _buildCardActions(sub),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _metaChip(
                                          Icons.payments_outlined,
                                          'EGP ${sub.price.toStringAsFixed(0)}',
                                          luxury.gold,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: _metaChip(
                                          Icons.date_range_rounded,
                                          sub.duration.displayName,
                                          AppColors.info,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildDaysRemainingChip(sub),
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(child: _buildVisitsChip(sub)),
                                      SizedBox(width: 8.w),
                                      _buildCardActions(sub),
                                    ],
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Left accent stripe (positioned to stretch full height)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [tierColor, tierColor.withValues(alpha: 0.4)],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      bottomLeft: Radius.circular(20.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(AdminSubscription sub) {
    final luxury = context.luxury;
    return Container(
      width: 44.r,
      height: 44.r,
      decoration: BoxDecoration(
        gradient: sub.userAvatarUrl == null
            ? LinearGradient(
                colors: [luxury.gold, luxury.gold.withValues(alpha: 0.7)],
              )
            : null,
        borderRadius: BorderRadius.circular(13.r),
        image: sub.userAvatarUrl != null
            ? DecorationImage(
                image: NetworkImage(sub.userAvatarUrl!),
                fit: BoxFit.cover,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: luxury.gold.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: sub.userAvatarUrl == null
          ? Center(
              child: Text(
                sub.userName.isNotEmpty ? sub.userName[0].toUpperCase() : '?',
                style: GoogleFonts.raleway(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildTierBadge(SubscriptionTier tier) {
    final color = _tierColor(tier);
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tier == SubscriptionTier.premium)
            Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: Icon(Icons.diamond_rounded, size: 10.sp, color: color),
            ),
          Text(
            tier.displayName,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(SubscriptionStatus status) {
    final color = _statusColor(status);
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5.r,
            height: 5.r,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 4),
              ],
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            status.displayName,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaChip(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13.sp, color: color.withValues(alpha: 0.7)),
        SizedBox(width: 4.w),
        Flexible(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDaysRemainingChip(AdminSubscription sub) {
    final isExpiring = sub.isExpiringSoon;
    final color = sub.status != SubscriptionStatus.active
        ? AppColors.grey500
        : isExpiring
        ? AppColors.warning
        : AppColors.success;

    final text = sub.status != SubscriptionStatus.active
        ? sub.status.displayName
        : sub.daysRemaining <= 0
        ? 'Ended'
        : '${sub.daysRemaining}d left';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.hourglass_bottom_rounded,
          size: 13.sp,
          color: color.withValues(alpha: 0.7),
        ),
        SizedBox(width: 4.w),
        Flexible(
          child: Text(
            text,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildVisitsChip(AdminSubscription sub) {
    final text = sub.visitLimit != null
        ? '${sub.visitsUsed}/${sub.visitLimit}'
        : '${sub.visitsUsed} visits';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.directions_walk_rounded,
          size: 13.sp,
          color: AppColors.primary.withValues(alpha: 0.7),
        ),
        SizedBox(width: 4.w),
        Flexible(
          child: Text(
            text,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCardActions(AdminSubscription sub) {
    final cs = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return PopupMenuButton<String>(
      icon: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          Icons.more_horiz_rounded,
          size: 16.sp,
          color: cs.onSurfaceVariant,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      color: isDark ? const Color(0xFF1E1B4B) : Colors.white,
      elevation: 12,
      itemBuilder: (_) => [
        _buildPopupItem(
          'view',
          'View Details',
          Icons.visibility_outlined,
          luxury.gold,
        ),
        if (sub.status == SubscriptionStatus.active)
          _buildPopupItem(
            'pause',
            'Pause',
            Icons.pause_circle_outline,
            AppColors.warning,
          ),
        if (sub.status == SubscriptionStatus.paused)
          _buildPopupItem(
            'resume',
            'Resume',
            Icons.play_circle_outline,
            AppColors.success,
          ),
        if (sub.status == SubscriptionStatus.active ||
            sub.status == SubscriptionStatus.paused)
          _buildPopupItem(
            'extend',
            'Extend',
            Icons.add_circle_outline,
            AppColors.info,
          ),
        if (sub.status == SubscriptionStatus.active ||
            sub.status == SubscriptionStatus.paused)
          _buildPopupItem(
            'cancel',
            'Cancel',
            Icons.cancel_outlined,
            AppColors.error,
          ),
      ],
      onSelected: (a) => _handleAction(sub, a),
    );
  }

  PopupMenuItem<String> _buildPopupItem(
    String val,
    String label,
    IconData icon,
    Color color,
  ) {
    return PopupMenuItem(
      value: val,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(7.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 16.sp, color: color),
          ),
          SizedBox(width: 12.w),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // PAGINATION
  // ═══════════════════════════════════════════════════════════════

  Widget _buildPagination(int page, int pages, bool hasMore) {
    final cs = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
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
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: luxury.gold.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: luxury.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Page ',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [luxury.gold, luxury.gold.withValues(alpha: 0.8)],
                    ),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Text(
                    '$page',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  ' of $pages',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          _buildPageButton(Icons.chevron_left_rounded, page > 1, () {
            final cubit = context.read<AdminSubscriptionsCubit>();
            cubit.loadSubscriptions(
              filter: cubit.currentFilter.copyWith(page: page - 1),
            );
          }),
          SizedBox(width: 8.w),
          _buildPageButton(Icons.chevron_right_rounded, hasMore, () {
            final cubit = context.read<AdminSubscriptionsCubit>();
            cubit.loadSubscriptions(
              filter: cubit.currentFilter.copyWith(page: page + 1),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPageButton(IconData icon, bool enabled, VoidCallback onTap) {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: enabled ? onTap : null,
        child: Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: enabled
                ? luxury.gold.withValues(alpha: isDark ? 0.15 : 0.1)
                : cs.onSurface.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: enabled
                  ? luxury.gold.withValues(alpha: 0.25)
                  : cs.onSurface.withValues(alpha: 0.1),
            ),
          ),
          child: Icon(
            icon,
            size: 20.sp,
            color: enabled ? luxury.gold : cs.onSurface.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // STATES
  // ═══════════════════════════════════════════════════════════════

  Widget _buildLoadingState() {
    final isDark = context.isDarkMode;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.gold.withValues(alpha: isDark ? 0.2 : 0.1),
                  AppColors.gold.withValues(alpha: isDark ? 0.08 : 0.04),
                  Colors.transparent,
                ],
              ),
            ),
            child: SizedBox(
              width: 48.r,
              height: 48.r,
              child: CircularProgressIndicator(
                color: AppColors.gold,
                strokeWidth: 3,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Loading subscriptions…',
            style: GoogleFonts.raleway(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.7)
                  : const Color(0xFF1A1A2E).withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMore() {
    final luxury = context.luxury;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 24.r,
              height: 24.r,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: luxury.gold,
              ),
            ),
            SizedBox(width: 14.w),
            Text(
              'Loading more…',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: luxury.gold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String msg) {
    final luxury = context.luxury;
    final cs = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.error.withValues(alpha: isDark ? 0.2 : 0.1),
                  AppColors.error.withValues(alpha: isDark ? 0.08 : 0.04),
                  Colors.transparent,
                ],
              ),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 48.sp,
              color: AppColors.error,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Something Went Wrong',
            style: GoogleFonts.raleway(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            msg,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () =>
                  context.read<AdminSubscriptionsCubit>().loadInitial(),
              borderRadius: BorderRadius.circular(14.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [luxury.gold, luxury.gold.withValues(alpha: 0.85)],
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: luxury.gold.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'Try Again',
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
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 60.h),
          Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.gold.withValues(alpha: isDark ? 0.15 : 0.08),
                  AppColors.gold.withValues(alpha: isDark ? 0.06 : 0.03),
                  Colors.transparent,
                ],
              ),
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 56.sp,
              color: AppColors.gold,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No Subscriptions Found',
            style: GoogleFonts.raleway(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your filters or search terms',
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
          if (_hasFilters) ...[
            SizedBox(height: 32.h),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _clearFilters,
                borderRadius: BorderRadius.circular(14.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        luxury.gold,
                        luxury.gold.withValues(alpha: 0.85),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: luxury.gold.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.filter_alt_off_rounded,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Clear Filters',
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
          ],
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // DIALOGS & SHEETS
  // ═══════════════════════════════════════════════════════════════

  void _handleAction(AdminSubscription sub, String action) async {
    final cubit = context.read<AdminSubscriptionsCubit>();
    switch (action) {
      case 'view':
        _showDetailsSheet(sub);
        break;
      case 'pause':
        await cubit.pauseSubscription(sub.id);
        break;
      case 'resume':
        await cubit.resumeSubscription(sub.id);
        break;
      case 'extend':
        _showExtendSheet(sub);
        break;
      case 'cancel':
        _showCancelSheet(sub);
        break;
    }
  }

  void _showDetailsSheet(AdminSubscription sub) {
    final cs = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.72,
        maxChildSize: 0.92,
        minChildSize: 0.4,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [const Color(0xFF1E1B4B), const Color(0xFF0F0F18)]
                  : [Colors.white, const Color(0xFFF8F5FF)],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          ),
          child: ListView(
            controller: controller,
            padding: EdgeInsets.all(24.r),
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              // User header
              Row(
                children: [
                  _buildAvatar(sub),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sub.userName,
                          style: GoogleFonts.inter(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          sub.userEmail,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildTierBadge(sub.tier),
                      SizedBox(height: 6.h),
                      _buildStatusBadge(sub.status),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 28.h),

              // Details sections
              _buildDetailSection('Subscription', [
                _buildDetailRow(
                  'Tier',
                  sub.tier.displayName,
                  Icons.workspace_premium_rounded,
                ),
                _buildDetailRow(
                  'Duration',
                  sub.duration.displayName,
                  Icons.date_range_rounded,
                ),
                _buildDetailRow(
                  'Auto Renew',
                  sub.autoRenew ? 'Yes' : 'No',
                  Icons.autorenew_rounded,
                ),
              ]),
              SizedBox(height: 16.h),
              _buildDetailSection('Financial', [
                _buildDetailRow(
                  'Price',
                  'EGP ${sub.price.toStringAsFixed(0)}',
                  Icons.payments_rounded,
                ),
                _buildDetailRow(
                  'Platform Fee',
                  'EGP ${sub.platformFee.toStringAsFixed(0)}',
                  Icons.account_balance_rounded,
                ),
                _buildDetailRow(
                  'Gym Share',
                  'EGP ${sub.gymShare.toStringAsFixed(0)}',
                  Icons.store_rounded,
                ),
                _buildDetailRow(
                  'Payment',
                  sub.paymentMethod,
                  Icons.credit_card_rounded,
                ),
              ]),
              SizedBox(height: 16.h),
              _buildDetailSection('Dates', [
                _buildDetailRow(
                  'Start',
                  DateFormat('MMM d, yyyy').format(sub.startDate),
                  Icons.calendar_today_rounded,
                ),
                _buildDetailRow(
                  'End',
                  DateFormat('MMM d, yyyy').format(sub.endDate),
                  Icons.event_rounded,
                ),
                if (sub.status == SubscriptionStatus.active)
                  _buildDetailRow(
                    'Remaining',
                    sub.daysRemaining <= 0
                        ? 'Expired'
                        : '${sub.daysRemaining} days',
                    Icons.hourglass_bottom_rounded,
                  ),
              ]),
              SizedBox(height: 16.h),
              _buildDetailSection('Usage', [
                _buildDetailRow(
                  'Visits',
                  sub.visitLimit != null
                      ? '${sub.visitsUsed} / ${sub.visitLimit}'
                      : '${sub.visitsUsed}',
                  Icons.directions_walk_rounded,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    final cs = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : const Color(0xFFF8F7FB),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: cs.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 12.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    final cs = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: luxury.gold.withValues(alpha: 0.6)),
          SizedBox(width: 12.w),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: cs.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  void _showExtendSheet(AdminSubscription sub) {
    final cs = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;
    int selectedDays = 7;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (_, setSheet) => Container(
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [const Color(0xFF1E1B4B), const Color(0xFF0F0F18)]
                  : [Colors.white, const Color(0xFFF8F5FF)],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 24.h),
                decoration: BoxDecoration(
                  color: cs.onSurface.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_circle_outline_rounded,
                  size: 36.sp,
                  color: AppColors.info,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Extend Subscription',
                style: GoogleFonts.inter(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Extend ${sub.userName}\'s plan by:',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: cs.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 24.h),
              Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: [7, 14, 30, 60, 90].map((d) {
                  final sel = d == selectedDays;
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () => setSheet(() => selectedDays = d),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: sel ? luxury.goldGradient : null,
                          color: sel
                              ? null
                              : isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : const Color(0xFFF5F4F8),
                          borderRadius: BorderRadius.circular(12.r),
                          border: sel
                              ? null
                              : Border.all(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : Colors.black.withValues(alpha: 0.06),
                                ),
                          boxShadow: sel
                              ? [
                                  BoxShadow(
                                    color: luxury.gold.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          '$d days',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: sel ? Colors.white : cs.onSurface,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 28.h),
              Row(
                children: [
                  Expanded(
                    child: _buildSheetButton(
                      'Cancel',
                      cs.onSurfaceVariant,
                      false,
                      () => Navigator.pop(ctx),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: _buildSheetButton(
                      'Extend',
                      luxury.gold,
                      true,
                      () async {
                        Navigator.pop(ctx);
                        await context
                            .read<AdminSubscriptionsCubit>()
                            .extendSubscription(sub.id, selectedDays);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(ctx).padding.bottom + 8.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelSheet(AdminSubscription sub) {
    final cs = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;
    final reasonCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [const Color(0xFF1E1B4B), const Color(0xFF0F0F18)]
                  : [Colors.white, const Color(0xFFF8F5FF)],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 24.h),
                decoration: BoxDecoration(
                  color: cs.onSurface.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cancel_outlined,
                  size: 36.sp,
                  color: AppColors.error,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Cancel Subscription',
                style: GoogleFonts.inter(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Cancel ${sub.userName}\'s subscription?',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: cs.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : const Color(0xFFF5F4F8),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.06),
                  ),
                ),
                child: TextField(
                  controller: reasonCtrl,
                  maxLines: 3,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: cs.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Reason (optional)',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.r),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: _buildSheetButton(
                      'Keep Active',
                      cs.onSurfaceVariant,
                      false,
                      () => Navigator.pop(ctx),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: _buildSheetButton(
                      'Cancel',
                      AppColors.error,
                      true,
                      () async {
                        Navigator.pop(ctx);
                        await context
                            .read<AdminSubscriptionsCubit>()
                            .cancelSubscription(sub.id, reasonCtrl.text);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(ctx).padding.bottom + 8.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSheetButton(
    String label,
    Color color,
    bool filled,
    VoidCallback onTap,
  ) {
    final cs = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            gradient: filled
                ? LinearGradient(colors: [color, color.withValues(alpha: 0.85)])
                : null,
            color: filled
                ? null
                : isDark
                ? Colors.white.withValues(alpha: 0.05)
                : const Color(0xFFF5F4F8),
            borderRadius: BorderRadius.circular(14.r),
            border: filled
                ? null
                : Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.06),
                  ),
            boxShadow: filled
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: filled ? Colors.white : cs.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
