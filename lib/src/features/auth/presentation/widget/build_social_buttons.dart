import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Premium Luxury Social Sign-in Buttons
///
/// Features:
/// - Glassmorphism effect with subtle styling
/// - Gold accent borders
/// - Premium typography
/// - Full Light/Dark mode compliance
/// - NO animations (static luxury design)
class BuildSocialButtons extends StatelessWidget {
  const BuildSocialButtons({
    super.key,
    this.onGoogleSignIn,
    this.onAppleSignIn,
  });

  final VoidCallback? onGoogleSignIn;
  final VoidCallback? onAppleSignIn;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LuxurySocialButton(
          text: "Continue with Google",
          icon: Icons.g_mobiledata_rounded,
          isGoogleButton: true,
          onTap: onGoogleSignIn,
        ),
        SizedBox(height: 14.h),
        _LuxurySocialButton(
          text: 'Continue with Apple',
          icon: Icons.apple_rounded,
          isAppleButton: true,
          onTap: onAppleSignIn,
        ),
      ],
    );
  }
}

/// Static Luxury Social Button (no animations)
class _LuxurySocialButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isGoogleButton;
  final bool isAppleButton;
  final VoidCallback? onTap;

  const _LuxurySocialButton({
    required this.text,
    required this.icon,
    this.isGoogleButton = false,
    this.isAppleButton = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isApple = isAppleButton;
    final isDark = context.isDarkMode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 58.h,
        decoration: BoxDecoration(
          gradient: isApple
              ? LinearGradient(
                  colors: [
                    colorScheme.onPrimary,
                    colorScheme.onPrimary.withValues(alpha: 0.95),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : LinearGradient(
                  colors: isDark
                      ? [luxury.surfaceElevated, luxury.surfacePremium]
                      : [colorScheme.surface, colorScheme.surfaceContainerHighest ?? colorScheme.surface],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark
                ? luxury.gold.withValues(alpha: isApple ? 0.2 : 0.15)
                : colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: luxury.cardShadow.withValues(alpha: isDark ? 0.25 : 0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with subtle background
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isApple
                    ? colorScheme.onSurface.withValues(alpha: 0.05)
                    : colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.1),
              ),
              child: Icon(
                icon,
                size: 24.sp,
                color: isApple
                    ? colorScheme.onSurface
                    : (isDark ? colorScheme.onSurface : colorScheme.primary),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: isApple ? colorScheme.onSurface : colorScheme.onSurface,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
