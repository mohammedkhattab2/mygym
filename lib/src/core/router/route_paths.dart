/// Route path constants
class RoutePaths {
  RoutePaths._();

  // Root
  static const String splash = '/';
  
  // Auth
  static const String auth = '/auth';
  static const String login = '$auth/login';
  static const String otpVerification = '$auth/otp';
  
  // Onboarding
  static const String onboarding = '/onboarding';
  static const String onboardingSlides = '$onboarding/slides';
  static const String citySelection = '$onboarding/city';
  static const String interestsSelection = '$onboarding/interests';
  
  // Member
  static const String member = '/member';
  static const String memberHome = '$member/home';
  static const String home = memberHome;  // Alias for convenience
  static const String search = '$member/search';
  
  // Gyms
  static const String gyms = '$member/gyms';
  static const String gymsMap = '$gyms/map';
  static const String gymsList = '$gyms/list';
  static const String gymDetail = '$gyms/:gymId';
  static const String gymFilter = '$gyms/filter';
  
  // Subscriptions
  static const String subscriptions = '$member/subscriptions';
  static const String bundles = '$subscriptions/bundles';
  static const String checkout = '$subscriptions/checkout/:bundleId';
  static const String payment = '$subscriptions/payment';
  static const String invoices = '$subscriptions/invoices';
  
  // QR
  static const String qr = '$member/qr';
  
  // Classes
  static const classes = '/member/classes';
  static const classesSchedule = '/member/classes';  // Alias - main entry (weekly schedule)
  static const classesCalendar = '/member/classes/calendar';
  static const classDetail = '/member/classes/detail';  // + /:scheduleId
  static const classBookings = '/member/classes/bookings';
  
  // Rewards
  // Rewards
  static const rewards = '/member/rewards';
  static const referrals = '/member/rewards/referrals';
  static const pointsHistory = '/member/rewards/history';
  
  // History
  static const String history = '$member/history';
  
  // Profile
  static const String profile = '$member/profile';
  static const String profileView = '$profile/view';
  static const String profileEdit = '$profile/edit';
  
  // Settings
  static const String settings = '$member/settings';
  static const String languageSettings = '$settings/language';
  static const String notificationSettings = '$settings/notifications';
  
  // Partner
  static const String partner = '/partner';
  static const String partnerDashboard = '$partner/dashboard';
  static const String partnerScanner = '$partner/scanner';
  static const String partnerReports = '$partner/reports';
  static const String partnerSettings = '$partner/settings';
  static const String partnerBlockedUsers = '$partner/blocked-users';
  
  // Admin
  static const String admin = '/admin';
  static const String adminDashboard = '$admin/dashboard';
  static const String adminGyms = '$admin/gyms';
  static const String adminGymsList = '$adminGyms/list';
  static const String adminAddGym = '$adminGyms/add';
  static const String adminEditGym = '$adminGyms/edit/:gymId';
  static const String adminSettings = '$admin/settings';
}