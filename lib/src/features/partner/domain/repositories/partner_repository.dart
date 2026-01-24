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
}