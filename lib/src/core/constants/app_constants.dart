/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'MyGym';
  static const String appVersion = '1.0.0';
  
  // QR Token Configuration
  static const int qrTokenValiditySeconds = 60;
  static const int qrRefreshIntervalSeconds = 30;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;
  
  // Cache Configuration
  static const Duration cacheDuration = Duration(hours: 1);
  static const Duration shortCacheDuration = Duration(minutes: 15);
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 350);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;
  static const int otpLength = 6;
  static const int phoneNumberLength = 11;
  
  // Map Configuration
  static const double defaultLatitude = 30.0444; // Cairo
  static const double defaultLongitude = 31.2357;
  static const double defaultZoom = 14.0;
  static const double maxSearchRadius = 50.0; // km
  
  // Subscription Tiers
  static const String tierBasic = 'basic';
  static const String tierPlus = 'plus';
  static const String tierPremium = 'premium';
  
  // User Roles
  static const String roleMember = 'member';
  static const String roleGuest = 'guest';
  static const String rolePartner = 'partner';
  static const String roleAdmin = 'admin';
}