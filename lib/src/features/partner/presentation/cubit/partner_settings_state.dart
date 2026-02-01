// lib/src/features/partner/presentation/cubit/partner_settings_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/partner_entities.dart';

part 'partner_settings_state.freezed.dart';

@freezed
class PartnerSettingsState with _$PartnerSettingsState {
  const factory PartnerSettingsState({
    // Original settings from repository (for comparison)
    PartnerSettings? originalSettings,
    
    // Current editing settings
    PartnerSettings? settings,
    GymWorkingHours? editingWorkingHours,
    
    // Editing values (track changes before save)
    int? editingMaxCapacity,
    bool? editingAutoUpdateOccupancy,
    bool? editingAllowNetworkSubscriptions,
    int? editingMaxDailyVisits,
    int? editingMaxWeeklyVisits,
    
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
  
  /// Check if there are any unsaved changes
  bool get hasUnsavedChanges {
    if (originalSettings == null || settings == null) return false;
    
    // Check working hours changes
    if (editingWorkingHours != null) {
      final originalSchedule = originalSettings!.workingHours.schedule;
      final editingSchedule = editingWorkingHours!.schedule;
      
      for (final day in originalSchedule.keys) {
        final original = originalSchedule[day];
        final editing = editingSchedule[day];
        if (original?.openHour != editing?.openHour ||
            original?.openMinute != editing?.openMinute ||
            original?.closeHour != editing?.closeHour ||
            original?.closeMinute != editing?.closeMinute ||
            original?.isClosed != editing?.isClosed) {
          return true;
        }
      }
    }
    
    // Check capacity changes
    if (editingMaxCapacity != null &&
        editingMaxCapacity != originalSettings!.maxCapacity) {
      return true;
    }
    
    // Check auto update occupancy changes
    if (editingAutoUpdateOccupancy != null &&
        editingAutoUpdateOccupancy != originalSettings!.autoUpdateOccupancy) {
      return true;
    }
    
    // Check network subscriptions changes
    if (editingAllowNetworkSubscriptions != null &&
        editingAllowNetworkSubscriptions != originalSettings!.allowNetworkSubscriptions) {
      return true;
    }
    
    // Check visit limits changes
    if (editingMaxDailyVisits != null &&
        editingMaxDailyVisits != originalSettings!.maxDailyVisitsPerUser) {
      return true;
    }
    
    if (editingMaxWeeklyVisits != null &&
        editingMaxWeeklyVisits != originalSettings!.maxWeeklyVisitsPerUser) {
      return true;
    }
    
    return false;
  }
  
  /// Get the current max capacity value (edited or original)
  int get currentMaxCapacity =>
      editingMaxCapacity ?? settings?.maxCapacity ?? 0;
  
  /// Get the current auto update occupancy value (edited or original)
  bool get currentAutoUpdateOccupancy =>
      editingAutoUpdateOccupancy ?? settings?.autoUpdateOccupancy ?? false;
  
  /// Get the current allow network subscriptions value (edited or original)
  bool get currentAllowNetworkSubscriptions =>
      editingAllowNetworkSubscriptions ?? settings?.allowNetworkSubscriptions ?? true;
  
  /// Get the current max daily visits value (edited or original)
  int get currentMaxDailyVisits =>
      editingMaxDailyVisits ?? settings?.maxDailyVisitsPerUser ?? 1;
  
  /// Get the current max weekly visits value (edited or original)
  int get currentMaxWeeklyVisits =>
      editingMaxWeeklyVisits ?? settings?.maxWeeklyVisitsPerUser ?? 7;
}

enum PartnerSettingsStatus {
  initial,
  loading,
  success,
  failure,
}