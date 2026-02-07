import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/features/admin/presentation/bloc/admin_analytics_cubit.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/luxury_theme_extension.dart';
import '../../domain/entities/admin_analytics.dart';

class AdminAnalyticsView extends StatefulWidget {
  const AdminAnalyticsView({super.key});

  @override
  State<AdminAnalyticsView> createState() => _AdminAnalyticsViewState();
}

class _AdminAnalyticsViewState extends State<AdminAnalyticsView>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late AnimationController _waveController;
  late AnimationController _particleController;
  late Animation<double> _fadeIn;
  late Animation<double> _pulse;
  late Animation<double> _shimmer;
  late Animation<double> _wave;
  late Animation<double> _particle;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Shimmer animation for magical glow effects
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
    _shimmer = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );

    // Wave animation for flowing effects
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
    _wave = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.linear),
    );

    // Particle animation for floating sparkles
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
    _particle = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    context.read<AdminAnalyticsCubit>().loadAnalytics();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    _waveController.dispose();
    _particleController.dispose();
    super.dispose();
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
        child: Stack(
          children: [
            // Background magical orbs
            ..._buildBackgroundOrbs(isDark),
            // Main content
            BlocBuilder<AdminAnalyticsCubit, AdminAnalyticsState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const SizedBox.shrink(),
                  loading: () => _buildLoadingState(context),
                  error: (msg) => _buildErrorState(context, msg),
                  loaded: (data, range) => FadeTransition(
                    opacity: _fadeIn,
                    child: _buildContent(context, data, range),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBackgroundOrbs(bool isDark) {
    return [
      // Primary orb - top right
      Positioned(
        top: -80.r,
        right: -40.r,
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (_, __) => Opacity(
            opacity: _pulse.value,
            child: Container(
              width: 260.r,
              height: 260.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: isDark
                      ? [
                          AppColors.primary.withValues(alpha: 0.14),
                          AppColors.primary.withValues(alpha: 0.04),
                          Colors.transparent,
                        ]
                      : [
                          AppColors.primary.withValues(alpha: 0.07),
                          AppColors.primary.withValues(alpha: 0.02),
                          Colors.transparent,
                        ],
                ),
              ),
            ),
          ),
        ),
      ),
      // Gold orb - top left
      Positioned(
        top: 200.r,
        left: -100.r,
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (_, __) => Opacity(
            opacity: 0.4 + (_pulse.value * 0.4),
            child: Container(
              width: 220.r,
              height: 220.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: isDark
                      ? [
                          AppColors.gold.withValues(alpha: 0.12),
                          AppColors.gold.withValues(alpha: 0.04),
                          Colors.transparent,
                        ]
                      : [
                          AppColors.gold.withValues(alpha: 0.06),
                          AppColors.gold.withValues(alpha: 0.02),
                          Colors.transparent,
                        ],
                ),
              ),
            ),
          ),
        ),
      ),
      // Secondary orb - bottom right
      Positioned(
        bottom: 150.r,
        right: -60.r,
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (_, __) => Opacity(
            opacity: 0.5 + (_pulse.value * 0.3),
            child: Container(
              width: 180.r,
              height: 180.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: isDark
                      ? [
                          AppColors.secondary.withValues(alpha: 0.1),
                          AppColors.secondary.withValues(alpha: 0.03),
                          Colors.transparent,
                        ]
                      : [
                          AppColors.secondary.withValues(alpha: 0.05),
                          AppColors.secondary.withValues(alpha: 0.015),
                          Colors.transparent,
                        ],
                ),
              ),
            ),
          ),
        ),
      ),
      // Info orb - center left
      Positioned(
        top: 500.r,
        left: -80.r,
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (_, __) => Opacity(
            opacity: 0.3 + (_pulse.value * 0.4),
            child: Container(
              width: 160.r,
              height: 160.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: isDark
                      ? [
                          AppColors.info.withValues(alpha: 0.1),
                          AppColors.info.withValues(alpha: 0.03),
                          Colors.transparent,
                        ]
                      : [
                          AppColors.info.withValues(alpha: 0.05),
                          AppColors.info.withValues(alpha: 0.015),
                          Colors.transparent,
                        ],
                ),
              ),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildContent(BuildContext context, AnalyticsData data, AnalyticsRange range) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, range),
          SizedBox(height: 20.h),
          _buildOverviewCards(context, data.overview),
          SizedBox(height: 20.h),
          _buildEngagementSection(context, data.engagement),
          SizedBox(height: 20.h),
          // User Growth Chart - full width
          _buildUserGrowthChart(context, data.userGrowthTrend),
          SizedBox(height: 20.h),
          // Acquisition Sources - full width
          _buildAcquisitionSources(context, data.acquisitionSources),
          SizedBox(height: 20.h),
          // Visit Heatmap - full width
          _buildVisitHeatmap(context, data.visitAnalytics),
          SizedBox(height: 20.h),
          // Subscription Breakdown - full width
          _buildSubscriptionBreakdown(context, data.subscriptionAnalytics),
          SizedBox(height: 20.h),
          // Geographic Distribution - full width
          _buildGeographicDistribution(context, data.geographicDistribution),
          SizedBox(height: 20.h),
          // Popular Gyms - full width
          _buildPopularGyms(context, data.popularGyms),
          SizedBox(height: 20.h),
          // Retention Section - full width
          _buildRetentionSection(context, data.subscriptionAnalytics),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AnalyticsRange range) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1A1625).withValues(alpha: 0.98),
                  const Color(0xFF2D2640).withValues(alpha: 0.95),
                  const Color(0xFF1E1B4B).withValues(alpha: 0.92),
                ]
              : [
                  Colors.white.withValues(alpha: 0.98),
                  const Color(0xFFFAF8FF).withValues(alpha: 0.95),
                  const Color(0xFFF5F0FF).withValues(alpha: 0.92),
                ],
          stops: const [0.0, 0.5, 1.0],
        ),
        border: Border.all(
          color: isDark
              ? AppColors.info.withValues(alpha: 0.35)
              : AppColors.info.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          // Primary glow shadow
          BoxShadow(
            color: AppColors.info.withValues(alpha: isDark ? 0.25 : 0.12),
            blurRadius: 32,
            offset: const Offset(0, 12),
            spreadRadius: -8,
          ),
          // Secondary ambient shadow
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: -6,
          ),
          // Inner glow effect
          BoxShadow(
            color: AppColors.gold.withValues(alpha: isDark ? 0.08 : 0.04),
            blurRadius: 40,
            offset: const Offset(0, 4),
            spreadRadius: -10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Stack(
            children: [
              // Decorative gradient orb - top right
              Positioned(
                top: -30.r,
                right: -20.r,
                child: AnimatedBuilder(
                  animation: _pulse,
                  builder: (_, __) => Opacity(
                    opacity: 0.4 + (_pulse.value * 0.3),
                    child: Container(
                      width: 120.r,
                      height: 120.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.info.withValues(alpha: isDark ? 0.3 : 0.15),
                            AppColors.info.withValues(alpha: isDark ? 0.1 : 0.05),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Decorative gradient orb - bottom left
              Positioned(
                bottom: -40.r,
                left: -30.r,
                child: AnimatedBuilder(
                  animation: _pulse,
                  builder: (_, __) => Opacity(
                    opacity: 0.3 + (_pulse.value * 0.25),
                    child: Container(
                      width: 100.r,
                      height: 100.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.gold.withValues(alpha: isDark ? 0.25 : 0.12),
                            AppColors.gold.withValues(alpha: isDark ? 0.08 : 0.04),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Main content - Vertical layout with icon on top
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 18.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top row: Icon centered with action buttons on the right
                    Row(
                      children: [
                        // Spacer to center the icon
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _buildMagicalIconBadge(isDark),
                          ),
                        ),
                        // Action buttons on the right
                        _buildLuxuryRangeSelector(context, range, isDark),
                        SizedBox(width: 10.w),
                        _buildMagicalExportButton(context, isDark),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    // Title and subtitle below the icon
                    _buildTitleSection(isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Magical icon badge with layered glow effects
  Widget _buildMagicalIconBadge(bool isDark) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) => Container(
        padding: EdgeInsets.all(11.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.info.withValues(alpha: isDark ? 0.35 : 0.2),
              AppColors.info.withValues(alpha: isDark ? 0.15 : 0.08),
              AppColors.gold.withValues(alpha: isDark ? 0.1 : 0.05),
            ],
          ),
          border: Border.all(
            color: AppColors.info.withValues(alpha: isDark ? 0.5 : 0.3),
            width: 1.5,
          ),
          boxShadow: [
            // Outer glow
            BoxShadow(
              color: AppColors.info.withValues(alpha: (isDark ? 0.35 : 0.2) * _pulse.value),
              blurRadius: 16,
              spreadRadius: -4,
            ),
            // Inner glow
            BoxShadow(
              color: AppColors.gold.withValues(alpha: (isDark ? 0.15 : 0.08) * _pulse.value),
              blurRadius: 10,
              spreadRadius: -2,
            ),
          ],
        ),
        child: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF60A5FA), // Light blue
              const Color(0xFF818CF8), // Purple
              const Color(0xFFFFD700), // Gold accent
            ],
          ).createShader(bounds),
          child: Icon(
            Icons.insights_rounded,
            color: Colors.white,
            size: 22.sp,
          ),
        ),
      ),
    );
  }

  /// Title section with gradient text and subtitle - now full width for vertical layout
  Widget _buildTitleSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main title with shimmer gradient
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: isDark
                ? [
                    Colors.white,
                    const Color(0xFFE0E7FF),
                    const Color(0xFFC7D2FE),
                  ]
                : [
                    const Color(0xFF1E1B4B),
                    const Color(0xFF312E81),
                    const Color(0xFF4338CA),
                  ],
          ).createShader(bounds),
          child: Text(
            'Analytics & Insights',
            style: GoogleFonts.raleway(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        // Subtitle with icon
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                gradient: LinearGradient(
                  colors: [
                    AppColors.info.withValues(alpha: isDark ? 0.2 : 0.1),
                    AppColors.info.withValues(alpha: isDark ? 0.1 : 0.05),
                  ],
                ),
              ),
              child: Icon(
                Icons.auto_graph_rounded,
                size: 12.sp,
                color: AppColors.info,
              ),
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                'Real-time platform performance & insights',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                  letterSpacing: 0.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Luxury range selector dropdown
  Widget _buildLuxuryRangeSelector(BuildContext context, AnalyticsRange range, bool isDark) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surfaceContainerHighest.withValues(alpha: isDark ? 0.4 : 0.6),
            colorScheme.surfaceContainerHighest.withValues(alpha: isDark ? 0.2 : 0.4),
          ],
        ),
        border: Border.all(
          color: AppColors.info.withValues(alpha: isDark ? 0.35 : 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.info.withValues(alpha: isDark ? 0.1 : 0.05),
            blurRadius: 8,
            spreadRadius: -2,
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AnalyticsRange>(
          value: range,
          isDense: true,
          icon: Padding(
            padding: EdgeInsets.only(left: 6.w),
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF60A5FA), Color(0xFF818CF8)],
              ).createShader(bounds),
              child: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 18.sp),
            ),
          ),
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          dropdownColor: isDark ? const Color(0xFF1E1B4B) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          elevation: 8,
          items: AnalyticsRange.values.map((r) => DropdownMenuItem(
            value: r,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.info, AppColors.info.withValues(alpha: 0.6)],
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(r.displayName),
              ],
            ),
          )).toList(),
          onChanged: (newRange) {
            if (newRange != null) {
              context.read<AdminAnalyticsCubit>().changeRange(newRange);
            }
          },
        ),
      ),
    );
  }

  /// Magical export button with glow effects
  Widget _buildMagicalExportButton(BuildContext context, bool isDark) {
    return PopupMenuButton<String>(
      onSelected: (format) async {
        final url = await context.read<AdminAnalyticsCubit>().exportReport(format);
        if (url != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.white, size: 18.sp),
                  SizedBox(width: 10.w),
                  Text(
                    'Report exported successfully!',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              margin: EdgeInsets.all(16.r),
            ),
          );
        }
      },
      tooltip: 'Export Report',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      color: isDark ? const Color(0xFF1E1B4B) : Colors.white,
      elevation: 12,
      offset: Offset(0, 50.h),
      itemBuilder: (ctx) => [
        _buildExportMenuItem('pdf', 'Export PDF', Icons.picture_as_pdf_rounded, AppColors.error),
        _buildExportMenuItem('csv', 'Export CSV', Icons.table_chart_rounded, AppColors.success),
        _buildExportMenuItem('xlsx', 'Export Excel', Icons.grid_on_rounded, AppColors.info),
      ],
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (_, __) => Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF60A5FA),
                const Color(0xFF818CF8),
                const Color(0xFF60A5FA),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.info.withValues(alpha: (isDark ? 0.5 : 0.35) * (0.7 + _pulse.value * 0.3)),
                blurRadius: 16,
                offset: const Offset(0, 6),
                spreadRadius: -4,
              ),
              BoxShadow(
                color: const Color(0xFF818CF8).withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
                spreadRadius: -2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.download_rounded, color: Colors.white, size: 16.sp),
              SizedBox(width: 6.w),
              Text(
                'Export',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
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

  /// Export menu item with icon and color
  PopupMenuItem<String> _buildExportMenuItem(String value, String label, IconData icon, Color color) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return PopupMenuItem(
      value: value,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: isDark ? 0.2 : 0.12),
                    color.withValues(alpha: isDark ? 0.1 : 0.06),
                  ],
                ),
                border: Border.all(
                  color: color.withValues(alpha: isDark ? 0.3 : 0.2),
                ),
              ),
              child: Icon(icon, size: 18.sp, color: color),
            ),
            SizedBox(width: 14.w),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards(BuildContext context, AnalyticsOverview overview) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildMetricCard(
            context,
            title: 'Total Users',
            value: '${overview.totalUsers}',
            subtitle: '+${overview.newUsersThisPeriod} new',
            icon: Icons.people_rounded,
            color: AppColors.gold,
            growth: overview.userGrowthPercent,
            isPrimary: true,
          ),
          SizedBox(width: 12.w),
          _buildMetricCard(
            context,
            title: 'Active Subscriptions',
            value: '${overview.activeSubscriptions}',
            subtitle: '+${overview.newSubscriptionsThisPeriod} new',
            icon: Icons.card_membership_rounded,
            color: AppColors.success,
            growth: overview.subscriptionGrowthPercent,
          ),
          SizedBox(width: 12.w),
          _buildMetricCard(
            context,
            title: 'Total Visits',
            value: _formatNumber(overview.totalVisits.toDouble()),
            subtitle: '${overview.visitsThisPeriod} this period',
            icon: Icons.directions_walk_rounded,
            color: AppColors.info,
            growth: overview.visitsGrowthPercent,
          ),
          SizedBox(width: 12.w),
          _buildMetricCard(
            context,
            title: 'Retention Rate',
            value: '${overview.retentionRate.toStringAsFixed(1)}%',
            subtitle: 'Churn: ${overview.churnRate.toStringAsFixed(1)}%',
            icon: Icons.repeat_rounded,
            color: AppColors.warning,
          ),
          SizedBox(width: 12.w),
          _buildMetricCard(
            context,
            title: 'Conversion Rate',
            value: '${overview.conversionRate.toStringAsFixed(1)}%',
            subtitle: 'Visitors to subscribers',
            icon: Icons.trending_up_rounded,
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    double? growth,
    bool isPrimary = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    final secondaryColor = HSLColor.fromColor(color)
        .withLightness((HSLColor.fromColor(color).lightness + 0.15).clamp(0.0, 1.0))
        .toColor();

    return Container(
      width: 180.w,
      height: 220.h, // Fixed height for consistent card sizes
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
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
        border: Border.all(
          color: isPrimary
              ? color.withValues(alpha: isDark ? 0.5 : 0.35)
              : color.withValues(alpha: isDark ? 0.3 : 0.2),
          width: isPrimary ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isDark ? 0.15 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon at the top - centered
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: isDark ? 0.3 : 0.18),
                  color.withValues(alpha: isDark ? 0.15 : 0.1),
                ],
              ),
              border: Border.all(
                color: color.withValues(alpha: isDark ? 0.45 : 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: isDark ? 0.25 : 0.12),
                  blurRadius: 12,
                  spreadRadius: -3,
                ),
              ],
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [color, secondaryColor],
              ).createShader(bounds),
              child: Icon(icon, color: Colors.white, size: 22.sp),
            ),
          ),
          SizedBox(height: 14.h),
          // Value - large and prominent
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 26.sp,
              fontWeight: FontWeight.w700,
              color: isPrimary ? color : colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          // Title
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          // Subtitle
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // Growth badge at the bottom (or empty space for consistent height)
          if (growth != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                gradient: LinearGradient(
                  colors: growth >= 0
                      ? [
                          AppColors.success.withValues(alpha: isDark ? 0.22 : 0.14),
                          AppColors.success.withValues(alpha: isDark ? 0.12 : 0.08),
                        ]
                      : [
                          AppColors.error.withValues(alpha: isDark ? 0.22 : 0.14),
                          AppColors.error.withValues(alpha: isDark ? 0.12 : 0.08),
                        ],
                ),
                border: Border.all(
                  color: (growth >= 0 ? AppColors.success : AppColors.error)
                      .withValues(alpha: isDark ? 0.45 : 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    growth >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                    size: 12.sp,
                    color: growth >= 0 ? AppColors.success : AppColors.error,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${growth >= 0 ? '+' : ''}${growth.toStringAsFixed(1)}%',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: growth >= 0 ? AppColors.success : AppColors.error,
                    ),
                  ),
                ],
              ),
            )
          else
            // Empty placeholder to maintain consistent height
            SizedBox(height: 28.h),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
    Widget? trailing,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    final secondaryColor = HSLColor.fromColor(color)
        .withLightness((HSLColor.fromColor(color).lightness + 0.15).clamp(0.0, 1.0))
        .toColor();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1A1625).withValues(alpha: 0.95),
                  const Color(0xFF2D2640).withValues(alpha: 0.9),
                  const Color(0xFF1E1B4B).withValues(alpha: 0.85),
                ]
              : [
                  Colors.white.withValues(alpha: 0.98),
                  const Color(0xFFFAF8FF).withValues(alpha: 0.95),
                  const Color(0xFFF5F0FF).withValues(alpha: 0.92),
                ],
          stops: const [0.0, 0.5, 1.0],
        ),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.35 : 0.22),
          width: 1.5,
        ),
        boxShadow: [
          // Primary glow shadow
          BoxShadow(
            color: color.withValues(alpha: isDark ? 0.2 : 0.1),
            blurRadius: 24,
            offset: const Offset(0, 10),
            spreadRadius: -6,
          ),
          // Secondary ambient shadow
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
            spreadRadius: -4,
          ),
          // Inner glow effect
          BoxShadow(
            color: color.withValues(alpha: isDark ? 0.08 : 0.04),
            blurRadius: 32,
            offset: const Offset(0, 4),
            spreadRadius: -8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Stack(
            children: [
              // Decorative gradient orb - top right
              Positioned(
                top: -25.r,
                right: -15.r,
                child: Container(
                  width: 80.r,
                  height: 80.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        color.withValues(alpha: isDark ? 0.2 : 0.1),
                        color.withValues(alpha: isDark ? 0.08 : 0.04),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Decorative gradient orb - bottom left
              Positioned(
                bottom: -30.r,
                left: -20.r,
                child: Container(
                  width: 70.r,
                  height: 70.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        secondaryColor.withValues(alpha: isDark ? 0.15 : 0.08),
                        secondaryColor.withValues(alpha: isDark ? 0.05 : 0.02),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Main content - Vertical layout with icon on top
              Padding(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon centered at the top with enhanced glow
                    Container(
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            color.withValues(alpha: isDark ? 0.32 : 0.2),
                            color.withValues(alpha: isDark ? 0.16 : 0.1),
                            secondaryColor.withValues(alpha: isDark ? 0.1 : 0.06),
                          ],
                        ),
                        border: Border.all(
                          color: color.withValues(alpha: isDark ? 0.5 : 0.32),
                          width: 1.5,
                        ),
                        boxShadow: [
                          // Outer glow
                          BoxShadow(
                            color: color.withValues(alpha: isDark ? 0.3 : 0.18),
                            blurRadius: 16,
                            spreadRadius: -4,
                          ),
                          // Inner glow
                          BoxShadow(
                            color: secondaryColor.withValues(alpha: isDark ? 0.15 : 0.08),
                            blurRadius: 10,
                            spreadRadius: -2,
                          ),
                        ],
                      ),
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [color, secondaryColor, color.withValues(alpha: 0.8)],
                        ).createShader(bounds),
                        child: Icon(icon, color: Colors.white, size: 24.sp),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    // Title row with optional trailing widget
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (trailing != null) ...[
                          const Spacer(),
                        ],
                        Flexible(
                          flex: trailing != null ? 2 : 1,
                          child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: isDark
                                  ? [Colors.white, const Color(0xFFE0E7FF), const Color(0xFFC7D2FE)]
                                  : [const Color(0xFF1E1B4B), const Color(0xFF312E81), const Color(0xFF4338CA)],
                            ).createShader(bounds),
                            child: Text(
                              title,
                              style: GoogleFonts.raleway(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        if (trailing != null) ...[
                          const Spacer(),
                          trailing,
                        ],
                      ],
                    ),
                    SizedBox(height: 18.h),
                    // Decorative divider
                    Container(
                      height: 1.5,
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            color.withValues(alpha: isDark ? 0.4 : 0.25),
                            color.withValues(alpha: isDark ? 0.5 : 0.3),
                            color.withValues(alpha: isDark ? 0.4 : 0.25),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                        ),
                        borderRadius: BorderRadius.circular(1.r),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    // Content/Chart below
                    child,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEngagementSection(BuildContext context, EngagementMetrics engagement) {
    final isDark = context.isDarkMode;

    return _buildSectionCard(
      context,
      title: 'User Engagement',
      icon: Icons.insights_rounded,
      color: AppColors.info,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            _buildEngagementMetric(
              context,
              icon: Icons.today_rounded,
              label: 'DAU',
              value: engagement.dailyActiveUsers.toStringAsFixed(0),
              subtitle: 'Daily Active',
              color: AppColors.success,
            ),
            SizedBox(width: 12.w),
            _buildEngagementMetric(
              context,
              icon: Icons.date_range_rounded,
              label: 'WAU',
              value: engagement.weeklyActiveUsers.toStringAsFixed(0),
              subtitle: 'Weekly Active',
              color: AppColors.info,
            ),
            SizedBox(width: 12.w),
            _buildEngagementMetric(
              context,
              icon: Icons.calendar_month_rounded,
              label: 'MAU',
              value: engagement.monthlyActiveUsers.toStringAsFixed(0),
              subtitle: 'Monthly Active',
              color: AppColors.gold,
            ),
            SizedBox(width: 12.w),
            _buildEngagementMetric(
              context,
              icon: Icons.speed_rounded,
              label: 'DAU/WAU',
              value: '${engagement.dauWauRatio.toStringAsFixed(0)}%',
              subtitle: 'Stickiness',
              color: AppColors.warning,
            ),
            SizedBox(width: 12.w),
            _buildEngagementMetric(
              context,
              icon: Icons.analytics_rounded,
              label: 'DAU/MAU',
              value: '${engagement.dauMauRatio.toStringAsFixed(0)}%',
              subtitle: 'Engagement',
              color: AppColors.secondary,
            ),
            SizedBox(width: 12.w),
            _buildEngagementMetric(
              context,
              icon: Icons.repeat_rounded,
              label: 'Sessions/Week',
              value: '${engagement.averageSessionsPerWeek}',
              subtitle: 'Per User',
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementMetric(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    final secondaryColor = HSLColor.fromColor(color)
        .withLightness((HSLColor.fromColor(color).lightness + 0.15).clamp(0.0, 1.0))
        .toColor();

    return Container(
      width: 140.w,
      height: 160.h, // Fixed height for consistent card sizes
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: isDark ? 0.15 : 0.08),
            color.withValues(alpha: isDark ? 0.08 : 0.04),
          ],
        ),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.35 : 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isDark ? 0.12 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: -3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon at the top - centered
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: isDark ? 0.28 : 0.16),
                  color.withValues(alpha: isDark ? 0.14 : 0.08),
                ],
              ),
              border: Border.all(
                color: color.withValues(alpha: isDark ? 0.4 : 0.25),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: isDark ? 0.2 : 0.1),
                  blurRadius: 8,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [color, secondaryColor],
              ).createShader(bounds),
              child: Icon(icon, color: Colors.white, size: 18.sp),
            ),
          ),
          // Value - large and prominent
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [color, secondaryColor],
            ).createShader(bounds),
            child: Text(
              value,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Label and subtitle at the bottom
          Column(
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserGrowthChart(BuildContext context, List<GrowthDataPoint> data) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    if (data.isEmpty) return const SizedBox.shrink();

    final maxValue = data.map((d) => d.cumulativeValue).reduce((a, b) => a > b ? a : b);

    return _buildSectionCard(
      context,
      title: 'User Growth Trend  •  +${data.last.value} new',
      icon: Icons.show_chart_rounded,
      color: AppColors.gold,
      child: Column(
        children: [
          // Magical animated legend with pulsing orbs
          _buildMagicalChartLegend(isDark),
          SizedBox(height: 20.h),
          // Enchanted chart area with floating particles and glowing bars
          _buildEnchantedChartArea(context, data, maxValue, isDark),
        ],
      ),
    );
  }

  /// Magical chart legend with animated glowing orbs
  Widget _buildMagicalChartLegend(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: AnimatedBuilder(
        animation: _shimmer,
        builder: (_, __) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMagicalLegendOrb(
              label: 'Cumulative Users',
              color: AppColors.gold,
              secondaryColor: const Color(0xFFFFE066),
              icon: Icons.people_rounded,
              isDark: isDark,
            ),
            SizedBox(width: 24.w),
            _buildMagicalLegendOrb(
              label: 'New Users',
              color: AppColors.success,
              secondaryColor: const Color(0xFF86EFAC),
              icon: Icons.person_add_rounded,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  /// Individual magical legend orb with glow and pulse
  Widget _buildMagicalLegendOrb({
    required String label,
    required Color color,
    required Color secondaryColor,
    required IconData icon,
    required bool isDark,
  }) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) => Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: isDark ? 0.2 : 0.12),
              color.withValues(alpha: isDark ? 0.08 : 0.04),
            ],
          ),
          border: Border.all(
            color: color.withValues(alpha: isDark ? 0.4 : 0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: (isDark ? 0.3 : 0.18) * (0.6 + _pulse.value * 0.4)),
              blurRadius: 16,
              spreadRadius: -4,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated glowing orb
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow ring
                Container(
                  width: 24.r,
                  height: 24.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        color.withValues(alpha: 0.4 * _pulse.value),
                        color.withValues(alpha: 0.1 * _pulse.value),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Inner orb with shimmer
                Container(
                  width: 16.r,
                  height: 16.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment(-1 + _shimmer.value * 2, -1),
                      end: Alignment(1 + _shimmer.value * 2, 1),
                      colors: [
                        color,
                        secondaryColor,
                        color,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.6),
                        blurRadius: 8,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: 10.sp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(width: 10.w),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: isDark
                    ? [Colors.white, Colors.white.withValues(alpha: 0.8)]
                    : [const Color(0xFF1A1A2E), const Color(0xFF1A1A2E).withValues(alpha: 0.8)],
              ).createShader(bounds),
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Enchanted chart area with magical effects
  Widget _buildEnchantedChartArea(
    BuildContext context,
    List<GrowthDataPoint> data,
    int maxValue,
    bool isDark,
  ) {
    return Container(
      height: 280.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  const Color(0xFF1A1625).withValues(alpha: 0.6),
                  const Color(0xFF0F0A1A).withValues(alpha: 0.8),
                ]
              : [
                  const Color(0xFFFFFBF5).withValues(alpha: 0.6),
                  const Color(0xFFF5F0FF).withValues(alpha: 0.8),
                ],
        ),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: isDark ? 0.2 : 0.12),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            // Floating magical particles background
            _buildFloatingParticles(isDark),
            // Grid lines with subtle glow
            _buildMagicalGridLines(isDark),
            // Main chart content
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 20.h, 12.w, 40.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: data.asMap().entries.map((entry) {
                  final index = entry.key;
                  final point = entry.value;
                  final heightPercent = maxValue > 0 ? point.cumulativeValue / maxValue : 0.0;
                  final newUserPercent = maxValue > 0 ? point.value / maxValue : 0.0;
                  
                  return Expanded(
                    child: _buildMagicalChartBar(
                      context: context,
                      index: index,
                      point: point,
                      heightPercent: heightPercent,
                      newUserPercent: newUserPercent,
                      isDark: isDark,
                      totalBars: data.length,
                    ),
                  );
                }).toList(),
              ),
            ),
            // Animated line graph overlay
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.w, 20.h, 12.w, 40.h),
                child: _buildAnimatedLineGraph(data, maxValue, isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Floating magical particles
  Widget _buildFloatingParticles(bool isDark) {
    return AnimatedBuilder(
      animation: _particle,
      builder: (_, __) => CustomPaint(
        size: Size.infinite,
        painter: _MagicalParticlesPainter(
          progress: _particle.value,
          isDark: isDark,
          primaryColor: AppColors.gold,
          secondaryColor: AppColors.success,
        ),
      ),
    );
  }

  /// Magical grid lines with subtle glow
  Widget _buildMagicalGridLines(bool isDark) {
    return AnimatedBuilder(
      animation: _wave,
      builder: (_, __) => CustomPaint(
        size: Size.infinite,
        painter: _MagicalGridPainter(
          waveProgress: _wave.value,
          isDark: isDark,
          lineColor: AppColors.gold.withValues(alpha: isDark ? 0.15 : 0.08),
        ),
      ),
    );
  }

  /// Individual magical chart bar with crystal effect
  Widget _buildMagicalChartBar({
    required BuildContext context,
    required int index,
    required GrowthDataPoint point,
    required double heightPercent,
    required double newUserPercent,
    required bool isDark,
    required int totalBars,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Tooltip(
        message: '${point.label}\nTotal: ${point.cumulativeValue}\nNew: +${point.value}',
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF2D2640), const Color(0xFF1E1B4B)]
                : [Colors.white, const Color(0xFFF5F0FF)],
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.gold.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.2),
              blurRadius: 12,
              spreadRadius: -4,
            ),
          ],
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Crystal bar with magical glow
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: heightPercent),
              duration: Duration(milliseconds: 1200 + (index * 100)),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return AnimatedBuilder(
                  animation: Listenable.merge([_pulse, _shimmer]),
                  builder: (_, __) => Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Outer glow effect
                      Container(
                        width: double.infinity,
                        height: (180.h * value).clamp(12.0, 180.h),
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gold.withValues(
                                alpha: (isDark ? 0.5 : 0.35) * (0.5 + _pulse.value * 0.5),
                              ),
                              blurRadius: 20,
                              spreadRadius: -4,
                            ),
                          ],
                        ),
                      ),
                      // Main crystal bar
                      Container(
                        width: double.infinity,
                        height: (180.h * value).clamp(12.0, 180.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              AppColors.gold.withValues(alpha: 0.3),
                              AppColors.gold.withValues(alpha: 0.6),
                              AppColors.gold.withValues(alpha: 0.85),
                              AppColors.gold,
                              const Color(0xFFFFE066),
                              const Color(0xFFFFF9E6),
                            ],
                            stops: const [0.0, 0.2, 0.4, 0.6, 0.85, 1.0],
                          ),
                          border: Border.all(
                            color: AppColors.gold.withValues(alpha: isDark ? 0.7 : 0.5),
                            width: 1.5,
                          ),
                          boxShadow: [
                            // Inner glow
                            BoxShadow(
                              color: const Color(0xFFFFE066).withValues(alpha: 0.4),
                              blurRadius: 8,
                              spreadRadius: -2,
                              offset: const Offset(0, -4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Stack(
                            children: [
                              // Shimmer effect overlay
                              Positioned.fill(
                                child: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    begin: Alignment(-2 + _shimmer.value * 4, 0),
                                    end: Alignment(-1 + _shimmer.value * 4, 0),
                                    colors: [
                                      Colors.transparent,
                                      Colors.white.withValues(alpha: 0.3),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 0.5, 1.0],
                                  ).createShader(bounds),
                                  blendMode: BlendMode.srcATop,
                                  child: Container(color: Colors.white),
                                ),
                              ),
                              // Crystal facet lines
                              Positioned(
                                left: 0,
                                right: 0,
                                top: 0,
                                child: Container(
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.white.withValues(alpha: 0.5),
                                        Colors.transparent,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10.r),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // New users indicator (small glowing orb at top)
                      if (newUserPercent > 0.05)
                        Positioned(
                          top: 0,
                          child: _buildNewUserIndicator(point.value, isDark),
                        ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 12.h),
            // Label with subtle animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 800 + (index * 100)),
              curve: Curves.easeOut,
              builder: (context, opacity, child) => Opacity(
                opacity: opacity,
                child: Text(
                  point.label,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// New user indicator orb
  Widget _buildNewUserIndicator(int newUsers, bool isDark) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) => Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          gradient: LinearGradient(
            colors: [
              AppColors.success,
              AppColors.success.withValues(alpha: 0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.success.withValues(alpha: 0.5 * _pulse.value),
              blurRadius: 10,
              spreadRadius: -2,
            ),
          ],
        ),
        child: Text(
          '+$newUsers',
          style: GoogleFonts.inter(
            fontSize: 8.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Animated line graph overlay
  Widget _buildAnimatedLineGraph(List<GrowthDataPoint> data, int maxValue, bool isDark) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 2000),
      curve: Curves.easeOutCubic,
      builder: (context, progress, child) {
        return AnimatedBuilder(
          animation: _pulse,
          builder: (_, __) => CustomPaint(
            size: Size.infinite,
            painter: _MagicalLineGraphPainter(
              data: data,
              maxValue: maxValue,
              progress: progress,
              pulseValue: _pulse.value,
              isDark: isDark,
              lineColor: AppColors.success,
              glowColor: AppColors.success.withValues(alpha: 0.5),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChartLegendItem(String label, Color color, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12.r,
          height: 12.r,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withValues(alpha: 0.7)],
            ),
            borderRadius: BorderRadius.circular(4.r),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 6,
                spreadRadius: -2,
              ),
            ],
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildAcquisitionSources(BuildContext context, List<AcquisitionSource> sources) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    final colors = [AppColors.gold, AppColors.info, AppColors.success, AppColors.warning, AppColors.secondary];

    return _buildSectionCard(
      context,
      title: 'Acquisition Sources',
      icon: Icons.source_rounded,
      color: AppColors.info,
      child: Column(
        children: sources.asMap().entries.map((entry) {
          final source = entry.value;
          final color = colors[entry.key % colors.length];
          
          return Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10.r,
                      height: 10.r,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)]),
                        borderRadius: BorderRadius.circular(3.r),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.4),
                            blurRadius: 4,
                            spreadRadius: -1,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        source.source,
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      '${source.count}',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 8.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          color: color.withValues(alpha: isDark ? 0.2 : 0.12),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: source.percentage / 100,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.r),
                              gradient: LinearGradient(
                                colors: [color, color.withValues(alpha: 0.7)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  spreadRadius: -1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      '${source.percentage.toStringAsFixed(0)}%',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVisitHeatmap(BuildContext context, VisitAnalytics analytics) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayVisits = analytics.visitsByDayOfWeek;
    final maxVisits = dayVisits.values.isNotEmpty ? dayVisits.values.reduce((a, b) => a > b ? a : b) : 1;

    return _buildSectionCard(
      context,
      title: 'Visit Patterns  •  Peak: ${analytics.peakDay} @ ${analytics.peakHour}:00',
      icon: Icons.calendar_view_week_rounded,
      color: AppColors.warning,
      child: Column(
        children: [
          // Days of week heatmap
          Row(
            children: days.map((day) {
              final visits = dayVisits[day] ?? 0;
              final intensity = visits / maxVisits;
              final isPeak = day == analytics.peakDay;
              
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    children: [
                      Container(
                        height: 60.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              AppColors.gold.withValues(alpha: 0.15 + intensity * 0.6),
                              AppColors.gold.withValues(alpha: 0.25 + intensity * 0.6),
                            ],
                          ),
                          border: isPeak
                              ? Border.all(color: AppColors.gold, width: 2)
                              : Border.all(
                                  color: AppColors.gold.withValues(alpha: isDark ? 0.3 : 0.2),
                                  width: 1,
                                ),
                          boxShadow: isPeak
                              ? [
                                  BoxShadow(
                                    color: AppColors.gold.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    spreadRadius: -2,
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            _formatNumber(visits.toDouble()),
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: intensity > 0.5
                                  ? Colors.white
                                  : colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        day,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: isPeak ? FontWeight.w700 : FontWeight.w500,
                          color: isPeak
                              ? AppColors.gold
                              : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiary),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 18.h),
          Container(
            height: 1,
            color: AppColors.gold.withValues(alpha: isDark ? 0.15 : 0.1),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildVisitStat(
                context,
                label: 'Avg Duration',
                value: '${analytics.averageVisitDuration.toStringAsFixed(0)} min',
                icon: Icons.timer_outlined,
              ),
              _buildVisitStat(
                context,
                label: 'Avg/User',
                value: '${analytics.averageVisitsPerUser.toStringAsFixed(1)}/week',
                icon: Icons.person_outline,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVisitStat(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Row(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
          ).createShader(bounds),
          child: Icon(icon, size: 18.sp, color: Colors.white),
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubscriptionBreakdown(BuildContext context, SubscriptionAnalytics analytics) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    final tierColors = {
      'Basic': AppColors.grey500,
      'Plus': AppColors.info,
      'Premium': AppColors.gold,
    };
    final totalSubs = analytics.byTier.values.fold<int>(0, (sum, v) => sum + v);

    return _buildSectionCard(
      context,
      title: 'Subscription Breakdown',
      icon: Icons.pie_chart_rounded,
      color: AppColors.secondary,
      child: Column(
        children: [
          // Tier distribution
          ...analytics.byTier.entries.map((entry) {
            final color = tierColors[entry.key] ?? AppColors.grey500;
            final percent = totalSubs > 0 ? (entry.value / totalSubs * 100) : 0;
            
            return Padding(
              padding: EdgeInsets.only(bottom: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        entry.key,
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [color, color.withValues(alpha: 0.7)],
                        ).createShader(bounds),
                        child: Text(
                          '${entry.value}',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 10.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      color: color.withValues(alpha: isDark ? 0.2 : 0.12),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: percent / 100,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          gradient: LinearGradient(
                            colors: [color, color.withValues(alpha: 0.7)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.3),
                              blurRadius: 4,
                              spreadRadius: -1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 8.h),
          Container(
            height: 1,
            color: AppColors.secondary.withValues(alpha: isDark ? 0.15 : 0.1),
          ),
          SizedBox(height: 14.h),
          _buildSubscriptionStat(
            context,
            label: 'Avg Lifetime Value',
            value: 'EGP ${analytics.averageLifetimeValue.toStringAsFixed(0)}',
            color: AppColors.success,
          ),
          SizedBox(height: 10.h),
          _buildSubscriptionStat(
            context,
            label: 'Avg Subscription Length',
            value: '${analytics.averageSubscriptionLength.toStringAsFixed(1)} months',
            color: colorScheme.onSurface,
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionStat(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildGeographicDistribution(BuildContext context, List<GeographicData> data) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return _buildSectionCard(
      context,
      title: 'Geographic Distribution',
      icon: Icons.map_rounded,
      color: AppColors.success,
      child: Column(
        children: data.take(5).map((geo) => Padding(
          padding: EdgeInsets.only(bottom: 14.h),
          child: Row(
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
                ).createShader(bounds),
                child: Icon(Icons.location_on_rounded, size: 18.sp, color: Colors.white),
              ),
              SizedBox(width: 10.w),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      geo.city,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '${geo.gymsCount} gyms',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${geo.usersCount}',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'users',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.success.withValues(alpha: isDark ? 0.2 : 0.12),
                      AppColors.success.withValues(alpha: isDark ? 0.1 : 0.06),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: isDark ? 0.4 : 0.25),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${geo.revenuePercent.toStringAsFixed(0)}%',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildPopularGyms(BuildContext context, List<PopularGym> gyms) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    final medalColors = [AppColors.gold, AppColors.grey500, const Color(0xFFCD7F32)];

    return _buildSectionCard(
      context,
      title: 'Top Performing Gyms',
      icon: Icons.emoji_events_rounded,
      color: AppColors.gold,
      child: Column(
        children: gyms.asMap().entries.map((entry) {
          final index = entry.key;
          final gym = entry.value;
          final isTopThree = index < 3;
          final medalColor = isTopThree ? medalColors[index] : colorScheme.surfaceContainerHighest;
          
          return Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: Row(
              children: [
                // Rank badge
                Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isTopThree
                        ? LinearGradient(
                            colors: [medalColor, medalColor.withValues(alpha: 0.7)],
                          )
                        : null,
                    color: isTopThree ? null : medalColor,
                    boxShadow: isTopThree
                        ? [
                            BoxShadow(
                              color: medalColor.withValues(alpha: 0.4),
                              blurRadius: 8,
                              spreadRadius: -2,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: isTopThree ? Colors.white : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gym.name,
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
                            ).createShader(bounds),
                            child: Icon(Icons.star_rounded, size: 12.sp, color: Colors.white),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${gym.rating}',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '${gym.visitsCount} visits',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
                  ).createShader(bounds),
                  child: Text(
                    '${gym.subscribersCount}',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRetentionSection(BuildContext context, SubscriptionAnalytics analytics) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    final tierColors = {
      'Basic': AppColors.grey500,
      'Plus': AppColors.info,
      'Premium': AppColors.gold,
    };

    final tierIcons = {
      'Basic': Icons.star_outline_rounded,
      'Plus': Icons.star_half_rounded,
      'Premium': Icons.star_rounded,
    };

    // Calculate average renewal rate for title
    final avgRenewal = analytics.renewalRateByTier.values.isNotEmpty
        ? (analytics.renewalRateByTier.values.reduce((a, b) => a + b) / analytics.renewalRateByTier.values.length)
        : 0.0;

    return _buildSectionCard(
      context,
      title: 'Renewal Rates  •  Avg ${avgRenewal.toStringAsFixed(0)}%',
      icon: Icons.autorenew_rounded,
      color: AppColors.primary,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: analytics.renewalRateByTier.entries.map((entry) {
            final color = tierColors[entry.key] ?? AppColors.grey500;
            final icon = tierIcons[entry.key] ?? Icons.star_outline_rounded;
            
            // Create secondary color for gradients
            final secondaryColor = HSLColor.fromColor(color)
                .withLightness((HSLColor.fromColor(color).lightness + 0.15).clamp(0.0, 1.0))
                .toColor();
            
            return _buildMagicalTierCard(
              context: context,
              tierName: entry.key,
              renewalRate: entry.value,
              color: color,
              secondaryColor: secondaryColor,
              icon: icon,
              isDark: isDark,
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Magical tier card with enchanted animations and luxury design
  Widget _buildMagicalTierCard({
    required BuildContext context,
    required String tierName,
    required double renewalRate,
    required Color color,
    required Color secondaryColor,
    required IconData icon,
    required bool isDark,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: Listenable.merge([_pulse, _shimmer]),
      builder: (_, __) => Container(
        width: 180.w,
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1A1625).withValues(alpha: 0.95),
                    const Color(0xFF2D2640).withValues(alpha: 0.9),
                    color.withValues(alpha: 0.15),
                  ]
                : [
                    Colors.white.withValues(alpha: 0.98),
                    const Color(0xFFFAF8FF).withValues(alpha: 0.95),
                    color.withValues(alpha: 0.08),
                  ],
            stops: const [0.0, 0.6, 1.0],
          ),
          border: Border.all(
            color: color.withValues(alpha: isDark ? 0.45 : 0.3),
            width: 1.5,
          ),
          boxShadow: [
            // Primary glow shadow with pulse
            BoxShadow(
              color: color.withValues(alpha: (isDark ? 0.35 : 0.2) * (0.6 + _pulse.value * 0.4)),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: -6,
            ),
            // Secondary ambient shadow
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.4)
                  : Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
              spreadRadius: -4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Stack(
              children: [
                // Decorative gradient orb - top right
                Positioned(
                  top: -20.r,
                  right: -15.r,
                  child: Container(
                    width: 60.r,
                    height: 60.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          color.withValues(alpha: (isDark ? 0.3 : 0.18) * _pulse.value),
                          color.withValues(alpha: (isDark ? 0.1 : 0.06) * _pulse.value),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Decorative gradient orb - bottom left
                Positioned(
                  bottom: -25.r,
                  left: -20.r,
                  child: Container(
                    width: 50.r,
                    height: 50.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          secondaryColor.withValues(alpha: isDark ? 0.2 : 0.12),
                          secondaryColor.withValues(alpha: isDark ? 0.06 : 0.03),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Main content
                Padding(
                  padding: EdgeInsets.all(18.r),
                  child: Column(
                    children: [
                      // Tier icon with magical glow
                      Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.r),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              color.withValues(alpha: isDark ? 0.35 : 0.22),
                              color.withValues(alpha: isDark ? 0.18 : 0.12),
                              secondaryColor.withValues(alpha: isDark ? 0.12 : 0.08),
                            ],
                          ),
                          border: Border.all(
                            color: color.withValues(alpha: isDark ? 0.55 : 0.38),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: (isDark ? 0.4 : 0.25) * _pulse.value),
                              blurRadius: 14,
                              spreadRadius: -4,
                            ),
                          ],
                        ),
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color, secondaryColor, color.withValues(alpha: 0.85)],
                          ).createShader(bounds),
                          child: Icon(icon, color: Colors.white, size: 20.sp),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      // Tier name with gradient text
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: isDark
                              ? [Colors.white, const Color(0xFFE0E7FF)]
                              : [const Color(0xFF1E1B4B), const Color(0xFF312E81)],
                        ).createShader(bounds),
                        child: Text(
                          tierName,
                          style: GoogleFonts.raleway(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Magical circular progress with enchanted effects
                      _buildEnchantedCircularProgress(
                        renewalRate: renewalRate,
                        color: color,
                        secondaryColor: secondaryColor,
                        isDark: isDark,
                      ),
                      SizedBox(height: 12.h),
                      // Renewal rate label with subtle glow
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          gradient: LinearGradient(
                            colors: [
                              color.withValues(alpha: isDark ? 0.18 : 0.1),
                              color.withValues(alpha: isDark ? 0.08 : 0.04),
                            ],
                          ),
                          border: Border.all(
                            color: color.withValues(alpha: isDark ? 0.3 : 0.18),
                          ),
                        ),
                        child: Text(
                          'Renewal Rate',
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Enchanted circular progress indicator with magical effects
  Widget _buildEnchantedCircularProgress({
    required double renewalRate,
    required Color color,
    required Color secondaryColor,
    required bool isDark,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow ring with pulse
        AnimatedBuilder(
          animation: _pulse,
          builder: (_, __) => Container(
            width: 100.r,
            height: 100.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color.withValues(alpha: (isDark ? 0.25 : 0.15) * _pulse.value),
                  color.withValues(alpha: (isDark ? 0.1 : 0.06) * _pulse.value),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Progress ring background
        SizedBox(
          width: 85.r,
          height: 85.r,
          child: CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 10,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation(
              color.withValues(alpha: isDark ? 0.15 : 0.1),
            ),
            strokeCap: StrokeCap.round,
          ),
        ),
        // Animated progress ring
        SizedBox(
          width: 85.r,
          height: 85.r,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: renewalRate / 100),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return AnimatedBuilder(
                animation: _shimmer,
                builder: (_, __) => ShaderMask(
                  shaderCallback: (bounds) => SweepGradient(
                    startAngle: -math.pi / 2,
                    endAngle: 3 * math.pi / 2,
                    colors: [
                      color,
                      secondaryColor,
                      color.withValues(alpha: 0.8),
                      secondaryColor.withValues(alpha: 0.9),
                      color,
                    ],
                    stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                    transform: GradientRotation(_shimmer.value * 2 * math.pi),
                  ).createShader(bounds),
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 10,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                    strokeCap: StrokeCap.round,
                  ),
                ),
              );
            },
          ),
        ),
        // Inner decorative ring
        Container(
          width: 68.r,
          height: 68.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: isDark
                  ? [
                      const Color(0xFF1A1625).withValues(alpha: 0.9),
                      const Color(0xFF2D2640).withValues(alpha: 0.8),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.95),
                      const Color(0xFFF5F0FF).withValues(alpha: 0.9),
                    ],
            ),
            border: Border.all(
              color: color.withValues(alpha: isDark ? 0.25 : 0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: isDark ? 0.15 : 0.08),
                blurRadius: 8,
                spreadRadius: -2,
              ),
            ],
          ),
        ),
        // Percentage text with shimmer gradient
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: renewalRate),
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return AnimatedBuilder(
              animation: _shimmer,
              builder: (_, __) => ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  begin: Alignment(-1 + _shimmer.value * 2, 0),
                  end: Alignment(1 + _shimmer.value * 2, 0),
                  colors: [
                    color,
                    secondaryColor,
                    Colors.white,
                    secondaryColor,
                    color,
                  ],
                  stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                ).createShader(bounds),
                child: Text(
                  '${value.toStringAsFixed(0)}%',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final isDark = context.isDarkMode;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulse,
            builder: (_, __) => Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.gold.withValues(alpha: isDark ? 0.25 * _pulse.value : 0.15 * _pulse.value),
                    AppColors.gold.withValues(alpha: isDark ? 0.1 * _pulse.value : 0.05 * _pulse.value),
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
          ),
          SizedBox(height: 24.h),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: isDark
                  ? [Colors.white, const Color(0xFFE8E0FF)]
                  : [const Color(0xFF1A1A2E), const Color(0xFF312E81)],
            ).createShader(bounds),
            child: Text(
              'Loading analytics...',
              style: GoogleFonts.raleway(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.r),
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
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [AppColors.error, AppColors.error.withValues(alpha: 0.7)],
              ).createShader(bounds),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48.sp,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: isDark
                  ? [Colors.white, const Color(0xFFE8E0FF)]
                  : [const Color(0xFF1A1A2E), const Color(0xFF312E81)],
            ).createShader(bounds),
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 24.h),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.read<AdminAnalyticsCubit>().loadAnalytics(),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFD700), Color(0xFFD4A574), Color(0xFFFFD700)],
                    stops: [0.0, 0.5, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: isDark ? 0.4 : 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                      spreadRadius: -4,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh_rounded, color: Colors.white, size: 18.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Retry',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
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

  String _formatNumber(double n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toStringAsFixed(0);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CUSTOM PAINTERS FOR MAGICAL CHART EFFECTS
// ═══════════════════════════════════════════════════════════════════════════

/// Magical floating particles painter
class _MagicalParticlesPainter extends CustomPainter {
  final double progress;
  final bool isDark;
  final Color primaryColor;
  final Color secondaryColor;

  _MagicalParticlesPainter({
    required this.progress,
    required this.isDark,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42); // Fixed seed for consistent particles
    final particleCount = 20;

    for (int i = 0; i < particleCount; i++) {
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final particleProgress = (progress + i / particleCount) % 1.0;
      
      // Floating motion
      final x = baseX + math.sin(particleProgress * 2 * math.pi + i) * 15;
      final y = baseY - particleProgress * 30 + math.cos(particleProgress * 2 * math.pi + i) * 10;
      
      // Fade in/out based on progress
      final opacity = math.sin(particleProgress * math.pi) * (isDark ? 0.6 : 0.4);
      final radius = 1.5 + random.nextDouble() * 2;
      
      final color = i % 2 == 0 ? primaryColor : secondaryColor;
      
      final paint = Paint()
        ..color = color.withValues(alpha: opacity.clamp(0.0, 1.0))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      
      canvas.drawCircle(Offset(x, y % size.height), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MagicalParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Magical grid lines painter with wave effect
class _MagicalGridPainter extends CustomPainter {
  final double waveProgress;
  final bool isDark;
  final Color lineColor;

  _MagicalGridPainter({
    required this.waveProgress,
    required this.isDark,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Horizontal grid lines with subtle wave
    for (int i = 1; i < 5; i++) {
      final y = size.height * i / 5;
      final path = Path();
      
      for (double x = 0; x <= size.width; x += 2) {
        final waveOffset = math.sin(x / 50 + waveProgress) * 1.5;
        if (x == 0) {
          path.moveTo(x, y + waveOffset);
        } else {
          path.lineTo(x, y + waveOffset);
        }
      }
      
      canvas.drawPath(path, paint);
    }

    // Vertical dashed lines
    final dashPaint = Paint()
      ..color = lineColor.withValues(alpha: 0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 1; i < 8; i++) {
      final x = size.width * i / 8;
      for (double y = 0; y < size.height; y += 8) {
        canvas.drawLine(
          Offset(x, y),
          Offset(x, math.min(y + 4, size.height)),
          dashPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MagicalGridPainter oldDelegate) {
    return oldDelegate.waveProgress != waveProgress;
  }
}

/// Magical line graph painter with glow effect
class _MagicalLineGraphPainter extends CustomPainter {
  final List<GrowthDataPoint> data;
  final int maxValue;
  final double progress;
  final double pulseValue;
  final bool isDark;
  final Color lineColor;
  final Color glowColor;

  _MagicalLineGraphPainter({
    required this.data,
    required this.maxValue,
    required this.progress,
    required this.pulseValue,
    required this.isDark,
    required this.lineColor,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || maxValue == 0) return;

    final points = <Offset>[];
    final barWidth = size.width / data.length;

    for (int i = 0; i < data.length; i++) {
      final x = barWidth * i + barWidth / 2;
      final normalizedValue = data[i].value / maxValue;
      final y = size.height - (normalizedValue * size.height * 0.8);
      points.add(Offset(x, y));
    }

    // Draw only up to the current progress
    final visiblePoints = (points.length * progress).ceil();
    if (visiblePoints < 2) return;

    // Create smooth curve path
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < visiblePoints - 1; i++) {
      final p0 = i > 0 ? points[i - 1] : points[i];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = i + 2 < visiblePoints ? points[i + 2] : p2;

      // Catmull-Rom to Bezier conversion
      final cp1x = p1.dx + (p2.dx - p0.dx) / 6;
      final cp1y = p1.dy + (p2.dy - p0.dy) / 6;
      final cp2x = p2.dx - (p3.dx - p1.dx) / 6;
      final cp2y = p2.dy - (p3.dy - p1.dy) / 6;

      path.cubicTo(cp1x, cp1y, cp2x, cp2y, p2.dx, p2.dy);
    }

    // Draw glow effect
    final glowPaint = Paint()
      ..color = glowColor.withValues(alpha: 0.3 + pulseValue * 0.2)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(path, glowPaint);

    // Draw main line
    final linePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          lineColor.withValues(alpha: 0.8),
          lineColor,
          lineColor.withValues(alpha: 0.9),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);

    // Draw data points with glow
    for (int i = 0; i < visiblePoints; i++) {
      final point = points[i];
      
      // Outer glow
      final outerGlowPaint = Paint()
        ..color = lineColor.withValues(alpha: 0.3 * pulseValue)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(point, 10, outerGlowPaint);
      
      // Inner glow
      final innerGlowPaint = Paint()
        ..color = lineColor.withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(point, 6, innerGlowPaint);
      
      // Core point
      final pointPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white,
            lineColor,
          ],
        ).createShader(Rect.fromCircle(center: point, radius: 4));
      canvas.drawCircle(point, 4, pointPaint);
      
      // Highlight
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.8);
      canvas.drawCircle(Offset(point.dx - 1, point.dy - 1), 1.5, highlightPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MagicalLineGraphPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.pulseValue != pulseValue;
  }
}
