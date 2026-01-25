import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Premium Luxury Social Sign-in Buttons
///
/// Features:
/// - Glassmorphism effect with subtle blur
/// - Gold accent borders
/// - Hover/press effects with scale animation
/// - Premium typography
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
          iconColor: Colors.white,
          isGoogleButton: true,
          onTap: onGoogleSignIn,
        ),
        SizedBox(height: 14.h),
        _LuxurySocialButton(
          text: 'Continue with Apple',
          icon: Icons.apple_rounded,
          iconColor: Colors.black,
          isAppleButton: true,
          onTap: onAppleSignIn,
        ),
      ],
    );
  }
}

class _LuxurySocialButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final Color iconColor;
  final bool isGoogleButton;
  final bool isAppleButton;
  final VoidCallback? onTap;

  const _LuxurySocialButton({
    required this.text,
    required this.icon,
    required this.iconColor,
    this.isGoogleButton = false,
    this.isAppleButton = false,
    this.onTap,
  });

  @override
  State<_LuxurySocialButton> createState() => _LuxurySocialButtonState();
}

class _LuxurySocialButtonState extends State<_LuxurySocialButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isApple = widget.isAppleButton;
    final isDark = context.isDarkMode;
    
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: Container(
          width: double.infinity,
          height: 58.h,
          decoration: BoxDecoration(
            gradient: isApple
                ? LinearGradient(
                    colors: isDark
                        ? [Colors.white, const Color(0xFFF5F5F5)]
                        : [Colors.white, const Color(0xFFF0F0F0)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : LinearGradient(
                    colors: [
                      luxury.surfaceElevated,
                      colorScheme.surface,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isApple
                  ? luxury.gold.withValues(alpha: 0.2)
                  : luxury.gold.withValues(alpha: 0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isApple
                    ? Colors.white.withValues(alpha: 0.1)
                    : colorScheme.primary.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with subtle glow
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isApple
                      ? Colors.black.withValues(alpha: 0.05)
                      : colorScheme.primary.withValues(alpha: 0.1),
                ),
                child: Icon(
                  widget.icon,
                  size: 24.sp,
                  color: widget.iconColor,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                widget.text,
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: isApple ? Colors.black : colorScheme.onSurface,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
