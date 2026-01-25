import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Application typography - Luxury Premium Design System
///
/// Font Families (via Google Fonts):
/// - Playfair Display: Elegant headlines and hero text (luxury serif)
/// - Montserrat: Modern titles and labels (clean sans-serif)
/// - Inter: Body text and UI elements (readable sans-serif)
/// - Space Grotesk: Numbers and statistics (distinctive numerals)
class AppTextStyles {
  AppTextStyles._();

  // ============================================
  // FONT FAMILIES (Fallback strings for TextStyle)
  // ============================================
  
  /// Luxury serif font for hero headlines
  static String get fontFamilyDisplay => GoogleFonts.playfairDisplay().fontFamily ?? 'Playfair Display';
  
  /// Primary font for titles and labels
  static String get fontFamily => GoogleFonts.montserrat().fontFamily ?? 'Montserrat';
  
  /// Secondary font for body text
  static String get fontFamilyBody => GoogleFonts.inter().fontFamily ?? 'Inter';
  
  /// Font for numbers and statistics
  static String get fontFamilyNumbers => GoogleFonts.spaceGrotesk().fontFamily ?? 'Space Grotesk';
  
  // ============================================
  // GOOGLE FONTS TEXT STYLE BUILDERS
  // ============================================
  
  /// Get Playfair Display style (luxury serif)
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
  
  /// Get Montserrat style (modern sans-serif)
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
  
