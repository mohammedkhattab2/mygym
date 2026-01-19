import 'package:flutter/material.dart';

/// Application color palette - Premium Dark Theme Design System
class AppColors {
  AppColors._();

  // ============================================
  // PRIMARY COLORS
  // ============================================
  
  /// Electric Purple - Main brand color
  static const Color primary = Color(0xFF8B5CF6);
  static const Color primaryLight = Color(0xFFA78BFA);
  static const Color primaryDark = Color(0xFF7C3AED);

  // ============================================
  // SECONDARY COLORS
  // ============================================
  
  /// Neon Blue - Secondary brand color
  static const Color secondary = Color(0xFF3B82F6);
  static const Color secondaryLight = Color(0xFF60A5FA);
  static const Color secondaryDark = Color(0xFF2563EB);

  // ============================================
  // ACCENT COLORS
  // ============================================
  
  static const Color accent = Color(0xFFF59E0B);
  static const Color accentLight = Color(0xFFFBBF24);
  static const Color accentDark = Color(0xFFD97706);

  // Tertiary - Cyan
  static const Color tertiary = Color(0xFF06B6D4);
  static const Color tertiaryLight = Color(0xFF22D3EE);
  static const Color tertiaryDark = Color(0xFF0891B2);

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
  // DARK THEME COLORS - PREMIUM
  // ============================================
  
  /// Deep dark background for premium look
  static const Color backgroundDark = Color(0xFF0F0F1A);
  
  /// Dark surface for cards and containers
  static const Color surfaceDark = Color(0xFF1A1A2E);
  
  /// Elevated surface for modals and dropdowns
  static const Color surfaceElevatedDark = Color(0xFF252542);
  
  /// Subtle border for dark theme
  static const Color borderDark = Color(0xFF2D2D4A);
  
  /// Lighter border for hover states
  static const Color borderLightDark = Color(0xFF3D3D5C);
  
  // Dark theme text
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color textTertiaryDark = Color(0xFF6B7280);
  static const Color textMutedDark = Color(0xFF4B5563);

  // ============================================
  // GRADIENTS
  // ============================================
  
  /// Primary gradient - Purple to Blue (main CTA buttons)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Primary gradient vertical
  static const LinearGradient primaryGradientVertical = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Sunset gradient - Rose to Amber (special offers, promotions)
  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFF43F5E), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Ocean gradient - Cyan to Blue (info, secondary actions)
  static const LinearGradient oceanGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Energy gradient - Green to Cyan (success, check-in)
  static const LinearGradient energyGradient = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dark card gradient
  static const LinearGradient cardGradientDark = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF252542)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Premium card gradient (for subscription cards)
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFA855F7), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Background gradient for splash/onboarding
  static const LinearGradient backgroundGradientDark = LinearGradient(
    colors: [Color(0xFF0F0F1A), Color(0xFF1A1A2E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ============================================
  // GLASSMORPHISM COLORS
  // ============================================
  
  /// Glass effect white overlay
  static Color glassWhite = Colors.white.withValues(alpha: 0.1);
  static Color glassWhiteStrong = Colors.white.withValues(alpha: 0.15);
  static Color glassWhiteLight = Colors.white.withValues(alpha: 0.05);
  
  /// Glass border colors
  static Color glassBorder = Colors.white.withValues(alpha: 0.2);
  static Color glassBorderLight = Colors.white.withValues(alpha: 0.1);
  static Color glassBorderStrong = Colors.white.withValues(alpha: 0.3);
  
  /// Glass overlay for modals
  static Color glassOverlay = Colors.black.withValues(alpha: 0.5);
  static Color glassOverlayLight = Colors.black.withValues(alpha: 0.3);

  // ============================================
  // GLOW / SHADOW COLORS
  // ============================================
  
  /// Primary glow for buttons and active elements
  static Color primaryGlow = const Color(0xFF8B5CF6).withValues(alpha: 0.4);
  static Color primaryGlowStrong = const Color(0xFF8B5CF6).withValues(alpha: 0.6);
  static Color primaryGlowLight = const Color(0xFF8B5CF6).withValues(alpha: 0.2);
  
  /// Secondary glow
  static Color secondaryGlow = const Color(0xFF3B82F6).withValues(alpha: 0.4);
  
  /// Success glow (for check-in success, etc.)
  static Color successGlow = const Color(0xFF22C55E).withValues(alpha: 0.4);
  
  /// Error glow
  static Color errorGlow = const Color(0xFFF43F5E).withValues(alpha: 0.4);
  
  /// Warning glow
  static Color warningGlow = const Color(0xFFF59E0B).withValues(alpha: 0.4);

  /// Card shadow for dark theme
  static Color cardShadowDark = Colors.black.withValues(alpha: 0.3);

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
  // SUBSCRIPTION TIER COLORS
  // ============================================
  
  /// Basic tier
  static const Color tierBasic = Color(0xFF6B7280);
  
  /// Plus tier
  static const Color tierPlus = Color(0xFF3B82F6);
  
  /// Premium tier
  static const Color tierPremium = Color(0xFF8B5CF6);

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
}