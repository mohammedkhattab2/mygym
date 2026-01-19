/// Environment types for the application
enum Environment {
  development,
  staging,
  production,
}

extension EnvironmentExtension on Environment {
  bool get isDevelopment => this == Environment.development;
  bool get isStaging => this == Environment.staging;
  bool get isProduction => this == Environment.production;
  
  String get name {
    switch (this) {
      case Environment.development:
        return 'Development';
      case Environment.staging:
        return 'Staging';
      case Environment.production:
        return 'Production';
    }
  }
}