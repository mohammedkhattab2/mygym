// Admin gym management entities
// Used for the Admin Dashboard (Web) feature

/// Gym status enum for admin management
enum GymStatus {
  pending,
  active,
  blocked,
  suspended,
}

/// Extension for GymStatus display
extension GymStatusX on GymStatus {
  String get displayName {
    switch (this) {
      case GymStatus.pending:
        return 'Pending';
      case GymStatus.active:
        return 'Active';
      case GymStatus.blocked:
        return 'Blocked';
      case GymStatus.suspended:
        return 'Suspended';
    }
  }

  String get color {
    switch (this) {
      case GymStatus.pending:
        return '#FFA500'; // Orange
      case GymStatus.active:
        return '#4CAF50'; // Green
      case GymStatus.blocked:
        return '#F44336'; // Red
      case GymStatus.suspended:
        return '#9E9E9E'; // Gray
    }
  }
}

/// Admin gym entity for dashboard table
class AdminGym {
  final String id;
  final String name;
  final String city;
  final String address;
  final double latitude;
  final double longitude;
  final GymStatus status;
  final DateTime dateAdded;
  final DateTime? lastUpdated;
  final List<String> imageUrls;
  final List<AdminFacility> facilities;
  final List<AdminBundle> customBundles;
  final AdminGymSettings settings;
  final AdminGymStats stats;
  final String? partnerEmail;
  final String? partnerPhone;
  final String? notes;

  const AdminGym({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.dateAdded,
    this.lastUpdated,
    this.imageUrls = const [],
    this.facilities = const [],
    this.customBundles = const [],
    required this.settings,
    required this.stats,
    this.partnerEmail,
    this.partnerPhone,
    this.notes,
  });

  AdminGym copyWith({
    String? id,
    String? name,
    String? city,
    String? address,
    double? latitude,
    double? longitude,
    GymStatus? status,
    DateTime? dateAdded,
    DateTime? lastUpdated,
    List<String>? imageUrls,
    List<AdminFacility>? facilities,
    List<AdminBundle>? customBundles,
    AdminGymSettings? settings,
    AdminGymStats? stats,
    String? partnerEmail,
    String? partnerPhone,
    String? notes,
  }) {
    return AdminGym(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      dateAdded: dateAdded ?? this.dateAdded,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      imageUrls: imageUrls ?? this.imageUrls,
      facilities: facilities ?? this.facilities,
      customBundles: customBundles ?? this.customBundles,
      settings: settings ?? this.settings,
      stats: stats ?? this.stats,
      partnerEmail: partnerEmail ?? this.partnerEmail,
      partnerPhone: partnerPhone ?? this.partnerPhone,
      notes: notes ?? this.notes,
    );
  }
}

/// Facility for admin gym management
class AdminFacility {
  final String id;
  final String name;
  final String? icon;
  final bool isAvailable;

  const AdminFacility({
    required this.id,
    required this.name,
    this.icon,
    this.isAvailable = true,
  });
}

/// Custom bundle for gym
class AdminBundle {
  final String id;
  final String name;
  final BundleTier tier;
  final BundleDuration duration;
  final double price;
  final int? visitLimit;
  final List<String> features;
  final bool isActive;

  const AdminBundle({
    required this.id,
    required this.name,
    required this.tier,
    required this.duration,
    required this.price,
    this.visitLimit,
    this.features = const [],
    this.isActive = true,
  });
}

/// Bundle tier enum
enum BundleTier {
  basic,
  plus,
  premium,
}

/// Bundle duration enum
enum BundleDuration {
  monthly,
  quarterly,
  yearly,
  visits, // Pay per visit
}

/// Extension for BundleTier
extension BundleTierX on BundleTier {
  String get displayName {
    switch (this) {
      case BundleTier.basic:
        return 'Basic';
      case BundleTier.plus:
        return 'Plus';
      case BundleTier.premium:
        return 'Premium';
    }
  }
}

/// Extension for BundleDuration
extension BundleDurationX on BundleDuration {
  String get displayName {
    switch (this) {
      case BundleDuration.monthly:
        return 'Monthly';
      case BundleDuration.quarterly:
        return 'Quarterly';
      case BundleDuration.yearly:
        return 'Yearly';
      case BundleDuration.visits:
        return 'Per Visit';
    }
  }
}

/// Gym settings for admin
class AdminGymSettings {
  final int dailyVisitLimit;
  final int weeklyVisitLimit;
  final double revenueSharePercent;
  final List<WorkingHoursEntry> workingHours;
  final bool allowGuestCheckIn;
  final int maxConcurrentVisitors;
  final bool requiresGeofence;
  final double? geofenceRadius;

