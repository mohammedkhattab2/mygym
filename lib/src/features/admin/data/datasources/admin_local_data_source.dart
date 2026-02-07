import 'package:injectable/injectable.dart';

import '../../domain/entities/admin_gym.dart';
import '../../domain/repositories/admin_repository.dart';

/// Local data source for admin dashboard with mock data
/// Used for development when backend is not available
@LazySingleton(env: [Environment.dev])
class AdminLocalDataSource {
  // Simulated delay for realistic UX
  static const _delay = Duration(milliseconds: 500);
  
  // Mutable list to allow adding new gyms
  static final List<AdminGym> _gyms = List.from(_initialMockGyms);

  /// Get mock dashboard statistics - calculated from actual mock data
  Future<AdminDashboardStats> getDashboardStats() async {
    await Future.delayed(_delay);
    
    // Calculate stats from actual mock gyms
    final totalGyms = _gyms.length;
    final activeGyms = _gyms.where((g) => g.status == GymStatus.active).length;
    final pendingGyms = _gyms.where((g) => g.status == GymStatus.pending).length;
    final blockedGyms = _gyms.where((g) => g.status == GymStatus.blocked).length;
    final suspendedGyms = _gyms.where((g) => g.status == GymStatus.suspended).length;
    
    // Calculate totals from gym stats
    double totalRevenue = 0;
    double revenueThisMonth = 0;
    int totalVisitsThisMonth = 0;
    int activeSubscribers = 0;
    
    for (final gym in _gyms) {
      totalRevenue += gym.stats.totalRevenue;
      revenueThisMonth += gym.stats.revenueThisMonth;
      totalVisitsThisMonth += gym.stats.visitsThisMonth;
      activeSubscribers += gym.stats.activeSubscribers;
    }
    
    // Calculate city breakdown from actual data
    final cityMap = <String, List<AdminGym>>{};
    for (final gym in _gyms) {
      cityMap.putIfAbsent(gym.city, () => []).add(gym);
    }
    
    final cityBreakdown = cityMap.entries.map((entry) {
      final cityGyms = entry.value;
      double cityRevenue = 0;
      int citySubscribers = 0;
      for (final gym in cityGyms) {
        cityRevenue += gym.stats.totalRevenue;
        citySubscribers += gym.stats.activeSubscribers;
      }
      return CityStats(
        city: entry.key,
        gymCount: cityGyms.length,
        userCount: citySubscribers,
        revenue: cityRevenue,
      );
    }).toList();
    
    return AdminDashboardStats(
      totalGyms: totalGyms,
      activeGyms: activeGyms,
      pendingGyms: pendingGyms,
      blockedGyms: blockedGyms,
      suspendedGyms: suspendedGyms,
      totalUsers: activeSubscribers,
      activeSubscriptions: activeSubscribers,
      totalRevenue: totalRevenue,
      revenueThisMonth: revenueThisMonth,
      totalVisitsToday: (totalVisitsThisMonth / 30).round(),
      totalVisitsThisWeek: (totalVisitsThisMonth / 4).round(),
      totalVisitsThisMonth: totalVisitsThisMonth,
      cityBreakdown: cityBreakdown,
    );
  }

