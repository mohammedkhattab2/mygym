import 'package:mygym/src/features/partner/domain/entities/partner_entities.dart';

abstract class PartnerRepository {
  Future<PartnerReport> getReport({
    required String gymId,
    required ReportPeriod period,
  });

  Future<PartnerSettings> getSettings({required String gymId});

  // Helpers (تستخدم gymId افتراضي للـ partner الحالي)
  Future<PartnerReport> getMyGymReport(ReportPeriod period);
  Future<PartnerSettings> getMyGymSettings();
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Settings Management
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Update gym settings
  Future<void> updateSettings(PartnerSettings settings);
  
  /// Update only specific settings fields
  Future<PartnerSettings> updatePartialSettings({
    required String gymId,
    int? maxCapacity,
    bool? autoUpdateOccupancy,
    bool? allowNetworkSubscriptions,
    int? maxDailyVisitsPerUser,
    int? maxWeeklyVisitsPerUser,
    GymWorkingHours? workingHours,
  });
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Blocked Users Management
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Get list of blocked users for a gym
  Future<List<BlockedUser>> getBlockedUsers({required String gymId});
  
  /// Get blocked users for current partner's gym
  Future<List<BlockedUser>> getMyGymBlockedUsers();
  
  /// Block a user from the gym
  Future<void> blockUser({
    required String gymId,
    required String visitorId,
    required String visitorName,
    String? reason,
  });
  
  /// Unblock a user from the gym
  Future<void> unblockUser({
    required String gymId,
    required String visitorId,
  });
  
  /// Block user for current partner's gym
  Future<void> blockUserFromMyGym({
    required String visitorId,
    required String visitorName,
    String? reason,
  });
  
  /// Unblock user from current partner's gym
  Future<void> unblockUserFromMyGym({required String visitorId});
}