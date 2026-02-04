import 'package:injectable/injectable.dart';

import '../../domain/entities/admin_gym.dart';
import '../../domain/repositories/admin_repository.dart';

/// Local data source for admin dashboard with mock data
/// Used for development when backend is not available
@LazySingleton(env: [Environment.dev])
class AdminLocalDataSource {
  // Simulated delay for realistic UX
  static const _delay = Duration(milliseconds: 500);

  /// Get mock dashboard statistics
  Future<AdminDashboardStats> getDashboardStats() async {
    await Future.delayed(_delay);
    return const AdminDashboardStats(
      totalGyms: 45,
      activeGyms: 38,
      pendingGyms: 5,
      blockedGyms: 2,
      totalUsers: 12500,
      activeSubscriptions: 8750,
      totalRevenue: 1250000.0,
      revenueThisMonth: 185000.0,
      totalVisitsToday: 342,
      totalVisitsThisWeek: 2150,
      totalVisitsThisMonth: 8920,
      cityBreakdown: [
        CityStats(city: 'Cairo', gymCount: 18, userCount: 5200, revenue: 520000.0),
        CityStats(city: 'Alexandria', gymCount: 12, userCount: 3100, revenue: 310000.0),
        CityStats(city: 'Giza', gymCount: 8, userCount: 2400, revenue: 240000.0),
        CityStats(city: 'Mansoura', gymCount: 4, userCount: 1100, revenue: 110000.0),
        CityStats(city: 'Tanta', gymCount: 3, userCount: 700, revenue: 70000.0),
      ],
    );
  }

  /// Get mock gyms list
  Future<PaginatedGyms> getGyms(AdminGymFilter filter) async {
    await Future.delayed(_delay);
    
    var gyms = _mockGyms;
    
    // Apply filters
    if (filter.status != null) {
      gyms = gyms.where((g) => g.status == filter.status).toList();
    }
    if (filter.city != null && filter.city!.isNotEmpty) {
      gyms = gyms.where((g) => g.city.toLowerCase() == filter.city!.toLowerCase()).toList();
    }
    if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
      final query = filter.searchQuery!.toLowerCase();
      gyms = gyms.where((g) => 
        g.name.toLowerCase().contains(query) ||
        g.address.toLowerCase().contains(query)
      ).toList();
    }
    
    // Apply sorting
    gyms = _sortGyms(gyms, filter.sortBy, filter.sortAscending);
    
    // Apply pagination
    final totalCount = gyms.length;
    final totalPages = (totalCount / filter.pageSize).ceil();
    final startIndex = (filter.page - 1) * filter.pageSize;
    final endIndex = (startIndex + filter.pageSize).clamp(0, totalCount);
    
    final paginatedGyms = startIndex < totalCount 
        ? gyms.sublist(startIndex, endIndex) 
        : <AdminGym>[];
    
