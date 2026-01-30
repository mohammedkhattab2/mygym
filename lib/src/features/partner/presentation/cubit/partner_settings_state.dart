// lib/src/features/partner/presentation/cubit/partner_settings_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/partner_entities.dart';

part 'partner_settings_state.freezed.dart';

@freezed
class PartnerSettingsState with _$PartnerSettingsState {
  const factory PartnerSettingsState({
    // Settings data
    PartnerSettings? settings,
    GymWorkingHours? editingWorkingHours,
    
    // Status
    @Default(PartnerSettingsStatus.initial) PartnerSettingsStatus loadStatus,
    @Default(PartnerSettingsStatus.initial) PartnerSettingsStatus saveStatus,
    
    // Error
    String? errorMessage,
    String? successMessage,
  }) = _PartnerSettingsState;

  const PartnerSettingsState._();

  bool get isLoading => loadStatus == PartnerSettingsStatus.loading;
  bool get isSaving => saveStatus == PartnerSettingsStatus.loading;
}

enum PartnerSettingsStatus {
  initial,
  loading,
  success,
  failure,
}