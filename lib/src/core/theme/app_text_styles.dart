import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Application Typography - Premium Elegant Design System
///
/// Font Families:
/// - Playfair Display: Elegant headlines (luxury serif)
/// - Inter: Primary UI font (clean, readable)
/// - Space Grotesk: Numbers and statistics
class AppTextStyles {
  AppTextStyles._();

  // ============================================
  // FONT FAMILIES
  // ============================================
  
  static String get fontFamilyDisplay => GoogleFonts.playfairDisplay().fontFamily ?? 'Playfair Display';
  static String get fontFamily => GoogleFonts.inter().fontFamily ?? 'Inter';
  static String get fontFamilyBody => GoogleFonts.inter().fontFamily ?? 'Inter';
  static String get fontFamilyNumbers => GoogleFonts.spaceGrotesk().fontFamily ?? 'Space Grotesk';

  // ============================================
  // DISPLAY STYLES (Hero sections)
  // ============================================
  
  static TextStyle get displayLarge => GoogleFonts.playfairDisplay(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    height: 1.15,
    color: AppColors.textPrimary,
  );

  static TextStyle get displayMedium => GoogleFonts.playfairDisplay(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static TextStyle get displaySmall => GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.25,
    color: AppColors.textPrimary,
  );
  
  static TextStyle get displayGold => displayMedium.copyWith(
    color: AppColors.gold,
  );

  // ============================================
  // HEADLINE STYLES (Page titles)
  // ============================================
  
  static TextStyle get headlineLarge => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineMedium => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineSmall => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // ============================================
  // TITLE STYLES (Card titles, sections)
  // ============================================
  
  static TextStyle get titleLarge => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleMedium => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.45,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleSmall => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.45,
    color: AppColors.textPrimary,
  );

  // ============================================
  // BODY STYLES (Paragraphs)
  // ============================================
  
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.55,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 1.45,
    color: AppColors.textSecondary,
  );

  // ============================================
  // LABEL STYLES (Buttons, chips)
  // ============================================
  
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
    height: 1.3,
    color: AppColors.textSecondary,
  );

  // ============================================
  // BUTTON STYLES
  // ============================================
  
  static TextStyle get button => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.2,
    color: AppColors.white,
  );

  static TextStyle get buttonSmall => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.2,
    color: AppColors.white,
  );

  static TextStyle get buttonText => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.4,
    color: AppColors.primary,
  );

  // ============================================
  // CAPTION & OVERLINE
  // ============================================
  
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 1.35,
    color: AppColors.textSecondary,
  );

  static TextStyle get overline => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  // ============================================
  // NUMBER STYLES
  // ============================================
  
  static TextStyle get numberLarge => GoogleFonts.spaceGrotesk(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.0,
    color: AppColors.textPrimary,
  );

  static TextStyle get numberMedium => GoogleFonts.spaceGrotesk(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.0,
    color: AppColors.textPrimary,
  );

  static TextStyle get numberSmall => GoogleFonts.spaceGrotesk(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.2,
    color: AppColors.textPrimary,
  );
  
  static TextStyle get numberGold => numberMedium.copyWith(
    color: AppColors.gold,
  );

  // ============================================
  // PRICE STYLES
  // ============================================
  
  static TextStyle get priceLarge => GoogleFonts.spaceGrotesk(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.0,
    color: AppColors.primary,
  );

  static TextStyle get priceMedium => GoogleFonts.spaceGrotesk(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.2,
    color: AppColors.primary,
  );
  
  static TextStyle get priceGold => priceLarge.copyWith(
    color: AppColors.gold,
  );

  static TextStyle get priceOriginal => GoogleFonts.spaceGrotesk(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.4,
    color: AppColors.textSecondary,
    decoration: TextDecoration.lineThrough,
  );

  static TextStyle get priceDiscount => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    height: 1.0,
    color: AppColors.success,
  );

  // ============================================
  // BADGE STYLES
  // ============================================
  
  static TextStyle get badge => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    height: 1.2,
    color: AppColors.white,
  );

  static TextStyle get badgeLarge => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    height: 1.2,
    color: AppColors.white,
  );

  // ============================================
  // INPUT STYLES
  // ============================================
  
  static TextStyle get input => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle get inputHint => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.5,
    color: AppColors.textDisabled,
  );

  static TextStyle get inputLabel => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static TextStyle get inputError => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 1.35,
    color: AppColors.error,
  );

  // ============================================
  // LINK STYLES
  // ============================================
  
  static TextStyle get link => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    height: 1.45,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  // ============================================
  // COUNTDOWN STYLES
  // ============================================
  
  static TextStyle get countdown => GoogleFonts.spaceGrotesk(
    fontSize: 56,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
    height: 1.0,
    color: AppColors.textPrimary,
  );

  static TextStyle get countdownSmall => GoogleFonts.spaceGrotesk(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    height: 1.0,
    color: AppColors.textPrimary,
  );

  // ============================================
  // HELPER METHODS
  // ============================================
  
  static TextStyle withDarkTheme(TextStyle style) {
    return style.copyWith(
      color: style.color == AppColors.textPrimary
          ? AppColors.textPrimaryDark
          : style.color == AppColors.textSecondary
              ? AppColors.textSecondaryDark
              : style.color,
    );
  }

  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle bold(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w700);
  }

  static TextStyle semiBold(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w600);
  }

  static TextStyle medium(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w500);
  }
  
  static TextStyle gold(TextStyle style) {
    return style.copyWith(color: AppColors.gold);
  }
  
  static TextStyle forGradient(TextStyle style) {
    return style.copyWith(color: Colors.white);
  }
  
  // Google Fonts builders for custom use
  static TextStyle playfairDisplay({
    double fontSize = 28,
    FontWeight fontWeight = FontWeight.w700,
    Color? color,
    double? letterSpacing,
    double? height,
  }) => GoogleFonts.playfairDisplay(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color ?? AppColors.textPrimary,
    letterSpacing: letterSpacing ?? -0.5,
    height: height ?? 1.2,
  );
  
  static TextStyle inter({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double? letterSpacing,
    double? height,
  }) => GoogleFonts.inter(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color ?? AppColors.textPrimary,
    letterSpacing: letterSpacing ?? 0.2,
    height: height ?? 1.5,
  );
  
  static TextStyle spaceGrotesk({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.w700,
    Color? color,
    double? letterSpacing,
    double? height,
  }) => GoogleFonts.spaceGrotesk(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color ?? AppColors.textPrimary,
    letterSpacing: letterSpacing ?? -0.3,
    height: height ?? 1.0,
  );
  
  static TextStyle montserrat({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
    double? letterSpacing,
    double? height,
  }) => GoogleFonts.montserrat(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color ?? AppColors.textPrimary,
    letterSpacing: letterSpacing ?? 0.1,
    height: height ?? 1.4,
  );
  
  static TextStyle luxuryHeading({
    double fontSize = 28,
    FontWeight fontWeight = FontWeight.w700,
    Color? color,
  }) {
    return GoogleFonts.playfairDisplay(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: -0.5,
      height: 1.2,
      color: color ?? AppColors.textPrimary,
    );
  }
}