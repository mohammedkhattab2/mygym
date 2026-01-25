import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../features/settings/domain/entities/app_settings.dart';
import '../../../features/settings/domain/repositories/settings_repository.dart';

/// Theme state for the application
class ThemeState {
  final AppThemeMode themeMode;
  final ThemeMode flutterThemeMode;
  final bool isLoading;

  const ThemeState({
    required this.themeMode,
    required this.flutterThemeMode,
    this.isLoading = false,
  });

  factory ThemeState.initial() => const ThemeState(
        themeMode: AppThemeMode.system,
        flutterThemeMode: ThemeMode.system,
      );

  ThemeState copyWith({
    AppThemeMode? themeMode,
    ThemeMode? flutterThemeMode,
    bool? isLoading,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      flutterThemeMode: flutterThemeMode ?? this.flutterThemeMode,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Global theme cubit for managing app theme state
/// 
/// This cubit follows MVVM pattern and handles:
/// - Loading saved theme preference
/// - Switching between Light, Dark, and System themes
/// - Persisting theme changes
@lazySingleton
class ThemeCubit extends Cubit<ThemeState> {
  final SettingsRepository _settingsRepository;

  ThemeCubit(this._settingsRepository) : super(ThemeState.initial()) {
    _loadTheme();
  }

  /// Load saved theme preference from storage
  Future<void> _loadTheme() async {
    emit(state.copyWith(isLoading: true));
    try {
      final settings = await _settingsRepository.loadSettings();
      final flutterMode = _convertToFlutterThemeMode(settings.themeMode);
      emit(state.copyWith(
        themeMode: settings.themeMode,
        flutterThemeMode: flutterMode,
        isLoading: false,
      ));
    } catch (e) {
      // On error, keep default system theme
      emit(state.copyWith(isLoading: false));
    }
  }

  /// Change theme mode and persist the change
  Future<void> setTheme(AppThemeMode mode) async {
    final flutterMode = _convertToFlutterThemeMode(mode);
    
    // Emit immediately for responsive UI
    emit(state.copyWith(
      themeMode: mode,
      flutterThemeMode: flutterMode,
    ));

    // Persist to storage
    try {
      final currentSettings = await _settingsRepository.loadSettings();
      final updatedSettings = currentSettings.copyWith(themeMode: mode);
      await _settingsRepository.saveSettings(updatedSettings);
    } catch (e) {
      // Silent fail for persistence - UI already updated
    }
  }

  /// Set light theme
  void setLightTheme() => setTheme(AppThemeMode.light);

  /// Set dark theme
  void setDarkTheme() => setTheme(AppThemeMode.dark);

  /// Set system theme
  void setSystemTheme() => setTheme(AppThemeMode.system);

  /// Toggle between light and dark (ignoring system)
  void toggleTheme() {
    if (state.themeMode == AppThemeMode.dark) {
      setLightTheme();
    } else {
      setDarkTheme();
    }
  }

  /// Convert AppThemeMode to Flutter's ThemeMode
  ThemeMode _convertToFlutterThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  /// Check if current theme is dark (considering system)
  bool isDarkMode(BuildContext context) {
    if (state.themeMode == AppThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return state.themeMode == AppThemeMode.dark;
  }
}