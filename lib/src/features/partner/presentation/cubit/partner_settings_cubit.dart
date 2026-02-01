// lib/src/features/partner/presentation/cubit/partner_settings_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/partner_entities.dart';
import '../../domain/repositories/partner_repository.dart';
import 'partner_settings_state.dart';

@injectable
class PartnerSettingsCubit extends Cubit<PartnerSettingsState> {
  final PartnerRepository _repository;

  PartnerSettingsCubit(this._repository) : super(const PartnerSettingsState());

  // ═══════════════════════════════════════════════════════════════════════════
  // Load Settings
  // ═══════════════════════════════════════════════════════════════════════════

  /// Load settings from repository
  Future<void> loadSettings() async {
    emit(state.copyWith(loadStatus: PartnerSettingsStatus.loading));

    try {
      final settings = await _repository.getMyGymSettings();
      
      emit(state.copyWith(
        loadStatus: PartnerSettingsStatus.success,
        settings: settings,
        originalSettings: settings,
        editingWorkingHours: settings.workingHours,
        // Reset all editing values
        editingMaxCapacity: null,
        editingAutoUpdateOccupancy: null,
        editingAllowNetworkSubscriptions: null,
        editingMaxDailyVisits: null,
        editingMaxWeeklyVisits: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        loadStatus: PartnerSettingsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Toggle Methods
  // ═══════════════════════════════════════════════════════════════════════════

  /// Toggle auto update occupancy setting
  void toggleAutoUpdateOccupancy(bool value) {
    emit(state.copyWith(editingAutoUpdateOccupancy: value));
  }

  /// Toggle allow network subscriptions setting
  void toggleAllowNetworkSubscriptions(bool value) {
    emit(state.copyWith(editingAllowNetworkSubscriptions: value));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Update Methods
  // ═══════════════════════════════════════════════════════════════════════════

  /// Update max capacity
  void updateMaxCapacity(int newCapacity) {
    if (newCapacity < 1) return;
    emit(state.copyWith(editingMaxCapacity: newCapacity));
  }

  /// Update max daily visits per user
  void updateMaxDailyVisits(int visits) {
    if (visits < 1) return;
    emit(state.copyWith(editingMaxDailyVisits: visits));
  }

  /// Update max weekly visits per user
  void updateMaxWeeklyVisits(int visits) {
    if (visits < 1) return;
    emit(state.copyWith(editingMaxWeeklyVisits: visits));
  }

  /// Update working hours for a specific day
  void updateDaySchedule(int dayOfWeek, DaySchedule schedule) {
    if (state.editingWorkingHours == null) return;

    final newSchedule = Map<int, DaySchedule>.from(state.editingWorkingHours!.schedule);
    newSchedule[dayOfWeek] = schedule;

    emit(state.copyWith(
      editingWorkingHours: GymWorkingHours(schedule: newSchedule),
    ));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Save & Discard
  // ═══════════════════════════════════════════════════════════════════════════

  /// Save all changes to repository
  Future<void> saveSettings() async {
    if (!state.hasUnsavedChanges) return;
    
    emit(state.copyWith(
      saveStatus: PartnerSettingsStatus.loading,
      successMessage: null,
      errorMessage: null,
    ));

    try {
      final updatedSettings = await _repository.updatePartialSettings(
        gymId: state.settings!.gymId,
        maxCapacity: state.editingMaxCapacity,
        autoUpdateOccupancy: state.editingAutoUpdateOccupancy,
        allowNetworkSubscriptions: state.editingAllowNetworkSubscriptions,
        maxDailyVisitsPerUser: state.editingMaxDailyVisits,
        maxWeeklyVisitsPerUser: state.editingMaxWeeklyVisits,
        workingHours: state.editingWorkingHours,
      );

      emit(state.copyWith(
        saveStatus: PartnerSettingsStatus.success,
        settings: updatedSettings,
        originalSettings: updatedSettings,
        editingWorkingHours: updatedSettings.workingHours,
        // Reset editing values after successful save
        editingMaxCapacity: null,
        editingAutoUpdateOccupancy: null,
        editingAllowNetworkSubscriptions: null,
        editingMaxDailyVisits: null,
        editingMaxWeeklyVisits: null,
        successMessage: 'Settings saved successfully!',
      ));
    } catch (e) {
      emit(state.copyWith(
        saveStatus: PartnerSettingsStatus.failure,
        errorMessage: 'Failed to save settings: ${e.toString()}',
      ));
    }
  }

  /// Discard all unsaved changes and reload from original
  void discardChanges() {
    if (state.originalSettings == null) return;
    
    emit(state.copyWith(
      settings: state.originalSettings,
      editingWorkingHours: state.originalSettings!.workingHours,
      editingMaxCapacity: null,
      editingAutoUpdateOccupancy: null,
      editingAllowNetworkSubscriptions: null,
      editingMaxDailyVisits: null,
      editingMaxWeeklyVisits: null,
      successMessage: 'Changes discarded',
    ));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Block/Unblock Users
  // ═══════════════════════════════════════════════════════════════════════════

  /// Block a user from the gym
  Future<void> blockUser(String userId, String userName, String reason) async {
    emit(state.copyWith(
      saveStatus: PartnerSettingsStatus.loading,
      errorMessage: null,
    ));

    try {
      await _repository.blockUserFromMyGym(
        visitorId: userId,
        visitorName: userName,
        reason: reason,
      );
      
      // Reload settings to get updated blocked list
      final settings = await _repository.getMyGymSettings();
      
      emit(state.copyWith(
        saveStatus: PartnerSettingsStatus.success,
        settings: settings,
        originalSettings: settings,
        successMessage: 'User blocked successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        saveStatus: PartnerSettingsStatus.failure,
        errorMessage: 'Failed to block user: ${e.toString()}',
      ));
    }
  }

  /// Unblock a user from the gym
  Future<void> unblockUser(String userId) async {
    emit(state.copyWith(
      saveStatus: PartnerSettingsStatus.loading,
      errorMessage: null,
    ));

    try {
      await _repository.unblockUserFromMyGym(visitorId: userId);
      
      // Reload settings to get updated blocked list
      final settings = await _repository.getMyGymSettings();
      
      emit(state.copyWith(
        saveStatus: PartnerSettingsStatus.success,
        settings: settings,
        originalSettings: settings,
        successMessage: 'User unblocked successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        saveStatus: PartnerSettingsStatus.failure,
        errorMessage: 'Failed to unblock user: ${e.toString()}',
      ));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Utility Methods
  // ═══════════════════════════════════════════════════════════════════════════

  /// Clear success/error messages
  void clearMessages() {
    emit(state.copyWith(
      successMessage: null,
      errorMessage: null,
    ));
  }
  
  /// Reset save status to initial
  void resetSaveStatus() {
    emit(state.copyWith(saveStatus: PartnerSettingsStatus.initial));
  }
}