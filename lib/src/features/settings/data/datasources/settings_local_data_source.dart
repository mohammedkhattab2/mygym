import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:mygym/src/features/profile/domain/entities/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/app_settings.dart';

const _kAppSettingsKey = 'app_settings';
const _kNotificationPrefsKey = 'notification_prefs';

@lazySingleton
class SettingsLocalDataSource {
  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  // ============ AppSettings ============

  Future<AppSettings> loadSettings() async {
    final prefs = await _prefs;
    final jsonString = prefs.getString(_kAppSettingsKey);

    if (jsonString == null) {
      // default
      return const AppSettings();
    }

    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return _appSettingsFromJson(map);
    } catch (_) {
      return const AppSettings();
    }
  }

  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await _prefs;
    final jsonString = jsonEncode(_appSettingsToJson(settings));
    await prefs.setString(_kAppSettingsKey, jsonString);
  }

  // ============ NotificationPreferences ============

  Future<NotificationPreferences> loadNotificationPreferences() async {
    final prefs = await _prefs;
    final jsonString = prefs.getString(_kNotificationPrefsKey);

    if (jsonString == null) {
      return const NotificationPreferences();
    }

    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return _notificationPrefsFromJson(map);
    } catch (_) {
      return const NotificationPreferences();
    }
  }

  Future<void> saveNotificationPreferences(
    NotificationPreferences prefsModel,
  ) async {
    final prefs = await _prefs;
    final jsonString = jsonEncode(_notificationPrefsToJson(prefsModel));
    await prefs.setString(_kNotificationPrefsKey, jsonString);
  }

  // ============ JSON Helpers ============

  Map<String, dynamic> _appSettingsToJson(AppSettings s) {
    return {
      'language': s.language.name,
      'themeMode': s.themeMode.name,
      'biometricEnabled': s.biometricEnabled,
      'analyticsEnabled': s.analyticsEnabled,
      'crashReportingEnabled': s.crashReportingEnabled,
      'measurementUnit': s.measurementUnit.name,
      'currency': {
        'code': s.currency.code,
        'symbol': s.currency.symbol,
        'name': s.currency.name,
        'decimalPlaces': s.currency.decimalPlaces,
      },
    };
  }

  AppSettings _appSettingsFromJson(Map<String, dynamic> json) {
    return AppSettings(
      language: _parseLanguage(json['language'] as String?),
      themeMode: _parseThemeMode(json['themeMode'] as String?),
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
      analyticsEnabled: json['analyticsEnabled'] as bool? ?? true,
      crashReportingEnabled: json['crashReportingEnabled'] as bool? ?? true,
      measurementUnit:
          _parseMeasurementUnit(json['measurementUnit'] as String?),
      currency: _parseCurrency(json['currency'] as Map<String, dynamic>?),
    );
  }

  AppLanguage _parseLanguage(String? name) {
    switch (name) {
      case 'arabic':
        return AppLanguage.arabic;
      case 'english':
      default:
        return AppLanguage.english;
    }
  }

  AppThemeMode _parseThemeMode(String? name) {
    switch (name) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      case 'system':
      default:
        return AppThemeMode.system;
    }
  }

  MeasurementUnit _parseMeasurementUnit(String? name) {
    switch (name) {
      case 'imperial':
        return MeasurementUnit.imperial;
      case 'metric':
      default:
        return MeasurementUnit.metric;
    }
  }

  CurrencySettings _parseCurrency(Map<String, dynamic>? json) {
    if (json == null) return const CurrencySettings();
    return CurrencySettings(
      code: json['code'] as String? ?? 'EGP',
      symbol: json['symbol'] as String? ?? 'E£',
      name: json['name'] as String? ?? 'Egyptian Pound',
      decimalPlaces: json['decimalPlaces'] as int? ?? 2,
    );
  }

  Map<String, dynamic> _notificationPrefsToJson(
      NotificationPreferences p) {
    return {
      'pushEnabled': p.pushEnabled,
      'emailEnabled': p.emailEnabled,
      'smsEnabled': p.smsEnabled,
      'classReminders': p.classReminders,
      'promotionalOffers': p.promotionalOffers,
      'subscriptionAlerts': p.subscriptionAlerts,
      'visitReminders': p.visitReminders,
      'weeklyDigest': p.weeklyDigest,
      'reminderMinutesBefore': p.reminderMinutesBefore,
    };
  }

  NotificationPreferences _notificationPrefsFromJson(
      Map<String, dynamic> json) {
    return NotificationPreferences(
      pushEnabled: json['pushEnabled'] as bool? ?? true,
      emailEnabled: json['emailEnabled'] as bool? ?? true,
      smsEnabled: json['smsEnabled'] as bool? ?? false,
      classReminders: json['classReminders'] as bool? ?? true,
      promotionalOffers: json['promotionalOffers'] as bool? ?? false,
      subscriptionAlerts: json['subscriptionAlerts'] as bool? ?? true,
      visitReminders: json['visitReminders'] as bool? ?? true,
      weeklyDigest: json['weeklyDigest'] as bool? ?? true,
      reminderMinutesBefore:
          json['reminderMinutesBefore'] as int? ?? 30,
    );
  }
}