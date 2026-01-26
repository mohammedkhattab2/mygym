import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Premium Luxury Header for Auth screens
///
/// Features:
/// - Logo with gradient background and gold border
/// - Static multi-layer glow effects (no animations)
/// - Elegant serif title
/// - Premium tagline
class BuildHeader extends StatelessWidget {
  const BuildHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        // Logo with luxury styling
        Container(
          width: 90.w,
          height: 90.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.primary.withValues(alpha: 0.8),
                colorScheme.secondary,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(
              color: luxury.gold.withValues(alpha: 0.35),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [
                    colorScheme.onPrimary,
                    luxury.goldLight,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: Icon(
                Icons.fitness_center_rounded,
                size: 44.sp,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
        ),
        SizedBox(height: 28.h),
        // Subtitle label
        Text(
          'PREMIUM FITNESS',
          style: GoogleFonts.montserrat(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: luxury.gold,
            letterSpacing: 3,
          ),
        ),
        SizedBox(height: 10.h),
        // Main title with elegant font
        ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                colorScheme.onSurface,
                colorScheme.onSurface.withValues(alpha: 0.9),
                luxury.goldLight.withValues(alpha: isDark ? 0.7 : 0.5),
              ],
              stops: const [0.0, 0.7, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds);
          },
          child: Text(
            "Welcome Back",
            style: GoogleFonts.playfairDisplay(
              fontSize: 32.sp,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        // Tagline
        Text(
          "Sign in to continue your fitness journey",
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: luxury.textTertiary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}