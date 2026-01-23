import 'package:injectable/injectable.dart';
import 'package:mygym/src/features/profile/domain/entities/user_profile.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _local;

  SettingsRepositoryImpl(this._local);

  @override
  Future<AppSettings> loadSettings() {
    return _local.loadSettings();
  }

  @override
  Future<void> saveSettings(AppSettings settings) {
    return _local.saveSettings(settings);
  }

  @override
  Future<NotificationPreferences> loadNotificationPreferences() {
    return _local.loadNotificationPreferences();
  }

  @override
  Future<void> saveNotificationPreferences(
    NotificationPreferences preferences,
  ) {
    return _local.saveNotificationPreferences(preferences);
  }
}