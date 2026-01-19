/// Storage keys for Hive and SecureStorage
class StorageKeys {
  StorageKeys._();

  // Hive Box Names
  static const String settingsBox = 'settings_box';
  static const String cacheBox = 'cache_box';
  static const String userBox = 'user_box';
  static const String gymsBox = 'gyms_box';
  static const String subscriptionsBox = 'subscriptions_box';

  // Secure Storage Keys
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String tokenExpiry = 'token_expiry';
  static const String userId = 'user_id';
  static const String userRole = 'user_role';
  static const String isOnboardingComplete = 'is_onboarding_complete';

  // Settings Keys
  static const String language = 'language';
  static const String themeMode = 'theme_mode';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String selectedCity = 'selected_city';
  static const String selectedInterests = 'selected_interests';

  // Cache Keys
  static const String cachedGyms = 'cached_gyms';
  static const String cachedBundles = 'cached_bundles';
  static const String cachedClasses = 'cached_classes';
  static const String cachedRewards = 'cached_rewards';
  static const String lastCacheTime = 'last_cache_time';

  // User Data Keys
  static const String cachedUser = 'cached_user';
  static const String userProfile = 'user_profile';
  static const String userSubscription = 'user_subscription';
  static const String userPoints = 'user_points';
  static const String visitHistory = 'visit_history';

  // FCM Keys
  static const String fcmToken = 'fcm_token';
  static const String deviceId = 'device_id';
}