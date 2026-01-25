import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Premium Luxury Divider with gold accents
///
/// Features:
/// - Gradient lines fading from gold to transparent
/// - Elegant typography
/// - Subtle gold glow on text
class BuildDivider extends StatelessWidget {
  const BuildDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    return Row(
      children: [
        // Left gradient line
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  colorScheme.outline.withValues(alpha: 0.3),
                  luxury.gold.withValues(alpha: 0.3),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
        // Center text with gold accent
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            "OR CONTINUE WITH",
            style: GoogleFonts.montserrat(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: luxury.textTertiary,
              letterSpacing: 2,
            ),
          ),
        ),
        // Right gradient line
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  luxury.gold.withValues(alpha: 0.3),
                  colorScheme.outline.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}