import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/luxury_theme_extension.dart';

/// Luxury Premium Splash Screen for MyGym
///
/// Features:
/// - Perfectly centered content vertically and horizontally
/// - Premium static gradients and layered glowing orbs
/// - Elegant logo with magical glow effect
/// - Full Light/Dark mode compliance using ThemeData
/// - Responsive design for all screen sizes
/// - NO animations (static luxury design)
/// - Auto-navigation after delay
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  bool _systemUISet = false;

  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_systemUISet) {
      _systemUISet = true;
      _setSystemUI();
    }
  }

  void _setSystemUI() {
    final brightness = Theme.of(context).brightness;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            brightness == Brightness.dark ? Brightness.light : Brightness.dark,
        statusBarBrightness: brightness,
      ),
    );
  }

  void _navigateAfterDelay() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: luxury.backgroundGradient,
        ),
        child: Stack(
          children: [
            // Main content - perfectly centered
            SafeArea(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo with luxury glow
                      _buildLogo(colorScheme, luxury),

                      SizedBox(height: 40.h),

                      // App name with premium styling
                      _buildAppName(colorScheme, luxury, isDark),

                      SizedBox(height: 12.h),

                      // Elegant tagline
                      _buildTagline(colorScheme),
                    ],
                  ),
                ),
              ),
            ),

            // Loading indicator at bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 48.h),
                  child: _buildLoadingIndicator(colorScheme, luxury),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the luxury logo with premium styling
  Widget _buildLogo(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primaryContainer,
            colorScheme.secondary,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.25),
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
            size: 56.sp,
            color: colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  /// Build premium app name with gradient text
  Widget _buildAppName(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
  ) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: isDark
              ? [
                  colorScheme.onSurface,
                  luxury.goldLight,
                  colorScheme.onSurface,
                ]
              : [
                  colorScheme.primary,
                  colorScheme.secondary,
                  colorScheme.primary,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcIn,
      child: Text(
        'MyGym',
        style: GoogleFonts.montserrat(
          fontSize: 44.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
          height: 1.1,
        ),
      ),
    );
  }

  /// Build elegant tagline
  Widget _buildTagline(ColorScheme colorScheme) {
    return Text(
      'Elevate Your Fitness Experience',
      textAlign: TextAlign.center,
      style: GoogleFonts.montserrat(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface.withValues(alpha: 0.6),
        letterSpacing: 2,
      ),
    );
  }

  /// Build static premium loading indicator
  Widget _buildLoadingIndicator(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Static gradient loading bar
        Container(
          width: 100.w,
          height: 3.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.r),
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                luxury.gold,
                colorScheme.secondary,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: luxury.primaryGlow,
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Loading text
        Text(
          'LOADING',
          style: GoogleFonts.montserrat(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: luxury.textTertiary,
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }
}