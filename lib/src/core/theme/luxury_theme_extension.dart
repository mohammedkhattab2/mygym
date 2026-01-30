import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Luxury Theme Extension for Premium Brand Colors
/// 
/// Provides access to premium colors, gradients, and effects
/// not part of the standard Material ColorScheme.
/// 
/// Usage:
/// ```dart
/// final luxury = Theme.of(context).extension<LuxuryThemeExtension>()!;
/// Container(color: luxury.gold);
/// ```
@immutable
class LuxuryThemeExtension extends ThemeExtension<LuxuryThemeExtension> {
  const LuxuryThemeExtension({
    // Gold colors
    required this.gold,
    required this.goldLight,
    required this.goldDark,
    required this.goldShimmer,
    // Rose gold colors
    required this.roseGold,
    required this.roseGoldLight,
    // Platinum
    required this.platinum,
    // Background variants
    required this.backgroundSecondary,
    required this.surfacePremium,
    required this.surfaceElevated,
    // Border variants
    required this.borderLight,
    required this.borderGold,
    // Text variants
    required this.textTertiary,
    required this.textMuted,
    required this.textGold,
    // Glow colors
    required this.primaryGlow,
    required this.goldGlow,
    required this.successGlow,
    // Glass colors
    required this.glassWhite,
    required this.glassBorder,
    required this.glassOverlay,
    // Gradients
    required this.primaryGradient,
    required this.goldGradient,
    required this.premiumGradient,
    required this.backgroundGradient,
    required this.cardGradient,
    // Semantic colors
    required this.success,
    required this.warning,
    required this.info,
    // Gym status colors
    required this.gymOpen,
    required this.gymClosed,
    required this.gymBusy,
    // Shadow
    required this.cardShadow,
  });

  // Gold colors
  final Color gold;
  final Color goldLight;
  final Color goldDark;
  final Color goldShimmer;

  // Rose gold colors
  final Color roseGold;
  final Color roseGoldLight;

  // Platinum
  final Color platinum;

  // Background variants
  final Color backgroundSecondary;
  final Color surfacePremium;
  final Color surfaceElevated;

  // Border variants
  final Color borderLight;
  final Color borderGold;

  // Text variants
  final Color textTertiary;
  final Color textMuted;
  final Color textGold;

  // Glow colors
  final Color primaryGlow;
  final Color goldGlow;
  final Color successGlow;

  // Glass colors
  final Color glassWhite;
  final Color glassBorder;
  final Color glassOverlay;

  // Gradients
  final LinearGradient primaryGradient;
  final LinearGradient goldGradient;
  final LinearGradient premiumGradient;
  final LinearGradient backgroundGradient;
  final LinearGradient cardGradient;

  // Semantic colors
  final Color success;
  final Color warning;
  final Color info;

  // Gym status colors
  final Color gymOpen;
  final Color gymClosed;
  final Color gymBusy;

  // Shadow
  final Color cardShadow;

  /// Light theme luxury extension - PREMIUM ELEGANT
  /// Soft, warm, airy, luxurious feel with refined surfaces
  static LuxuryThemeExtension get light => LuxuryThemeExtension(
        // Gold colors - warm luxury accent
        gold: AppColors.gold,
        goldLight: AppColors.goldLight,
        goldDark: AppColors.goldDark,
        goldShimmer: AppColors.goldShimmer,
        // Rose gold - feminine luxury
        roseGold: AppColors.roseGold,
        roseGoldLight: AppColors.roseGoldLight,
        // Platinum - cool elegance
        platinum: AppColors.platinum,
        // Background variants - warm, airy surfaces
        backgroundSecondary: AppColors.backgroundSecondary,
        surfacePremium: AppColors.surfacePremium,
        surfaceElevated: AppColors.surfaceElevated,
        // Border variants - soft, refined edges
        borderLight: AppColors.borderLight,
        borderGold: AppColors.gold.withValues(alpha: 0.20),
        // Text variants - clear hierarchy
        textTertiary: AppColors.textTertiary,
        textMuted: AppColors.textDisabled,
        textGold: AppColors.goldDark,
        // Glow colors - subtle, elegant
        primaryGlow: AppColors.primaryGlowLightMode,
        goldGlow: AppColors.goldGlowLightMode,
        successGlow: AppColors.successGlowLightMode,
        // Glass colors - elegant transparency
        glassWhite: AppColors.glassLight,
        glassBorder: AppColors.glassBorderLightMode,
        glassOverlay: AppColors.glassOverlayLightMode,
        // Gradients - subtle warmth
        primaryGradient: AppColors.primaryGradient,
        goldGradient: AppColors.goldGradient,
        premiumGradient: AppColors.premiumGradientLight,
        backgroundGradient: AppColors.backgroundGradientLight,
        cardGradient: AppColors.cardGradientLight,
        // Semantic colors - clear indicators
        success: AppColors.success,
        warning: AppColors.warning,
        info: AppColors.info,
        // Gym status - visible but refined
        gymOpen: AppColors.gymOpen,
        gymClosed: AppColors.gymClosed,
        gymBusy: AppColors.gymBusy,
        // Shadow - soft, elegant depth
        cardShadow: AppColors.cardShadowLight,
      );

