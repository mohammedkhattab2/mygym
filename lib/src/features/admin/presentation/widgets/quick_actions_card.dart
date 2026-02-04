import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

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
                ? AppColors.primary.withValues(alpha: 0.25)
                : AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 40,
            offset: const Offset(0, 20),
            spreadRadius: -8,
          ),
          BoxShadow(
            color: isDark
                ? AppColors.gold.withValues(alpha: 0.15)
                : AppColors.gold.withValues(alpha: 0.06),
            blurRadius: 60,
            offset: const Offset(0, 10),
            spreadRadius: -10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Stack(
            children: [
              // Magical aurora background effect
              Positioned(
                top: -80.r,
                right: -60.r,
                child: Container(
                  width: 200.r,
                  height: 200.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: isDark
                          ? [
                              AppColors.primary.withValues(alpha: 0.4),
                              AppColors.secondary.withValues(alpha: 0.2),
                              Colors.transparent,
                            ]
                          : [
                              AppColors.primary.withValues(alpha: 0.15),
                              AppColors.secondary.withValues(alpha: 0.08),
                              Colors.transparent,
                            ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -100.r,
                left: -80.r,
                child: Container(
                  width: 220.r,
                  height: 220.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: isDark
                          ? [
                              AppColors.gold.withValues(alpha: 0.35),
                              AppColors.roseGold.withValues(alpha: 0.15),
                              Colors.transparent,
                            ]
                          : [
                              AppColors.gold.withValues(alpha: 0.12),
                              AppColors.roseGold.withValues(alpha: 0.06),
                              Colors.transparent,
                            ],
                    ),
                  ),
                ),
              ),
              // Floating magical stars/sparkles
              ..._buildMagicalSparkles(isDark),
              // Main content
              Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLuxuryHeader(context, isDark, luxury),
                    SizedBox(height: 28.h),
                    _buildMagicalDivider(isDark),
                    SizedBox(height: 24.h),
                    _buildPremiumActionsList(context, isDark, luxury),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMagicalSparkles(bool isDark) {
    final sparkles = [
      _SparkleData(top: 30, right: 40, size: 4, opacity: 0.8),
      _SparkleData(top: 80, right: 100, size: 3, opacity: 0.6),
      _SparkleData(top: 150, left: 50, size: 3, opacity: 0.5),
      _SparkleData(bottom: 80, right: 60, size: 4, opacity: 0.7),
      _SparkleData(bottom: 120, left: 80, size: 2, opacity: 0.4),
      _SparkleData(top: 200, right: 30, size: 2, opacity: 0.5),
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
                ? AppColors.gold.withValues(alpha: sparkle.opacity)
                : AppColors.gold.withValues(alpha: sparkle.opacity * 0.6),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: isDark ? 0.6 : 0.3),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildLuxuryHeader(BuildContext context, bool isDark, LuxuryThemeExtension luxury) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        // Luxurious gem-like icon container
        Container(
          padding: EdgeInsets.all(3.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
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
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [const Color(0xFF1E1B4B), const Color(0xFF312E81)]
                    : [Colors.white, const Color(0xFFF5F0FF)],
              ),
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
              ).createShader(bounds),
              child: Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: isDark
                      ? [Colors.white, const Color(0xFFE8E0FF)]
                      : [const Color(0xFF1A1A2E), const Color(0xFF312E81)],
                ).createShader(bounds),
                child: Text(
                  'Quick Actions',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                    height: 1.1,
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Your command center awaits',
                style: GoogleFonts.raleway(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? luxury.textTertiary : AppColors.textSecondary,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        // Premium crown badge
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.gold.withValues(alpha: isDark ? 0.25 : 0.15),
                AppColors.gold.withValues(alpha: isDark ? 0.1 : 0.05),
              ],
            ),
            border: Border.all(
              color: AppColors.gold.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.workspace_premium_rounded,
            size: 20.sp,
            color: AppColors.gold,
          ),
        ),
      ],
    );
  }

  Widget _buildMagicalDivider(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.gold.withValues(alpha: isDark ? 0.5 : 0.3),
                  AppColors.primary.withValues(alpha: isDark ? 0.5 : 0.3),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
            width: 8.r,
            height: 8.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFF8B5CF6)],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: isDark ? 0.5 : 0.3),
                  AppColors.gold.withValues(alpha: isDark ? 0.5 : 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumActionsList(BuildContext context, bool isDark, LuxuryThemeExtension luxury) {
    final actions = [
      _LuxuryActionData(
        icon: Icons.add_business_rounded,
        label: 'Add New Gym',
        subtitle: 'Register fitness center',
        primaryColor: AppColors.gold,
        secondaryColor: AppColors.goldLight,
        accentIcon: Icons.stars_rounded,
        onTap: () => context.go(RoutePaths.adminAddGym),
      ),
      _LuxuryActionData(
        icon: Icons.hourglass_top_rounded,
        label: 'Review Pending',
        subtitle: 'Approve submissions',
        primaryColor: const Color(0xFFE879F9),
        secondaryColor: const Color(0xFFF0ABFC),
        accentIcon: Icons.schedule_rounded,
        onTap: () {},
      ),
      _LuxuryActionData(
        icon: Icons.cloud_download_rounded,
        label: 'Export Report',
        subtitle: 'Download analytics',
        primaryColor: const Color(0xFF38BDF8),
        secondaryColor: const Color(0xFF7DD3FC),
        accentIcon: Icons.analytics_rounded,
        onTap: () {},
      ),
      _LuxuryActionData(
        icon: Icons.insights_rounded,
        label: 'View Analytics',
        subtitle: 'Track metrics',
        primaryColor: const Color(0xFF34D399),
        secondaryColor: const Color(0xFF6EE7B7),
        accentIcon: Icons.trending_up_rounded,
        onTap: () {},
      ),
    ];

    return Column(
      children: actions.asMap().entries.map((entry) {
        final index = entry.key;
        final action = entry.value;
        return Padding(
          padding: EdgeInsets.only(bottom: index < actions.length - 1 ? 14.h : 0),
          child: _MagicalActionTile(
            icon: action.icon,
            label: action.label,
            subtitle: action.subtitle,
            primaryColor: action.primaryColor,
            secondaryColor: action.secondaryColor,
            accentIcon: action.accentIcon,
            onTap: action.onTap,
            isDark: isDark,
            luxury: luxury,
            index: index,
          ),
        );
      }).toList(),
    );
  }
}

