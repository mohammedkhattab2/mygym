import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Application typography - Premium Design System
/// 
/// Font Families:
/// - Poppins: Headlines and titles (Bold, Semi-bold)
/// - Inter: Body text and UI elements (Regular, Medium)
/// - Space Grotesk: Numbers and statistics
class AppTextStyles {
  AppTextStyles._();

  // ============================================
  // FONT FAMILIES
  // ============================================
  
  /// Primary font for headlines and titles
  static const String fontFamily = 'Poppins';
  
  /// Secondary font for body text
  static const String fontFamilyBody = 'Inter';
  
  /// Font for numbers and statistics
  static const String fontFamilyNumbers = 'Space Grotesk';

  // ============================================
  // DISPLAY STYLES (Hero sections, Welcome screens)
  // ============================================
  
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 57,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
    height: 1.12,
    color: AppColors.textPrimary,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 45,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.16,
    color: AppColors.textPrimary,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.22,
    color: AppColors.textPrimary,
  );

  // ============================================
  // HEADLINE STYLES (Page titles, Section headers)
  // ============================================
  
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.29,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
    color: AppColors.textPrimary,
  );

  // ============================================
  // TITLE STYLES (Card titles, Dialog titles)
  // ============================================
  
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.27,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  // ============================================
  // BODY STYLES (Paragraphs, Descriptions)
  // ============================================
  
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColors.textSecondary,
  );

  // ============================================
  // LABEL STYLES (Buttons, Chips, Tabs)
  // ============================================
  
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.33,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
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
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.25,
    color: AppColors.white,
  );

  /// Small button text
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.25,
    color: AppColors.white,
  );

  /// Text button style
  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
    height: 1.43,
    color: AppColors.primary,
  );

  // ============================================
  // CAPTION & OVERLINE
  // ============================================
  
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColors.textSecondary,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
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
  static const TextStyle numberLarge = TextStyle(
    fontFamily: fontFamilyNumbers,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -1,
    height: 1.0,
    color: AppColors.textPrimary,
  );

  /// Medium numbers for cards
  static const TextStyle numberMedium = TextStyle(
    fontFamily: fontFamilyNumbers,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.0,
    color: AppColors.textPrimary,
  );

  /// Small numbers for badges
  static const TextStyle numberSmall = TextStyle(
    fontFamily: fontFamilyNumbers,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  // ============================================
  // PRICE STYLES
  // ============================================
  
  /// Current price
  static const TextStyle priceLarge = TextStyle(
    fontFamily: fontFamilyNumbers,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.0,
    color: AppColors.primary,
  );

  static const TextStyle priceMedium = TextStyle(
    fontFamily: fontFamilyNumbers,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.2,
    color: AppColors.primary,
  );

  /// Original price (strikethrough)
  static const TextStyle priceOriginal = TextStyle(
    fontFamily: fontFamilyNumbers,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    color: AppColors.textSecondary,
    decoration: TextDecoration.lineThrough,
  );

  /// Discount percentage
  static const TextStyle priceDiscount = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    height: 1.0,
    color: AppColors.success,
  );

  // ============================================
  // BADGE STYLES
  // ============================================
  
  static const TextStyle badge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    height: 1.2,
    color: AppColors.white,
  );

  static const TextStyle badgeLarge = TextStyle(
    fontFamily: fontFamily,
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
  static const TextStyle input = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  /// Input hint
  static const TextStyle inputHint = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
    color: AppColors.textDisabled,
  );

  /// Input label
  static const TextStyle inputLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColors.textSecondary,
  );

  /// Input error
  static const TextStyle inputError = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColors.error,
  );

  // ============================================
  // LINK STYLES
  // ============================================
  
  static const TextStyle link = TextStyle(
    fontFamily: fontFamilyBody,
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
  
  static const TextStyle countdown = TextStyle(
    fontFamily: fontFamilyNumbers,
    fontSize: 64,
    fontWeight: FontWeight.w700,
    letterSpacing: -2,
    height: 1.0,
    color: AppColors.textPrimary,
  );

  static const TextStyle countdownSmall = TextStyle(
    fontFamily: fontFamilyNumbers,
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
}