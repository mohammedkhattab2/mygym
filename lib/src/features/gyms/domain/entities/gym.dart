/// Gym entity representing a fitness center
/// 
/// Core domain entity for gym information including
/// location, facilities, ratings, and availability.
class Gym {
  final String id;
  final String name;
  final String address;
  final String? description;
  final double latitude;
  final double longitude;
  final String city;
  final List<String> images;
  final List<String> facilities;
  final double rating;
  final int reviewCount;
  final String? crowdLevel; // 'low', 'medium', 'high'
  final int? currentOccupancy;
  final int? maxCapacity;
  final WorkingHours workingHours;
  final bool isOpen;
  final bool isPartner;
  final String? partnerSince;
  final GymStatus status;
  final List<String>? rules;
  final ContactInfo? contactInfo;
  final double? distance; // in kilometers, calculated from user location

  const Gym({
    required this.id,
    required this.name,
    required this.address,
    this.description,
    required this.latitude,
    required this.longitude,
    required this.city,
    this.images = const [],
    this.facilities = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.crowdLevel,
    this.currentOccupancy,
    this.maxCapacity,
    required this.workingHours,
    this.isOpen = false,
    this.isPartner = false,
    this.partnerSince,
    this.status = GymStatus.active,
    this.rules,
    this.contactInfo,
    this.distance,
  });

  /// Get crowd percentage (0-100)
  int? get crowdPercentage {
    if (currentOccupancy != null && maxCapacity != null && maxCapacity! > 0) {
      return ((currentOccupancy! / maxCapacity!) * 100).round();
    }
    return null;
  }

  /// Check if gym is currently available
  bool get isAvailable => isOpen && status == GymStatus.active;

  /// Get formatted distance string
  String? get formattedDistance {
    if (distance == null) return null;
    if (distance! < 1) {
      return '${(distance! * 1000).round()} m';
    }
    return '${distance!.toStringAsFixed(1)} km';
  }
}

/// Working hours for each day of the week
class WorkingHours {
  final DayHours? monday;
  final DayHours? tuesday;
  final DayHours? wednesday;
  final DayHours? thursday;
  final DayHours? friday;
  final DayHours? saturday;
  final DayHours? sunday;

  const WorkingHours({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  /// Get hours for a specific day (0 = Monday, 6 = Sunday)
  DayHours? getHoursForDay(int weekday) {
    switch (weekday) {
      case 1:
        return monday;
      case 2:
        return tuesday;
      case 3:
        return wednesday;
      case 4:
        return thursday;
      case 5:
        return friday;
      case 6:
        return saturday;
      case 7:
        return sunday;
      default:
        return null;
    }
  }

  /// Check if open at a specific time
  bool isOpenAt(DateTime dateTime) {
    final dayHours = getHoursForDay(dateTime.weekday);
    if (dayHours == null || dayHours.isClosed) return false;
    
    final currentMinutes = dateTime.hour * 60 + dateTime.minute;
    final openMinutes = dayHours.openTime.hour * 60 + dayHours.openTime.minute;
    final closeMinutes = dayHours.closeTime.hour * 60 + dayHours.closeTime.minute;
    
    return currentMinutes >= openMinutes && currentMinutes <= closeMinutes;
  }

  /// Get today's hours
  DayHours? get todayHours => getHoursForDay(DateTime.now().weekday);
}

/// Opening hours for a single day
class DayHours {
  final TimeOfDay openTime;
  final TimeOfDay closeTime;
  final bool isClosed;

  const DayHours({
    required this.openTime,
    required this.closeTime,
    this.isClosed = false,
  });

  /// Create closed day
  factory DayHours.closed() => const DayHours(
        openTime: TimeOfDay(hour: 0, minute: 0),
        closeTime: TimeOfDay(hour: 0, minute: 0),
        isClosed: true,
      );

  /// Format as string (e.g., "6:00 AM - 10:00 PM")
  String get formatted {
    if (isClosed) return 'Closed';
    return '${_formatTime(openTime)} - ${_formatTime(closeTime)}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    if (hour == 0) return '12:$minute AM';
    if (hour < 12) return '$hour:$minute AM';
    if (hour == 12) return '12:$minute PM';
    return '${hour - 12}:$minute PM';
  }
}

/// Simple TimeOfDay class (without Flutter dependency)
class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});
}

/// Gym status enum
enum GymStatus {
  pending,
  active,
  suspended,
  blocked,
}

/// Contact information for a gym
class ContactInfo {
  final String? phone;
  final String? email;
  final String? website;
  final String? whatsapp;
  final Map<String, String>? socialMedia;

  const ContactInfo({
    this.phone,
    this.email,
    this.website,
    this.whatsapp,
    this.socialMedia,
  });
}

