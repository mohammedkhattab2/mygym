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
}