  const AdminGymSettings({
    this.dailyVisitLimit = 1,
    this.weeklyVisitLimit = 7,
    this.revenueSharePercent = 70.0,
    this.workingHours = const [],
    this.allowGuestCheckIn = false,
    this.maxConcurrentVisitors = 100,
    this.requiresGeofence = false,
    this.geofenceRadius,
  });
}

/// Working hours entry
class WorkingHoursEntry {
  final int dayOfWeek; // 1 = Monday, 7 = Sunday
  final String openTime; // HH:mm format
  final String closeTime; // HH:mm format
  final bool isClosed;

  const WorkingHoursEntry({
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
    this.isClosed = false,
  });

  String get dayName {
    switch (dayOfWeek) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }
}

/// Gym statistics for admin overview
class AdminGymStats {
  final int totalVisits;
  final int visitsThisMonth;
  final int activeSubscribers;
  final double totalRevenue;
  final double revenueThisMonth;
  final double averageRating;
  final int totalReviews;

  const AdminGymStats({
    this.totalVisits = 0,
    this.visitsThisMonth = 0,
    this.activeSubscribers = 0,
    this.totalRevenue = 0.0,
    this.revenueThisMonth = 0.0,
    this.averageRating = 0.0,
    this.totalReviews = 0,
  });
}

/// Dashboard overview statistics
class AdminDashboardStats {
  final int totalGyms;
  final int activeGyms;
  final int pendingGyms;
  final int blockedGyms;
  final int totalUsers;
  final int activeSubscriptions;
  final double totalRevenue;
  final double revenueThisMonth;
  final int totalVisitsToday;
  final int totalVisitsThisWeek;
  final int totalVisitsThisMonth;
  final List<CityStats> cityBreakdown;

  const AdminDashboardStats({
    this.totalGyms = 0,
    this.activeGyms = 0,
    this.pendingGyms = 0,
    this.blockedGyms = 0,
    this.totalUsers = 0,
    this.activeSubscriptions = 0,
    this.totalRevenue = 0.0,
    this.revenueThisMonth = 0.0,
    this.totalVisitsToday = 0,
    this.totalVisitsThisWeek = 0,
    this.totalVisitsThisMonth = 0,
    this.cityBreakdown = const [],
  });
}

/// City statistics
class CityStats {
  final String city;
  final int gymCount;
  final int userCount;
  final double revenue;

  const CityStats({
    required this.city,
    required this.gymCount,
    required this.userCount,
    required this.revenue,
  });
}

/// Gym filter for admin table
class AdminGymFilter {
  final String? searchQuery;
  final GymStatus? status;
  final String? city;
  final DateTime? dateAddedFrom;
  final DateTime? dateAddedTo;
  final AdminGymSortBy sortBy;
  final bool sortAscending;
  final int page;
  final int pageSize;

  const AdminGymFilter({
    this.searchQuery,
    this.status,
    this.city,
    this.dateAddedFrom,
    this.dateAddedTo,
    this.sortBy = AdminGymSortBy.dateAdded,
    this.sortAscending = false,
    this.page = 1,
    this.pageSize = 20,
  });

  AdminGymFilter copyWith({
    String? searchQuery,
    GymStatus? status,
    String? city,
    DateTime? dateAddedFrom,
    DateTime? dateAddedTo,
    AdminGymSortBy? sortBy,
    bool? sortAscending,
    int? page,
    int? pageSize,
  }) {
    return AdminGymFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
      city: city ?? this.city,
      dateAddedFrom: dateAddedFrom ?? this.dateAddedFrom,
      dateAddedTo: dateAddedTo ?? this.dateAddedTo,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

/// Sort options for gym table
enum AdminGymSortBy {
  name,
  city,
  status,
  dateAdded,
  totalVisits,
  revenue,
  rating,
}

/// Paginated gym list response
class PaginatedGyms {
  final List<AdminGym> gyms;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  const PaginatedGyms({
    required this.gyms,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
  });
}

/// Form data for adding/editing gym
class GymFormData {
  final String? id; // null for new gym
  final String name;
  final String city;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> imageUrls;
  final List<String> facilityIds;
  final List<AdminBundle> customBundles;
  final AdminGymSettings settings;
  final String? partnerEmail;
  final String? partnerPhone;
  final String? notes;

  const GymFormData({
    this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.imageUrls = const [],
    this.facilityIds = const [],
    this.customBundles = const [],
    required this.settings,
    this.partnerEmail,
    this.partnerPhone,
    this.notes,
  });
}

/// Available cities for dropdown
class AvailableCity {
  final String id;
  final String name;
  final String country;

  const AvailableCity({
    required this.id,
    required this.name,
    required this.country,
  });
}

/// Available facility for selection
class AvailableFacility {
  final String id;
  final String name;
  final String? icon;
  final String category;

  const AvailableFacility({
    required this.id,
    required this.name,
    this.icon,
    required this.category,
  });
}