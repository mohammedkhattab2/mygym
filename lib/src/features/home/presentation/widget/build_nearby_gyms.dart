import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/home/data/datasources/home_dummy_data_source.dart';
import 'package:mygym/src/features/home/domain/entities/gym_entity.dart';

/// Premium Luxury Nearby Gyms Section
///
/// Features:
/// - Elegant section header with gold accent
/// - Premium glassmorphism gym cards
/// - Gradient overlays and glow effects
/// - Star rating with gold styling
/// - Press animations
class BuildNearbyGyms extends StatelessWidget {
  const BuildNearbyGyms({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Column(
      children: [
        // Section header with luxury styling
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary,
                          luxury.gold,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "Nearby Gyms",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _onSeeAllGyms(context),
                child: Row(
                  children: [
                    Text(
                      "See all",
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: luxury.gold,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12.sp,
                      color: luxury.gold.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 18.h),
        // Gym cards list
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            physics: const BouncingScrollPhysics(),
            itemCount: HomeDummyDataSource.gyms.length,
            itemBuilder: (itemContext, index) {
              final gym = HomeDummyDataSource.gyms[index];
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: _LuxuryGymCard(
                  gym: gym,
                  onTap: () => onGymTap(itemContext, gym),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _onSeeAllGyms(BuildContext context) {
    context.go(RoutePaths.gymsList);
  }

  void onGymTap(BuildContext context, GymEntity gym) {
    context.go('${RoutePaths.gyms}/${gym.id}');
  }
}

class _LuxuryGymCard extends StatefulWidget {
  final GymEntity gym;
  final VoidCallback onTap;

  const _LuxuryGymCard({
    required this.gym,
    required this.onTap,
  });

  @override
  State<_LuxuryGymCard> createState() => _LuxuryGymCardState();
}

class _LuxuryGymCardState extends State<_LuxuryGymCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 170.w,
          padding: EdgeInsets.all(12.w),
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
              color: luxury.gold.withValues(alpha: 0.12),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image container with gradient overlay
              Container(
                width: double.infinity,
                height: 85.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.15),
                      colorScheme.secondary.withValues(alpha: 0.1),
                      luxury.gold.withValues(alpha: 0.08),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: luxury.gold.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Stack(
                  children: [
                    // Emoji center
                    Center(
                      child: Text(
                        widget.gym.emoji,
                        style: TextStyle(fontSize: 40.sp),
                      ),
                    ),
                    // Premium badge
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              luxury.gold.withValues(alpha: 0.9),
                              luxury.gold.withValues(alpha: 0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(6.r),
                          boxShadow: [
                            BoxShadow(
                              color: luxury.gold.withValues(alpha: 0.3),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          'PRO',
                          style: GoogleFonts.montserrat(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              // Gym name
              Text(
                widget.gym.name,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              // Location with icon
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 12.sp,
                    color: luxury.textTertiary,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      widget.gym.location,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Bottom row with rating and distance
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Rating with gold star
                  Row(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: [
                              luxury.gold,
                              luxury.goldLight,
                            ],
                          ).createShader(bounds);
                        },
                        child: Icon(
                          Icons.star_rounded,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        widget.gym.rating.toString(),
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  // Distance
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      widget.gym.distance,
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
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