class _SparkleData {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double size;
  final double opacity;

  _SparkleData({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.size,
    required this.opacity,
  });
}

class _LuxuryActionData {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color primaryColor;
  final Color secondaryColor;
  final IconData accentIcon;
  final VoidCallback onTap;

  _LuxuryActionData({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentIcon,
    required this.onTap,
  });
}

class _MagicalActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color primaryColor;
  final Color secondaryColor;
  final IconData accentIcon;
  final VoidCallback onTap;
  final bool isDark;
  final LuxuryThemeExtension luxury;
  final int index;

  const _MagicalActionTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentIcon,
    required this.onTap,
    required this.isDark,
    required this.luxury,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      primaryColor.withValues(alpha: 0.12),
                      primaryColor.withValues(alpha: 0.06),
                      secondaryColor.withValues(alpha: 0.03),
                    ]
                  : [
                      primaryColor.withValues(alpha: 0.08),
                      primaryColor.withValues(alpha: 0.04),
                      secondaryColor.withValues(alpha: 0.02),
                    ],
            ),
            border: Border.all(
              color: primaryColor.withValues(alpha: isDark ? 0.35 : 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: isDark ? 0.2 : 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: -4,
              ),
            ],
          ),
          child: Row(
            children: [
              // Magical icon orb
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          primaryColor.withValues(alpha: isDark ? 0.35 : 0.25),
                          secondaryColor.withValues(alpha: isDark ? 0.2 : 0.15),
                        ],
                      ),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.4),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: -2,
                        ),
                      ],
                    ),
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [primaryColor, secondaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                    ),
                  ),
                  // Floating accent sparkle
                  Positioned(
                    top: -4.r,
                    right: -4.r,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? const Color(0xFF1E1B4B) : Colors.white,
                        border: Border.all(
                          color: primaryColor.withValues(alpha: 0.5),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.4),
                            blurRadius: 6,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Icon(
                        accentIcon,
                        size: 10.sp,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 18.w),
              // Text content with luxury styling
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.raleway(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Container(
                          width: 4.r,
                          height: 4.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor.withValues(alpha: 0.8),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            subtitle,
                            style: GoogleFonts.raleway(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: luxury.textTertiary,
                              letterSpacing: 0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Luxurious arrow indicator
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryColor.withValues(alpha: isDark ? 0.2 : 0.12),
                      secondaryColor.withValues(alpha: isDark ? 0.1 : 0.06),
                    ],
                  ),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
