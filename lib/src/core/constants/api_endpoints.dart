/// API endpoint constants
class ApiEndpoints {
  ApiEndpoints._();

  // Base URLs (will be overridden by environment config)
  static const String baseUrl = 'https://api.mygym.com/v1';
  static const String devBaseUrl = 'https://dev-api.mygym.com/v1';
  static const String stagingBaseUrl = 'https://staging-api.mygym.com/v1';

  // Auth Endpoints
  static const String auth = '/auth';
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String socialLogin = '$auth/social';
  static const String loginGoogle = '$auth/google';
  static const String loginApple = '$auth/apple';
  static const String requestOtp = '$auth/otp/send';
  static const String verifyOtp = '$auth/otp/verify';
  static const String sendOTP = '$auth/otp/send';
  static const String verifyOTP = '$auth/otp/verify';
  static const String refreshToken = '$auth/refresh';
  static const String logout = '$auth/logout';
  static const String profile = '$auth/profile';
  static const String forgotPassword = '$auth/forgot-password';
  static const String deleteAccount = '$auth/delete-account';

  // User Endpoints
  static const String users = '/users';
  static const String userProfile = '$users/me';
  static const String updateProfile = '$users/me';
  static const String updateAvatar = '$users/me/avatar';
  static const String userPreferences = '$users/me/preferences';
  static const String updatePreferences = '$users/me/preferences';

  // Gym Endpoints
  static const String gyms = '/gyms';
  static const String gymDetails = '$gyms/{id}';
  static const String nearbyGyms = '$gyms/nearby';
  static const String searchGyms = '$gyms/search';
  static const String gymFacilities = '$gyms/{id}/facilities';
  static const String gymWorkingHours = '$gyms/{id}/working-hours';
  static const String gymCrowdLevel = '$gyms/{id}/crowd';

  // Subscription Endpoints
  static const String subscriptions = '/subscriptions';
  static const String bundles = '/bundles';
  static const String userSubscription = '$subscriptions/me';
  static const String cancelSubscription = '$subscriptions/me/cancel';
  static const String toggleAutoRenew = '$subscriptions/me/auto-renew';

  // Payment Endpoints
  static const String payments = '/payments';
  static const String initiatePayment = '$payments/initiate';
  static const String paymentCallback = '$payments/callback';
  static const String invoices = '$payments/invoices';

  // QR Check-in Endpoints
  static const String qr = '/qr';
  static const String generateQR = '$qr/generate';
  static const String validateQR = '$qr/validate';
  static const String checkin = '$qr/checkin';

  // Classes Endpoints
  static const String classes = '/classes';
  static const String classSchedule = '$classes/schedule';
  static const String classDetails = '$classes/{id}';
  static const String bookClass = '$classes/{id}/book';
  static const String cancelBooking = '$classes/bookings/{id}/cancel';
  static const String myBookings = '$classes/bookings/me';

  // Rewards Endpoints
  static const String rewards = '/rewards';
  static const String redeemReward = '$rewards/{id}/redeem';
  static const String referrals = '/referrals';
  static const String referralCode = '$referrals/code';
  static const String applyReferral = '$referrals/apply';
  static const String pointsHistory = '/points/history';

  // History Endpoints
  static const String visits = '/visits';
  static const String visitStats = '$visits/stats';

  // Partner Endpoints
  static const String partner = '/partner';
  static const String partnerGym = '$partner/gym';
  static const String partnerReports = '$partner/reports';
  static const String partnerRevenue = '$partner/revenue';
  static const String partnerSettings = '$partner/settings';
  static const String blockUser = '$partner/users/{id}/block';

  // Admin Endpoints
  static const String admin = '/admin';
  static const String adminGyms = '$admin/gyms';
  static const String adminAddGym = '$admin/gyms';
  static const String adminUpdateGym = '$admin/gyms/{id}';
  static const String adminDeleteGym = '$admin/gyms/{id}';
  static const String adminGymStatus = '$admin/gyms/{id}/status';
  static const String adminStats = '$admin/stats';
  static const String adminUsers = '$admin/users';

  // Notifications
  static const String notifications = '/notifications';
  static const String registerDevice = '$notifications/device';
  static const String notificationSettings = '$notifications/settings';

  // Support
  static const String support = '/support';
  static const String faq = '$support/faq';
  static const String contactSupport = '$support/contact';
}