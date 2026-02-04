import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/admin/domain/entities/admin_gym.dart';
import 'package:mygym/src/features/admin/presentation/widgets/gym_status_badge.dart';

class RecentGymsCard extends StatelessWidget {
  final List<AdminGym> gyms;

  const RecentGymsCard({super.key, required this.gyms});

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
              // Magical aurora orbs
              Positioned(
                top: -60.r,
                right: -40.r,
                child: Container(
                  width: 160.r,
                  height: 160.r,
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
                              AppColors.gold.withValues(alpha: 0.12),
                              AppColors.gold.withValues(alpha: 0.04),
                              Colors.transparent,
                            ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -80.r,
                left: -60.r,
                child: Container(
                  width: 180.r,
                  height: 180.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: isDark
                          ? [
                              AppColors.primary.withValues(alpha: 0.25),
                              AppColors.secondary.withValues(alpha: 0.1),
                              Colors.transparent,
                            ]
                          : [
                              AppColors.primary.withValues(alpha: 0.1),
                              AppColors.secondary.withValues(alpha: 0.04),
                              Colors.transparent,
                            ],
                    ),
                  ),
                ),
              ),
              // Floating sparkles
              ..._buildMagicalSparkles(isDark),
              // Main content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(24.r),
                    child: _buildLuxuryHeader(context, isDark, luxury),
                  ),
                  _buildMagicalDivider(isDark),
                  if (gyms.isEmpty)
                    _buildEmptyState(context, isDark, luxury)
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      itemCount: gyms.length,
                      separatorBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                AppColors.gold.withValues(alpha: isDark ? 0.15 : 0.1),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      itemBuilder: (context, index) {
                        final gym = gyms[index];
                        return _MagicalGymListItem(gym: gym, index: index);
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMagicalSparkles(bool isDark) {
    final sparkles = [
      _SparkleData(top: 40, right: 60, size: 4, opacity: 0.7),
      _SparkleData(top: 100, right: 30, size: 3, opacity: 0.5),
      _SparkleData(top: 180, left: 40, size: 3, opacity: 0.6),
      _SparkleData(bottom: 100, right: 80, size: 2, opacity: 0.4),
      _SparkleData(bottom: 60, left: 100, size: 3, opacity: 0.5),
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

  Widget _buildLuxuryHeader(BuildContext context, bool isDark, LuxuryThemeExtension luxury) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
            // Gem-like icon container
            Container(
              padding: EdgeInsets.all(3.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
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
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13.r),
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
                    Icons.fitness_center_rounded,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Flexible(
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
                      'Recent Gyms',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        height: 1.1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Latest fitness centers',
                    style: GoogleFonts.raleway(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark ? luxury.textTertiary : AppColors.textSecondary,
                      letterSpacing: 1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            ],
          ),
        ),
        // View all button with luxury styling
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.go(RoutePaths.adminGymsList),
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          AppColors.gold.withValues(alpha: 0.15),
                          AppColors.gold.withValues(alpha: 0.08),
                        ]
                      : [
                          AppColors.gold.withValues(alpha: 0.1),
                          AppColors.gold.withValues(alpha: 0.05),
                        ],
                ),
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: isDark ? 0.35 : 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View all',
                    style: GoogleFonts.raleway(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 14.sp,
                    color: AppColors.gold,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMagicalDivider(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
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
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark, LuxuryThemeExtension luxury) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(48.r),
      child: Center(
        child: Column(
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
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    AppColors.gold.withValues(alpha: 0.5),
                    AppColors.gold.withValues(alpha: 0.3),
                  ],
                ).createShader(bounds),
                child: Icon(
                  Icons.fitness_center_outlined,
                  size: 48.sp,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'No gyms yet',
              style: GoogleFonts.raleway(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Add your first fitness center',
              style: GoogleFonts.raleway(
                fontSize: 12.sp,
                color: luxury.textTertiary,
              ),
            ),
          ],
        ),
      ),
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

class _MagicalGymListItem extends StatelessWidget {
  final AdminGym gym;
  final int index;

  const _MagicalGymListItem({required this.gym, required this.index});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    // Different accent colors for each item
    final accentColors = [
      [AppColors.gold, AppColors.goldLight],
      [AppColors.primary, AppColors.primaryLight],
      [const Color(0xFF34D399), const Color(0xFF6EE7B7)],
      [const Color(0xFFE879F9), const Color(0xFFF0ABFC)],
      [const Color(0xFF38BDF8), const Color(0xFF7DD3FC)],
    ];
    final colors = accentColors[index % accentColors.length];
    final primaryColor = colors[0];
    final secondaryColor = colors[1];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Navigate to gym detail
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      primaryColor.withValues(alpha: 0.1),
                      primaryColor.withValues(alpha: 0.04),
                    ]
                  : [
                      primaryColor.withValues(alpha: 0.06),
                      primaryColor.withValues(alpha: 0.02),
                    ],
            ),
            border: Border.all(
              color: primaryColor.withValues(alpha: isDark ? 0.25 : 0.15),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Gym image/icon with gradient border
              Container(
                padding: EdgeInsets.all(2.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryColor.withValues(alpha: 0.8),
                      secondaryColor.withValues(alpha: 0.6),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: isDark ? 0.3 : 0.15),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Container(
                  width: 52.r,
                  height: 52.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: isDark ? const Color(0xFF1E1B4B) : Colors.white,
                    image: gym.imageUrls.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(gym.imageUrls.first),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: gym.imageUrls.isEmpty
                      ? Center(
                          child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [primaryColor, secondaryColor],
                            ).createShader(bounds),
                            child: Icon(
                              Icons.fitness_center_rounded,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
              SizedBox(width: 14.w),
              // Gym info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gym.name,
                      style: GoogleFonts.raleway(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                        letterSpacing: 0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor.withValues(alpha: isDark ? 0.2 : 0.12),
                          ),
                          child: Icon(
                            Icons.location_on_rounded,
                            size: 10.sp,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            gym.city,
                            style: GoogleFonts.raleway(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: luxury.textTertiary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              // Status and date column
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GymStatusBadge(
                    status: gym.status,
                    isCompact: true,
                    showIcon: false,
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.04),
                    ),
                    child: Text(
                      DateFormat('MMM d').format(gym.dateAdded),
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: luxury.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