    return PaginatedGyms(
      gyms: paginatedGyms,
      totalCount: totalCount,
      currentPage: filter.page,
      totalPages: totalPages,
      hasMore: filter.page < totalPages,
    );
  }

  /// Get mock gym by ID
  Future<AdminGym?> getGymById(String gymId) async {
    await Future.delayed(_delay);
    try {
      return _mockGyms.firstWhere((g) => g.id == gymId);
    } catch (_) {
      return null;
    }
  }

  /// Get available cities
  Future<List<AvailableCity>> getAvailableCities() async {
    await Future.delayed(_delay);
    return const [
      AvailableCity(id: 'cairo', name: 'Cairo', country: 'Egypt'),
      AvailableCity(id: 'alexandria', name: 'Alexandria', country: 'Egypt'),
      AvailableCity(id: 'giza', name: 'Giza', country: 'Egypt'),
      AvailableCity(id: 'mansoura', name: 'Mansoura', country: 'Egypt'),
      AvailableCity(id: 'tanta', name: 'Tanta', country: 'Egypt'),
      AvailableCity(id: 'aswan', name: 'Aswan', country: 'Egypt'),
      AvailableCity(id: 'luxor', name: 'Luxor', country: 'Egypt'),
    ];
  }

  /// Get available facilities
  Future<List<AvailableFacility>> getAvailableFacilities() async {
    await Future.delayed(_delay);
    return const [
      AvailableFacility(id: 'gym', name: 'Gym Equipment', icon: 'fitness_center', category: 'Equipment'),
      AvailableFacility(id: 'cardio', name: 'Cardio Zone', icon: 'directions_run', category: 'Equipment'),
      AvailableFacility(id: 'weights', name: 'Free Weights', icon: 'fitness_center', category: 'Equipment'),
      AvailableFacility(id: 'pool', name: 'Swimming Pool', icon: 'pool', category: 'Amenities'),
      AvailableFacility(id: 'sauna', name: 'Sauna', icon: 'hot_tub', category: 'Amenities'),
      AvailableFacility(id: 'steam', name: 'Steam Room', icon: 'spa', category: 'Amenities'),
      AvailableFacility(id: 'locker', name: 'Lockers', icon: 'lock', category: 'Amenities'),
      AvailableFacility(id: 'shower', name: 'Showers', icon: 'shower', category: 'Amenities'),
      AvailableFacility(id: 'parking', name: 'Parking', icon: 'local_parking', category: 'Amenities'),
      AvailableFacility(id: 'wifi', name: 'WiFi', icon: 'wifi', category: 'Amenities'),
      AvailableFacility(id: 'cafe', name: 'Cafe/Juice Bar', icon: 'local_cafe', category: 'Services'),
      AvailableFacility(id: 'pt', name: 'Personal Training', icon: 'person', category: 'Services'),
      AvailableFacility(id: 'classes', name: 'Group Classes', icon: 'groups', category: 'Services'),
      AvailableFacility(id: 'yoga', name: 'Yoga Studio', icon: 'self_improvement', category: 'Classes'),
      AvailableFacility(id: 'spinning', name: 'Spinning', icon: 'pedal_bike', category: 'Classes'),
      AvailableFacility(id: 'crossfit', name: 'CrossFit', icon: 'sports_gymnastics', category: 'Classes'),
    ];
  }

  /// Get mock revenue report
  Future<GymRevenueReport> getGymRevenueReport(
    String gymId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    await Future.delayed(_delay);
    final gym = _mockGyms.firstWhere((g) => g.id == gymId, orElse: () => _mockGyms.first);
    
    return GymRevenueReport(
      gymId: gymId,
      gymName: gym.name,
      startDate: startDate,
      endDate: endDate,
      totalRevenue: 45000.0,
      platformShare: 13500.0,
      gymShare: 31500.0,
      totalVisits: 850,
      uniqueVisitors: 320,
      dailyBreakdown: List.generate(7, (i) => DailyRevenue(
        date: DateTime.now().subtract(Duration(days: 6 - i)),
        revenue: 5000.0 + (i * 500),
        visits: 100 + (i * 15),
      )),
      bundleBreakdown: const [
        BundleRevenue(bundleName: 'Basic Monthly', tier: BundleTier.basic, revenue: 15000.0, subscriptionCount: 50),
        BundleRevenue(bundleName: 'Plus Monthly', tier: BundleTier.plus, revenue: 18000.0, subscriptionCount: 30),
        BundleRevenue(bundleName: 'Premium Monthly', tier: BundleTier.premium, revenue: 12000.0, subscriptionCount: 12),
      ],
    );
  }

  List<AdminGym> _sortGyms(List<AdminGym> gyms, AdminGymSortBy sortBy, bool ascending) {
    final sorted = List<AdminGym>.from(gyms);
    sorted.sort((a, b) {
      int comparison;
      switch (sortBy) {
        case AdminGymSortBy.name:
          comparison = a.name.compareTo(b.name);
          break;
        case AdminGymSortBy.city:
          comparison = a.city.compareTo(b.city);
          break;
        case AdminGymSortBy.status:
          comparison = a.status.index.compareTo(b.status.index);
          break;
        case AdminGymSortBy.dateAdded:
          comparison = a.dateAdded.compareTo(b.dateAdded);
          break;
        case AdminGymSortBy.totalVisits:
          comparison = a.stats.totalVisits.compareTo(b.stats.totalVisits);
          break;
        case AdminGymSortBy.revenue:
          comparison = a.stats.totalRevenue.compareTo(b.stats.totalRevenue);
          break;
        case AdminGymSortBy.rating:
          comparison = a.stats.averageRating.compareTo(b.stats.averageRating);
          break;
      }
      return ascending ? comparison : -comparison;
    });
    return sorted;
  }

  /// Mock gyms data
  static final List<AdminGym> _mockGyms = [
    AdminGym(
      id: 'gym_001',
      name: 'Gold\'s Gym Cairo',
      city: 'Cairo',
      address: '123 Tahrir Square, Downtown Cairo',
      latitude: 30.0444,
      longitude: 31.2357,
      status: GymStatus.active,
      dateAdded: DateTime.now().subtract(const Duration(days: 365)),
      lastUpdated: DateTime.now().subtract(const Duration(days: 5)),
      imageUrls: ['https://picsum.photos/seed/gym1/800/600'],
      facilities: const [
        AdminFacility(id: 'gym', name: 'Gym Equipment', icon: 'fitness_center'),
        AdminFacility(id: 'cardio', name: 'Cardio Zone', icon: 'directions_run'),
        AdminFacility(id: 'pool', name: 'Swimming Pool', icon: 'pool'),
        AdminFacility(id: 'sauna', name: 'Sauna', icon: 'hot_tub'),
      ],
      customBundles: const [
        AdminBundle(id: 'b1', name: 'Basic Monthly', tier: BundleTier.basic, duration: BundleDuration.monthly, price: 500.0, visitLimit: 12),
        AdminBundle(id: 'b2', name: 'Plus Monthly', tier: BundleTier.plus, duration: BundleDuration.monthly, price: 800.0, visitLimit: 20),
        AdminBundle(id: 'b3', name: 'Premium Unlimited', tier: BundleTier.premium, duration: BundleDuration.monthly, price: 1200.0),
      ],
      settings: const AdminGymSettings(
        dailyVisitLimit: 1,
        weeklyVisitLimit: 7,
        revenueSharePercent: 70.0,
        workingHours: [
          WorkingHoursEntry(dayOfWeek: 1, openTime: '06:00', closeTime: '23:00'),
          WorkingHoursEntry(dayOfWeek: 2, openTime: '06:00', closeTime: '23:00'),
          WorkingHoursEntry(dayOfWeek: 3, openTime: '06:00', closeTime: '23:00'),
          WorkingHoursEntry(dayOfWeek: 4, openTime: '06:00', closeTime: '23:00'),
          WorkingHoursEntry(dayOfWeek: 5, openTime: '06:00', closeTime: '23:00'),
          WorkingHoursEntry(dayOfWeek: 6, openTime: '08:00', closeTime: '22:00'),
          WorkingHoursEntry(dayOfWeek: 7, openTime: '08:00', closeTime: '20:00'),
        ],
        allowGuestCheckIn: true,
        maxConcurrentVisitors: 150,
      ),
      stats: const AdminGymStats(
        totalVisits: 15420,
        visitsThisMonth: 1250,
        activeSubscribers: 320,
        totalRevenue: 456000.0,
        revenueThisMonth: 38500.0,
        averageRating: 4.7,
        totalReviews: 284,
      ),
      partnerEmail: 'manager@goldsgym-cairo.com',
      partnerPhone: '+20 123 456 7890',
    ),
    AdminGym(
      id: 'gym_002',
      name: 'FitZone Alexandria',
      city: 'Alexandria',
      address: '45 Corniche Road, Stanley',
      latitude: 31.2001,
      longitude: 29.9187,
      status: GymStatus.active,
      dateAdded: DateTime.now().subtract(const Duration(days: 280)),
      lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
      imageUrls: ['https://picsum.photos/seed/gym2/800/600'],
      facilities: const [
        AdminFacility(id: 'gym', name: 'Gym Equipment', icon: 'fitness_center'),
        AdminFacility(id: 'cardio', name: 'Cardio Zone', icon: 'directions_run'),
        AdminFacility(id: 'yoga', name: 'Yoga Studio', icon: 'self_improvement'),
      ],
      customBundles: const [
        AdminBundle(id: 'b1', name: 'Basic Monthly', tier: BundleTier.basic, duration: BundleDuration.monthly, price: 400.0, visitLimit: 12),
        AdminBundle(id: 'b2', name: 'Plus Monthly', tier: BundleTier.plus, duration: BundleDuration.monthly, price: 650.0, visitLimit: 20),
      ],
      settings: const AdminGymSettings(
        dailyVisitLimit: 1,
        weeklyVisitLimit: 5,
        revenueSharePercent: 65.0,
        workingHours: [
          WorkingHoursEntry(dayOfWeek: 1, openTime: '07:00', closeTime: '22:00'),
          WorkingHoursEntry(dayOfWeek: 2, openTime: '07:00', closeTime: '22:00'),
          WorkingHoursEntry(dayOfWeek: 3, openTime: '07:00', closeTime: '22:00'),
          WorkingHoursEntry(dayOfWeek: 4, openTime: '07:00', closeTime: '22:00'),
          WorkingHoursEntry(dayOfWeek: 5, openTime: '07:00', closeTime: '22:00'),
          WorkingHoursEntry(dayOfWeek: 6, openTime: '09:00', closeTime: '20:00'),
          WorkingHoursEntry(dayOfWeek: 7, openTime: '09:00', closeTime: '18:00'),
        ],
        allowGuestCheckIn: false,
        maxConcurrentVisitors: 80,
      ),
      stats: const AdminGymStats(
        totalVisits: 8750,
        visitsThisMonth: 720,
        activeSubscribers: 185,
        totalRevenue: 234000.0,
        revenueThisMonth: 19500.0,
        averageRating: 4.5,
        totalReviews: 156,
      ),
      partnerEmail: 'info@fitzone-alex.com',
      partnerPhone: '+20 111 222 3333',
    ),
    AdminGym(
      id: 'gym_003',
      name: 'PowerHouse Giza',
      city: 'Giza',
      address: '78 Pyramids Road, Haram',
      latitude: 29.9765,
      longitude: 31.1313,
      status: GymStatus.active,
      dateAdded: DateTime.now().subtract(const Duration(days: 200)),
      lastUpdated: DateTime.now().subtract(const Duration(days: 10)),
      imageUrls: ['https://picsum.photos/seed/gym3/800/600'],
      facilities: const [
        AdminFacility(id: 'gym', name: 'Gym Equipment', icon: 'fitness_center'),
        AdminFacility(id: 'weights', name: 'Free Weights', icon: 'fitness_center'),
        AdminFacility(id: 'crossfit', name: 'CrossFit', icon: 'sports_gymnastics'),
      ],
      customBundles: const [
        AdminBundle(id: 'b1', name: 'Basic Monthly', tier: BundleTier.basic, duration: BundleDuration.monthly, price: 350.0, visitLimit: 10),
      ],
      settings: const AdminGymSettings(
        dailyVisitLimit: 1,
        weeklyVisitLimit: 4,
        revenueSharePercent: 60.0,
        workingHours: [
          WorkingHoursEntry(dayOfWeek: 1, openTime: '05:00', closeTime: '24:00'),
          WorkingHoursEntry(dayOfWeek: 2, openTime: '05:00', closeTime: '24:00'),
          WorkingHoursEntry(dayOfWeek: 3, openTime: '05:00', closeTime: '24:00'),
          WorkingHoursEntry(dayOfWeek: 4, openTime: '05:00', closeTime: '24:00'),
          WorkingHoursEntry(dayOfWeek: 5, openTime: '05:00', closeTime: '24:00'),
          WorkingHoursEntry(dayOfWeek: 6, openTime: '06:00', closeTime: '22:00'),
          WorkingHoursEntry(dayOfWeek: 7, openTime: '08:00', closeTime: '20:00'),
        ],
        allowGuestCheckIn: true,
        maxConcurrentVisitors: 100,
      ),
      stats: const AdminGymStats(
        totalVisits: 6200,
        visitsThisMonth: 580,
        activeSubscribers: 145,
        totalRevenue: 178000.0,
        revenueThisMonth: 15200.0,
        averageRating: 4.3,
        totalReviews: 98,
      ),
      partnerEmail: 'contact@powerhouse-giza.com',
      partnerPhone: '+20 100 555 6666',
    ),
    AdminGym(
      id: 'gym_004',
      name: 'Elite Fitness Maadi',
      city: 'Cairo',
      address: '15 Road 9, Maadi',
      latitude: 29.9602,
      longitude: 31.2569,
      status: GymStatus.pending,
      dateAdded: DateTime.now().subtract(const Duration(days: 7)),
      imageUrls: ['https://picsum.photos/seed/gym4/800/600'],
      facilities: const [
        AdminFacility(id: 'gym', name: 'Gym Equipment', icon: 'fitness_center'),
        AdminFacility(id: 'cardio', name: 'Cardio Zone', icon: 'directions_run'),
        AdminFacility(id: 'pool', name: 'Swimming Pool', icon: 'pool'),
        AdminFacility(id: 'spa', name: 'Spa', icon: 'spa'),
      ],
      customBundles: const [],
      settings: const AdminGymSettings(),
      stats: const AdminGymStats(),
      partnerEmail: 'elite.maadi@email.com',
      partnerPhone: '+20 122 333 4444',
      notes: 'New application - awaiting verification',
    ),
    AdminGym(
      id: 'gym_005',
      name: 'Flex Gym Nasr City',
      city: 'Cairo',
      address: '200 Abbas El Akkad St, Nasr City',
      latitude: 30.0511,
      longitude: 31.3656,
      status: GymStatus.pending,
      dateAdded: DateTime.now().subtract(const Duration(days: 3)),
      imageUrls: ['https://picsum.photos/seed/gym5/800/600'],
      facilities: const [
        AdminFacility(id: 'gym', name: 'Gym Equipment', icon: 'fitness_center'),
        AdminFacility(id: 'cardio', name: 'Cardio Zone', icon: 'directions_run'),
      ],
      customBundles: const [],
      settings: const AdminGymSettings(),
      stats: const AdminGymStats(),
      partnerEmail: 'flex.nasrcity@email.com',
      partnerPhone: '+20 155 666 7777',
      notes: 'Pending documentation review',
    ),
    AdminGym(
      id: 'gym_006',
      name: 'Iron Paradise',
      city: 'Cairo',
      address: '50 Mokattam Ring Road',
      latitude: 30.0084,
      longitude: 31.2988,
      status: GymStatus.blocked,
      dateAdded: DateTime.now().subtract(const Duration(days: 180)),
      lastUpdated: DateTime.now().subtract(const Duration(days: 15)),
      imageUrls: ['https://picsum.photos/seed/gym6/800/600'],
      facilities: const [
        AdminFacility(id: 'gym', name: 'Gym Equipment', icon: 'fitness_center'),
        AdminFacility(id: 'weights', name: 'Free Weights', icon: 'fitness_center'),
      ],
      customBundles: const [
        AdminBundle(id: 'b1', name: 'Basic Monthly', tier: BundleTier.basic, duration: BundleDuration.monthly, price: 300.0, visitLimit: 8),
      ],
      settings: const AdminGymSettings(
        dailyVisitLimit: 1,
        weeklyVisitLimit: 3,
        revenueSharePercent: 55.0,
      ),
      stats: const AdminGymStats(
        totalVisits: 2100,
        visitsThisMonth: 0,
        activeSubscribers: 0,
        totalRevenue: 45000.0,
        revenueThisMonth: 0.0,
        averageRating: 2.8,
        totalReviews: 42,
      ),
      partnerEmail: 'ironparadise@email.com',
      partnerPhone: '+20 188 999 0000',
      notes: 'Blocked due to multiple customer complaints and safety violations',
    ),
    AdminGym(
      id: 'gym_007',
      name: 'Sunrise Fitness Mansoura',
      city: 'Mansoura',
      address: '33 El Gomhouria St',
      latitude: 31.0409,
      longitude: 31.3785,
      status: GymStatus.active,
      dateAdded: DateTime.now().subtract(const Duration(days: 150)),
      lastUpdated: DateTime.now().subtract(const Duration(days: 20)),
      imageUrls: ['https://picsum.photos/seed/gym7/800/600'],
      facilities: const [
        AdminFacility(id: 'gym', name: 'Gym Equipment', icon: 'fitness_center'),
        AdminFacility(id: 'cardio', name: 'Cardio Zone', icon: 'directions_run'),
        AdminFacility(id: 'yoga', name: 'Yoga Studio', icon: 'self_improvement'),
        AdminFacility(id: 'locker', name: 'Lockers', icon: 'lock'),
      ],
      customBundles: const [
        AdminBundle(id: 'b1', name: 'Basic Monthly', tier: BundleTier.basic, duration: BundleDuration.monthly, price: 280.0, visitLimit: 10),
        AdminBundle(id: 'b2', name: 'Plus Quarterly', tier: BundleTier.plus, duration: BundleDuration.quarterly, price: 700.0, visitLimit: 36),
      ],
      settings: const AdminGymSettings(
        dailyVisitLimit: 1,
        weeklyVisitLimit: 5,
        revenueSharePercent: 65.0,
        workingHours: [
          WorkingHoursEntry(dayOfWeek: 1, openTime: '06:00', closeTime: '22:00'),
          WorkingHoursEntry(dayOfWeek: 2, openTime: '06:00', closeTime: '22:00'),
          WorkingHoursEntry(dayOfWeek: 3, openTime: '06:00', closeTime: '22:00'),
          WorkingHoursEntry(dayOfWeek: 4, openTime: '06:00', closeTime: '22:00'),
          WorkingHoursEntry(dayOfWeek: 5, openTime: '06:00', closeTime: '22:00'),
          WorkingHoursEntry(dayOfWeek: 6, openTime: '08:00', closeTime: '20:00'),
          WorkingHoursEntry(dayOfWeek: 7, openTime: '08:00', closeTime: '18:00'),
        ],
        allowGuestCheckIn: false,
        maxConcurrentVisitors: 60,
      ),
      stats: const AdminGymStats(
        totalVisits: 4350,
        visitsThisMonth: 420,
        activeSubscribers: 95,
        totalRevenue: 98000.0,
        revenueThisMonth: 9200.0,
        averageRating: 4.6,
        totalReviews: 78,
      ),
      partnerEmail: 'sunrise.mansoura@email.com',
      partnerPhone: '+20 133 444 5555',
    ),
    AdminGym(
      id: 'gym_008',
      name: 'Body Works Tanta',
      city: 'Tanta',
      address: '12 Said Street, Downtown',
      latitude: 30.7865,
      longitude: 31.0004,
      status: GymStatus.active,
      dateAdded: DateTime.now().subtract(const Duration(days: 90)),
      lastUpdated: DateTime.now().subtract(const Duration(days: 8)),
      imageUrls: ['https://picsum.photos/seed/gym8/800/600'],
      facilities: const [
        AdminFacility(id: 'gym', name: 'Gym Equipment', icon: 'fitness_center'),
        AdminFacility(id: 'cardio', name: 'Cardio Zone', icon: 'directions_run'),
      ],
      customBundles: const [
        AdminBundle(id: 'b1', name: 'Basic Monthly', tier: BundleTier.basic, duration: BundleDuration.monthly, price: 250.0, visitLimit: 8),
      ],
      settings: const AdminGymSettings(
        dailyVisitLimit: 1,
        weeklyVisitLimit: 4,
        revenueSharePercent: 60.0,
        allowGuestCheckIn: true,
        maxConcurrentVisitors: 40,
      ),
      stats: const AdminGymStats(
        totalVisits: 1850,
        visitsThisMonth: 310,
        activeSubscribers: 68,
        totalRevenue: 42000.0,
        revenueThisMonth: 7100.0,
        averageRating: 4.2,
        totalReviews: 35,
      ),
      partnerEmail: 'bodyworks.tanta@email.com',
      partnerPhone: '+20 144 777 8888',
    ),
    AdminGym(
      id: 'gym_009',
      name: 'Champions Gym Heliopolis',
      city: 'Cairo',
      address: '88 El Merghany St, Heliopolis',
      latitude: 30.0866,
      longitude: 31.3256,
      status: GymStatus.suspended,
      dateAdded: DateTime.now().subtract(const Duration(days: 250)),
      lastUpdated: DateTime.now().subtract(const Duration(days: 30)),
      imageUrls: ['https://picsum.photos/seed/gym9/800/600'],
      facilities: const [
        AdminFacility(id: 'gym', name: 'Gym Equipment', icon: 'fitness_center'),
        AdminFacility(id: 'cardio', name: 'Cardio Zone', icon: 'directions_run'),
        AdminFacility(id: 'pool', name: 'Swimming Pool', icon: 'pool'),
        AdminFacility(id: 'sauna', name: 'Sauna', icon: 'hot_tub'),
        AdminFacility(id: 'steam', name: 'Steam Room', icon: 'spa'),
      ],
      customBundles: const [
        AdminBundle(id: 'b1', name: 'Basic Monthly', tier: BundleTier.basic, duration: BundleDuration.monthly, price: 450.0, visitLimit: 12),
        AdminBundle(id: 'b2', name: 'Plus Monthly', tier: BundleTier.plus, duration: BundleDuration.monthly, price: 750.0, visitLimit: 20),
        AdminBundle(id: 'b3', name: 'Premium Yearly', tier: BundleTier.premium, duration: BundleDuration.yearly, price: 8000.0),
      ],
      settings: const AdminGymSettings(
        dailyVisitLimit: 1,
        weeklyVisitLimit: 7,
        revenueSharePercent: 70.0,
        allowGuestCheckIn: true,
        maxConcurrentVisitors: 120,
      ),
      stats: const AdminGymStats(
        totalVisits: 9800,
        visitsThisMonth: 0,
        activeSubscribers: 0,
        totalRevenue: 285000.0,
        revenueThisMonth: 0.0,
        averageRating: 4.4,
        totalReviews: 167,
      ),
      partnerEmail: 'champions.helio@email.com',
      partnerPhone: '+20 166 888 9999',
      notes: 'Suspended - undergoing renovation. Expected to reopen in 2 months.',
    ),
    AdminGym(
      id: 'gym_010',
      name: 'Wellness Hub 6th October',
      city: 'Giza',
      address: '25 Central Axis, 6th October City',
      latitude: 29.9285,
      longitude: 30.9188,
      status: GymStatus.active,
      dateAdded: DateTime.now().subtract(const Duration(days: 120)),
      lastUpdated: DateTime.now().subtract(const Duration(days: 3)),
      imageUrls: ['https://picsum.photos/seed/gym10/800/600'],
      facilities: const [
        AdminFacility(id: 'gym', name: 'Gym Equipment', icon: 'fitness_center'),
        AdminFacility(id: 'cardio', name: 'Cardio Zone', icon: 'directions_run'),
        AdminFacility(id: 'yoga', name: 'Yoga Studio', icon: 'self_improvement'),
        AdminFacility(id: 'spinning', name: 'Spinning', icon: 'pedal_bike'),
        AdminFacility(id: 'cafe', name: 'Juice Bar', icon: 'local_cafe'),
      ],
      customBundles: const [
        AdminBundle(id: 'b1', name: 'Basic Monthly', tier: BundleTier.basic, duration: BundleDuration.monthly, price: 380.0, visitLimit: 10),
        AdminBundle(id: 'b2', name: 'Plus Monthly', tier: BundleTier.plus, duration: BundleDuration.monthly, price: 620.0, visitLimit: 16),
        AdminBundle(id: 'b3', name: 'Premium Monthly', tier: BundleTier.premium, duration: BundleDuration.monthly, price: 950.0),
      ],
      settings: const AdminGymSettings(
        dailyVisitLimit: 1,
        weeklyVisitLimit: 6,
        revenueSharePercent: 68.0,
        workingHours: [
          WorkingHoursEntry(dayOfWeek: 1, openTime: '05:30', closeTime: '23:30'),
          WorkingHoursEntry(dayOfWeek: 2, openTime: '05:30', closeTime: '23:30'),
          WorkingHoursEntry(dayOfWeek: 3, openTime: '05:30', closeTime: '23:30'),
          WorkingHoursEntry(dayOfWeek: 4, openTime: '05:30', closeTime: '23:30'),
          WorkingHoursEntry(dayOfWeek: 5, openTime: '05:30', closeTime: '23:30'),
          WorkingHoursEntry(dayOfWeek: 6, openTime: '07:00', closeTime: '22:00'),
          WorkingHoursEntry(dayOfWeek: 7, openTime: '07:00', closeTime: '20:00'),
        ],
        allowGuestCheckIn: true,
        maxConcurrentVisitors: 90,
      ),
      stats: const AdminGymStats(
        totalVisits: 5680,
        visitsThisMonth: 520,
        activeSubscribers: 142,
        totalRevenue: 156000.0,
        revenueThisMonth: 14800.0,
        averageRating: 4.8,
        totalReviews: 112,
      ),
      partnerEmail: 'wellness.october@email.com',
      partnerPhone: '+20 177 000 1111',
    ),
  ];
}