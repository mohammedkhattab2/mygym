import 'package:flutter/material.dart';

/// Application color palette - Luxury Premium Dark Theme Design System
///
/// A sophisticated color system featuring:
/// - Royal Purple & Deep Violet as primary tones
/// - Champagne Gold & Rose Gold luxury accents
/// - Rich gradients with depth and dimension
/// - Magical glow effects for immersive experience
class AppColors {
  AppColors._();

  // ============================================
  // PRIMARY COLORS - Royal Purple
  // ============================================
  
  /// Royal Purple - Main brand color for luxury feel
  static const Color primary = Color(0xFF9333EA);
  static const Color primaryLight = Color(0xFFAE5AFF);
  static const Color primaryDark = Color(0xFF7E22CE);
  static const Color primaryDeep = Color(0xFF581C87);

  // ============================================
  // SECONDARY COLORS - Deep Violet
  // ============================================
  
  /// Deep Violet - Secondary brand color
  static const Color secondary = Color(0xFF6366F1);
  static const Color secondaryLight = Color(0xFF818CF8);
  static const Color secondaryDark = Color(0xFF4F46E5);

  // ============================================
  // LUXURY ACCENT COLORS - Gold & Rose Gold
  // ============================================
  
  /// Champagne Gold - Premium luxury accent
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFE8D48B);
  static const Color goldDark = Color(0xFFB8960C);
  static const Color goldShimmer = Color(0xFFF7E7A0);
  
  /// Rose Gold - Elegant accent
  static const Color roseGold = Color(0xFFE8A0BF);
  static const Color roseGoldLight = Color(0xFFF5D0E0);
  static const Color roseGoldDark = Color(0xFFD4749A);
  
  /// Platinum - Subtle luxury
  static const Color platinum = Color(0xFFE5E4E2);
  static const Color platinumDark = Color(0xFFC0C0C0);

  // ============================================
  // ACCENT COLORS
  // ============================================
  
  static const Color accent = Color(0xFFD4AF37); // Gold as primary accent
  static const Color accentLight = Color(0xFFE8D48B);
  static const Color accentDark = Color(0xFFB8960C);

  // Tertiary - Teal Emerald
  static const Color tertiary = Color(0xFF14B8A6);
  static const Color tertiaryLight = Color(0xFF2DD4BF);
  static const Color tertiaryDark = Color(0xFF0D9488);

  // ============================================
  // NEUTRAL COLORS
  // ============================================
  
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  
  // Grey scale
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // ============================================
  // SEMANTIC COLORS
  // ============================================
  
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color successDark = Color(0xFF16A34A);
  
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFFD97706);
  
  static const Color error = Color(0xFFF43F5E);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorDark = Color(0xFFE11D48);
  
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);
  static const Color infoDark = Color(0xFF2563EB);

  // ============================================
  // LIGHT THEME COLORS
  // ============================================
  
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFF1F5F9);
  static const Color border = Color(0xFFE2E8F0);
  
  // Light theme text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFF9CA3AF);

  // ============================================
  // DARK THEME COLORS - LUXURY PREMIUM
  // ============================================
  
  /// Deep obsidian background for luxury look
  static const Color backgroundDark = Color(0xFF0A0A12);
  
  /// Secondary background with subtle purple tint
  static const Color backgroundDarkSecondary = Color(0xFF0E0E18);
  
  /// Dark surface for cards and containers
  static const Color surfaceDark = Color(0xFF151520);
  
  /// Elevated surface for modals and dropdowns
  static const Color surfaceElevatedDark = Color(0xFF1C1C2D);
  
  /// Premium surface with subtle shimmer
  static const Color surfacePremiumDark = Color(0xFF1A1A2E);
  
  /// Subtle border for dark theme
  static const Color borderDark = Color(0xFF252538);
  
  /// Lighter border for hover states
  static const Color borderLightDark = Color(0xFF353550);
  
  /// Gold accent border for premium elements
  static const Color borderGold = Color(0x40D4AF37);
  
  // Dark theme text
  static const Color textPrimaryDark = Color(0xFFFAFAFA);
  static const Color textSecondaryDark = Color(0xFFA1A1AA);
  static const Color textTertiaryDark = Color(0xFF71717A);
  static const Color textMutedDark = Color(0xFF52525B);
  
  /// Gold text for luxury highlights
  static const Color textGold = Color(0xFFD4AF37);

  // ============================================
  // LUXURY GRADIENTS
  // ============================================
  
  /// Primary gradient - Royal Purple to Deep Violet (main CTA buttons)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF9333EA), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Primary gradient vertical
  static const LinearGradient primaryGradientVertical = LinearGradient(
    colors: [Color(0xFF9333EA), Color(0xFF6366F1)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  /// Luxury Gold gradient - Champagne to Gold (premium elements)
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFE8D48B), Color(0xFFD4AF37), Color(0xFFB8960C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Rose Gold gradient - Elegant feminine luxury
  static const LinearGradient roseGoldGradient = LinearGradient(
    colors: [Color(0xFFF5D0E0), Color(0xFFE8A0BF), Color(0xFFD4749A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Platinum gradient - Subtle luxury shimmer
  static const LinearGradient platinumGradient = LinearGradient(
    colors: [Color(0xFFE5E4E2), Color(0xFFC0C0C0), Color(0xFFE5E4E2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Sunset gradient - Rose to Amber (special offers, promotions)
  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFEC4899), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Ocean gradient - Teal to Indigo (info, secondary actions)
  static const LinearGradient oceanGradient = LinearGradient(
    colors: [Color(0xFF14B8A6), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Energy gradient - Emerald to Teal (success, check-in)
  static const LinearGradient energyGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF14B8A6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Magical Aurora gradient - Multi-color premium effect
  static const LinearGradient auroraGradient = LinearGradient(
    colors: [
      Color(0xFF9333EA),
      Color(0xFF6366F1),
      Color(0xFF14B8A6),
      Color(0xFFD4AF37),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.33, 0.66, 1.0],
  );
  
  /// Mystic Purple gradient - Deep immersive purple
  static const LinearGradient mysticGradient = LinearGradient(
    colors: [Color(0xFF581C87), Color(0xFF7E22CE), Color(0xFF9333EA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dark card gradient with depth
  static const LinearGradient cardGradientDark = LinearGradient(
    colors: [Color(0xFF151520), Color(0xFF1C1C2D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Premium card gradient with gold hint
  static const LinearGradient cardGradientPremium = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF252542), Color(0xFF1A1A2E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Premium subscription gradient (for subscription cards)
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFF9333EA), Color(0xFFAE5AFF), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// VIP Gold premium gradient
  static const LinearGradient vipGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFE8D48B), Color(0xFFD4AF37)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Background gradient for splash/onboarding - deeper and richer
  static const LinearGradient backgroundGradientDark = LinearGradient(
    colors: [Color(0xFF0A0A12), Color(0xFF0E0E18), Color(0xFF151520)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
  );
  
  /// Radial glow gradient for magical effects
  static const RadialGradient magicalGlowGradient = RadialGradient(
    colors: [
      Color(0x409333EA),
      Color(0x206366F1),
      Color(0x00000000),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // ============================================
  // LUXURY GLASSMORPHISM COLORS
  // ============================================
  
  /// Glass effect white overlay
  static Color glassWhite = Colors.white.withValues(alpha: 0.08);
  static Color glassWhiteStrong = Colors.white.withValues(alpha: 0.12);
  static Color glassWhiteLight = Colors.white.withValues(alpha: 0.04);
  
  /// Glass with purple tint for luxury
  static Color glassPurple = const Color(0xFF9333EA).withValues(alpha: 0.08);
  static Color glassPurpleStrong = const Color(0xFF9333EA).withValues(alpha: 0.15);
  
  /// Glass with gold tint for premium
  static Color glassGold = const Color(0xFFD4AF37).withValues(alpha: 0.08);
  static Color glassGoldStrong = const Color(0xFFD4AF37).withValues(alpha: 0.12);
  
  /// Glass border colors
  static Color glassBorder = Colors.white.withValues(alpha: 0.15);
  static Color glassBorderLight = Colors.white.withValues(alpha: 0.08);
  static Color glassBorderStrong = Colors.white.withValues(alpha: 0.25);
  
  /// Gold glass border for premium elements
  static Color glassBorderGold = const Color(0xFFD4AF37).withValues(alpha: 0.3);
  
  /// Glass overlay for modals
  static Color glassOverlay = Colors.black.withValues(alpha: 0.6);
  static Color glassOverlayLight = Colors.black.withValues(alpha: 0.4);

  // ============================================
  // LUXURY GLOW / SHADOW COLORS
  // ============================================
  
  /// Primary glow for buttons and active elements
  static Color primaryGlow = const Color(0xFF9333EA).withValues(alpha: 0.4);
  static Color primaryGlowStrong = const Color(0xFF9333EA).withValues(alpha: 0.6);
  static Color primaryGlowLight = const Color(0xFF9333EA).withValues(alpha: 0.2);
  static Color primaryGlowSubtle = const Color(0xFF9333EA).withValues(alpha: 0.1);
  
  /// Secondary glow
  static Color secondaryGlow = const Color(0xFF6366F1).withValues(alpha: 0.4);
  
  /// Gold glow for premium elements
  static Color goldGlow = const Color(0xFFD4AF37).withValues(alpha: 0.4);
  static Color goldGlowStrong = const Color(0xFFD4AF37).withValues(alpha: 0.6);
  static Color goldGlowLight = const Color(0xFFD4AF37).withValues(alpha: 0.2);
  
  /// Rose gold glow
  static Color roseGoldGlow = const Color(0xFFE8A0BF).withValues(alpha: 0.4);
  
  /// Success glow (for check-in success, etc.)
  static Color successGlow = const Color(0xFF10B981).withValues(alpha: 0.4);
  
  /// Error glow
  static Color errorGlow = const Color(0xFFEF4444).withValues(alpha: 0.4);
  
  /// Warning glow
  static Color warningGlow = const Color(0xFFF59E0B).withValues(alpha: 0.4);

  /// Card shadow for dark theme - deeper
  static Color cardShadowDark = Colors.black.withValues(alpha: 0.4);
  
  /// Premium card shadow with purple tint
  static Color cardShadowPremium = const Color(0xFF9333EA).withValues(alpha: 0.15);

  // ============================================
  // GYM-SPECIFIC COLORS
  // ============================================
  
  /// Gym open status
  static const Color gymOpen = Color(0xFF22C55E);
  
  /// Gym closed status
  static const Color gymClosed = Color(0xFFF43F5E);
  
  /// Gym busy status
  static const Color gymBusy = Color(0xFFF59E0B);
  
  /// Gym moderate crowd
  static const Color gymModerate = Color(0xFF3B82F6);
  
  /// Gym low crowd
  static const Color gymLow = Color(0xFF22C55E);

  // ============================================
  // SUBSCRIPTION TIER COLORS - LUXURY
  // ============================================
  
  /// Basic tier - Silver
  static const Color tierBasic = Color(0xFF9CA3AF);
  
  /// Plus tier - Royal Purple
  static const Color tierPlus = Color(0xFF9333EA);
  
  /// Premium tier - Gold
  static const Color tierPremium = Color(0xFFD4AF37);
  
  /// VIP tier - Rose Gold
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

  /// Create gradient from two colors
  static LinearGradient createGradient(Color start, Color end) {
    return LinearGradient(
      colors: [start, end],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  /// Create luxury gradient with three colors
  static LinearGradient createLuxuryGradient(Color start, Color middle, Color end) {
    return LinearGradient(
      colors: [start, middle, end],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: const [0.0, 0.5, 1.0],
    );
  }
  
  /// Create radial glow gradient
  static RadialGradient createGlowGradient(Color color, {double intensity = 0.4}) {
    return RadialGradient(
      colors: [
        color.withValues(alpha: intensity),
        color.withValues(alpha: intensity * 0.5),
        Colors.transparent,
      ],
      stops: const [0.0, 0.5, 1.0],
    );
  }
  
  /// Get shimmer gradient for loading effects
  static LinearGradient get shimmerGradient => LinearGradient(
    colors: [
      Colors.white.withValues(alpha: 0.0),
      Colors.white.withValues(alpha: 0.1),
      Colors.white.withValues(alpha: 0.0),
    ],
    stops: const [0.0, 0.5, 1.0],
    begin: const Alignment(-1.0, 0.0),
    end: const Alignment(1.0, 0.0),
  );
  
  /// Get gold shimmer gradient for premium elements
  static LinearGradient get goldShimmerGradient => LinearGradient(
    colors: [
      goldShimmer.withValues(alpha: 0.0),
      goldShimmer.withValues(alpha: 0.3),
      goldShimmer.withValues(alpha: 0.0),
    ],
    stops: const [0.0, 0.5, 1.0],
    begin: const Alignment(-1.0, 0.0),
    end: const Alignment(1.0, 0.0),
  );
}