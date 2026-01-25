import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Premium Luxury Terms & Privacy Text
///
/// Features:
/// - Elegant typography with Google Fonts
/// - Gold accent on links
/// - Subtle gradient on important text
class BuildTerms extends StatelessWidget {
  const BuildTerms({super.key});

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    
    return Text.rich(
      TextSpan(
        text: 'By continuing, you agree to our ',
        style: GoogleFonts.inter(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: luxury.textTertiary,
          height: 1.5,
        ),
        children: [
          TextSpan(
            text: 'Terms of Service',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: luxury.gold,
            ),
          ),
          const TextSpan(
            text: " and ",
          ),
          TextSpan(
            text: "Privacy Policy",
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: luxury.gold,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}