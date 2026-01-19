import 'environment.dart';
import '../constants/api_endpoints.dart';

/// Application configuration singleton
class AppConfig {
  AppConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.googleMapsApiKey,
    required this.enableAnalytics,
    required this.enableCrashlytics,
    required this.logLevel,
  });

  final Environment environment;
  final String apiBaseUrl;
  final String googleMapsApiKey;
  final bool enableAnalytics;
  final bool enableCrashlytics;
  final LogLevel logLevel;

  static late AppConfig _instance;
  static AppConfig get instance => _instance;
  static bool _initialized = false;

  /// Initialize the app configuration based on environment
  static void initialize(Environment env) {
    if (_initialized) return;

    switch (env) {
      case Environment.development:
        _instance = AppConfig._(
          environment: env,
          apiBaseUrl: ApiEndpoints.devBaseUrl,
          googleMapsApiKey: const String.fromEnvironment(
            'GOOGLE_MAPS_API_KEY',
            defaultValue: 'YOUR_DEV_API_KEY',
          ),
          enableAnalytics: false,
          enableCrashlytics: false,
          logLevel: LogLevel.debug,
        );
        break;

      case Environment.staging:
        _instance = AppConfig._(
          environment: env,
          apiBaseUrl: ApiEndpoints.stagingBaseUrl,
          googleMapsApiKey: const String.fromEnvironment(
            'GOOGLE_MAPS_API_KEY',
            defaultValue: 'YOUR_STAGING_API_KEY',
          ),
          enableAnalytics: true,
          enableCrashlytics: true,
          logLevel: LogLevel.info,
        );
        break;

      case Environment.production:
        _instance = AppConfig._(
          environment: env,
          apiBaseUrl: ApiEndpoints.baseUrl,
          googleMapsApiKey: const String.fromEnvironment(
            'GOOGLE_MAPS_API_KEY',
            defaultValue: 'YOUR_PROD_API_KEY',
          ),
          enableAnalytics: true,
          enableCrashlytics: true,
          logLevel: LogLevel.error,
        );
        break;
    }

    _initialized = true;
  }

  /// Check if running in debug mode
  bool get isDebug => environment.isDevelopment;

  /// Check if running in release mode
  bool get isRelease => environment.isProduction;
}

/// Log levels for the application
enum LogLevel {
  debug,
  info,
  warning,
  error,
  none,
}

extension LogLevelExtension on LogLevel {
  bool shouldLog(LogLevel messageLevel) {
    return messageLevel.index >= index;
  }
}