import 'package:injectable/injectable.dart';

import '../../domain/entities/partner_entities.dart';

@lazySingleton
class PartnerLocalDataSource {
  PartnerLocalDataSource() {
    _seedDummyData();
  }

  late PartnerSettings _settings;
  late final PartnerReport _dailyReport;
  late final PartnerReport _weeklyReport;
  
  // Blocked users storage (mutable for demo)
  final Map<String, List<BlockedUser>> _blockedUsers = {};

  void _seedDummyData() {
    // Working hours: كل الأيام من 6AM لـ 11PM
    final workingHours = GymWorkingHours(
      schedule: {
        for (var d = 1; d <= 7; d++)
          d: const DaySchedule(
            openHour: 6,
            openMinute: 0,
            closeHour: 23,
            closeMinute: 0,
          ),
      },
    );

    // Seed some blocked users for demo
    _blockedUsers['gym_1'] = [
      BlockedUser(
        visitorId: 'user_blocked_1',
        visitorName: 'Ahmed Mohamed',
        reason: 'Violated gym rules - damaged equipment',
        blockedAt: DateTime.now().subtract(const Duration(days: 15)),
        blockedBy: 'Manager',
      ),
      BlockedUser(
        visitorId: 'user_blocked_2',
        visitorName: 'Sara Ali',
        reason: 'Membership fraud attempt',
        blockedAt: DateTime.now().subtract(const Duration(days: 7)),
        blockedBy: 'System',
      ),
      BlockedUser(
        visitorId: 'user_blocked_3',
        visitorName: 'Mohamed Hassan',
        reason: 'Repeated policy violations',
        blockedAt: DateTime.now().subtract(const Duration(days: 3)),
        blockedBy: 'Manager',
      ),
    ];

    // Initialize settings with blocked user IDs from the blocked users list
    _settings = PartnerSettings(
      gymId: 'gym_1',
      revenueSharePercentage: 70,
      maxDailyVisitsPerUser: 2,
      maxWeeklyVisitsPerUser: 10,
      allowNetworkSubscriptions: true,
      blockedUserIds: _blockedUsers['gym_1']!.map((u) => u.visitorId).toList(),
      workingHours: workingHours,
      autoUpdateOccupancy: true,
      maxCapacity: 80,
    );

    final now = DateTime.now();

    // Daily report (اليوم)
    _dailyReport = PartnerReport(
      gymId: 'gym_1',
      gymName: 'Downtown Fitness',
      reportDate: now,
      period: ReportPeriod.daily,
      visitSummary: VisitSummary(
        totalVisits: 120,
        uniqueVisitors: 80,
        averageVisitsPerUser: 1.5,
        previousPeriodVisits: 100,
        growthPercentage: 20,
        visitsBySubscriptionType: const {
          'Basic': 40,
          'Plus': 50,
          'Premium': 30,
        },
      ),
      revenueSummary: RevenueSummary(
        totalRevenue: 8500,
        revenueShare: 0.7,
        netRevenue: 5950,
        previousPeriodRevenue: 7000,
        growthPercentage: 21.4,
        currency: 'EGP',
        revenueByBundle: const {
          'Monthly Plus': 5000,
          'Monthly Premium': 3500,
        },
      ),
      dailyStats: [
        DailyStats(
          date: now,
          visits: 120,
          revenue: 8500,
          newUsers: 10,
          averageOccupancy: 0.65,
        ),
      ],
      peakHours: const [
        PeakHourData(
          hour: 7,
          dayOfWeek: 1,
          averageVisits: 20,
          averageOccupancy: 0.8,
          isRecommendedPromo: false,
        ),
        PeakHourData(
          hour: 18,
          dayOfWeek: 1,
          averageVisits: 30,
          averageOccupancy: 0.9,
          isRecommendedPromo: true,
        ),
      ],
      userRetention: const UserRetention(
        totalActiveUsers: 420,
        newUsersThisPeriod: 25,
        returningUsers: 395,
        retentionRate: 85,
        churnRate: 5,
        visitFrequencyDistribution: {
          1: 50,
          2: 80,
          4: 120,
          8: 100,
          12: 70,
        },
      ),
    );

    // Weekly report (7 أيام)
    final weekDates = List.generate(
      7,
      (i) => DateTime(now.year, now.month, now.day - (6 - i)),
    );

    final weeklyDailyStats = weekDates
        .map(
          (d) => DailyStats(
            date: d,
            visits: 80 + (d.day % 5) * 10,
            revenue: 5000 + (d.day % 5) * 700,
            newUsers: 3 + (d.day % 3),
            averageOccupancy: 0.5 + (d.day % 3) * 0.1,
          ),
        )
        .toList();

    _weeklyReport = PartnerReport(
      gymId: 'gym_1',
      gymName: 'Downtown Fitness',
      reportDate: now,
      period: ReportPeriod.weekly,
      visitSummary: const VisitSummary(
        totalVisits: 600,
        uniqueVisitors: 320,
        averageVisitsPerUser: 1.9,
        previousPeriodVisits: 540,
        growthPercentage: 11.1,
        visitsBySubscriptionType: {
          'Basic': 200,
          'Plus': 250,
          'Premium': 150,
        },
      ),
      revenueSummary: const RevenueSummary(
        totalRevenue: 42000,
        revenueShare: 0.7,
        netRevenue: 29400,
        previousPeriodRevenue: 38000,
        growthPercentage: 10.5,
        currency: 'EGP',
        revenueByBundle: {
          'Weekly Pass': 8000,
          'Monthly Plus': 20000,
          'Monthly Premium': 14000,
        },
      ),
      dailyStats: weeklyDailyStats,
      peakHours: _dailyReport.peakHours,
      userRetention: _dailyReport.userRetention,
    );
  }