/// Gym facility/amenity
class Facility {
  final String id;
  final String name;
  final String nameAr;
  final String iconPath;

  const Facility({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.iconPath,
  });
}

/// Available gym facilities
class AvailableFacilities {
  static const List<Facility> facilities = [
    Facility(
      id: 'weights',
      name: 'Free Weights',
      nameAr: 'أوزان حرة',
      iconPath: 'assets/icons/weights.svg',
    ),
    Facility(
      id: 'machines',
      name: 'Machines',
      nameAr: 'أجهزة',
      iconPath: 'assets/icons/machines.svg',
    ),
    Facility(
      id: 'cardio',
      name: 'Cardio Area',
      nameAr: 'منطقة كارديو',
      iconPath: 'assets/icons/cardio.svg',
    ),
    Facility(
      id: 'pool',
      name: 'Swimming Pool',
      nameAr: 'حمام سباحة',
      iconPath: 'assets/icons/pool.svg',
    ),
    Facility(
      id: 'sauna',
      name: 'Sauna',
      nameAr: 'ساونا',
      iconPath: 'assets/icons/sauna.svg',
    ),
    Facility(
      id: 'steam',
      name: 'Steam Room',
      nameAr: 'غرفة بخار',
      iconPath: 'assets/icons/steam.svg',
    ),
    Facility(
      id: 'jacuzzi',
      name: 'Jacuzzi',
      nameAr: 'جاكوزي',
      iconPath: 'assets/icons/jacuzzi.svg',
    ),
    Facility(
      id: 'locker',
      name: 'Lockers',
      nameAr: 'خزائن',
      iconPath: 'assets/icons/locker.svg',
    ),
    Facility(
      id: 'shower',
      name: 'Showers',
      nameAr: 'دش',
      iconPath: 'assets/icons/shower.svg',
    ),
    Facility(
      id: 'parking',
      name: 'Parking',
      nameAr: 'موقف سيارات',
      iconPath: 'assets/icons/parking.svg',
    ),
    Facility(
      id: 'wifi',
      name: 'Free WiFi',
      nameAr: 'واي فاي مجاني',
      iconPath: 'assets/icons/wifi.svg',
    ),
    Facility(
      id: 'trainer',
      name: 'Personal Trainers',
      nameAr: 'مدربين شخصيين',
      iconPath: 'assets/icons/trainer.svg',
    ),
    Facility(
      id: 'classes',
      name: 'Group Classes',
      nameAr: 'فصول جماعية',
      iconPath: 'assets/icons/classes.svg',
    ),
    Facility(
      id: 'cafe',
      name: 'Juice Bar',
      nameAr: 'بار عصير',
      iconPath: 'assets/icons/cafe.svg',
    ),
    Facility(
      id: 'towel',
      name: 'Towel Service',
      nameAr: 'خدمة المناشف',
      iconPath: 'assets/icons/towel.svg',
    ),
    Facility(
      id: 'women',
      name: 'Women Only Area',
      nameAr: 'منطقة نساء فقط',
      iconPath: 'assets/icons/women.svg',
    ),
  ];

  static Facility? getById(String id) {
    try {
      return facilities.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }
}

/// Filter options for gym search
class GymFilter {
  final double? maxDistance; // in km
  final List<String>? facilities;
  final double? minRating;
  final bool? openNow;
  final String? crowdLevel;
  final String? sortBy; // 'distance', 'rating', 'popularity'

  const GymFilter({
    this.maxDistance,
    this.facilities,
    this.minRating,
    this.openNow,
    this.crowdLevel,
    this.sortBy,
  });

  GymFilter copyWith({
    double? maxDistance,
    List<String>? facilities,
    double? minRating,
    bool? openNow,
    String? crowdLevel,
    String? sortBy,
  }) {
    return GymFilter(
      maxDistance: maxDistance ?? this.maxDistance,
      facilities: facilities ?? this.facilities,
      minRating: minRating ?? this.minRating,
      openNow: openNow ?? this.openNow,
      crowdLevel: crowdLevel ?? this.crowdLevel,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  bool get hasActiveFilters =>
      maxDistance != null ||
      (facilities != null && facilities!.isNotEmpty) ||
      minRating != null ||
      openNow == true ||
      crowdLevel != null;

  /// Convert to query parameters
  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    if (maxDistance != null) params['max_distance'] = maxDistance;
    if (facilities != null && facilities!.isNotEmpty) {
      params['facilities'] = facilities!.join(',');
    }
    if (minRating != null) params['min_rating'] = minRating;
    if (openNow == true) params['open_now'] = true;
    if (crowdLevel != null) params['crowd_level'] = crowdLevel;
    if (sortBy != null) params['sort_by'] = sortBy;
    return params;
  }
}