  /// Get mock gyms list
  Future<PaginatedGyms> getGyms(AdminGymFilter filter) async {
    await Future.delayed(_delay);
    
    var gyms = _gyms;
    
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
      return _gyms.firstWhere((g) => g.id == gymId);
    } catch (_) {
      return null;
    }
  }

  /// Add new gym to local storage
  Future<AdminGym> addGym(GymFormData formData) async {
    await Future.delayed(_delay);
    
    // Generate a new ID
    final newId = 'gym_${DateTime.now().millisecondsSinceEpoch}';
    
    // Convert facilities from IDs to AdminFacility objects
    final allFacilities = await getAvailableFacilities();
    final selectedFacilities = formData.facilityIds
        .map((id) {
          try {
            final facility = allFacilities.firstWhere((f) => f.id == id);
            return AdminFacility(
              id: facility.id,
              name: facility.name,
              icon: facility.icon,
            );
          } catch (_) {
            return AdminFacility(id: id, name: id);
          }
        })
        .toList();
    
    final newGym = AdminGym(
      id: newId,
      name: formData.name,
      city: formData.city,
      address: formData.address,
      latitude: formData.latitude,
      longitude: formData.longitude,
      status: GymStatus.pending,
      dateAdded: DateTime.now(),
      imageUrls: formData.imageUrls,
      facilities: selectedFacilities,
      customBundles: formData.customBundles,
      settings: formData.settings,
      stats: const AdminGymStats(),
      partnerEmail: formData.partnerEmail,
      partnerPhone: formData.partnerPhone,
      notes: formData.notes,
    );
    
    // Add to the beginning of the list
    _gyms.insert(0, newGym);
    
    return newGym;
  }

  /// Update existing gym
  Future<AdminGym?> updateGym(String gymId, GymFormData formData) async {
    await Future.delayed(_delay);
    
    final index = _gyms.indexWhere((g) => g.id == gymId);
    if (index == -1) return null;
    
    final existingGym = _gyms[index];
    
    // Convert facilities from IDs to AdminFacility objects
    final allFacilities = await getAvailableFacilities();
    final selectedFacilities = formData.facilityIds
        .map((id) {
          try {
            final facility = allFacilities.firstWhere((f) => f.id == id);
            return AdminFacility(
              id: facility.id,
              name: facility.name,
              icon: facility.icon,
            );
          } catch (_) {
            return AdminFacility(id: id, name: id);
          }
        })
        .toList();
    
    final updatedGym = AdminGym(
      id: gymId,
      name: formData.name,
      city: formData.city,
      address: formData.address,
      latitude: formData.latitude,
      longitude: formData.longitude,
      status: existingGym.status,
      dateAdded: existingGym.dateAdded,
      lastUpdated: DateTime.now(),
      imageUrls: formData.imageUrls,
      facilities: selectedFacilities,
      customBundles: formData.customBundles,
      settings: formData.settings,
      stats: existingGym.stats,
      partnerEmail: formData.partnerEmail,
      partnerPhone: formData.partnerPhone,
      notes: formData.notes,
    );
    
    _gyms[index] = updatedGym;
    
    return updatedGym;
  }

  /// Delete gym
  Future<bool> deleteGym(String gymId) async {
    await Future.delayed(_delay);
    final index = _gyms.indexWhere((g) => g.id == gymId);
    if (index == -1) return false;
    _gyms.removeAt(index);
    return true;
  }

  /// Change gym status
  Future<AdminGym?> changeGymStatus(String gymId, GymStatus status) async {
    await Future.delayed(_delay);
    
    final index = _gyms.indexWhere((g) => g.id == gymId);
    if (index == -1) return null;
    
    final existingGym = _gyms[index];
    final updatedGym = AdminGym(
      id: existingGym.id,
      name: existingGym.name,
      city: existingGym.city,
      address: existingGym.address,
      latitude: existingGym.latitude,
      longitude: existingGym.longitude,
      status: status,
      dateAdded: existingGym.dateAdded,
      lastUpdated: DateTime.now(),
      imageUrls: existingGym.imageUrls,
      facilities: existingGym.facilities,
      customBundles: existingGym.customBundles,
      settings: existingGym.settings,
      stats: existingGym.stats,
      partnerEmail: existingGym.partnerEmail,
      partnerPhone: existingGym.partnerPhone,
      notes: existingGym.notes,
    );
    
    _gyms[index] = updatedGym;
    
    return updatedGym;
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
    final gym = _gyms.firstWhere((g) => g.id == gymId, orElse: () => _gyms.first);
    
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

  /// Initial mock gyms data
  static final List<AdminGym> _initialMockGyms = [
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