import 'package:mygym/src/features/profile/domain/entities/user_profile.dart';
import 'package:mygym/src/features/settings/domain/entities/app_settings.dart';

abstract class SettingsRepository {
  Future<AppSettings> loadSettings();
  Future<void> saveSettings(AppSettings settings);
  Future<NotificationPreferences> loadNotificationPreferences();
  Future<void> saveNotificationPreferences(NotificationPreferences preferences);
}
