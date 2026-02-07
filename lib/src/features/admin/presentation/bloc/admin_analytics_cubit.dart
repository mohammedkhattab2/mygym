import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/admin_analytics.dart';
import '../../domain/repositories/admin_analytics_repository.dart';

part 'admin_analytics_cubit.freezed.dart';

@injectable
class AdminAnalyticsCubit extends Cubit<AdminAnalyticsState> {
  final AdminAnalyticsRepository _repository;

  AdminAnalyticsCubit(this._repository) : super(const AdminAnalyticsState.initial());

  AnalyticsRange _currentRange = AnalyticsRange.last30Days;
  AnalyticsRange get currentRange => _currentRange;

  Future<void> loadAnalytics() async {
    emit(const AdminAnalyticsState.loading());

    final result = await _repository.getAnalyticsData(_currentRange);

    result.fold(
      (failure) => emit(AdminAnalyticsState.error(failure.message)),
      (data) => emit(AdminAnalyticsState.loaded(
        data: data,
        range: _currentRange,
      )),
    );
  }

  Future<void> changeRange(AnalyticsRange range) async {
    _currentRange = range;
    await loadAnalytics();
  }

  Future<String?> exportReport(String format) async {
    final result = await _repository.exportAnalyticsReport(_currentRange, format);
    return result.fold(
      (failure) => null,
      (url) => url,
    );
  }
}

@freezed
class AdminAnalyticsState with _$AdminAnalyticsState {
  const factory AdminAnalyticsState.initial() = AdminAnalyticsInitial;
  const factory AdminAnalyticsState.loading() = AdminAnalyticsLoading;
  const factory AdminAnalyticsState.loaded({
    required AnalyticsData data,
    required AnalyticsRange range,
  }) = AdminAnalyticsLoaded;
  const factory AdminAnalyticsState.error(String message) = AdminAnalyticsError;
}