  /// Dark theme luxury extension - Premium Elegant style
  /// High contrast with refined, calm aesthetic
  static LuxuryThemeExtension get dark => LuxuryThemeExtension(
        // Gold colors - subtle warmth
        gold: AppColors.gold,
        goldLight: AppColors.goldLight,
        goldDark: AppColors.goldDark,
        goldShimmer: AppColors.goldShimmer,
        // Rose gold
        roseGold: AppColors.roseGold,
        roseGoldLight: AppColors.roseGoldLight,
        // Platinum
        platinum: AppColors.platinum,
        // Background variants - deep charcoal with clear layering
        backgroundSecondary: AppColors.backgroundDarkSecondary,
        surfacePremium: AppColors.surfacePremiumDark,
        surfaceElevated: AppColors.surfaceElevatedDark,
        // Border variants - visible but subtle
        borderLight: AppColors.borderLightDark,
        borderGold: AppColors.borderGold,
        // Text variants - HIGH CONTRAST
        textTertiary: AppColors.textTertiaryDark,
        textMuted: AppColors.textMutedDark,
        textGold: AppColors.textGold,
        // Glow colors - refined, not aggressive
        primaryGlow: AppColors.primaryGlow,
        goldGlow: AppColors.goldGlow,
        successGlow: AppColors.successGlow,
        // Glass colors - subtle elegance
        glassWhite: AppColors.glassWhite,
        glassBorder: AppColors.glassBorder,
        glassOverlay: AppColors.glassOverlay,
        // Gradients
        primaryGradient: AppColors.primaryGradient,
        goldGradient: AppColors.goldGradient,
        premiumGradient: AppColors.premiumGradient,
        backgroundGradient: AppColors.backgroundGradientDark,
        cardGradient: AppColors.cardGradientDark,
        // Semantic colors - clear visibility
        success: AppColors.success,
        warning: AppColors.warning,
        info: AppColors.info,
        // Gym status - clear indicators
        gymOpen: AppColors.gymOpen,
        gymClosed: AppColors.gymClosed,
        gymBusy: AppColors.gymBusy,
        // Shadow - deep for contrast
        cardShadow: AppColors.cardShadowDark,
      );

