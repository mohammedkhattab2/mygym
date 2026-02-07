import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mygym/src/features/admin/presentation/bloc/admin_revenue_cubit.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/luxury_theme_extension.dart';
import '../../domain/entities/admin_revenue.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// LUXURY ADMIN REVENUE VIEW
/// A premium revenue dashboard with glassmorphic cards and elegant design
/// ═══════════════════════════════════════════════════════════════════════════

class AdminRevenueView extends StatefulWidget {
  const AdminRevenueView({super.key});

  @override
  State<AdminRevenueView> createState() => _AdminRevenueViewState();
}

class _AdminRevenueViewState extends State<AdminRevenueView>
    with TickerProviderStateMixin {
  // Animation controllers for legend orbs
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;
  
  // Animation controllers for chart
  late AnimationController _chartBarController;
  late AnimationController _chartShimmerController;
  late AnimationController _chartParticleController;
  late Animation<double> _chartBarAnimation;
  late Animation<double> _chartShimmerAnimation;
  late Animation<double> _chartParticleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation - subtle scale effect
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // Glow animation - opacity breathing effect
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    _glowAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    
    // Chart bar rise animation
    _chartBarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _chartBarAnimation = CurvedAnimation(
      parent: _chartBarController,
      curve: Curves.easeOutCubic,
    );
    
    // Chart shimmer animation - continuous
    _chartShimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
    
    _chartShimmerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _chartShimmerController, curve: Curves.linear),
    );
    
    // Chart particle floating animation
    _chartParticleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
    
    _chartParticleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _chartParticleController, curve: Curves.easeInOut),
    );
    
    context.read<AdminRevenueCubit>().loadRevenueData();
    
    // Start chart animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _chartBarController.forward();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    _chartBarController.dispose();
    _chartShimmerController.dispose();
    _chartParticleController.dispose();
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF030014),
                    const Color(0xFF0A0520),
                    const Color(0xFF150A30),
                    const Color(0xFF0A0520),
                    const Color(0xFF030014),
                  ]
                : [
                    const Color(0xFFFFFDF7),
                    const Color(0xFFF8F0FF),
                    const Color(0xFFF0F7FF),
                    const Color(0xFFF8F0FF),
                    const Color(0xFFFFFDF7),
                  ],
            stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Ambient orbs (static)
            ..._buildAmbientOrbs(isDark),
            // Main content
            BlocBuilder<AdminRevenueCubit, AdminRevenueState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const SizedBox.shrink(),
                  loading: () => _buildLoadingState(context),
                  error: (msg) => _buildErrorState(context, msg),
                  loaded: (data, filter) => _buildContent(context, data, filter),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // AMBIENT ORBS — Static glowing spheres
  // ═══════════════════════════════════════════════════════════════════════════

  List<Widget> _buildAmbientOrbs(bool isDark) {
    return [
      // Primary gold orb - top right
      Positioned(
        top: -100.r,
        right: -60.r,
        child: Opacity(
          opacity: 0.5,
          child: Container(
            width: 320.r,
            height: 320.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFFD700).withValues(alpha:  isDark ? 0.25 : 0.15),
                  const Color(0xFFFFD700).withValues(alpha:  isDark ? 0.08 : 0.04),
                  const Color(0xFFFFD700).withValues(alpha:  0.0),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
      ),
      // Purple mystical orb - left center
      Positioned(
        top: 300.r,
        left: -120.r,
        child: Opacity(
          opacity: 0.4,
          child: Container(
            width: 280.r,
            height: 280.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF8B5CF6).withValues(alpha:  isDark ? 0.22 : 0.12),
                  const Color(0xFF8B5CF6).withValues(alpha:  isDark ? 0.06 : 0.03),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),
      // Cyan energy orb - bottom right
      Positioned(
        bottom: 100.r,
        right: -80.r,
        child: Opacity(
          opacity: 0.35,
          child: Container(
            width: 240.r,
            height: 240.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF06B6D4).withValues(alpha:  isDark ? 0.18 : 0.1),
                  const Color(0xFF06B6D4).withValues(alpha:  isDark ? 0.05 : 0.025),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),
      // Rose accent orb - bottom left
      Positioned(
        bottom: 350.r,
        left: -60.r,
        child: Opacity(
          opacity: 0.3,
          child: Container(
            width: 180.r,
            height: 180.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFEC4899).withValues(alpha:  isDark ? 0.15 : 0.08),
                  const Color(0xFFEC4899).withValues(alpha:  isDark ? 0.04 : 0.02),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),
    ];
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOADING STATE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildLoadingState(BuildContext context) {
    final isDark = context.isDarkMode;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Loading orb
          Container(
            width: 120.r,
            height: 120.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFFD700).withValues(alpha:  0.3),
                  const Color(0xFF8B5CF6).withValues(alpha:  0.15),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD700).withValues(alpha:  0.3),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 60.r,
                height: 60.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFD700),
                      Color(0xFFD4A574),
                      Color(0xFFFFD700),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withValues(alpha:  0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.r),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                    strokeCap: StrokeCap.round,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 32.h),
          // Text
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFFFFD700),
                Color(0xFF8B5CF6),
                Color(0xFFFFD700),
              ],
            ).createShader(bounds),
            child: Text(
              'Loading Revenue Data...',
              style: GoogleFonts.cinzel(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Please wait while we gather the insights',
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: isDark
                  ? Colors.white.withValues(alpha:  0.5)
                  : Colors.black.withValues(alpha:  0.4),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN CONTENT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildContent(
      BuildContext context, RevenueData data, RevenueFilter filter) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Header
        SliverPadding(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 0),
          sliver: SliverToBoxAdapter(
            child: _buildHeader(context, data.overview, filter),
          ),
        ),
        // Stat Cards
        SliverPadding(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
          sliver: SliverToBoxAdapter(
            child: _buildStatCards(context, data.overview),
          ),
        ),
        // Revenue Trend Chart
        SliverPadding(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
          sliver: SliverToBoxAdapter(
            child: _buildSectionCard(
              context,
              title: 'Revenue Constellation',
              subtitle: 'Track your earnings over time',
              icon: Icons.auto_graph_rounded,
              accentColor: const Color(0xFFFFD700),
              centeredHeader: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLegendOrb('Revenue', const Color(0xFFFFD700)),
                  SizedBox(width: 16.w),
                  _buildLegendOrb('Fees', const Color(0xFF10B981)),
                ],
              ),
              child: _buildChart(context, data.chartData, filter),
            ),
          ),
        ),
        // Row 1: Tier Breakdown + Pending Payouts
        SliverPadding(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
          sliver: SliverToBoxAdapter(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tier Breakdown
                Expanded(
                  child: _buildSectionCard(
                    context,
                    title: 'Tier Breakdown',
                    subtitle: 'Revenue by tier',
                    icon: Icons.diamond_rounded,
                    accentColor: const Color(0xFF8B5CF6),
                    centeredHeader: false,
                    trailing: _buildBadge(
                      '${data.byTier.length} tiers',
                      const Color(0xFF8B5CF6),
                    ),
                    child: _buildTierContentHorizontal(context, data.byTier),
                  ),
                ),
                SizedBox(width: 20.w),
                // Pending Payouts
                Expanded(
                  child: _buildSectionCard(
                    context,
                    title: 'Pending Payouts',
                    subtitle: 'Awaiting distribution',
                    icon: Icons.account_balance_wallet_rounded,
                    accentColor: const Color(0xFFF59E0B),
                    centeredHeader: false,
                    trailing: _buildBadge(
                      '${data.pendingPayouts.length}',
                      const Color(0xFFF59E0B),
                    ),
                    child: _buildPayoutsContentHorizontal(context, data.pendingPayouts),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Row 2: Gym Revenue + Recent Transactions
        SliverPadding(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 40.h),
          sliver: SliverToBoxAdapter(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gym Revenue
                Expanded(
                  child: _buildSectionCard(
                    context,
                    title: 'Gym Revenue',
                    subtitle: 'Revenue by gym',
                    icon: Icons.castle_rounded,
                    accentColor: const Color(0xFF10B981),
                    centeredHeader: false,
                    trailing: _buildBadge(
                      '${data.byGym.length} gyms',
                      const Color(0xFF10B981),
                    ),
                    child: _buildGymTableHorizontal(context, data.byGym),
                  ),
                ),
                SizedBox(width: 20.w),
                // Recent Transactions
                Expanded(
                  child: _buildSectionCard(
                    context,
                    title: 'Recent Transactions',
                    subtitle: 'Latest activity',
                    icon: Icons.history_edu_rounded,
                    accentColor: const Color(0xFFEC4899),
                    centeredHeader: false,
                    trailing: _buildViewAllButton(),
                    child: _buildTransactionsContentHorizontal(context, data.recentTransactions),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildHeader(
      BuildContext context, RevenueOverview overview, RevenueFilter filter) {
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1A1035).withValues(alpha:  0.95),
                  const Color(0xFF2D1B4E).withValues(alpha:  0.85),
                  const Color(0xFF1A1035).withValues(alpha: 0.95),
                ]
              : [
                  Colors.white.withValues(alpha: 0.95),
                  const Color(0xFFF8F0FF).withValues(alpha: 0.9),
                  Colors.white.withValues(alpha: 0.95),
                ],
        ),
        border: Border.all(
          width: 1.5,
          color: const Color(0xFFFFD700).withValues(alpha:  0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withValues(alpha:  isDark ? 0.15 : 0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha:  isDark ? 0.1 : 0.05),
            blurRadius: 40,
            offset: const Offset(0, 15),
            spreadRadius: -10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 600;

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildHeaderIcon(),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [
                                    Color(0xFFFFD700),
                                    Color(0xFFD4A574),
                                    Color(0xFFFFD700),
                                  ],
                                ).createShader(bounds),
                                child: Text(
                                  'Revenue & Payouts',
                                  style: GoogleFonts.cinzel(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              _buildGrowthIndicator(overview.revenueGrowthPercent),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(child: _buildPeriodSelector(context, filter)),
                        SizedBox(width: 10.w),
                        _buildExportButton(context),
                      ],
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  _buildHeaderIcon(),
                  SizedBox(width: 18.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFFFFD700),
                              Color(0xFFD4A574),
                              Color(0xFFFFD700),
                            ],
                          ).createShader(bounds),
                          child: Text(
                            'Revenue & Payouts',
                            style: GoogleFonts.cinzel(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        _buildGrowthIndicator(overview.revenueGrowthPercent),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  _buildPeriodSelector(context, filter),
                  SizedBox(width: 12.w),
                  _buildExportButton(context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon() {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFFD700).withValues(alpha:  0.3),
            const Color(0xFFD4A574).withValues(alpha:  0.15),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFFFD700).withValues(alpha:  0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withValues(alpha:  0.3),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
        ).createShader(bounds),
        child: Icon(
          Icons.payments_rounded,
          color: Colors.white,
          size: 26.sp,
        ),
      ),
    );
  }

  Widget _buildGrowthIndicator(double percent) {
    final isPositive = percent >= 0;
    final color = isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha:  isDark ? 0.25 : 0.15),
            color.withValues(alpha:  isDark ? 0.1 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: color.withValues(alpha:  isDark ? 0.4 : 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha:  0.2),
            blurRadius: 8,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            size: 14.sp,
            color: color,
          ),
          SizedBox(width: 5.w),
          Text(
            '${isPositive ? '+' : ''}${percent.toStringAsFixed(1)}% vs previous',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(BuildContext context, RevenueFilter filter) {
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      height: 42.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  Colors.white.withValues(alpha:  0.1),
                  Colors.white.withValues(alpha: 0.05),
                ]
              : [
                  Colors.black.withValues(alpha: 0.05),
                  Colors.black.withValues(alpha: 0.02),
                ],
        ),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFFFD700).withValues(alpha:  0.3),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<RevenuePeriod>(
          value: filter.period,
          icon: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
            ).createShader(bounds),
            child: Icon(Icons.keyboard_arrow_down_rounded,
                color: Colors.white, size: 20.sp),
          ),
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
          dropdownColor: isDark ? const Color(0xFF1A1035) : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          items: RevenuePeriod.values
              .map((p) => DropdownMenuItem(
                    value: p,
                    child: Text(p.displayName),
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

  Widget _buildExportButton(BuildContext context) {
    final isDark = context.isDarkMode;

    return PopupMenuButton<String>(
      onSelected: (format) async {
        final cubit = context.read<AdminRevenueCubit>();
        final messenger = ScaffoldMessenger.of(context);
        final url = await cubit.exportReport(format);
        if (url != null && mounted) {
          messenger.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 20.sp),
                  SizedBox(width: 10.w),
                  Text('Report exported successfully',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                ],
              ),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
            ),
          );
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      color: isDark ? const Color(0xFF1A1035) : Colors.white,
      elevation: 20,
      itemBuilder: (ctx) => [
        _buildExportMenuItem('csv', 'Export CSV', Icons.table_chart_rounded),
        _buildExportMenuItem('pdf', 'Export PDF', Icons.picture_as_pdf_rounded),
        _buildExportMenuItem('xlsx', 'Export Excel', Icons.grid_on_rounded),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 11.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFD700),
              Color(0xFFD4A574),
              Color(0xFFFFD700),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withValues(alpha:  0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: -4,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.download_rounded, color: Colors.white, size: 18.sp),
            SizedBox(width: 6.w),
            Text(
              'Export',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildExportMenuItem(
      String value, String label, IconData icon) {
    final isDark = context.isDarkMode;

    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
            ).createShader(bounds),
            child: Icon(icon, size: 20.sp, color: Colors.white),
          ),
          SizedBox(width: 14.w),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STAT CARDS — 2x2 Grid Layout with Individual Cards
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStatCards(BuildContext context, RevenueOverview overview) {
    // All 4 stat cards in a single row
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            title: 'Total Revenue',
            value: overview.totalRevenue,
            subtitle: '${overview.totalTransactions} txns',
            icon: Icons.account_balance_wallet_rounded,
            accentColor: const Color(0xFFFFD700),
            secondaryColor: const Color(0xFFD4A574),
            isHighlighted: true,
            growthPercent: 15.5,
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: _buildStatCard(
            context,
            title: 'Platform Fees',
            value: overview.totalPlatformFees,
            subtitle: overview.totalRevenue > 0
                ? '${(overview.totalPlatformFees / overview.totalRevenue * 100).toStringAsFixed(1)}%'
                : '0%',
            icon: Icons.toll_rounded,
            accentColor: const Color(0xFF10B981),
            secondaryColor: const Color(0xFF059669),
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: _buildStatCard(
            context,
            title: 'Gym Payouts',
            value: overview.totalGymPayouts,
            subtitle: 'To partners',
            icon: Icons.storefront_rounded,
            accentColor: const Color(0xFF8B5CF6),
            secondaryColor: const Color(0xFF7C3AED),
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: _buildStatCard(
            context,
            title: 'Pending',
            value: overview.pendingPayouts,
            subtitle: 'Awaiting',
            icon: Icons.schedule_rounded,
            accentColor: const Color(0xFFF59E0B),
            secondaryColor: const Color(0xFFD97706),
          ),
        ),
      ],
    );
  }

  /// Individual stat card with centered icon above title layout
  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required double value,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required Color secondaryColor,
    bool isHighlighted = false,
    double? growthPercent,
  }) {
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 20.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1A1035).withValues(alpha:  0.95),
                  const Color(0xFF2D1B4E).withValues(alpha: 0.85),
                ]
              : [
                  Colors.white.withValues(alpha: 0.98),
                  const Color(0xFFF8F0FF).withValues(alpha: 0.95),
                ],
        ),
        border: Border.all(
          color: accentColor.withValues(alpha:  isDark ? 0.35 : 0.25),
          width: isHighlighted ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha:  isDark ? 0.2 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -5,
          ),
          if (isHighlighted)
            BoxShadow(
              color: accentColor.withValues(alpha:  isDark ? 0.15 : 0.08),
              blurRadius: 30,
              offset: const Offset(0, 12),
              spreadRadius: -8,
            ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Centered Icon with glow effect
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor.withValues(alpha:  isDark ? 0.35 : 0.25),
                  accentColor.withValues(alpha:  isDark ? 0.15 : 0.1),
                ],
              ),
              border: Border.all(
                color: accentColor.withValues(alpha:  isDark ? 0.5 : 0.35),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha:  isDark ? 0.4 : 0.25),
                  blurRadius: 20,
                  spreadRadius: -2,
                ),
                BoxShadow(
                  color: accentColor.withValues(alpha:  isDark ? 0.2 : 0.1),
                  blurRadius: 40,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accentColor, secondaryColor],
              ).createShader(bounds),
              child: Icon(icon, color: Colors.white, size: 26.sp),
            ),
          ),
          SizedBox(height: 14.h),
          // Title with elegant font - centered below icon
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: isDark
                  ? [Colors.white.withValues(alpha:  0.9), Colors.white.withValues(alpha: 0.6)]
                  : [Colors.black.withValues(alpha: 0.7), Colors.black.withValues(alpha: 0.5)],
            ).createShader(bounds),
            child: Text(
              title,
              style: GoogleFonts.cinzel(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(height: 12.h),
          // Value - Large and prominent with gradient
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: isHighlighted
                  ? [accentColor, secondaryColor]
                  : [
                      isDark ? Colors.white : Colors.black87,
                      isDark ? Colors.white70 : Colors.black54,
                    ],
            ).createShader(bounds),
            child: Text(
              'EGP ${_formatNumber(value)}',
              style: GoogleFonts.spaceGrotesk(
                fontSize: isHighlighted ? 26.sp : 22.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 8.h),
          // Subtitle
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.5)
                  : Colors.black.withValues(alpha: 0.4),
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          // Growth Badge (if applicable) - at the bottom
          if (growthPercent != null) ...[
            SizedBox(height: 10.h),
            _buildGrowthBadge(growthPercent, isDark),
          ],
        ],
      ),
    );
  }

  /// Growth badge for stat cards - compact version
  Widget _buildGrowthBadge(double percent, bool isDark) {
    final isPositive = percent >= 0;
    final color = isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: isDark ? 0.25 : 0.15),
            color.withValues(alpha: isDark ? 0.1 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.4 : 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            size: 10.sp,
            color: color,
          ),
          SizedBox(width: 2.w),
          Text(
            '${percent.toStringAsFixed(0)}%',
            style: GoogleFonts.inter(
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION CARD — Premium Horizontal Layout with Accent Sidebar
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required Widget child,
    Widget? trailing,
    bool centeredHeader = false,
  }) {
    final isDark = context.isDarkMode;

    // Create secondary color for gradient effects
    final secondaryColor = HSLColor.fromColor(accentColor)
        .withLightness(
            (HSLColor.fromColor(accentColor).lightness + 0.15).clamp(0.0, 1.0))
        .toColor();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        // Clean gradient background
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1A1035).withValues(alpha: 0.95),
                  const Color(0xFF2D1B4E).withValues(alpha: 0.85),
                ]
              : [
                  Colors.white.withValues(alpha: 0.98),
                  const Color(0xFFFAF5FF).withValues(alpha: 0.95),
                ],
        ),
        border: Border.all(
          color: accentColor.withValues(alpha: isDark ? 0.25 : 0.18),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: isDark ? 0.15 : 0.08),
            blurRadius: 30,
            offset: const Offset(0, 12),
            spreadRadius: -8,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ═══════════════════════════════════════════════════════════════
              // HEADER SECTION — Centered or Horizontal Layout
              // ═══════════════════════════════════════════════════════════════
              centeredHeader
                  ? _buildCenteredHeader(
                      context,
                      title: title,
                      subtitle: subtitle,
                      icon: icon,
                      accentColor: accentColor,
                      secondaryColor: secondaryColor,
                      trailing: trailing,
                    )
                  : _buildHorizontalHeader(
                      context,
                      title: title,
                      subtitle: subtitle,
                      icon: icon,
                      accentColor: accentColor,
                      secondaryColor: secondaryColor,
                      trailing: trailing,
                    ),
              // ═══════════════════════════════════════════════════════════════
              // CONTENT SECTION
              // ═══════════════════════════════════════════════════════════════
              Padding(
                padding: EdgeInsets.all(20.r),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Centered header layout with icon on top, title and subtitle below - all centered
  Widget _buildCenteredHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required Color secondaryColor,
    Widget? trailing,
  }) {
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 28.r, horizontal: 20.r),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            accentColor.withValues(alpha: isDark ? 0.12 : 0.06),
            Colors.transparent,
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: accentColor.withValues(alpha: isDark ? 0.2 : 0.12),
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Centered Icon with magical glow
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accentColor.withValues(alpha: isDark ? 0.4 : 0.3),
                    secondaryColor.withValues(alpha: isDark ? 0.2 : 0.15),
                  ],
                ),
                border: Border.all(
                  color: accentColor.withValues(alpha: isDark ? 0.5 : 0.35),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: isDark ? 0.5 : 0.3),
                    blurRadius: 30,
                    spreadRadius: -2,
                  ),
                  BoxShadow(
                    color: secondaryColor.withValues(alpha: isDark ? 0.3 : 0.15),
                    blurRadius: 50,
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, secondaryColor.withValues(alpha: 0.9)],
                ).createShader(bounds),
                child: Icon(icon, color: Colors.white, size: 36.sp),
              ),
            ),
            SizedBox(height: 20.h),
            // Title with gradient - centered
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: isDark
                    ? [Colors.white, Colors.white.withValues(alpha: 0.85)]
                    : [Colors.black87, Colors.black.withValues(alpha: 0.7)],
              ).createShader(bounds),
              child: Text(
                title,
                style: GoogleFonts.cinzel(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8.h),
            // Subtitle - centered
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.55)
                    : Colors.black.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
            // Trailing widget (legend orbs for chart) - centered
            if (trailing != null) ...[
              SizedBox(height: 20.h),
              Center(child: trailing),
            ],
          ],
        ),
      ),
    );
  }

  /// Horizontal header layout with left accent bar
  Widget _buildHorizontalHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required Color secondaryColor,
    Widget? trailing,
  }) {
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            accentColor.withValues(alpha: isDark ? 0.12 : 0.06),
            Colors.transparent,
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: accentColor.withValues(alpha: isDark ? 0.2 : 0.12),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Left accent bar
          Container(
            width: 4.w,
            height: 50.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.r),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  accentColor,
                  secondaryColor,
                  accentColor.withValues(alpha: 0.6),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.5),
                  blurRadius: 8,
                  spreadRadius: -1,
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          // Icon container
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor.withValues(alpha: isDark ? 0.3 : 0.2),
                  accentColor.withValues(alpha: isDark ? 0.12 : 0.08),
                ],
              ),
              border: Border.all(
                color: accentColor.withValues(alpha: isDark ? 0.4 : 0.25),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: isDark ? 0.3 : 0.15),
                  blurRadius: 12,
                  spreadRadius: -3,
                ),
              ],
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accentColor, secondaryColor],
              ).createShader(bounds),
              child: Icon(icon, color: Colors.white, size: 24.sp),
            ),
          ),
          SizedBox(width: 16.w),
          // Title and subtitle - Flexible to prevent overflow
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: isDark
                        ? [Colors.white, Colors.white.withValues(alpha: 0.85)]
                        : [Colors.black87, Colors.black.withValues(alpha: 0.7)],
                  ).createShader(bounds),
                  child: Text(
                    title,
                    style: GoogleFonts.cinzel(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.5)
                        : Colors.black.withValues(alpha: 0.45),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          // Trailing widget
          if (trailing != null) ...[
            SizedBox(width: 8.w),
            trailing,
          ],
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MAGICAL ANIMATED CHART
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildChart(
      BuildContext context, List<RevenuePeriodData> chartData, RevenueFilter filter) {
    final isDark = context.isDarkMode;

    if (chartData.isEmpty) {
      return _buildEmptyChartState(isDark);
    }

    final maxRevenue =
        chartData.map((d) => d.revenue).reduce((a, b) => a > b ? a : b);
    final displayData = chartData
        .take(filter.period == RevenuePeriod.today
            ? 12
            : (filter.period == RevenuePeriod.thisWeek ? 7 : 15))
        .toList();

    return AnimatedBuilder(
      animation: Listenable.merge([
        _chartBarAnimation,
        _chartShimmerAnimation,
        _chartParticleAnimation,
      ]),
      builder: (context, child) {
        return Container(
          height: 280.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [
                      const Color(0xFF1A1035).withValues(alpha:  0.3),
                      const Color(0xFF0D0620).withValues(alpha: 0.5),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.3),
                      const Color(0xFFF8F0FF).withValues(alpha: 0.5),
                    ],
            ),
          ),
          child: Stack(
            children: [
              // Magical grid lines
              _buildMagicalGridLines(isDark),
              // Floating particles
              ..._buildFloatingParticles(isDark, displayData.length),
              // Chart bars
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 20.h, 12.w, 40.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: displayData.asMap().entries.map((entry) {
                    return _buildAnimatedChartBar(
                      entry.key,
                      entry.value,
                      maxRevenue,
                      displayData.length,
                      isDark,
                    );
                  }).toList(),
                ),
              ),
              // Bottom labels
              Positioned(
                left: 12.w,
                right: 12.w,
                bottom: 8.h,
                child: Row(
                  children: displayData.asMap().entries.map((entry) {
                    return Expanded(
                      child: _buildChartLabel(entry.value.label, isDark),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Empty chart state with magical orb
  Widget _buildEmptyChartState(bool isDark) {
    return SizedBox(
      height: 220.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    padding: EdgeInsets.all(24.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFFFFD700).withValues(alpha: isDark ? 0.3 : 0.15),
                          const Color(0xFF8B5CF6).withValues(alpha: isDark ? 0.15 : 0.08),
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD700).withValues(alpha:  0.3 * _glowAnimation.value),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFF8B5CF6), Color(0xFFFFD700)],
                      ).createShader(bounds),
                      child: Icon(Icons.auto_graph_rounded,
                          size: 48.sp, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20.h),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: isDark
                    ? [Colors.white.withValues(alpha:  0.7), Colors.white.withValues(alpha: 0.4)]
                    : [Colors.black.withValues(alpha: 0.6), Colors.black.withValues(alpha: 0.3)],
              ).createShader(bounds),
              child: Text(
                'No chart data available',
                style: GoogleFonts.cinzel(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Magical grid lines with subtle glow
  Widget _buildMagicalGridLines(bool isDark) {
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 20.h, 12.w, 40.h),
        child: Column(
          children: List.generate(5, (index) {
            final opacity = (0.1 + (index * 0.02)) * _glowAnimation.value;
            return Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? const Color(0xFFFFD700).withValues(alpha:  opacity)
                          : const Color(0xFF8B5CF6).withValues(alpha:  opacity * 0.5),
                      width: 1,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  /// Floating magical particles above the chart
  List<Widget> _buildFloatingParticles(bool isDark, int barCount) {
    final particles = <Widget>[];
    final particleColors = [
      const Color(0xFFFFD700),
      const Color(0xFF8B5CF6),
      const Color(0xFF10B981),
      const Color(0xFFEC4899),
    ];

    for (int i = 0; i < 8; i++) {
      final xOffset = (i * 47.0 + 20) % 300;
      final yOffset = 30.0 + (i * 23.0 % 80);
      final size = 3.0 + (i % 3) * 2.0;
      final color = particleColors[i % particleColors.length];
      
      // Calculate animated position
      final animatedY = yOffset + (15 * _chartParticleAnimation.value * (i.isEven ? 1 : -1));
      final animatedOpacity = 0.3 + (0.4 * _chartParticleAnimation.value);

      particles.add(
        Positioned(
          left: xOffset.w,
          top: animatedY.h,
          child: Container(
            width: size.r,
            height: size.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha:  animatedOpacity),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha:  animatedOpacity * 0.8),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return particles;
  }

  /// Individual animated chart bar with magical effects
  Widget _buildAnimatedChartBar(
    int index,
    RevenuePeriodData data,
    double maxRevenue,
    int totalBars,
    bool isDark,
  ) {
    final heightPercent = maxRevenue > 0 ? data.revenue / maxRevenue : 0.0;
    final feePercent = maxRevenue > 0 ? data.platformFees / maxRevenue : 0.0;
    
    // Staggered animation delay based on index
    final staggerDelay = index / totalBars;
    final animatedHeight = (_chartBarAnimation.value - staggerDelay).clamp(0.0, 1.0) / (1.0 - staggerDelay);
    final effectiveAnimatedHeight = animatedHeight.isNaN ? 0.0 : animatedHeight;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Tooltip(
          message:
              'Revenue: EGP ${_formatNumber(data.revenue)}\nFees: EGP ${_formatNumber(data.platformFees)}',
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [const Color(0xFF1A1035), const Color(0xFF2D1B4E)]
                  : [Colors.white, const Color(0xFFF8F0FF)],
            ),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: const Color(0xFFFFD700).withValues(alpha:  0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD700).withValues(alpha:  0.2),
                blurRadius: 15,
                spreadRadius: -3,
              ),
            ],
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black87,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Revenue bar with magical glow
              _buildMagicalBar(
                height: 180.h * heightPercent * effectiveAnimatedHeight,
                minHeight: 6.0,
                maxHeight: 180.h,
                colors: const [
                  Color(0xFFFFD700),
                  Color(0xFFD4A574),
                  Color(0xFFFFD700),
                ],
                glowColor: const Color(0xFFFFD700),
                isDark: isDark,
                isRevenue: true,
                index: index,
              ),
              SizedBox(height: 4.h),
              // Fee bar with emerald glow
              _buildMagicalBar(
                height: 40.h * feePercent * effectiveAnimatedHeight,
                minHeight: 3.0,
                maxHeight: 40.h,
                colors: const [
                  Color(0xFF10B981),
                  Color(0xFF059669),
                  Color(0xFF10B981),
                ],
                glowColor: const Color(0xFF10B981),
                isDark: isDark,
                isRevenue: false,
                index: index,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Magical bar with shimmer and glow effects
  Widget _buildMagicalBar({
    required double height,
    required double minHeight,
    required double maxHeight,
    required List<Color> colors,
    required Color glowColor,
    required bool isDark,
    required bool isRevenue,
    required int index,
  }) {
    final clampedHeight = height.clamp(minHeight, maxHeight);
    
    // Calculate shimmer position
    final shimmerPosition = (_chartShimmerAnimation.value + index * 0.1) % 1.0;

    return Stack(
      children: [
        // Main bar with gradient
        Container(
          height: clampedHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                colors[0].withValues(alpha:  0.7),
                colors[1],
                colors[2].withValues(alpha:  0.9),
              ],
            ),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(isRevenue ? 8.r : 4.r),
            ),
            border: Border.all(
              color: colors[1].withValues(alpha:  isDark ? 0.5 : 0.3),
              width: 1,
            ),
            boxShadow: [
              // Inner glow
              BoxShadow(
                color: glowColor.withValues(alpha:  isDark ? 0.4 : 0.25),
                blurRadius: 12,
                spreadRadius: -2,
              ),
              // Outer ambient glow
              BoxShadow(
                color: glowColor.withValues(alpha: (isDark ? 0.25 : 0.15) * _glowAnimation.value),
                blurRadius: 20,
                spreadRadius: -4,
              ),
            ],
          ),
        ),
        // Shimmer overlay
        if (clampedHeight > minHeight + 10)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(isRevenue ? 8.r : 4.r),
              ),
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white.withValues(alpha:  0.3),
                      Colors.transparent,
                    ],
                    stops: [
                      (shimmerPosition - 0.3).clamp(0.0, 1.0),
                      shimmerPosition,
                      (shimmerPosition + 0.3).clamp(0.0, 1.0),
                    ],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcATop,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.white.withValues(alpha:  0.0),
                        Colors.white.withValues(alpha:  0.15),
                        Colors.white.withValues(alpha:  0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        // Top sparkle
        if (isRevenue && clampedHeight > 30)
          Positioned(
            top: 4.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 6.r,
                height: 6.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha:  0.8 * _glowAnimation.value),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha:  0.6 * _glowAnimation.value),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Chart label with subtle animation
  Widget _buildChartLabel(String label, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [
            isDark ? Colors.white.withValues(alpha:  0.6) : Colors.black.withValues(alpha: 0.5),
            isDark ? Colors.white.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.3),
          ],
        ).createShader(bounds),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// Animated Legend Orb with pulsing glow effect
  Widget _buildLegendOrb(String label, Color color) {
    final isDark = context.isDarkMode;

    // Create a secondary color for gradient
    final secondaryColor = HSLColor.fromColor(color)
        .withLightness(
            (HSLColor.fromColor(color).lightness + 0.2).clamp(0.0, 1.0))
        .toColor();

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _glowAnimation]),
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated orb container
            Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 16.r,
                height: 16.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      color,
                      secondaryColor,
                      color.withValues(alpha:  0.6),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha:  isDark ? 0.3 : 0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    // Inner glow
                    BoxShadow(
                      color: color.withValues(alpha:  0.6 * _glowAnimation.value),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                    // Outer glow - animated
                    BoxShadow(
                      color: color.withValues(alpha:  0.4 * _glowAnimation.value),
                      blurRadius: 16 * _glowAnimation.value,
                      spreadRadius: 2 * _glowAnimation.value,
                    ),
                    // Ambient glow
                    BoxShadow(
                      color: secondaryColor.withValues(alpha:  0.2 * _glowAnimation.value),
                      blurRadius: 24,
                      spreadRadius: -4,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 6.r,
                    height: 6.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha:  0.8 * _glowAnimation.value),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha:  0.5 * _glowAnimation.value),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            // Label with subtle shimmer effect
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  isDark ? Colors.white.withValues(alpha: 0.8) : Colors.black.withValues(alpha: 0.7),
                  color.withValues(alpha: 0.8),
                  isDark ? Colors.white.withValues(alpha: 0.8) : Colors.black.withValues(alpha: 0.7),
                ],
                stops: [
                  0.0,
                  0.3 + (0.4 * _glowAnimation.value),
                  1.0,
                ],
              ).createShader(bounds),
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TIER CONTENT — Luxury Magical Cards (No Animation)
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildTierContent(BuildContext context, List<RevenueByTier> tiers) {
    final isDark = context.isDarkMode;
    
    // Magical tier colors with complementary pairs
    final tierColorPairs = [
      (const Color(0xFFFFD700), const Color(0xFFD4A574)), // Gold
      (const Color(0xFF8B5CF6), const Color(0xFFA78BFA)), // Purple
      (const Color(0xFF06B6D4), const Color(0xFF22D3EE)), // Cyan
      (const Color(0xFFEC4899), const Color(0xFFF472B6)), // Pink
    ];

    // Tier icons for visual variety
    final tierIcons = [
      Icons.workspace_premium_rounded,
      Icons.diamond_rounded,
      Icons.stars_rounded,
      Icons.auto_awesome_rounded,
    ];

    return Column(
      children: tiers.asMap().entries.map((entry) {
        final tier = entry.value;
        final index = entry.key;
        final colorPair = tierColorPairs[index % tierColorPairs.length];
        final primaryColor = colorPair.$1;
        final secondaryColor = colorPair.$2;
        final tierIcon = tierIcons[index % tierIcons.length];

        return Container(
          margin: EdgeInsets.only(bottom: 20.h),
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            // Glassmorphic background
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      primaryColor.withValues(alpha: 0.12),
                      secondaryColor.withValues(alpha: 0.06),
                      primaryColor.withValues(alpha: 0.08),
                    ]
                  : [
                      primaryColor.withValues(alpha: 0.08),
                      secondaryColor.withValues(alpha: 0.04),
                      primaryColor.withValues(alpha: 0.06),
                    ],
            ),
            border: Border.all(
              color: primaryColor.withValues(alpha: isDark ? 0.35 : 0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: isDark ? 0.2 : 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: -5,
              ),
              BoxShadow(
                color: secondaryColor.withValues(alpha: isDark ? 0.1 : 0.05),
                blurRadius: 30,
                offset: const Offset(0, 12),
                spreadRadius: -8,
              ),
            ],
          ),
          child: Column(
            children: [
              // ═══════════════════════════════════════════════════════════════
              // TIER HEADER ROW
              // ═══════════════════════════════════════════════════════════════
              Row(
                children: [
                  // Tier Icon Badge
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          primaryColor.withValues(alpha: isDark ? 0.4 : 0.3),
                          secondaryColor.withValues(alpha: isDark ? 0.2 : 0.15),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: isDark ? 0.2 : 0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: isDark ? 0.4 : 0.25),
                          blurRadius: 15,
                          spreadRadius: -2,
                        ),
                      ],
                    ),
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.white, secondaryColor],
                      ).createShader(bounds),
                      child: Icon(tierIcon, color: Colors.white, size: 22.sp),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  // Tier Name and Subscription Count
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: isDark
                                ? [Colors.white, Colors.white.withValues(alpha: 0.8)]
                                : [Colors.black87, Colors.black54],
                          ).createShader(bounds),
                          child: Text(
                            tier.tierName,
                            style: GoogleFonts.cinzel(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                gradient: LinearGradient(
                                  colors: [
                                    primaryColor.withValues(alpha: isDark ? 0.25 : 0.15),
                                    primaryColor.withValues(alpha: isDark ? 0.1 : 0.05),
                                  ],
                                ),
                                border: Border.all(
                                  color: primaryColor.withValues(alpha: isDark ? 0.3 : 0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.people_alt_rounded,
                                    size: 12.sp,
                                    color: primaryColor,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '${tier.subscriptionsCount}',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Revenue Amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [primaryColor, secondaryColor],
                        ).createShader(bounds),
                        child: Text(
                          'EGP ${_formatNumber(tier.revenue)}',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          gradient: LinearGradient(
                            colors: [
                              primaryColor.withValues(alpha: isDark ? 0.3 : 0.2),
                              secondaryColor.withValues(alpha: isDark ? 0.15 : 0.1),
                            ],
                          ),
                          border: Border.all(
                            color: primaryColor.withValues(alpha: isDark ? 0.4 : 0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.2),
                              blurRadius: 8,
                              spreadRadius: -2,
                            ),
                          ],
                        ),
                        child: Text(
                          '${tier.percentageOfTotal.toStringAsFixed(1)}%',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // ═══════════════════════════════════════════════════════════════
              // MAGICAL PROGRESS BAR
              // ═══════════════════════════════════════════════════════════════
              Container(
                height: 12.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  // Track background with subtle gradient
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            Colors.white.withValues(alpha: 0.08),
                            Colors.white.withValues(alpha: 0.04),
                          ]
                        : [
                            Colors.black.withValues(alpha: 0.06),
                            Colors.black.withValues(alpha: 0.03),
                          ],
                  ),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: isDark ? 0.2 : 0.15),
                  ),
                ),
                child: Stack(
                  children: [
                    // Progress fill
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: tier.percentageOfTotal / 100,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              primaryColor,
                              secondaryColor,
                              primaryColor.withValues(alpha: 0.9),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: isDark ? 0.5 : 0.35),
                              blurRadius: 10,
                              spreadRadius: -2,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Shimmer highlight effect (static)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.3),
                                      Colors.transparent,
                                      Colors.white.withValues(alpha: 0.1),
                                    ],
                                    stops: const [0.0, 0.5, 1.0],
                                  ),
                                ),
                              ),
                            ),
                            // End sparkle
                            Positioned(
                              right: 4.r,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: Container(
                                  width: 4.r,
                                  height: 4.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withValues(alpha: 0.6),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TIER CONTENT — Horizontally Scrollable Cards
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildTierContentHorizontal(BuildContext context, List<RevenueByTier> tiers) {
    final isDark = context.isDarkMode;
    
    if (tiers.isEmpty) {
      return _buildEmptyStateCard(
        isDark: isDark,
        icon: Icons.diamond_rounded,
        message: 'No tier data available',
        color: const Color(0xFF8B5CF6),
      );
    }
    
    // Magical tier colors with complementary pairs
    final tierColorPairs = [
      (const Color(0xFFFFD700), const Color(0xFFD4A574)), // Gold
      (const Color(0xFF8B5CF6), const Color(0xFFA78BFA)), // Purple
      (const Color(0xFF06B6D4), const Color(0xFF22D3EE)), // Cyan
      (const Color(0xFFEC4899), const Color(0xFFF472B6)), // Pink
    ];

    // Tier icons for visual variety
    final tierIcons = [
      Icons.workspace_premium_rounded,
      Icons.diamond_rounded,
      Icons.stars_rounded,
      Icons.auto_awesome_rounded,
    ];

    return SizedBox(
      height: 200.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: tiers.length,
        separatorBuilder: (context, index) => SizedBox(width: 16.w),
        itemBuilder: (context, index) {
          final tier = tiers[index];
          final colorPair = tierColorPairs[index % tierColorPairs.length];
          final primaryColor = colorPair.$1;
          final secondaryColor = colorPair.$2;
          final tierIcon = tierIcons[index % tierIcons.length];

          return Container(
            width: 260.w,
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        primaryColor.withValues(alpha: 0.15),
                        secondaryColor.withValues(alpha: 0.08),
                      ]
                    : [
                        primaryColor.withValues(alpha: 0.1),
                        secondaryColor.withValues(alpha: 0.05),
                      ],
              ),
              border: Border.all(
                color: primaryColor.withValues(alpha: isDark ? 0.4 : 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: isDark ? 0.25 : 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon and tier name
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            primaryColor.withValues(alpha: isDark ? 0.4 : 0.3),
                            secondaryColor.withValues(alpha: isDark ? 0.2 : 0.15),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: isDark ? 0.2 : 0.4),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: isDark ? 0.4 : 0.25),
                            blurRadius: 15,
                            spreadRadius: -2,
                          ),
                        ],
                      ),
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Colors.white, secondaryColor],
                        ).createShader(bounds),
                        child: Icon(tierIcon, color: Colors.white, size: 20.sp),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: isDark
                                  ? [Colors.white, Colors.white.withValues(alpha: 0.8)]
                                  : [Colors.black87, Colors.black54],
                            ).createShader(bounds),
                            child: Text(
                              tier.tierName,
                              style: GoogleFonts.cinzel(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(
                                Icons.people_alt_rounded,
                                size: 12.sp,
                                color: primaryColor,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '${tier.subscriptionsCount} subs',
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Revenue amount
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [primaryColor, secondaryColor],
                  ).createShader(bounds),
                  child: Text(
                    'EGP ${_formatNumber(tier.revenue)}',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                // Progress bar
                Container(
                  height: 10.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              Colors.white.withValues(alpha: 0.08),
                              Colors.white.withValues(alpha: 0.04),
                            ]
                          : [
                              Colors.black.withValues(alpha: 0.06),
                              Colors.black.withValues(alpha: 0.03),
                            ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: tier.percentageOfTotal / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            gradient: LinearGradient(
                              colors: [primaryColor, secondaryColor],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withValues(alpha: 0.5),
                                blurRadius: 8,
                                spreadRadius: -2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                // Percentage badge
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      gradient: LinearGradient(
                        colors: [
                          primaryColor.withValues(alpha: isDark ? 0.3 : 0.2),
                          secondaryColor.withValues(alpha: isDark ? 0.15 : 0.1),
                        ],
                      ),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: isDark ? 0.4 : 0.3),
                      ),
                    ),
                    child: Text(
                      '${tier.percentageOfTotal.toStringAsFixed(1)}%',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PAYOUTS CONTENT — Horizontally Scrollable Cards
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPayoutsContentHorizontal(BuildContext context, List<GymPayout> payouts) {
    final isDark = context.isDarkMode;
    
    if (payouts.isEmpty) {
      return _buildEmptyStateCard(
        isDark: isDark,
        icon: Icons.check_circle_outline_rounded,
        message: 'No pending payouts',
        color: const Color(0xFFF59E0B),
      );
    }
    
    return SizedBox(
      height: 180.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: payouts.length,
        separatorBuilder: (context, index) => SizedBox(width: 16.w),
        itemBuilder: (context, index) {
          return _buildPayoutCardHorizontal(context, payouts[index]);
        },
      ),
    );
  }

  Widget _buildPayoutCardHorizontal(BuildContext context, GymPayout payout) {
    final isDark = context.isDarkMode;

    final statusColors = {
      'pending': const Color(0xFFF59E0B),
      'processing': const Color(0xFF8B5CF6),
      'completed': const Color(0xFF10B981),
      'failed': const Color(0xFFEF4444),
    };
    final statusColor = statusColors[payout.status] ?? const Color(0xFF8B5CF6);

    return Container(
      width: 280.w,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            statusColor.withValues(alpha: isDark ? 0.15 : 0.08),
            statusColor.withValues(alpha: isDark ? 0.05 : 0.02),
          ],
        ),
        border: Border.all(
          color: statusColor.withValues(alpha: isDark ? 0.35 : 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: isDark ? 0.2 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with gym name and status
          Row(
            children: [
              // Gym icon
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      statusColor.withValues(alpha: isDark ? 0.35 : 0.25),
                      statusColor.withValues(alpha: isDark ? 0.15 : 0.1),
                    ],
                  ),
                  border: Border.all(
                    color: statusColor.withValues(alpha: isDark ? 0.4 : 0.3),
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [statusColor, statusColor.withValues(alpha: 0.7)],
                  ).createShader(bounds),
                  child: Icon(
                    Icons.storefront_rounded,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payout.gymName,
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${payout.transactionsCount} transactions',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : Colors.black.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          // Amount and status row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [statusColor, statusColor.withValues(alpha: 0.8)],
                ).createShader(bounds),
                child: Text(
                  'EGP ${_formatNumber(payout.amount)}',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  _buildStatusBadge(payout.status, statusColor),
                  if (payout.status == 'pending') ...[
                    SizedBox(width: 8.w),
                    _buildActionButton(
                      icon: Icons.check_rounded,
                      color: const Color(0xFF10B981),
                      onTap: () async {
                        final cubit = context.read<AdminRevenueCubit>();
                        final messenger = ScaffoldMessenger.of(context);
                        final success = await cubit.processGymPayout(payout.id);
                        if (success && mounted) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.check_circle_rounded,
                                      color: Colors.white, size: 20.sp),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Text(
                                      'Payout processed for ${payout.gymName}',
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: const Color(0xFF10B981),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r)),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // GYM TABLE — Horizontally Scrollable Cards
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildGymTableHorizontal(BuildContext context, List<RevenueByGym> gyms) {
    final isDark = context.isDarkMode;
    
    if (gyms.isEmpty) {
      return _buildEmptyStateCard(
        isDark: isDark,
        icon: Icons.castle_rounded,
        message: 'No gym data available',
        color: const Color(0xFF10B981),
      );
    }
    
    return SizedBox(
      height: 200.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: gyms.length,
        separatorBuilder: (context, index) => SizedBox(width: 16.w),
        itemBuilder: (context, index) {
          return _buildGymCardHorizontal(context, gyms[index], index);
        },
      ),
    );
  }

  Widget _buildGymCardHorizontal(BuildContext context, RevenueByGym gym, int index) {
    final isDark = context.isDarkMode;
    
    // Rotating colors for variety
    final cardColors = [
      (const Color(0xFF10B981), const Color(0xFF059669)),
      (const Color(0xFF8B5CF6), const Color(0xFF7C3AED)),
      (const Color(0xFF06B6D4), const Color(0xFF0891B2)),
      (const Color(0xFFEC4899), const Color(0xFFDB2777)),
    ];
    final colorPair = cardColors[index % cardColors.length];
    final primaryColor = colorPair.$1;
    final secondaryColor = colorPair.$2;

    return Container(
      width: 300.w,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withValues(alpha: isDark ? 0.15 : 0.08),
            secondaryColor.withValues(alpha: isDark ? 0.05 : 0.02),
          ],
        ),
        border: Border.all(
          color: primaryColor.withValues(alpha: isDark ? 0.35 : 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: isDark ? 0.2 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gym name and city
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withValues(alpha: isDark ? 0.35 : 0.25),
                      secondaryColor.withValues(alpha: isDark ? 0.15 : 0.1),
                    ],
                  ),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: isDark ? 0.4 : 0.3),
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [primaryColor, secondaryColor],
                  ).createShader(bounds),
                  child: Icon(
                    Icons.fitness_center_rounded,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gym.gymName,
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 12.sp,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.5)
                              : Colors.black.withValues(alpha: 0.4),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          gym.city,
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.5)
                                : Colors.black.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Share percentage badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Text(
                  '${gym.revenueSharePercent.toStringAsFixed(0)}%',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          // Revenue stats row
          Row(
            children: [
              Expanded(
                child: _buildGymStatColumn(
                  label: 'Revenue',
                  value: 'EGP ${_formatNumber(gym.totalRevenue)}',
                  color: primaryColor,
                  isDark: isDark,
                ),
              ),
              Container(
                width: 1,
                height: 40.h,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.06),
              ),
              Expanded(
                child: _buildGymStatColumn(
                  label: 'Platform Fee',
                  value: 'EGP ${_formatNumber(gym.platformFees)}',
                  color: const Color(0xFF10B981),
                  isDark: isDark,
                ),
              ),
              Container(
                width: 1,
                height: 40.h,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.06),
              ),
              Expanded(
                child: _buildGymStatColumn(
                  label: 'Payout',
                  value: 'EGP ${_formatNumber(gym.gymPayout)}',
                  color: secondaryColor,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGymStatColumn({
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: isDark
                ? Colors.white.withValues(alpha: 0.5)
                : Colors.black.withValues(alpha: 0.4),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TRANSACTIONS CONTENT — Horizontally Scrollable Cards
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildTransactionsContentHorizontal(
      BuildContext context, List<RevenueTransaction> transactions) {
    final isDark = context.isDarkMode;
    
    if (transactions.isEmpty) {
      return _buildEmptyStateCard(
        isDark: isDark,
        icon: Icons.history_edu_rounded,
        message: 'No recent transactions',
        color: const Color(0xFFEC4899),
      );
    }
    
    return SizedBox(
      height: 180.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: transactions.length,
        separatorBuilder: (context, index) => SizedBox(width: 16.w),
        itemBuilder: (context, index) {
          return _buildTransactionCardHorizontal(context, transactions[index]);
        },
      ),
    );
  }

  Widget _buildTransactionCardHorizontal(BuildContext context, RevenueTransaction txn) {
    final isDark = context.isDarkMode;

    final statusColors = {
      'completed': const Color(0xFF10B981),
      'pending': const Color(0xFFF59E0B),
      'failed': const Color(0xFFEF4444),
      'refunded': const Color(0xFF8B5CF6),
    };
    final statusColor = statusColors[txn.status] ?? const Color(0xFF8B5CF6);
    final isRefund = txn.type == 'refund';
    final txnColor = isRefund ? const Color(0xFFEF4444) : const Color(0xFF10B981);

    return Container(
      width: 280.w,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            txnColor.withValues(alpha: isDark ? 0.12 : 0.06),
            txnColor.withValues(alpha: isDark ? 0.04 : 0.02),
          ],
        ),
        border: Border.all(
          color: txnColor.withValues(alpha: isDark ? 0.3 : 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: txnColor.withValues(alpha: isDark ? 0.15 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with user and transaction type
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      txnColor.withValues(alpha: isDark ? 0.35 : 0.25),
                      txnColor.withValues(alpha: isDark ? 0.15 : 0.1),
                    ],
                  ),
                  border: Border.all(
                    color: txnColor.withValues(alpha: isDark ? 0.4 : 0.3),
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [txnColor, txnColor.withValues(alpha: 0.7)],
                  ).createShader(bounds),
                  child: Icon(
                    isRefund
                        ? Icons.remove_circle_outline_rounded
                        : Icons.add_circle_outline_rounded,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      txn.userName,
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${txn.subscriptionTier ?? 'Unknown'} • ${txn.subscriptionDuration ?? ''}',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : Colors.black.withValues(alpha: 0.4),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          // Amount and status row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [txnColor, txnColor.withValues(alpha: 0.7)],
                ).createShader(bounds),
                child: Text(
                  '${isRefund ? '' : '+'}EGP ${txn.amount.abs().toStringAsFixed(0)}',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildStatusBadge(txn.status, statusColor),
                  SizedBox(height: 4.h),
                  Text(
                    DateFormat('MMM d, HH:mm').format(txn.createdAt),
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.5)
                          : Colors.black.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EMPTY STATE CARD — Reusable empty state for horizontal scrollable sections
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildEmptyStateCard({
    required bool isDark,
    required IconData icon,
    required String message,
    required Color color,
  }) {
    return Container(
      height: 150.h,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color.withValues(alpha: isDark ? 0.2 : 0.1),
                  color.withValues(alpha: isDark ? 0.05 : 0.02),
                  Colors.transparent,
                ],
              ),
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [color, color.withValues(alpha: 0.7)],
              ).createShader(bounds),
              child: Icon(
                icon,
                size: 40.sp,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.5)
                  : Colors.black.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PAYOUTS CONTENT — Original Vertical Layout (kept for reference)
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPayoutsContentScrollable(BuildContext context, List<GymPayout> payouts) {
    final isDark = context.isDarkMode;
    
    if (payouts.isEmpty) {
      return Container(
        height: 120.h,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
              ).createShader(bounds),
              child: Icon(
                Icons.check_circle_outline_rounded,
                size: 40.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'No pending payouts',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.5)
                    : Colors.black.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      );
    }
    
    return SizedBox(
      height: 160.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: payouts.length,
        separatorBuilder: (context, index) => SizedBox(width: 16.w),
        itemBuilder: (context, index) {
          return _buildPayoutCard(context, payouts[index]);
        },
      ),
    );
  }

  Widget _buildPayoutCard(BuildContext context, GymPayout payout) {
    final isDark = context.isDarkMode;

    final statusColors = {
      'pending': const Color(0xFFF59E0B),
      'processing': const Color(0xFF8B5CF6),
      'completed': const Color(0xFF10B981),
      'failed': const Color(0xFFEF4444),
    };
    final statusColor = statusColors[payout.status] ?? const Color(0xFF8B5CF6);

    return Container(
      width: 280.w,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            statusColor.withValues(alpha: isDark ? 0.15 : 0.08),
            statusColor.withValues(alpha: isDark ? 0.05 : 0.02),
          ],
        ),
        border: Border.all(
          color: statusColor.withValues(alpha: isDark ? 0.35 : 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: isDark ? 0.2 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with gym name and status
          Row(
            children: [
              // Gym icon
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      statusColor.withValues(alpha: isDark ? 0.35 : 0.25),
                      statusColor.withValues(alpha: isDark ? 0.15 : 0.1),
                    ],
                  ),
                  border: Border.all(
                    color: statusColor.withValues(alpha: isDark ? 0.4 : 0.3),
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [statusColor, statusColor.withValues(alpha: 0.7)],
                  ).createShader(bounds),
                  child: Icon(
                    Icons.storefront_rounded,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payout.gymName,
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${payout.transactionsCount} transactions',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : Colors.black.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          // Amount and status row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [statusColor, statusColor.withValues(alpha: 0.8)],
                ).createShader(bounds),
                child: Text(
                  'EGP ${_formatNumber(payout.amount)}',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  _buildStatusBadge(payout.status, statusColor),
                  if (payout.status == 'pending') ...[
                    SizedBox(width: 8.w),
                    _buildActionButton(
                      icon: Icons.check_rounded,
                      color: const Color(0xFF10B981),
                      onTap: () async {
                        final cubit = context.read<AdminRevenueCubit>();
                        final messenger = ScaffoldMessenger.of(context);
                        final success = await cubit.processGymPayout(payout.id);
                        if (success && mounted) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.check_circle_rounded,
                                      color: Colors.white, size: 20.sp),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Text(
                                      'Payout processed for ${payout.gymName}',
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: const Color(0xFF10B981),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r)),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutsContent(BuildContext context, List<GymPayout> payouts) {
    return Column(
      children:
          payouts.map((payout) => _buildPayoutRow(context, payout)).toList(),
    );
  }

  Widget _buildPayoutRow(BuildContext context, GymPayout payout) {
    final isDark = context.isDarkMode;

    final statusColors = {
      'pending': const Color(0xFFF59E0B),
      'processing': const Color(0xFF8B5CF6),
      'completed': const Color(0xFF10B981),
      'failed': const Color(0xFFEF4444),
    };
    final statusColor = statusColors[payout.status] ?? const Color(0xFF8B5CF6);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            statusColor.withValues(alpha:  isDark ? 0.12 : 0.06),
            statusColor.withValues(alpha:  isDark ? 0.04 : 0.02),
          ],
        ),
        border: Border.all(
          color: statusColor.withValues(alpha: isDark ? 0.3 : 0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payout.gymName,
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 4.h),
                Text(
                  '${payout.transactionsCount} txns',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: isDark
                        ? Colors.white.withValues(alpha:  0.5)
                        : Colors.black.withValues(alpha:  0.4),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'EGP ${_formatNumber(payout.amount)}',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                _buildStatusBadge(payout.status, statusColor),
              ],
            ),
          ),
          if (payout.status == 'pending') ...[
            SizedBox(width: 10.w),
            _buildActionButton(
              icon: Icons.check_rounded,
              color: const Color(0xFF10B981),
              onTap: () async {
                final cubit = context.read<AdminRevenueCubit>();
                final messenger = ScaffoldMessenger.of(context);
                final success = await cubit.processGymPayout(payout.id);
                if (success && mounted) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle_rounded,
                              color: Colors.white, size: 20.sp),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              'Payout processed for ${payout.gymName}',
                              style:
                                  GoogleFonts.inter(fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: const Color(0xFF10B981),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                    ),
                  );
                }
              },
            ),
          ],
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // GYM TABLE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildGymTable(BuildContext context, List<RevenueByGym> gyms) {
    final isDark = context.isDarkMode;

    return Column(
      children: [
        // Table header
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 18.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      Colors.white.withValues(alpha:  0.06),
                      Colors.white.withValues(alpha: 0.02)
                    ]
                  : [
                      Colors.black.withValues(alpha: 0.04),
                      Colors.black.withValues(alpha: 0.01)
                    ],
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              Expanded(flex: 3, child: Text('GYM', style: _tableHeaderStyle)),
              Expanded(
                  flex: 2,
                  child: Text('REVENUE',
                      style: _tableHeaderStyle, textAlign: TextAlign.right)),
              Expanded(
                  flex: 2,
                  child: Text('PLATFORM FEE',
                      style: _tableHeaderStyle, textAlign: TextAlign.right)),
              Expanded(
                  flex: 2,
                  child: Text('PAYOUT',
                      style: _tableHeaderStyle, textAlign: TextAlign.right)),
              Expanded(
                  flex: 1,
                  child: Text('SHARE',
                      style: _tableHeaderStyle, textAlign: TextAlign.right)),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        ...gyms.map((gym) => _buildGymRow(context, gym)),
      ],
    );
  }

  TextStyle get _tableHeaderStyle => GoogleFonts.inter(
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        color: context.isDarkMode
            ? Colors.white.withValues(alpha: 0.5)
            : Colors.black.withValues(alpha: 0.4),
        letterSpacing: 1,
      );

  Widget _buildGymRow(BuildContext context, RevenueByGym gym) {
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 18.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.04),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gym.gymName,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  gym.city,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.5)
                        : Colors.black.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'EGP ${_formatNumber(gym.totalRevenue)}',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'EGP ${_formatNumber(gym.platformFees)}',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14.sp,
                color: const Color(0xFF10B981),
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'EGP ${_formatNumber(gym.gymPayout)}',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14.sp,
                color: isDark ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 1,
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
              ).createShader(bounds),
              child: Text(
                '${gym.revenueSharePercent.toStringAsFixed(0)}%',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TRANSACTIONS CONTENT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildTransactionsContent(
      BuildContext context, List<RevenueTransaction> transactions) {
    return Column(
      children: transactions
          .map((txn) => _buildTransactionRow(context, txn))
          .toList(),
    );
  }

  Widget _buildTransactionRow(BuildContext context, RevenueTransaction txn) {
    final isDark = context.isDarkMode;

    final statusColors = {
      'completed': const Color(0xFF10B981),
      'pending': const Color(0xFFF59E0B),
      'failed': const Color(0xFFEF4444),
      'refunded': const Color(0xFF8B5CF6),
    };
    final statusColor = statusColors[txn.status] ?? const Color(0xFF8B5CF6);
    final isRefund = txn.type == 'refund';
    final txnColor = isRefund ? const Color(0xFFEF4444) : const Color(0xFF10B981);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.04),
          ),
        ),
      ),
      child: Row(
        children: [
          // Transaction icon
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  txnColor.withValues(alpha: isDark ? 0.25 : 0.15),
                  txnColor.withValues(alpha: isDark ? 0.1 : 0.05),
                ],
              ),
              border: Border.all(
                color: txnColor.withValues(alpha: isDark ? 0.35 : 0.25),
              ),
              boxShadow: [
                BoxShadow(
                  color: txnColor.withValues(alpha: 0.2),
                  blurRadius: 10,
                  spreadRadius: -3,
                ),
              ],
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [txnColor, txnColor.withValues(alpha: 0.7)],
              ).createShader(bounds),
              child: Icon(
                isRefund
                    ? Icons.remove_circle_outline_rounded
                    : Icons.add_circle_outline_rounded,
                color: Colors.white,
                size: 22.sp,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn.userName,
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 4.h,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '${txn.subscriptionTier ?? 'Unknown'} • ${txn.subscriptionDuration ?? ''}',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : Colors.black.withValues(alpha: 0.4),
                      ),
                    ),
                    _buildStatusBadge(txn.status, statusColor),
                  ],
                ),
              ],
            ),
          ),
          // Amount + date
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [txnColor, txnColor.withValues(alpha: 0.7)],
                ).createShader(bounds),
                child: Text(
                  '${isRefund ? '' : '+'}EGP ${txn.amount.abs().toStringAsFixed(0)}',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                DateFormat('MMM d, HH:mm').format(txn.createdAt),
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.5)
                      : Colors.black.withValues (alpha: 0.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ERROR STATE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildErrorState(BuildContext context, String msg) {
    final isDark = context.isDarkMode;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(48.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error orb
            Container(
              padding: EdgeInsets.all(28.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFEF4444).withValues(alpha: 0.25),
                    const Color(0xFFEF4444).withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    const Color(0xFFEF4444),
                    const Color(0xFFEF4444).withValues(alpha: 0.7)
                  ],
                ).createShader(bounds),
                child: Icon(Icons.error_outline_rounded,
                    size: 60.sp, color: Colors.white),
              ),
            ),
            SizedBox(height: 28.h),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: isDark
                    ? [Colors.white, Colors.white70]
                    : [Colors.black87, Colors.black54],
              ).createShader(bounds),
              child: Text(
                msg,
                style: GoogleFonts.cinzel(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 32.h),
            // Retry button
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFD700),
                    Color(0xFFD4A574),
                    Color(0xFFFFD700),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.5),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () =>
                      context.read<AdminRevenueCubit>().loadRevenueData(),
                  borderRadius: BorderRadius.circular(16.r),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh_rounded,
                            color: Colors.white, size: 20.sp),
                        SizedBox(width: 10.w),
                        Text(
                          'Try Again',
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SHARED COMPONENTS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStatusBadge(String status, Color color) {
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: isDark ? 0.25 : 0.15),
            color.withValues(alpha: isDark ? 0.1 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.35 : 0.25),
        ),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: isDark ? 0.25 : 0.15),
            color.withValues(alpha: isDark ? 0.1 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.35 : 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 8,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildViewAllButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
            ).createShader(bounds),
            child: Text(
              'View All',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = context.isDarkMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: isDark ? 0.25 : 0.15),
                color.withValues(alpha: isDark ? 0.1 : 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: color.withValues(alpha: isDark ? 0.4 : 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.25),
                blurRadius: 12,
                spreadRadius: -3,
              ),
            ],
          ),
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [color, color.withValues(alpha: 0.7)],
            ).createShader(bounds),
            child: Icon(icon, color: Colors.white, size: 20.sp),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  String _formatNumber(double n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toStringAsFixed(0);
  }
}