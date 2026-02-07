import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/admin_revenue.dart';
import '../../domain/repositories/admin_revenue_repository.dart';

part 'admin_revenue_cubit.freezed.dart';

@injectable
class AdminRevenueCubit extends Cubit<AdminRevenueState> {
  final AdminRevenueRepository _repository;

  AdminRevenueCubit(this._repository) : super(const AdminRevenueState.initial());

  RevenueFilter _filter = const RevenueFilter();
  RevenueFilter get currentFilter => _filter;

  Future<void> loadRevenueData() async {
    emit(const AdminRevenueState.loading());

    final result = await _repository.getRevenueData(_filter);

    result.fold(
      (failure) => emit(AdminRevenueState.error(failure.message)),
      (data) => emit(AdminRevenueState.loaded(
        data: data,
        filter: _filter,
      )),
    );
  }

  Future<void> changePeriod(RevenuePeriod period) async {
    _filter = _filter.copyWith(period: period, startDate: null, endDate: null);
    await loadRevenueData();
  }

  Future<void> setCustomDateRange(DateTime start, DateTime end) async {
    _filter = _filter.copyWith(
      period: RevenuePeriod.custom,
      startDate: start,
      endDate: end,
    );
    await loadRevenueData();
  }

  Future<void> filterByGym(String? gymId) async {
    _filter = _filter.copyWith(gymId: gymId);
    await loadRevenueData();
  }

  Future<bool> processGymPayout(String payoutId) async {
    final result = await _repository.processGymPayout(payoutId);
    return result.fold(
      (failure) => false,
      (payout) {
        // Refresh data after processing
        loadRevenueData();
        return true;
      },
    );
  }

  Future<String?> exportReport(String format) async {
    final result = await _repository.exportRevenueReport(_filter, format);
    return result.fold(
      (failure) => null,
      (url) => url,
    );
  }
}

@freezed
class AdminRevenueState with _$AdminRevenueState {
  const factory AdminRevenueState.initial() = AdminRevenueInitial;
  const factory AdminRevenueState.loading() = AdminRevenueLoading;
  const factory AdminRevenueState.loaded({
    required RevenueData data,
    required RevenueFilter filter,
  }) = AdminRevenueLoaded;
  const factory AdminRevenueState.error(String message) = AdminRevenueError;
}