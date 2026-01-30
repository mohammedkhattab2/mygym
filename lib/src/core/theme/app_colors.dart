import 'package:flutter/material.dart';

/// Application Color Palette - Premium Elegant Design System
///
/// A refined color system featuring:
/// - Deep charcoal backgrounds for luxurious calm feel
/// - High contrast text for excellent readability
/// - Minimal, disciplined accent usage
/// - Clean, static visual hierarchy
class AppColors {
  AppColors._();

  // ============================================
  // PRIMARY COLORS - Royal Purple
  // ============================================
  
  /// Primary brand color - elegant purple
  static const Color primary = Color(0xFF8B5CF6);
  static const Color primaryLight = Color(0xFFA78BFA);
  static const Color primaryDark = Color(0xFF7C3AED);
  static const Color primaryDeep = Color(0xFF6D28D9);

  // ============================================
  // SECONDARY COLORS - Indigo
  // ============================================
  
  static const Color secondary = Color(0xFF6366F1);
  static const Color secondaryLight = Color(0xFF818CF8);
  static const Color secondaryDark = Color(0xFF4F46E5);

  // ============================================
  // ACCENT COLORS - Refined Gold (Minimal Use)
  // ============================================
  
  /// Champagne Gold - used sparingly for premium highlights
  static const Color gold = Color(0xFFD4A574);
  static const Color goldLight = Color(0xFFE8C9A0);
  static const Color goldDark = Color(0xFFC49A6C);
  static const Color goldShimmer = Color(0xFFF5E6D3);
  
  static const Color roseGold = Color(0xFFE8A0BF);
  static const Color roseGoldLight = Color(0xFFF5D0E0);
  static const Color roseGoldDark = Color(0xFFD4749A);
  
  static const Color platinum = Color(0xFFE5E4E2);
  static const Color platinumDark = Color(0xFFC0C0C0);
  
  static const Color accent = Color(0xFFD4A574);
  static const Color accentLight = Color(0xFFE8C9A0);
  static const Color accentDark = Color(0xFFC49A6C);
  
  static const Color tertiary = Color(0xFF14B8A6);
  static const Color tertiaryLight = Color(0xFF2DD4BF);
  static const Color tertiaryDark = Color(0xFF0D9488);

