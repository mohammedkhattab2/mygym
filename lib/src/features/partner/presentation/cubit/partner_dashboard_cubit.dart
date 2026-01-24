import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/partner_entities.dart';
import '../../domain/repositories/partner_repository.dart';

class PartnerDashboardState {
  final bool isLoading;
  final String? errorMessage;
  final PartnerReport? currentReport;
  final PartnerSettings? settings;
  final ReportPeriod selectedPeriod;

  const PartnerDashboardState({
    this.isLoading = false,
    this.errorMessage,
    this.currentReport,
    this.settings,
    this.selectedPeriod = ReportPeriod.daily,
  });

  PartnerDashboardState copyWith({
    bool? isLoading,
    String? errorMessage,
    PartnerReport? currentReport,
    PartnerSettings? settings,
    ReportPeriod? selectedPeriod,
  }) {
    return PartnerDashboardState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      currentReport: currentReport ?? this.currentReport,
      settings: settings ?? this.settings,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
    );
  }

  factory PartnerDashboardState.initial() =>
      const PartnerDashboardState(selectedPeriod: ReportPeriod.daily);
}

@injectable
class PartnerDashboardCubit extends Cubit<PartnerDashboardState> {
  final PartnerRepository _repository;

  PartnerDashboardCubit(this._repository)
      : super(PartnerDashboardState.initial());

  Future<void> loadInitial() async {
    await loadReport(state.selectedPeriod);
  }

  Future<void> loadReport(ReportPeriod period) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        selectedPeriod: period,
      ),
    );
    try {
      final report =
          await _repository.getMyGymReport(period); // dummy gym
      final settings = state.settings ?? await _repository.getMyGymSettings();

      emit(
        state.copyWith(
          isLoading: false,
          currentReport: report,
          settings: settings,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}