import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';
import 'luxury_theme_extension.dart';

/// Application Theme Configuration - Premium Elegant Design
///
/// Features:
/// - Deep charcoal backgrounds for calm, luxurious feel
/// - High contrast text for excellent readability
/// - Minimal accent usage for refined elegance
/// - Clean visual hierarchy without animations
class AppTheme {
  AppTheme._();

  // ============================================
  // STATIC CONSTANTS
  // ============================================
  
  static const double kBorderRadiusSmall = 8.0;
  static const double kBorderRadiusMedium = 12.0;
  static const double kBorderRadiusLarge = 16.0;
  static const double kBorderRadiusXLarge = 20.0;
  static const double kBorderRadiusXXLarge = 24.0;
  static const double kBorderRadiusRound = 100.0;

  static const double kButtonHeight = 52.0;
  static const double kButtonHeightSmall = 40.0;
  static const double kButtonHeightLarge = 56.0;
  static const double kInputHeight = 52.0;
  
  // ============================================
  // RESPONSIVE GETTERS
  // ============================================
  
  static double get borderRadiusSmall => 8.r;
  static double get borderRadiusMedium => 12.r;
  static double get borderRadiusLarge => 16.r;
  static double get borderRadiusXLarge => 20.r;
  static double get borderRadiusXXLarge => 24.r;
  static double get borderRadiusRound => 100.r;

  static double get buttonHeight => 52.h;
  static double get buttonHeightSmall => 40.h;
  static double get buttonHeightLarge => 56.h;
  static double get inputHeight => 52.h;
  
  static double get spacingXS => 4.w;
  static double get spacingS => 8.w;
  static double get spacingM => 16.w;
  static double get spacingL => 24.w;
  static double get spacingXL => 32.w;
  static double get spacingXXL => 48.w;
  
  static double get spacingXSV => 4.h;
  static double get spacingSV => 8.h;
  static double get spacingMV => 16.h;
  static double get spacingLV => 24.h;
  static double get spacingXLV => 32.h;
  static double get spacingXXLV => 48.h;

