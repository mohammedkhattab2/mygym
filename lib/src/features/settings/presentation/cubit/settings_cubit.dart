import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mygym/src/features/profile/domain/entities/user_profile.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsState {
  final AppSettings appSettings;
  final NotificationPreferences notificationPreferences;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;

  const SettingsState({
    required this.appSettings,
    required this.notificationPreferences,
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
  });

  SettingsState copyWith({
    AppSettings? appSettings,
    NotificationPreferences? notificationPreferences,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
  }) {
    return SettingsState(
      appSettings: appSettings ?? this.appSettings,
      notificationPreferences:
          notificationPreferences ?? this.notificationPreferences,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
    );
  }

  factory SettingsState.initial() => SettingsState(
        appSettings: const AppSettings(),
        notificationPreferences: const NotificationPreferences(),
      );
}

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _repository;

  SettingsCubit(this._repository) : super(SettingsState.initial()) {
    _loadAll();
  }

  Future<void> _loadAll() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final settings = await _repository.loadSettings();
      final notif = await _repository.loadNotificationPreferences();
      emit(
        state.copyWith(
          appSettings: settings,
          notificationPreferences: notif,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // ============ AppSettings actions ============

  Future<void> changeLanguage(AppLanguage language) async {
    final updated =
        state.appSettings.copyWith(language: language);
    await _saveAppSettings(updated);
  }

  Future<void> changeTheme(AppThemeMode mode) async {
    final updated = state.appSettings.copyWith(themeMode: mode);
    await _saveAppSettings(updated);
  }

  Future<void> changeMeasurementUnit(MeasurementUnit unit) async {
    final updated =
        state.appSettings.copyWith(measurementUnit: unit);
    await _saveAppSettings(updated);
  }

  Future<void> toggleBiometric(bool enabled) async {
    final updated =
        state.appSettings.copyWith(biometricEnabled: enabled);
    await _saveAppSettings(updated);
  }

  Future<void> _saveAppSettings(AppSettings updated) async {
    emit(
      state.copyWith(
        appSettings: updated,
        isSaving: true,
        errorMessage: null,
      ),
    );
    try {
      await _repository.saveSettings(updated);
      emit(state.copyWith(isSaving: false));
    } catch (e) {
      emit(
        state.copyWith(
          isSaving: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // ============ NotificationPreferences actions ============

  Future<void> updateNotificationPreferences(
      NotificationPreferences prefs) async {
    emit(
      state.copyWith(
        notificationPreferences: prefs,
        isSaving: true,
        errorMessage: null,
      ),
    );
    try {
      await _repository.saveNotificationPreferences(prefs);
      emit(state.copyWith(isSaving: false));
    } catch (e) {
      emit(
        state.copyWith(
          isSaving: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}