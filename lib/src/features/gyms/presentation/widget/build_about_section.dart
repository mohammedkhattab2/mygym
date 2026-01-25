import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/gyms/domain/entities/gym.dart';

/// Luxury About Section
///
/// Displays gym description in an elegant glassmorphism card
/// with premium typography and gold accents.
class BuildAboutSection extends StatelessWidget {
  final Gym gym;
  const BuildAboutSection({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    if (gym.description == null || gym.description!.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with gold accent
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
                Icons.info_outline_rounded,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              "About",
              style: GoogleFonts.montserrat(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        
        // Description card with glassmorphism effect
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                luxury.surfaceElevated.withValues(alpha: 0.8),
                colorScheme.surface.withValues(alpha: 0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: luxury.gold.withValues(alpha: 0.08),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            gym.description!,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurfaceVariant,
              height: 1.7,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }
}