  // ============================================
  // NEUTRAL COLORS
  // ============================================
  
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  
  // Grey scale - refined
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFE5E5E5);
  static const Color grey300 = Color(0xFFD4D4D4);
  static const Color grey400 = Color(0xFFA3A3A3);
  static const Color grey500 = Color(0xFF737373);
  static const Color grey600 = Color(0xFF525252);
  static const Color grey700 = Color(0xFF404040);
  static const Color grey800 = Color(0xFF262626);
  static const Color grey900 = Color(0xFF171717);

  // ============================================
  // SEMANTIC COLORS
  // ============================================
  
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color successDark = Color(0xFF059669);
  
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFFD97706);
  
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorDark = Color(0xFFDC2626);
  
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);
  static const Color infoDark = Color(0xFF2563EB);

  // ============================================
  // LIGHT THEME COLORS - PREMIUM ELEGANT
  // Soft, warm, airy, and luxurious
  // ============================================
  
  /// Primary background - warm off-white for elegance
  static const Color background = Color(0xFFFBFAF8);
  
  /// Secondary background - subtle warmth
  static const Color backgroundSecondary = Color(0xFFF7F6F3);
  
  /// Card/Surface - pure with subtle warmth
  static const Color surface = Color(0xFFFFFFFF);
  
  /// Elevated surface - cream undertone
  static const Color surfaceElevated = Color(0xFFFAF9F7);
  
  /// Premium surface - subtle luxury
  static const Color surfacePremium = Color(0xFFF8F7F4);
  
  /// Primary border - soft, refined
  static const Color border = Color(0xFFE8E6E1);
  
  /// Secondary border - lighter, subtle
  static const Color borderLight = Color(0xFFF0EEE9);
  
  /// Accent border - warm touch
  static const Color borderWarm = Color(0xFFE5E0D8);
  
  // Light theme text - REFINED HIERARCHY
  /// Primary text - deep charcoal (not pure black)
  static const Color textPrimary = Color(0xFF1A1A1A);
  
  /// Secondary text - warm grey
  static const Color textSecondary = Color(0xFF5C5C5C);
  
  /// Tertiary text - muted
  static const Color textTertiary = Color(0xFF8A8A8A);
  
  /// Disabled text - subtle
  static const Color textDisabled = Color(0xFFB8B8B8);
  
  /// Placeholder text - light
  static const Color textPlaceholder = Color(0xFFC5C5C5);

  // ============================================
  // DARK THEME COLORS - PREMIUM CHARCOAL
  // Deep, calm, luxurious backgrounds
  // ============================================
  
  /// Primary background - deep charcoal
  static const Color backgroundDark = Color(0xFF0A0A0C);
  
  /// Secondary background - subtle elevation
  static const Color backgroundDarkSecondary = Color(0xFF0F0F12);
  
  /// Card surface - clear separation
  static const Color surfaceDark = Color(0xFF141418);
  
  /// Elevated surface - modals, dropdowns
  static const Color surfaceElevatedDark = Color(0xFF1A1A1F);
  
  /// Premium surface - special cards
  static const Color surfacePremiumDark = Color(0xFF1F1F26);
  
  /// Primary border - subtle but visible
  static const Color borderDark = Color(0xFF2A2A32);
  
  /// Secondary border - hover states
  static const Color borderLightDark = Color(0xFF3A3A45);
  
  /// Accent border - premium elements (use sparingly)
  static const Color borderGold = Color(0x40D4A574);
  
  // Dark theme text - HIGH CONTRAST
  static const Color textPrimaryDark = Color(0xFFFAFAFA);
  static const Color textSecondaryDark = Color(0xFFA3A3A3);
  static const Color textTertiaryDark = Color(0xFF737373);
  static const Color textMutedDark = Color(0xFF525252);
  
  /// Gold text for premium highlights (minimal use)
  static const Color textGold = Color(0xFFD4A574);

  // ============================================
  // GRADIENTS - SIMPLIFIED & ELEGANT
  // ============================================
  
  /// Primary gradient - main CTA buttons
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Primary gradient vertical
  static const LinearGradient primaryGradientVertical = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  /// Subtle gold gradient - premium elements only
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFE8C9A0), Color(0xFFD4A574)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient roseGoldGradient = LinearGradient(
    colors: [Color(0xFFF5D0E0), Color(0xFFE8A0BF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient platinumGradient = LinearGradient(
    colors: [Color(0xFFE5E4E2), Color(0xFFC0C0C0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Success gradient
  static const LinearGradient energyGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF14B8A6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFEC4899), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient oceanGradient = LinearGradient(
    colors: [Color(0xFF14B8A6), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient auroraGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1), Color(0xFF14B8A6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient mysticGradient = LinearGradient(
    colors: [Color(0xFF6D28D9), Color(0xFF7C3AED), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dark card gradient - subtle depth
  static const LinearGradient cardGradientDark = LinearGradient(
    colors: [Color(0xFF1A1A1F), Color(0xFF141418)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradientPremium = LinearGradient(
    colors: [Color(0xFF1F1F26), Color(0xFF1A1A1F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient vipGradient = LinearGradient(
    colors: [Color(0xFFD4A574), Color(0xFFE8C9A0), Color(0xFFD4A574)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Background gradient for screens - very subtle
  static const LinearGradient backgroundGradientDark = LinearGradient(
    colors: [Color(0xFF0A0A0C), Color(0xFF0F0F12)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const RadialGradient magicalGlowGradient = RadialGradient(
    colors: [
      Color(0x408B5CF6),
      Color(0x206366F1),
      Color(0x00000000),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // ============================================
  // LIGHT MODE GRADIENTS - PREMIUM ELEGANT
  // ============================================
  
  /// Light background gradient - subtle warmth
  static const LinearGradient backgroundGradientLight = LinearGradient(
    colors: [Color(0xFFFBFAF8), Color(0xFFF7F6F3)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  /// Light card gradient - elegant surface
  static const LinearGradient cardGradientLight = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFFAF9F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Light premium gradient - subtle luxury
  static const LinearGradient premiumGradientLight = LinearGradient(
    colors: [Color(0xFFF8F7F4), Color(0xFFF5F3EE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Light accent gradient - soft purple
  static const LinearGradient accentGradientLight = LinearGradient(
    colors: [Color(0xFFF5F3FF), Color(0xFFEDE9FE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============================================
  // GLASS / OVERLAY COLORS - DARK MODE
  // ============================================
  
  /// Glass effect - subtle overlay (dark mode)
  static Color glassWhite = Colors.white.withValues(alpha: 0.06);
  static Color glassWhiteStrong = Colors.white.withValues(alpha: 0.10);
  static Color glassWhiteLight = Colors.white.withValues(alpha: 0.03);
  
  static Color glassPurple = const Color(0xFF8B5CF6).withValues(alpha: 0.08);
  static Color glassPurpleStrong = const Color(0xFF8B5CF6).withValues(alpha: 0.12);
  
  static Color glassGold = const Color(0xFFD4A574).withValues(alpha: 0.08);
  static Color glassGoldStrong = const Color(0xFFD4A574).withValues(alpha: 0.12);
  
  /// Glass border (dark mode)
  static Color glassBorder = Colors.white.withValues(alpha: 0.10);
  static Color glassBorderLight = Colors.white.withValues(alpha: 0.06);
  static Color glassBorderStrong = Colors.white.withValues(alpha: 0.15);
  static Color glassBorderGold = const Color(0xFFD4A574).withValues(alpha: 0.25);
  
  /// Overlay colors
  static Color glassOverlay = Colors.black.withValues(alpha: 0.60);
  static Color glassOverlayLight = Colors.black.withValues(alpha: 0.40);

  // ============================================
  // GLASS / OVERLAY COLORS - LIGHT MODE
  // ============================================
  
  /// Light glass effect - elegant transparency
  static Color glassLight = const Color(0xFFFFFFFF).withValues(alpha: 0.85);
  static Color glassLightStrong = const Color(0xFFFFFFFF).withValues(alpha: 0.95);
  static Color glassLightSubtle = const Color(0xFFFFFFFF).withValues(alpha: 0.70);
  
  /// Light glass border - refined edge
  static Color glassBorderLightMode = const Color(0xFFE8E6E1).withValues(alpha: 0.60);
  static Color glassBorderLightModeStrong = const Color(0xFFE8E6E1).withValues(alpha: 0.80);
  
  /// Light overlay
  static Color glassOverlayLightMode = const Color(0xFF1A1A1A).withValues(alpha: 0.04);
  static Color glassOverlayLightModeStrong = const Color(0xFF1A1A1A).withValues(alpha: 0.08);

  // ============================================
  // SHADOW / GLOW COLORS - DARK MODE
  // ============================================
  
  /// Primary glow - subtle
  static Color primaryGlow = const Color(0xFF8B5CF6).withValues(alpha: 0.30);
  static Color primaryGlowStrong = const Color(0xFF8B5CF6).withValues(alpha: 0.45);
  static Color primaryGlowLight = const Color(0xFF8B5CF6).withValues(alpha: 0.15);
  static Color primaryGlowSubtle = const Color(0xFF8B5CF6).withValues(alpha: 0.08);
  
  static Color secondaryGlow = const Color(0xFF6366F1).withValues(alpha: 0.30);
  
  /// Gold glow - premium elements
  static Color goldGlow = const Color(0xFFD4A574).withValues(alpha: 0.25);
  static Color goldGlowStrong = const Color(0xFFD4A574).withValues(alpha: 0.40);
  static Color goldGlowLight = const Color(0xFFD4A574).withValues(alpha: 0.15);
  
  static Color roseGoldGlow = const Color(0xFFE8A0BF).withValues(alpha: 0.30);
  
  /// Semantic glows
  static Color successGlow = const Color(0xFF10B981).withValues(alpha: 0.30);
  static Color errorGlow = const Color(0xFFEF4444).withValues(alpha: 0.30);
  static Color warningGlow = const Color(0xFFF59E0B).withValues(alpha: 0.30);

  /// Card shadow - deep for dark theme
  static Color cardShadowDark = Colors.black.withValues(alpha: 0.40);
  static Color cardShadowPremium = const Color(0xFF8B5CF6).withValues(alpha: 0.15);

  // ============================================
  // SHADOW COLORS - LIGHT MODE (PREMIUM ELEGANT)
  // ============================================
  
  /// Light mode card shadow - soft, refined
  static Color cardShadowLight = const Color(0xFF1A1A1A).withValues(alpha: 0.04);
  static Color cardShadowLightMedium = const Color(0xFF1A1A1A).withValues(alpha: 0.06);
  static Color cardShadowLightStrong = const Color(0xFF1A1A1A).withValues(alpha: 0.10);
  
  /// Light mode primary glow - subtle elegant
  static Color primaryGlowLightMode = const Color(0xFF8B5CF6).withValues(alpha: 0.08);
  static Color primaryGlowLightModeStrong = const Color(0xFF8B5CF6).withValues(alpha: 0.12);
  
  /// Light mode gold glow - warm accent
  static Color goldGlowLightMode = const Color(0xFFD4A574).withValues(alpha: 0.10);
  static Color goldGlowLightModeStrong = const Color(0xFFD4A574).withValues(alpha: 0.15);
  
  /// Light mode success glow
  static Color successGlowLightMode = const Color(0xFF10B981).withValues(alpha: 0.08);

  // ============================================
  // GYM STATUS COLORS
  // ============================================
  
  static const Color gymOpen = Color(0xFF10B981);
  static const Color gymClosed = Color(0xFFEF4444);
  static const Color gymBusy = Color(0xFFF59E0B);
  static const Color gymModerate = Color(0xFF3B82F6);
  static const Color gymLow = Color(0xFF10B981);

  // ============================================
  // SUBSCRIPTION TIER COLORS
  // ============================================
  
  static const Color tierBasic = Color(0xFF737373);
  static const Color tierPlus = Color(0xFF8B5CF6);
  static const Color tierPremium = Color(0xFFD4A574);
  static const Color tierVIP = Color(0xFFE8A0BF);

  // ============================================
  // SOCIAL BRAND COLORS
  // ============================================
  
  static const Color google = Color(0xFFDB4437);
  static const Color apple = Color(0xFF000000);
  static const Color facebook = Color(0xFF1877F2);

  // ============================================
  // HELPER METHODS
  // ============================================
  
  /// Get color with opacity
  static Color withAlpha(Color color, double alpha) {
    return color.withValues(alpha: alpha);
  }

  /// Create simple gradient from two colors
  static LinearGradient createGradient(Color start, Color end) {
    return LinearGradient(
      colors: [start, end],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  static LinearGradient createLuxuryGradient(Color start, Color middle, Color end) {
    return LinearGradient(
      colors: [start, middle, end],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: const [0.0, 0.5, 1.0],
    );
  }
  
  static RadialGradient createGlowGradient(Color color, {double intensity = 0.3}) {
    return RadialGradient(
      colors: [
        color.withValues(alpha: intensity),
        color.withValues(alpha: intensity * 0.5),
        Colors.transparent,
      ],
      stops: const [0.0, 0.5, 1.0],
    );
  }
  
  static LinearGradient get shimmerGradient => LinearGradient(
    colors: [
      Colors.white.withValues(alpha: 0.0),
      Colors.white.withValues(alpha: 0.08),
      Colors.white.withValues(alpha: 0.0),
    ],
    stops: const [0.0, 0.5, 1.0],
    begin: const Alignment(-1.0, 0.0),
    end: const Alignment(1.0, 0.0),
  );
  
  static LinearGradient get goldShimmerGradient => LinearGradient(
    colors: [
      goldShimmer.withValues(alpha: 0.0),
      goldShimmer.withValues(alpha: 0.2),
      goldShimmer.withValues(alpha: 0.0),
    ],
    stops: const [0.0, 0.5, 1.0],
    begin: const Alignment(-1.0, 0.0),
    end: const Alignment(1.0, 0.0),
  );
}