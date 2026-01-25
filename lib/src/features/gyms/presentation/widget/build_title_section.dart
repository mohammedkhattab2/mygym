import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/gyms/domain/entities/gym.dart';

/// Luxury Title Section for Gym Details
///
/// Features premium typography with Playfair Display for headings,
/// gold gradient star ratings, and elegant distance badges.
class BuildTitleSection extends StatelessWidget {
  final Gym gym;
  const BuildTitleSection({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gym name with distance badge
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                gym.name,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  height: 1.2,
                ),
              ),
            ),
            if (gym.formattedDistance != null) ...[
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.15),
                      colorScheme.secondary.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: colorScheme.primary,
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      gym.formattedDistance!,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 14.h),
        
        // Gold rating with premium styling
        Row(
          children: [
            // Gold star with shimmer effect
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [
                    luxury.gold,
                    luxury.goldLight,
                    luxury.gold,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ).createShader(bounds);
              },
              child: Icon(
                Icons.star_rounded,
                color: Colors.white,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              gym.rating.toStringAsFixed(1),
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              '(${gym.reviewCount} reviews)',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: luxury.textTertiary,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        
        // Address with elegant icon
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: luxury.surfaceElevated,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: luxury.gold.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.place_outlined,
                color: colorScheme.onSurfaceVariant,
                size: 14.sp,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                gym.address,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