  // ============================================
  // LIGHT THEME
  // ============================================
  
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          primaryContainer: AppColors.primaryLight,
          secondary: AppColors.secondary,
          secondaryContainer: AppColors.secondaryLight,
          tertiary: AppColors.tertiary,
          tertiaryContainer: AppColors.tertiaryLight,
          surface: AppColors.surface,
          error: AppColors.error,
          errorContainer: AppColors.errorLight,
          onPrimary: AppColors.white,
          onSecondary: AppColors.white,
          onTertiary: AppColors.white,
          onSurface: AppColors.textPrimary,
          onError: AppColors.white,
          outline: AppColors.border,
        ),
        fontFamily: AppTextStyles.fontFamily,
        textTheme: _textTheme,
        appBarTheme: _appBarTheme,
        elevatedButtonTheme: _elevatedButtonTheme,
        outlinedButtonTheme: _outlinedButtonTheme,
        textButtonTheme: _textButtonTheme,
        inputDecorationTheme: _inputDecorationTheme,
        cardTheme: _cardTheme,
        bottomNavigationBarTheme: _bottomNavigationBarTheme,
        navigationBarTheme: _navigationBarTheme,
        chipTheme: _chipTheme,
        dialogTheme: _dialogTheme,
        bottomSheetTheme: _bottomSheetTheme,
        dividerTheme: const DividerThemeData(
          color: AppColors.border,
          thickness: 1,
          space: 1,
        ),
        snackBarTheme: _snackBarTheme,
        floatingActionButtonTheme: _fabTheme,
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: 24,
        ),
        listTileTheme: _listTileTheme,
        switchTheme: _switchTheme,
        checkboxTheme: _checkboxTheme,
        radioTheme: _radioTheme,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primary,
          linearTrackColor: AppColors.grey200,
        ),
        sliderTheme: _sliderTheme,
        tabBarTheme: _tabBarTheme,
        tooltipTheme: _tooltipTheme,
        extensions: [LuxuryThemeExtension.light],
      );

  // ============================================
  // DARK THEME - PREMIUM CHARCOAL
  // ============================================
  
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          primaryContainer: AppColors.primaryDark,
          secondary: AppColors.secondary,
          secondaryContainer: AppColors.secondaryDark,
          tertiary: AppColors.gold,
          tertiaryContainer: AppColors.goldDark,
          surface: AppColors.surfaceDark,
          surfaceContainerHighest: AppColors.surfaceElevatedDark,
          error: AppColors.error,
          errorContainer: AppColors.errorDark,
          onPrimary: AppColors.white,
          onSecondary: AppColors.white,
          onTertiary: AppColors.backgroundDark,
          onSurface: AppColors.textPrimaryDark,
          onSurfaceVariant: AppColors.textSecondaryDark,
          onError: AppColors.white,
          outline: AppColors.borderDark,
          outlineVariant: AppColors.borderLightDark,
          shadow: AppColors.black,
        ),
        fontFamily: AppTextStyles.fontFamily,
        textTheme: _textThemeDark,
        appBarTheme: _appBarThemeDark,
        elevatedButtonTheme: _elevatedButtonThemeDark,
        outlinedButtonTheme: _outlinedButtonThemeDark,
        textButtonTheme: _textButtonThemeDark,
        inputDecorationTheme: _inputDecorationThemeDark,
        cardTheme: _cardThemeDark,
        bottomNavigationBarTheme: _bottomNavigationBarThemeDark,
        navigationBarTheme: _navigationBarThemeDark,
        chipTheme: _chipThemeDark,
        dialogTheme: _dialogThemeDark,
        bottomSheetTheme: _bottomSheetThemeDark,
        dividerTheme: const DividerThemeData(
          color: AppColors.borderDark,
          thickness: 1,
          space: 1,
        ),
        snackBarTheme: _snackBarThemeDark,
        floatingActionButtonTheme: _fabThemeDark,
        iconTheme: const IconThemeData(
          color: AppColors.textPrimaryDark,
          size: 24,
        ),
        listTileTheme: _listTileThemeDark,
        switchTheme: _switchThemeDark,
        checkboxTheme: _checkboxThemeDark,
        radioTheme: _radioThemeDark,
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: AppColors.primary,
          linearTrackColor: AppColors.borderDark,
        ),
        sliderTheme: _sliderThemeDark,
        tabBarTheme: _tabBarThemeDark,
        tooltipTheme: _tooltipThemeDark,
        extensions: [LuxuryThemeExtension.dark],
      );

  // ============================================
  // TEXT THEMES
  // ============================================
  
  static TextTheme get _textTheme => TextTheme(
    displayLarge: AppTextStyles.displayLarge,
    displayMedium: AppTextStyles.displayMedium,
    displaySmall: AppTextStyles.displaySmall,
    headlineLarge: AppTextStyles.headlineLarge,
    headlineMedium: AppTextStyles.headlineMedium,
    headlineSmall: AppTextStyles.headlineSmall,
    titleLarge: AppTextStyles.titleLarge,
    titleMedium: AppTextStyles.titleMedium,
    titleSmall: AppTextStyles.titleSmall,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodyMedium,
    bodySmall: AppTextStyles.bodySmall,
    labelLarge: AppTextStyles.labelLarge,
    labelMedium: AppTextStyles.labelMedium,
    labelSmall: AppTextStyles.labelSmall,
  );

  static TextTheme get _textThemeDark => TextTheme(
    displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColors.textPrimaryDark),
    displayMedium: AppTextStyles.displayMedium.copyWith(color: AppColors.textPrimaryDark),
    displaySmall: AppTextStyles.displaySmall.copyWith(color: AppColors.textPrimaryDark),
    headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColors.textPrimaryDark),
    headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimaryDark),
    headlineSmall: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimaryDark),
    titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimaryDark),
    titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimaryDark),
    titleSmall: AppTextStyles.titleSmall.copyWith(color: AppColors.textPrimaryDark),
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimaryDark),
    bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimaryDark),
    bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryDark),
    labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimaryDark),
    labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimaryDark),
    labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondaryDark),
  );

  // ============================================
  // APP BAR THEME
  // ============================================
  
  static AppBarTheme get _appBarTheme => AppBarTheme(
    backgroundColor: AppColors.surface,
    foregroundColor: AppColors.textPrimary,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    titleTextStyle: AppTextStyles.titleLarge,
    iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 24),
  );

  static AppBarTheme get _appBarThemeDark => AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.textPrimaryDark,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    titleTextStyle: AppTextStyles.titleLarge.copyWith(
      color: AppColors.textPrimaryDark,
      fontWeight: FontWeight.w600,
    ),
    iconTheme: const IconThemeData(color: AppColors.textPrimaryDark, size: 24),
  );

  // ============================================
  // ELEVATED BUTTON THEME
  // ============================================
  
  static ElevatedButtonThemeData get _elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.grey300,
          disabledForegroundColor: AppColors.grey500,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(double.infinity, kButtonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          ),
          textStyle: AppTextStyles.button,
        ),
      );

  static ElevatedButtonThemeData get _elevatedButtonThemeDark =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.grey700,
          disabledForegroundColor: AppColors.grey500,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(double.infinity, kButtonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          ),
          textStyle: AppTextStyles.button,
        ),
      );

  // ============================================
  // OUTLINED BUTTON THEME
  // ============================================
  
  static OutlinedButtonThemeData get _outlinedButtonTheme =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.grey400,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(double.infinity, kButtonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          ),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
        ),
      );

  static OutlinedButtonThemeData get _outlinedButtonThemeDark =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.grey600,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(double.infinity, kButtonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          ),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
        ),
      );

  // ============================================
  // TEXT BUTTON THEME
  // ============================================
  
  static TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: AppTextStyles.buttonText,
        ),
      );

  static TextButtonThemeData get _textButtonThemeDark => TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: AppTextStyles.buttonText,
        ),
      );

  // ============================================
  // INPUT DECORATION THEME
  // ============================================
  
  static InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        hintStyle: AppTextStyles.inputHint,
        labelStyle: AppTextStyles.inputLabel,
        errorStyle: AppTextStyles.inputError,
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
      );

  static InputDecorationTheme get _inputDecorationThemeDark =>
      InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevatedDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          borderSide: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          borderSide: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        hintStyle: AppTextStyles.inputHint.copyWith(color: AppColors.textTertiaryDark),
        labelStyle: AppTextStyles.inputLabel.copyWith(color: AppColors.textSecondaryDark),
        errorStyle: AppTextStyles.inputError,
        prefixIconColor: AppColors.textSecondaryDark,
        suffixIconColor: AppColors.textSecondaryDark,
      );

  // ============================================
  // CARD THEME
  // ============================================
  
  static CardThemeData get _cardTheme => CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      );

  static CardThemeData get _cardThemeDark => CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
        margin: EdgeInsets.zero,
      );

  // ============================================
  // BOTTOM NAVIGATION BAR THEME
  // ============================================
  
  static BottomNavigationBarThemeData get _bottomNavigationBarTheme =>
      BottomNavigationBarThemeData(
    backgroundColor: AppColors.surface,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.textSecondary,
    type: BottomNavigationBarType.fixed,
    elevation: 0,
    selectedLabelStyle: AppTextStyles.labelSmall,
    unselectedLabelStyle: AppTextStyles.labelSmall,
    showSelectedLabels: true,
    showUnselectedLabels: true,
  );

  static BottomNavigationBarThemeData get _bottomNavigationBarThemeDark =>
      BottomNavigationBarThemeData(
    backgroundColor: AppColors.surfaceDark,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.textSecondaryDark,
    type: BottomNavigationBarType.fixed,
    elevation: 0,
    selectedLabelStyle: AppTextStyles.labelSmall,
    unselectedLabelStyle: AppTextStyles.labelSmall,
    showSelectedLabels: true,
    showUnselectedLabels: true,
  );

  // ============================================
  // NAVIGATION BAR THEME
  // ============================================
  
  static NavigationBarThemeData get _navigationBarTheme => NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryLight.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600);
          }
          return AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.textSecondary, size: 24);
        }),
        elevation: 0,
        height: 72,
      );

  static NavigationBarThemeData get _navigationBarThemeDark => NavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        indicatorColor: AppColors.primary.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600);
          }
          return AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondaryDark);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.textSecondaryDark, size: 24);
        }),
        elevation: 0,
        height: 72,
      );

  // ============================================
  // CHIP THEME
  // ============================================
  
  static ChipThemeData get _chipTheme => ChipThemeData(
        backgroundColor: AppColors.grey100,
        selectedColor: AppColors.primary,
        disabledColor: AppColors.grey200,
        labelStyle: AppTextStyles.labelMedium,
        secondaryLabelStyle: AppTextStyles.labelMedium.copyWith(color: AppColors.white),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusRound),
        ),
        side: BorderSide.none,
      );

  static ChipThemeData get _chipThemeDark => ChipThemeData(
        backgroundColor: AppColors.surfaceElevatedDark,
        selectedColor: AppColors.primary,
        disabledColor: AppColors.grey700,
        labelStyle: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimaryDark),
        secondaryLabelStyle: AppTextStyles.labelMedium.copyWith(color: AppColors.white),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusRound),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
        side: const BorderSide(color: AppColors.borderDark, width: 1),
      );

  // ============================================
  // DIALOG THEME
  // ============================================
  
  static DialogThemeData get _dialogTheme => DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusXLarge),
        ),
        titleTextStyle: AppTextStyles.titleLarge,
        contentTextStyle: AppTextStyles.bodyMedium,
      );

  static DialogThemeData get _dialogThemeDark => DialogThemeData(
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusXLarge),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimaryDark),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondaryDark),
      );

  // ============================================
  // BOTTOM SHEET THEME
  // ============================================
  
  static BottomSheetThemeData get _bottomSheetTheme => BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(kBorderRadiusXLarge),
          ),
        ),
        dragHandleColor: AppColors.grey300,
        dragHandleSize: const Size(40, 4),
      );

  static BottomSheetThemeData get _bottomSheetThemeDark => BottomSheetThemeData(
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(kBorderRadiusXLarge),
          ),
        ),
        dragHandleColor: AppColors.grey600,
        dragHandleSize: const Size(40, 4),
      );

  // ============================================
  // SNACKBAR THEME
  // ============================================
  
  static SnackBarThemeData get _snackBarTheme => SnackBarThemeData(
        backgroundColor: AppColors.grey800,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusMedium),
        ),
        elevation: 0,
      );

  static SnackBarThemeData get _snackBarThemeDark => SnackBarThemeData(
        backgroundColor: AppColors.surfaceElevatedDark,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimaryDark),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusMedium),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
        elevation: 0,
      );

  // ============================================
  // FAB THEME
  // ============================================
  
  static FloatingActionButtonThemeData get _fabTheme => FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
        ),
      );

  static FloatingActionButtonThemeData get _fabThemeDark => FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
        ),
      );

  // ============================================
  // LIST TILE THEME
  // ============================================
  
  static ListTileThemeData get _listTileTheme => ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusMedium),
        ),
        tileColor: Colors.transparent,
        selectedTileColor: AppColors.primaryLight.withValues(alpha: 0.08),
        iconColor: AppColors.textSecondary,
        textColor: AppColors.textPrimary,
      );

  static ListTileThemeData get _listTileThemeDark => ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusMedium),
        ),
        tileColor: Colors.transparent,
        selectedTileColor: AppColors.primary.withValues(alpha: 0.08),
        iconColor: AppColors.textSecondaryDark,
        textColor: AppColors.textPrimaryDark,
      );

  // ============================================
  // SWITCH THEME
  // ============================================
  
  static SwitchThemeData get _switchTheme => SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.white;
          }
          return AppColors.grey400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.grey200;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      );

  static SwitchThemeData get _switchThemeDark => SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.white;
          }
          return AppColors.grey500;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.surfaceElevatedDark;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return AppColors.borderDark;
        }),
      );

  // ============================================
  // CHECKBOX THEME
  // ============================================
  
  static CheckboxThemeData get _checkboxTheme => CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.white),
        side: const BorderSide(color: AppColors.grey400, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      );

  static CheckboxThemeData get _checkboxThemeDark => CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.white),
        side: const BorderSide(color: AppColors.borderLightDark, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      );

  // ============================================
  // RADIO THEME
  // ============================================
  
  static RadioThemeData get _radioTheme => RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.grey400;
        }),
      );

  static RadioThemeData get _radioThemeDark => RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.borderLightDark;
        }),
      );

  // ============================================
  // SLIDER THEME
  // ============================================
  
  static SliderThemeData get _sliderTheme => SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.grey200,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withValues(alpha: 0.08),
        trackHeight: 4,
      );

  static SliderThemeData get _sliderThemeDark => SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.surfaceElevatedDark,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withValues(alpha: 0.15),
        trackHeight: 4,
      );

  // ============================================
  // TAB BAR THEME
  // ============================================
  
  static TabBarThemeData get _tabBarTheme => TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.labelLarge,
        unselectedLabelStyle: AppTextStyles.labelLarge,
        indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(kBorderRadiusRound),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: AppColors.border,
      );

  static TabBarThemeData get _tabBarThemeDark => TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondaryDark,
        labelStyle: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
        unselectedLabelStyle: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondaryDark),
        indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(kBorderRadiusRound),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: AppColors.borderDark,
      );

  // ============================================
  // TOOLTIP THEME
  // ============================================
  
  static TooltipThemeData get _tooltipTheme => TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.grey800,
          borderRadius: BorderRadius.circular(kBorderRadiusSmall),
        ),
        textStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      );

  static TooltipThemeData get _tooltipThemeDark => TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedDark,
          borderRadius: BorderRadius.circular(kBorderRadiusSmall),
          border: Border.all(color: AppColors.borderDark),
        ),
        textStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimaryDark),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      );

  // ============================================
  // SYSTEM UI STYLES
  // ============================================
  
  static SystemUiOverlayStyle get lightSystemUiOverlayStyle =>
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.surface,
        systemNavigationBarIconBrightness: Brightness.dark,
      );

  static SystemUiOverlayStyle get darkSystemUiOverlayStyle =>
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.backgroundDark,
        systemNavigationBarIconBrightness: Brightness.light,
      );
  
  // ============================================
  // DECORATION HELPERS
  // ============================================
  
  /// Premium card decoration
  static BoxDecoration get premiumCardDecoration => BoxDecoration(
    color: AppColors.surfaceDark,
    borderRadius: BorderRadius.circular(kBorderRadiusLarge),
    border: Border.all(color: AppColors.borderDark, width: 1),
  );
  
  /// Glass card decoration
  static BoxDecoration get glassCardDecoration => BoxDecoration(
    color: AppColors.glassWhite,
    borderRadius: BorderRadius.circular(kBorderRadiusLarge),
    border: Border.all(color: AppColors.glassBorder, width: 1),
  );
}