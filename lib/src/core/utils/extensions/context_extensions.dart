import 'package:flutter/material.dart';

/// Extension methods on BuildContext
extension ContextExtensions on BuildContext {
  /// Get the current theme
  ThemeData get theme => Theme.of(this);

  /// Get the current text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Get the current color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get the current media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get the screen size
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Get the screen width
  double get screenWidth => screenSize.width;

  /// Get the screen height
  double get screenHeight => screenSize.height;

  /// Check if the device is in landscape mode
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  /// Check if the device is in portrait mode
  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;

  /// Check if device is mobile (width < 600)
  bool get isMobile => screenWidth < 600;

  /// Check if device is tablet (600 <= width < 1200)
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;

  /// Check if device is desktop (width >= 1200)
  bool get isDesktop => screenWidth >= 1200;

  /// Get padding for safe area
  EdgeInsets get padding => mediaQuery.padding;

  /// Get view insets (keyboard, etc.)
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  /// Show a snackbar
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Show an error snackbar
  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: colorScheme.error,
    );
  }

  /// Show a success snackbar
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.green,
    );
  }

  /// Hide the current snackbar
  void hideSnackBar() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
  }

  /// Unfocus any focused widget
  void unfocus() {
    FocusScope.of(this).unfocus();
  }

  /// Pop the current route
  void pop<T>([T? result]) {
    Navigator.of(this).pop(result);
  }

  /// Check if can pop
  bool get canPop => Navigator.of(this).canPop();
}