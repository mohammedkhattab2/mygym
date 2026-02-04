import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/admin/domain/entities/admin_gym.dart';
import 'package:mygym/src/features/admin/presentation/bloc/admin_dashboard_cubit.dart';
import 'package:mygym/src/features/admin/presentation/widgets/admin_stats_card.dart';
import 'package:mygym/src/features/admin/presentation/widgets/quick_actions_card.dart';
import 'package:mygym/src/features/admin/presentation/widgets/recent_gyms_card.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().loadInitial();
  }

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        return state.when(
          initial: () => _buildLoadingState(context),
          loading: () => _buildLoadingState(context),
          error: (message) => _buildErrorState(context, message),
          loaded: (
            stats,
            gyms,
            totalGyms,
            currentPage,
            totalPages,
            hasMore,
            filter,
            isLoadingMore,
            selectedIds,
          ) {
            return Container(
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
                  RefreshIndicator(
                    onRefresh: () => context.read<AdminCubit>().loadInitial(),
                    color: luxury.gold,
                    backgroundColor: isDark ? const Color(0xFF1E1B4B) : Colors.white,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(24.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildWelcomeSection(context, stats),
                          SizedBox(height: 28.h),
                          _buildStatGrid(context, stats),
                          SizedBox(height: 28.h),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              if (constraints.maxWidth > 900) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: RecentGymsCard(gyms: gyms.take(5).toList()),
                                    ),
                                    SizedBox(width: 24.w),
                                    Expanded(
                                      flex: 1,
                                      child: const QuickActionsCard(),
                                    ),
                                  ],
                                );
                              }
                              return Column(
                                children: [
                                  RecentGymsCard(gyms: gyms.take(5).toList()),
                                  SizedBox(height: 24.h),
                                  const QuickActionsCard(),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> _buildBackgroundOrbs(bool isDark) {
    return [
      Positioned(
        top: -100.r,
        right: -50.r,
        child: Container(
          width: 300.r,
          height: 300.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: isDark
                  ? [
                      AppColors.primary.withValues(alpha: 0.15),
                      AppColors.primary.withValues(alpha: 0.05),
                      Colors.transparent,
                    ]
                  : [
                      AppColors.primary.withValues(alpha: 0.08),
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
          width: 250.r,
          height: 250.r,
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
      Positioned(
        bottom: 100.r,
        right: -80.r,
        child: Container(
          width: 200.r,
          height: 200.r,
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
                      AppColors.secondary.withValues(alpha: 0.01),
                      Colors.transparent,
                    ],
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildWelcomeSection(BuildContext context, AdminDashboardStats stats) {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1E1B4B).withValues(alpha: 0.95),
                  const Color(0xFF312E81).withValues(alpha: 0.85),
                  const Color(0xFF1E1B4B).withValues(alpha: 0.95),
                ]
              : [
                  const Color(0xFFFFFBF5),
                  const Color(0xFFF5F0FF),
                  const Color(0xFFFFFBF5),
                ],
          stops: const [0.0, 0.5, 1.0],
        ),
        border: Border.all(
          width: 1.5,
          color: isDark
              ? AppColors.gold.withValues(alpha: 0.3)
              : AppColors.gold.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.gold.withValues(alpha: 0.2)
                : AppColors.gold.withValues(alpha: 0.08),
            blurRadius: 40,
            offset: const Offset(0, 20),
            spreadRadius: -8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Stack(
            children: [
              // Decorative orbs
              Positioned(
                top: -40.r,
                right: -40.r,
                child: Container(
                  width: 150.r,
                  height: 150.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: isDark
                          ? [
                              AppColors.gold.withValues(alpha: 0.3),
                              AppColors.gold.withValues(alpha: 0.1),
                              Colors.transparent,
                            ]
                          : [
                              AppColors.gold.withValues(alpha: 0.15),
                              AppColors.gold.withValues(alpha: 0.05),
                              Colors.transparent,
                            ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -30.r,
                left: -30.r,
                child: Container(
                  width: 100.r,
                  height: 100.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: isDark
                          ? [
                              AppColors.primary.withValues(alpha: 0.25),
                              AppColors.primary.withValues(alpha: 0.08),
                              Colors.transparent,
                            ]
                          : [
                              AppColors.primary.withValues(alpha: 0.1),
                              AppColors.primary.withValues(alpha: 0.03),
                              Colors.transparent,
                            ],
                    ),
                  ),
                ),
              ),
              // Sparkles
              ..._buildWelcomeSparkles(isDark),
              // Content
              Padding(
                padding: EdgeInsets.all(28.r),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: isDark
                                        ? [Colors.white, const Color(0xFFE8E0FF)]
                                        : [const Color(0xFF1A1A2E), const Color(0xFF312E81)],
                                  ).createShader(bounds),
                                  child: Text(
                                    "Welcome back, Admin!",
                                    style: GoogleFonts.cormorantGaramond(
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                      height: 1.2,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "👋",
                                style: TextStyle(fontSize: 24.sp),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "Here's what's happening with MyGym today",
                            style: GoogleFonts.raleway(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: isDark ? luxury.textTertiary : colorScheme.onSurfaceVariant,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Wrap(
                            spacing: 20.w,
                            runSpacing: 16.h,
                            children: [
                              _buildMagicalMinStat(
                                context,
                                '${stats.totalVisitsToday}',
                                "Visits Today",
                                Icons.directions_walk_rounded,
                                [AppColors.primary, AppColors.primaryLight],
                              ),
                              _buildMagicalMinStat(
                                context,
                                '${stats.pendingGyms}',
                                'Pending Approval',
                                Icons.hourglass_top_rounded,
                                stats.pendingGyms > 0
                                    ? [AppColors.warning, const Color(0xFFFBBF24)]
                                    : [AppColors.success, const Color(0xFF34D399)],
                                isHighlighted: stats.pendingGyms > 0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (MediaQuery.of(context).size.width > 600)
                      _buildDecorativeIcon(isDark, luxury),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildWelcomeSparkles(bool isDark) {
    final sparkles = [
      _SparkleData(top: 20, right: 100, size: 4),
      _SparkleData(top: 60, right: 40, size: 3),
      _SparkleData(bottom: 30, left: 120, size: 3),
      _SparkleData(top: 80, left: 60, size: 2),
    ];

    return sparkles.map((sparkle) {
      return Positioned(
        top: sparkle.top?.r,
        bottom: sparkle.bottom?.r,
        left: sparkle.left?.r,
        right: sparkle.right?.r,
        child: Container(
          width: sparkle.size.r,
          height: sparkle.size.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? AppColors.gold.withValues(alpha: 0.7)
                : AppColors.gold.withValues(alpha: 0.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: isDark ? 0.5 : 0.3),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildMagicalMinStat(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    List<Color> gradientColors, {
    bool isHighlighted = false,
  }) {
    final isDark = context.isDarkMode;
    final luxury = context.luxury;
    final primaryColor = gradientColors[0];
    final secondaryColor = gradientColors[1];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withValues(alpha: isDark ? 0.15 : 0.1),
            primaryColor.withValues(alpha: isDark ? 0.08 : 0.04),
          ],
        ),
        border: Border.all(
          color: primaryColor.withValues(alpha: isDark ? 0.35 : 0.2),
          width: 1,
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: primaryColor.withValues(alpha: isDark ? 0.25 : 0.15),
                  blurRadius: 12,
                  spreadRadius: -2,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor.withValues(alpha: isDark ? 0.3 : 0.2),
                  secondaryColor.withValues(alpha: isDark ? 0.2 : 0.12),
                ],
              ),
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: gradientColors,
              ).createShader(bounds),
              child: Icon(
                icon,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: isDark
                      ? [Colors.white, const Color(0xFFE8E0FF)]
                      : [const Color(0xFF1A1A2E), primaryColor],
                ).createShader(bounds),
                child: Text(
                  value,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                label,
                style: GoogleFonts.raleway(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: luxury.textTertiary,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeIcon(bool isDark, LuxuryThemeExtension luxury) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFD700),
            Color(0xFFD4A574),
            Color(0xFFFFD700),
            Color(0xFFE8C9A0),
          ],
          stops: [0.0, 0.3, 0.6, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: isDark ? 0.5 : 0.3),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Container(
        width: 100.r,
        height: 100.r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF1E1B4B), const Color(0xFF312E81)]
                : [Colors.white, const Color(0xFFF5F0FF)],
          ),
        ),
        child: Center(
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
            ).createShader(bounds),
            child: Icon(
              Icons.fitness_center_rounded,
              color: Colors.white,
              size: 48.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final isDark = context.isDarkMode;

    return Container(
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
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
              child: CircularProgressIndicator(
                color: AppColors.gold,
                strokeWidth: 3,
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
                "Loading dashboard...",
                style: GoogleFonts.raleway(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Container(
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
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
                  colors: [AppColors.error, const Color(0xFFF87171)],
                ).createShader(bounds),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 56.sp,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Failed to load dashboard",
              style: GoogleFonts.cormorantGaramond(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Text(
                message,
                style: GoogleFonts.raleway(
                  fontSize: 14.sp,
                  color: luxury.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 28.h),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: isDark ? 0.4 : 0.25),
                    blurRadius: 16,
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.read<AdminCubit>().loadInitial(),
                  borderRadius: BorderRadius.circular(14.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "Retry",
                          style: GoogleFonts.raleway(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatGrid(BuildContext context, AdminDashboardStats stats) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1200
            ? 4
            : constraints.maxWidth > 800
                ? 3
                : constraints.maxWidth > 500
                    ? 2
                    : 1;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 18.h,
          crossAxisSpacing: 18.w,
          childAspectRatio: constraints.maxWidth > 600 ? 1.8 : 1.5,
          children: [
            AdminStatsCard(
              title: 'Total Gyms',
              value: '${stats.totalGyms}',
              subtitle: '${stats.activeGyms} active',
              icon: Icons.fitness_center_rounded,
              iconColor: AppColors.primary,
              trend: TrendDate(value: 12, isPositive: true),
            ),
            AdminStatsCard(
              title: 'Total Users',
              value: '${stats.totalUsers}',
              subtitle: '${stats.activeSubscriptions} subscribed',
              icon: Icons.people_rounded,
              iconColor: AppColors.info,
              trend: TrendDate(value: 8, isPositive: true),
            ),
            AdminStatsCard(
              title: 'Revenue',
              value: 'EGP ${_formatNumber(stats.totalRevenue)}',
              subtitle: 'EGP ${_formatNumber(stats.revenueThisMonth)} this month',
              icon: Icons.payments_rounded,
              iconColor: AppColors.success,
              trend: TrendDate(value: 15, isPositive: true),
            ),
            AdminStatsCard(
              title: 'Monthly Visits',
              value: '${stats.totalVisitsThisMonth}',
              subtitle: '${stats.totalVisitsThisWeek} this week',
              icon: Icons.trending_up_rounded,
              iconColor: AppColors.warning,
              trend: TrendDate(value: 5, isPositive: true),
            ),
          ],
        );
      },
    );
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toStringAsFixed(0);
  }
}

class _SparkleData {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double size;

  _SparkleData({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.size,
  });
}
