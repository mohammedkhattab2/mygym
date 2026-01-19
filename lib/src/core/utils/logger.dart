import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

/// Application logger utility
class AppLogger {
  AppLogger._();

  static const String _tag = 'MyGym';

  /// Log debug message
  static void debug(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Log info message
  static void info(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Log warning message
  static void warning(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Log error message
  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Internal log method
  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Check if we should log based on app config
    if (!AppConfig.instance.logLevel.shouldLog(level)) {
      return;
    }

    final logTag = tag ?? _tag;
    final prefix = _getLevelPrefix(level);
    final fullMessage = '$prefix [$logTag] $message';

    if (kDebugMode) {
      developer.log(
        fullMessage,
        name: logTag,
        error: error,
        stackTrace: stackTrace,
        level: _getDeveloperLogLevel(level),
      );
    }

    // In production, you might want to send logs to a service like Crashlytics
    if (level == LogLevel.error && error != null) {
      // TODO: Send to crash reporting service
      // FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }

  static String _getLevelPrefix(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🔍 DEBUG';
      case LogLevel.info:
        return 'ℹ️ INFO';
      case LogLevel.warning:
        return '⚠️ WARNING';
      case LogLevel.error:
        return '❌ ERROR';
      case LogLevel.none:
        return '';
    }
  }

  static int _getDeveloperLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.none:
        return 0;
    }
  }
}