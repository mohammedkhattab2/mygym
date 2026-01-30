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

  /// Load settings
  Future<void> loadSettings() async {
    emit(state.copyWith(loadStatus: PartnerSettingsStatus.loading));

    try {
      final settings = await _repository.getMyGymSettings();
      
      emit(state.copyWith(
        loadStatus: PartnerSettingsStatus.success,
        settings: settings,
        editingWorkingHours: settings.workingHours,
      ));
    } catch (e) {
      emit(state.copyWith(
        loadStatus: PartnerSettingsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Update working hours for a day
  void updateDaySchedule(int dayOfWeek, DaySchedule schedule) {
    if (state.editingWorkingHours == null) return;

    final newSchedule = Map<int, DaySchedule>.from(state.editingWorkingHours!.schedule);
    newSchedule[dayOfWeek] = schedule;

    emit(state.copyWith(
      editingWorkingHours: GymWorkingHours(schedule: newSchedule),
    ));
  }

  /// Save settings (mock - just show success)
  Future<void> saveSettings() async {
    emit(state.copyWith(
      saveStatus: PartnerSettingsStatus.loading,
      successMessage: null,
    ));

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    emit(state.copyWith(
      saveStatus: PartnerSettingsStatus.success,
      successMessage: 'Settings saved successfully!',
    ));
  }

  /// Clear messages
  void clearMessages() {
    emit(state.copyWith(
      successMessage: null,
      errorMessage: null,
    ));
  }
}