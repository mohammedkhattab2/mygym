import 'package:injectable/injectable.dart';

import '../../domain/entities/partner_entities.dart';
import '../../domain/repositories/partner_repository.dart';
import '../datasources/partner_local_data_source.dart';

@LazySingleton(as: PartnerRepository)
class PartnerRepositoryImpl implements PartnerRepository {
  final PartnerLocalDataSource _local;

  PartnerRepositoryImpl(this._local);

  // مؤقتًا gymId ثابت لحد ما نربطه بـ Auth / اختيار الجيم
  static const _dummyGymId = 'gym_1';

  @override
  Future<PartnerReport> getReport({
    required String gymId,
    required ReportPeriod period,
  }) {
    return _local.getReport(gymId: gymId, period: period);
  }

  @override
  Future<PartnerSettings> getSettings({required String gymId}) {
    return _local.getSettings(gymId);
  }

  // helpers لو حبيت تستعمل gymId ثابت بسرعة
  @override
  Future<PartnerReport> getMyGymReport(ReportPeriod period) {
    return getReport(gymId: _dummyGymId, period: period);
  }

  @override
  Future<PartnerSettings> getMyGymSettings() {
    return getSettings(gymId: _dummyGymId);
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Settings Management
  // ═══════════════════════════════════════════════════════════════════════════
  
  @override
  Future<void> updateSettings(PartnerSettings settings) {
    return _local.updateSettings(settings);
  }
  
  @override
  Future<PartnerSettings> updatePartialSettings({
    required String gymId,
    int? maxCapacity,
    bool? autoUpdateOccupancy,
    bool? allowNetworkSubscriptions,
    int? maxDailyVisitsPerUser,
    int? maxWeeklyVisitsPerUser,
    GymWorkingHours? workingHours,
  }) {
    return _local.updatePartialSettings(
      gymId: gymId,
      maxCapacity: maxCapacity,
      autoUpdateOccupancy: autoUpdateOccupancy,
      allowNetworkSubscriptions: allowNetworkSubscriptions,
      maxDailyVisitsPerUser: maxDailyVisitsPerUser,
      maxWeeklyVisitsPerUser: maxWeeklyVisitsPerUser,
      workingHours: workingHours,
    );
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Blocked Users Management
  // ═══════════════════════════════════════════════════════════════════════════
  
  @override
  Future<List<BlockedUser>> getBlockedUsers({required String gymId}) {
    return _local.getBlockedUsers(gymId);
  }
  
  @override
  Future<List<BlockedUser>> getMyGymBlockedUsers() {
    return getBlockedUsers(gymId: _dummyGymId);
  }
  
  @override
  Future<void> blockUser({
    required String gymId,
    required String visitorId,
    required String visitorName,
    String? reason,
  }) {
    return _local.blockUser(
      gymId: gymId,
      visitorId: visitorId,
      visitorName: visitorName,
      reason: reason,
    );
  }
  
  @override
  Future<void> unblockUser({
    required String gymId,
    required String visitorId,
  }) {
    return _local.unblockUser(gymId: gymId, visitorId: visitorId);
  }
  
  @override
  Future<void> blockUserFromMyGym({
    required String visitorId,
    required String visitorName,
    String? reason,
  }) {
    return blockUser(
      gymId: _dummyGymId,
      visitorId: visitorId,
      visitorName: visitorName,
      reason: reason,
    );
  }
  
  @override
  Future<void> unblockUserFromMyGym({required String visitorId}) {
    return unblockUser(gymId: _dummyGymId, visitorId: visitorId);
  }
}