import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Premium Luxury Guest Login Option
///
/// Features:
/// - Subtle gold accent on icon
/// - Elegant typography
/// - No animations (static premium look)
class BuildGuestOption extends StatelessWidget {
  const BuildGuestOption({
    super.key,
    required this.onGuestLogin,
  });

  final VoidCallback onGuestLogin;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    return GestureDetector(
      onTap: onGuestLogin,
      behavior: HitTestBehavior.opaque,
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
              color: colorScheme.onSurface,
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
    );
  }
}