  Future<PartnerSettings> getSettings(String gymId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _settings;
  }

  Future<PartnerReport> getReport({
    required String gymId,
    required ReportPeriod period,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    switch (period) {
      case ReportPeriod.daily:
        return _dailyReport;
      case ReportPeriod.weekly:
        return _weeklyReport;
      default:
        return _weeklyReport;
    }
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Settings Management
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Update full settings
  Future<void> updateSettings(PartnerSettings settings) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _settings = settings;
  }
  
  /// Update partial settings and return updated settings
  Future<PartnerSettings> updatePartialSettings({
    required String gymId,
    int? maxCapacity,
    bool? autoUpdateOccupancy,
    bool? allowNetworkSubscriptions,
    int? maxDailyVisitsPerUser,
    int? maxWeeklyVisitsPerUser,
    GymWorkingHours? workingHours,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    _settings = PartnerSettings(
      gymId: _settings.gymId,
      revenueSharePercentage: _settings.revenueSharePercentage,
      maxDailyVisitsPerUser: maxDailyVisitsPerUser ?? _settings.maxDailyVisitsPerUser,
      maxWeeklyVisitsPerUser: maxWeeklyVisitsPerUser ?? _settings.maxWeeklyVisitsPerUser,
      allowNetworkSubscriptions: allowNetworkSubscriptions ?? _settings.allowNetworkSubscriptions,
      blockedUserIds: _settings.blockedUserIds,
      workingHours: workingHours ?? _settings.workingHours,
      autoUpdateOccupancy: autoUpdateOccupancy ?? _settings.autoUpdateOccupancy,
      maxCapacity: maxCapacity ?? _settings.maxCapacity,
    );
    
    return _settings;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Blocked Users Management
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Get all blocked users for a gym
  Future<List<BlockedUser>> getBlockedUsers(String gymId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _blockedUsers[gymId] ?? [];
  }
  
  /// Block a user
  Future<void> blockUser({
    required String gymId,
    required String visitorId,
    required String visitorName,
    String? reason,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final blockedUser = BlockedUser(
      visitorId: visitorId,
      visitorName: visitorName,
      reason: reason,
      blockedAt: DateTime.now(),
      blockedBy: 'Partner', // In real app, get from auth
    );
    
    _blockedUsers.putIfAbsent(gymId, () => []);
    
    // Check if already blocked
    final existingIndex = _blockedUsers[gymId]!
        .indexWhere((u) => u.visitorId == visitorId);
    
    if (existingIndex == -1) {
      _blockedUsers[gymId]!.add(blockedUser);
    }
    
    // Also update settings blocked list
    final currentBlockedIds = List<String>.from(_settings.blockedUserIds);
    if (!currentBlockedIds.contains(visitorId)) {
      currentBlockedIds.add(visitorId);
      _settings = PartnerSettings(
        gymId: _settings.gymId,
        revenueSharePercentage: _settings.revenueSharePercentage,
        maxDailyVisitsPerUser: _settings.maxDailyVisitsPerUser,
        maxWeeklyVisitsPerUser: _settings.maxWeeklyVisitsPerUser,
        allowNetworkSubscriptions: _settings.allowNetworkSubscriptions,
        blockedUserIds: currentBlockedIds,
        workingHours: _settings.workingHours,
        autoUpdateOccupancy: _settings.autoUpdateOccupancy,
        maxCapacity: _settings.maxCapacity,
      );
    }
  }
  
  /// Unblock a user
  Future<void> unblockUser({
    required String gymId,
    required String visitorId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    _blockedUsers[gymId]?.removeWhere((u) => u.visitorId == visitorId);
    
    // Also update settings blocked list
    final currentBlockedIds = List<String>.from(_settings.blockedUserIds);
    currentBlockedIds.remove(visitorId);
    _settings = PartnerSettings(
      gymId: _settings.gymId,
      revenueSharePercentage: _settings.revenueSharePercentage,
      maxDailyVisitsPerUser: _settings.maxDailyVisitsPerUser,
      maxWeeklyVisitsPerUser: _settings.maxWeeklyVisitsPerUser,
      allowNetworkSubscriptions: _settings.allowNetworkSubscriptions,
      blockedUserIds: currentBlockedIds,
      workingHours: _settings.workingHours,
      autoUpdateOccupancy: _settings.autoUpdateOccupancy,
      maxCapacity: _settings.maxCapacity,
    );
  }
}