  @override
  LuxuryThemeExtension copyWith({
    Color? gold,
    Color? goldLight,
    Color? goldDark,
    Color? goldShimmer,
    Color? roseGold,
    Color? roseGoldLight,
    Color? platinum,
    Color? backgroundSecondary,
    Color? surfacePremium,
    Color? surfaceElevated,
    Color? borderLight,
    Color? borderGold,
    Color? textTertiary,
    Color? textMuted,
    Color? textGold,
    Color? primaryGlow,
    Color? goldGlow,
    Color? successGlow,
    Color? glassWhite,
    Color? glassBorder,
    Color? glassOverlay,
    LinearGradient? primaryGradient,
    LinearGradient? goldGradient,
    LinearGradient? premiumGradient,
    LinearGradient? backgroundGradient,
    LinearGradient? cardGradient,
    Color? success,
    Color? warning,
    Color? info,
    Color? gymOpen,
    Color? gymClosed,
    Color? gymBusy,
    Color? cardShadow,
  }) {
    return LuxuryThemeExtension(
      gold: gold ?? this.gold,
      goldLight: goldLight ?? this.goldLight,
      goldDark: goldDark ?? this.goldDark,
      goldShimmer: goldShimmer ?? this.goldShimmer,
      roseGold: roseGold ?? this.roseGold,
      roseGoldLight: roseGoldLight ?? this.roseGoldLight,
      platinum: platinum ?? this.platinum,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
      surfacePremium: surfacePremium ?? this.surfacePremium,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      borderLight: borderLight ?? this.borderLight,
      borderGold: borderGold ?? this.borderGold,
      textTertiary: textTertiary ?? this.textTertiary,
      textMuted: textMuted ?? this.textMuted,
      textGold: textGold ?? this.textGold,
      primaryGlow: primaryGlow ?? this.primaryGlow,
      goldGlow: goldGlow ?? this.goldGlow,
      successGlow: successGlow ?? this.successGlow,
      glassWhite: glassWhite ?? this.glassWhite,
      glassBorder: glassBorder ?? this.glassBorder,
      glassOverlay: glassOverlay ?? this.glassOverlay,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      goldGradient: goldGradient ?? this.goldGradient,
      premiumGradient: premiumGradient ?? this.premiumGradient,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      cardGradient: cardGradient ?? this.cardGradient,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      gymOpen: gymOpen ?? this.gymOpen,
      gymClosed: gymClosed ?? this.gymClosed,
      gymBusy: gymBusy ?? this.gymBusy,
      cardShadow: cardShadow ?? this.cardShadow,
    );
  }

  @override
  LuxuryThemeExtension lerp(LuxuryThemeExtension? other, double t) {
    if (other is! LuxuryThemeExtension) {
      return this;
    }
    return LuxuryThemeExtension(
      gold: Color.lerp(gold, other.gold, t)!,
      goldLight: Color.lerp(goldLight, other.goldLight, t)!,
      goldDark: Color.lerp(goldDark, other.goldDark, t)!,
      goldShimmer: Color.lerp(goldShimmer, other.goldShimmer, t)!,
      roseGold: Color.lerp(roseGold, other.roseGold, t)!,
      roseGoldLight: Color.lerp(roseGoldLight, other.roseGoldLight, t)!,
      platinum: Color.lerp(platinum, other.platinum, t)!,
      backgroundSecondary: Color.lerp(backgroundSecondary, other.backgroundSecondary, t)!,
      surfacePremium: Color.lerp(surfacePremium, other.surfacePremium, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      borderGold: Color.lerp(borderGold, other.borderGold, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textGold: Color.lerp(textGold, other.textGold, t)!,
      primaryGlow: Color.lerp(primaryGlow, other.primaryGlow, t)!,
      goldGlow: Color.lerp(goldGlow, other.goldGlow, t)!,
      successGlow: Color.lerp(successGlow, other.successGlow, t)!,
      glassWhite: Color.lerp(glassWhite, other.glassWhite, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      glassOverlay: Color.lerp(glassOverlay, other.glassOverlay, t)!,
      primaryGradient: LinearGradient.lerp(primaryGradient, other.primaryGradient, t)!,
      goldGradient: LinearGradient.lerp(goldGradient, other.goldGradient, t)!,
      premiumGradient: LinearGradient.lerp(premiumGradient, other.premiumGradient, t)!,
      backgroundGradient: LinearGradient.lerp(backgroundGradient, other.backgroundGradient, t)!,
      cardGradient: LinearGradient.lerp(cardGradient, other.cardGradient, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      gymOpen: Color.lerp(gymOpen, other.gymOpen, t)!,
      gymClosed: Color.lerp(gymClosed, other.gymClosed, t)!,
      gymBusy: Color.lerp(gymBusy, other.gymBusy, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
    );
  }
}

/// Extension on BuildContext for easy access to LuxuryThemeExtension
extension LuxuryThemeExtensionContext on BuildContext {
  /// Get the LuxuryThemeExtension from the current theme
  LuxuryThemeExtension get luxury =>
      Theme.of(this).extension<LuxuryThemeExtension>()!;

  /// Check if the current theme is dark
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Get the current ColorScheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get the current TextTheme
  TextTheme get textTheme => Theme.of(this).textTheme;
}