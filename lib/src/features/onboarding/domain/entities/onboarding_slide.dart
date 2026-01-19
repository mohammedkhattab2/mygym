/// Onboarding slide data
/// 
/// Represents a single slide in the onboarding flow.
class OnboardingSlide {
  final String title;
  final String description;
  final String imagePath;
  final String? lottieAnimation;

  const OnboardingSlide({
    required this.title,
    required this.description,
    required this.imagePath,
    this.lottieAnimation,
  });
}

/// Predefined onboarding slides for the app
class OnboardingSlides {
  static const List<OnboardingSlide> slides = [
    OnboardingSlide(
      title: 'Discover Gyms Near You',
      description: 'Find the best gyms in your city with real-time availability, crowd estimates, and detailed facilities information.',
      imagePath: 'assets/images/onboarding/discover.png',
      lottieAnimation: 'assets/animations/discover.json',
    ),
    OnboardingSlide(
      title: 'Flexible Subscriptions',
      description: 'Choose from various subscription plans - monthly, yearly, or pay-per-visit. No long-term commitments required.',
      imagePath: 'assets/images/onboarding/subscription.png',
      lottieAnimation: 'assets/animations/subscription.json',
    ),
    OnboardingSlide(
      title: 'Seamless Check-in',
      description: 'Simply scan your QR code at the gym entrance. No cards, no hassle - just show and go.',
      imagePath: 'assets/images/onboarding/checkin.png',
      lottieAnimation: 'assets/animations/qr_scan.json',
    ),
    OnboardingSlide(
      title: 'Book Classes & Earn Rewards',
      description: 'Reserve your spot in fitness classes and earn points with every visit. Refer friends for bonus rewards.',
      imagePath: 'assets/images/onboarding/rewards.png',
      lottieAnimation: 'assets/animations/rewards.json',
    ),
  ];
}

/// City model for location selection
class City {
  final String id;
  final String name;
  final String nameAr;
  final String country;
  final double latitude;
  final double longitude;
  final int gymCount;

  const City({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.gymCount = 0,
  });
}

/// Predefined cities for Egypt
class AvailableCities {
  static const List<City> cities = [
    City(
      id: 'cairo',
      name: 'Cairo',
      nameAr: 'القاهرة',
      country: 'Egypt',
      latitude: 30.0444,
      longitude: 31.2357,
      gymCount: 150,
    ),
    City(
      id: 'giza',
      name: 'Giza',
      nameAr: 'الجيزة',
      country: 'Egypt',
      latitude: 30.0131,
      longitude: 31.2089,
      gymCount: 80,
    ),
    City(
      id: 'alexandria',
      name: 'Alexandria',
      nameAr: 'الإسكندرية',
      country: 'Egypt',
      latitude: 31.2001,
      longitude: 29.9187,
      gymCount: 60,
    ),
    City(
      id: 'new-cairo',
      name: 'New Cairo',
      nameAr: 'القاهرة الجديدة',
      country: 'Egypt',
      latitude: 30.0300,
      longitude: 31.4700,
      gymCount: 45,
    ),
    City(
      id: 'sheikh-zayed',
      name: 'Sheikh Zayed',
      nameAr: 'الشيخ زايد',
      country: 'Egypt',
      latitude: 30.0500,
      longitude: 30.9833,
      gymCount: 35,
    ),
    City(
      id: '6th-october',
      name: '6th of October',
      nameAr: 'السادس من أكتوبر',
      country: 'Egypt',
      latitude: 29.9285,
      longitude: 30.9188,
      gymCount: 40,
    ),
  ];
}

/// Interest/activity category for personalization
class Interest {
  final String id;
  final String name;
  final String nameAr;
  final String iconPath;

  const Interest({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.iconPath,
  });
}

/// Predefined fitness interests
class AvailableInterests {
  static const List<Interest> interests = [
    Interest(
      id: 'weightlifting',
      name: 'Weightlifting',
      nameAr: 'رفع الأثقال',
      iconPath: 'assets/icons/weightlifting.svg',
    ),
    Interest(
      id: 'cardio',
      name: 'Cardio',
      nameAr: 'تمارين القلب',
      iconPath: 'assets/icons/cardio.svg',
    ),
    Interest(
      id: 'yoga',
      name: 'Yoga',
      nameAr: 'يوغا',
      iconPath: 'assets/icons/yoga.svg',
    ),
    Interest(
      id: 'swimming',
      name: 'Swimming',
      nameAr: 'السباحة',
      iconPath: 'assets/icons/swimming.svg',
    ),
    Interest(
      id: 'crossfit',
      name: 'CrossFit',
      nameAr: 'كروس فيت',
      iconPath: 'assets/icons/crossfit.svg',
    ),
    Interest(
      id: 'boxing',
      name: 'Boxing',
      nameAr: 'الملاكمة',
      iconPath: 'assets/icons/boxing.svg',
    ),
    Interest(
      id: 'pilates',
      name: 'Pilates',
      nameAr: 'بيلاتس',
      iconPath: 'assets/icons/pilates.svg',
    ),
    Interest(
      id: 'spinning',
      name: 'Spinning',
      nameAr: 'سبينينج',
      iconPath: 'assets/icons/spinning.svg',
    ),
    Interest(
      id: 'martial-arts',
      name: 'Martial Arts',
      nameAr: 'فنون قتالية',
      iconPath: 'assets/icons/martial_arts.svg',
    ),
    Interest(
      id: 'dance',
      name: 'Dance Fitness',
      nameAr: 'الرقص اللياقي',
      iconPath: 'assets/icons/dance.svg',
    ),
  ];
}