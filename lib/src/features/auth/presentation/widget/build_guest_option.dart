import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Premium Luxury Guest Login Option
///
/// Features:
/// - Subtle gold accent on icon
/// - Elegant typography
/// - Press animation
class BuildGuestOption extends StatefulWidget {
  const BuildGuestOption({
    super.key,
    required this.onGuestLogin,
  });

  final VoidCallback onGuestLogin;

  @override
  State<BuildGuestOption> createState() => _BuildGuestOptionState();
}

class _BuildGuestOptionState extends State<BuildGuestOption> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onGuestLogin();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: _isPressed ? 0.7 : 1.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [
                    luxury.textTertiary,
                    luxury.gold.withValues(alpha: 0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: Icon(
                Icons.person_outline_rounded,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              "Continue as Guest",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: luxury.textTertiary,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: luxury.gold.withValues(alpha: 0.4),
              size: 12.sp,
            ),
          ],
        ),
      ),
    );
  }
}