  /// Get Inter style (readable body text)
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
    letterSpacing: letterSpacing ?? 0.25,
    height: height ?? 1.5,
  );
  
  /// Get Space Grotesk style (distinctive numerals)
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
    letterSpacing: letterSpacing ?? -0.5,
    height: height ?? 1.0,
  );

  // ============================================
  // DISPLAY STYLES (Hero sections, Welcome screens)
  // Elegant serif font for maximum luxury impact
  // ============================================
  
  static TextStyle get displayLarge => GoogleFonts.playfairDisplay(
    fontSize: 57,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    height: 1.12,
    color: AppColors.textPrimary,
  );

  static TextStyle get displayMedium => GoogleFonts.playfairDisplay(
    fontSize: 45,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.16,
    color: AppColors.textPrimary,
  );

  static TextStyle get displaySmall => GoogleFonts.playfairDisplay(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.22,
    color: AppColors.textPrimary,
  );
  
  /// Elegant display style with gold accent (for premium headers)
  static TextStyle get displayGold => displayMedium.copyWith(
    color: AppColors.gold,
    letterSpacing: 1.0,
  );

  // ============================================
  // HEADLINE STYLES (Page titles, Section headers)
  // ============================================
  
  static TextStyle get headlineLarge => GoogleFonts.montserrat(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineMedium => GoogleFonts.montserrat(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.29,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineSmall => GoogleFonts.montserrat(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
    color: AppColors.textPrimary,
  );

  // ============================================
  // TITLE STYLES (Card titles, Dialog titles)
  // ============================================
  
  static TextStyle get titleLarge => GoogleFonts.montserrat(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.27,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleMedium => GoogleFonts.montserrat(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleSmall => GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  // ============================================
  // BODY STYLES (Paragraphs, Descriptions)
  // ============================================
  
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColors.textSecondary,
  );

  // ============================================
  // LABEL STYLES (Buttons, Chips, Tabs)
  // ============================================
  
  static TextStyle get labelLarge => GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  static TextStyle get labelMedium => GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.33,
    color: AppColors.textPrimary,
  );

  static TextStyle get labelSmall => GoogleFonts.montserrat(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
    color: AppColors.textSecondary,
  );

  // ============================================
  // BUTTON STYLES
  // ============================================
  
  /// Primary button text
  static TextStyle get button => GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.25,
    color: AppColors.white,
  );

  /// Small button text
  static TextStyle get buttonSmall => GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.25,
    color: AppColors.white,
  );

  /// Text button style
  static TextStyle get buttonText => GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
    height: 1.43,
    color: AppColors.primary,
  );

  // ============================================
  // CAPTION & OVERLINE
  // ============================================
  
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColors.textSecondary,
  );

  static TextStyle get overline => GoogleFonts.montserrat(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    height: 1.6,
    color: AppColors.textSecondary,
  );

  // ============================================
  // NUMBER STYLES (Stats, Prices, Countdowns)
  // ============================================
  
  /// Large numbers for stats
  static TextStyle get numberLarge => GoogleFonts.spaceGrotesk(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -1,
    height: 1.0,
    color: AppColors.textPrimary,
  );

  /// Medium numbers for cards
  static TextStyle get numberMedium => GoogleFonts.spaceGrotesk(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.0,
    color: AppColors.textPrimary,
  );

  /// Small numbers for badges
  static TextStyle get numberSmall => GoogleFonts.spaceGrotesk(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.2,
    color: AppColors.textPrimary,
  );
  
  /// Gold numbers for premium stats
  static TextStyle get numberGold => numberMedium.copyWith(
    color: AppColors.gold,
  );

  // ============================================
  // PRICE STYLES
  // ============================================
  
  /// Current price
  static TextStyle get priceLarge => GoogleFonts.spaceGrotesk(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.0,
    color: AppColors.primary,
  );

  static TextStyle get priceMedium => GoogleFonts.spaceGrotesk(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.2,
    color: AppColors.primary,
  );
  
  /// Premium price with gold color
  static TextStyle get priceGold => priceLarge.copyWith(
    color: AppColors.gold,
  );

  /// Original price (strikethrough)
  static TextStyle get priceOriginal => GoogleFonts.spaceGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    color: AppColors.textSecondary,
    decoration: TextDecoration.lineThrough,
  );

  /// Discount percentage
  static TextStyle get priceDiscount => GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    height: 1.0,
    color: AppColors.success,
  );

  // ============================================
  // BADGE STYLES
  // ============================================
  
  static TextStyle get badge => GoogleFonts.montserrat(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    height: 1.2,
    color: AppColors.white,
  );

  static TextStyle get badgeLarge => GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    height: 1.2,
    color: AppColors.white,
  );

  // ============================================
  // INPUT STYLES
  // ============================================
  
  /// Input text
  static TextStyle get input => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  /// Input hint
  static TextStyle get inputHint => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
    color: AppColors.textDisabled,
  );

  /// Input label
  static TextStyle get inputLabel => GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColors.textSecondary,
  );

  /// Input error
  static TextStyle get inputError => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColors.error,
  );

  // ============================================
  // LINK STYLES
  // ============================================
  
  static TextStyle get link => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
    height: 1.43,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  // ============================================
  // COUNTDOWN/TIMER STYLES
  // ============================================
  
  static TextStyle get countdown => GoogleFonts.spaceGrotesk(
    fontSize: 64,
    fontWeight: FontWeight.w700,
    letterSpacing: -2,
    height: 1.0,
    color: AppColors.textPrimary,
  );

  static TextStyle get countdownSmall => GoogleFonts.spaceGrotesk(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -1,
    height: 1.0,
    color: AppColors.textPrimary,
  );

  // ============================================
  // HELPER METHODS
  // ============================================
  
  /// Apply dark theme colors to a text style
  static TextStyle withDarkTheme(TextStyle style) {
    return style.copyWith(
      color: style.color == AppColors.textPrimary
          ? AppColors.textPrimaryDark
          : style.color == AppColors.textSecondary
              ? AppColors.textSecondaryDark
              : style.color,
    );
  }

  /// Apply custom color to a text style
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Make text style bold
  static TextStyle bold(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w700);
  }

  /// Make text style semi-bold
  static TextStyle semiBold(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w600);
  }

  /// Make text style medium weight
  static TextStyle medium(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w500);
  }
  
  /// Apply gold color for luxury accent
  static TextStyle gold(TextStyle style) {
    return style.copyWith(color: AppColors.gold);
  }
  
  /// Apply gradient shader for text (use with ShaderMask)
  static TextStyle forGradient(TextStyle style) {
    return style.copyWith(color: Colors.white);
  }
  
  /// Luxury heading style with elegant serif
  static TextStyle luxuryHeading({
    double fontSize = 28,
    FontWeight fontWeight = FontWeight.w700,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: -0.5,
      height: 1.2,
      color: color ?? AppColors.textPrimary,
    );
  }
}