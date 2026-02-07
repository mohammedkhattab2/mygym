import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/admin_subscription.dart';
import '../../domain/repositories/admin_subscriptions_repository.dart';

part 'admin_subscriptions_cubit.freezed.dart';

@injectable
class AdminSubscriptionsCubit extends Cubit<AdminSubscriptionsState> {
  final AdminSubscriptionsRepository _repository;

  AdminSubscriptionsCubit(this._repository) : super(const AdminSubscriptionsState.initial());

  AdminSubscriptionFilter _filter = const AdminSubscriptionFilter();
  AdminSubscriptionFilter get currentFilter => _filter;

  Future<void> loadInitial() async {
    emit(const AdminSubscriptionsState.loading());

    final statsResult = await _repository.getSubscriptionsStats();
    final subsResult = await _repository.getSubscriptions(_filter);

    statsResult.fold(
      (f) => emit(AdminSubscriptionsState.error(f.message)),
      (stats) {
        subsResult.fold(
          (f) => emit(AdminSubscriptionsState.error(f.message)),
          (paginated) => emit(AdminSubscriptionsState.loaded(
            stats: stats,
            subscriptions: paginated.subscriptions,
            totalCount: paginated.totalCount,
            currentPage: paginated.currentPage,
            totalPages: paginated.totalPages,
            hasMore: paginated.hasMore,
            filter: _filter,
          )),
        );
      },
    );
  }

  Future<void> loadSubscriptions({AdminSubscriptionFilter? filter}) async {
    if (filter != null) _filter = filter;
    
    final current = state;
    if (current is AdminSubscriptionsLoaded) {
      emit(current.copyWith(isLoadingMore: true));
    }

    final result = await _repository.getSubscriptions(_filter);
    
    result.fold(
      (f) {
        if (current is AdminSubscriptionsLoaded) {
          emit(current.copyWith(isLoadingMore: false));
        }
      },
      (paginated) {
        if (current is AdminSubscriptionsLoaded) {
          emit(current.copyWith(
            subscriptions: paginated.subscriptions,
            totalCount: paginated.totalCount,
            currentPage: paginated.currentPage,
            totalPages: paginated.totalPages,
            hasMore: paginated.hasMore,
            filter: _filter,
            isLoadingMore: false,
          ));
        } else {
          loadInitial();
        }
      },
    );
  }

  Future<void> searchSubscriptions(String query) async {
    _filter = _filter.copyWith(searchQuery: query.isEmpty ? null : query, page: 1);
    await loadSubscriptions();
  }

  Future<void> filterByStatus(SubscriptionStatus? status) async {
    _filter = _filter.copyWith(status: status, page: 1);
    await loadSubscriptions();
  }

  Future<void> filterByTier(SubscriptionTier? tier) async {
    _filter = _filter.copyWith(tier: tier, page: 1);
    await loadSubscriptions();
  }

  Future<void> filterExpiringOnly(bool? expiring) async {
    _filter = _filter.copyWith(expiringOnly: expiring, page: 1);
    await loadSubscriptions();
  }

  Future<void> clearFilters() async {
    _filter = const AdminSubscriptionFilter();
    await loadSubscriptions();
  }

  Future<bool> cancelSubscription(String id, String reason) async {
    final result = await _repository.cancelSubscription(id, reason);
    return result.fold(
      (f) => false,
      (updated) {
        _updateSubscriptionInList(updated);
        return true;
      },
    );
  }

  Future<bool> pauseSubscription(String id) async {
    final result = await _repository.pauseSubscription(id);
    return result.fold((f) => false, (updated) {
      _updateSubscriptionInList(updated);
      return true;
    });
  }

  Future<bool> resumeSubscription(String id) async {
    final result = await _repository.resumeSubscription(id);
    return result.fold((f) => false, (updated) {
      _updateSubscriptionInList(updated);
      return true;
    });
  }

  Future<bool> extendSubscription(String id, int days) async {
    final result = await _repository.extendSubscription(id, days);
    return result.fold((f) => false, (updated) {
      _updateSubscriptionInList(updated);
      return true;
    });
  }

  void _updateSubscriptionInList(AdminSubscription updated) {
    final current = state;
    if (current is AdminSubscriptionsLoaded) {
      final updatedList = current.subscriptions.map((s) {
        return s.id == updated.id ? updated : s;
      }).toList();
      emit(current.copyWith(subscriptions: updatedList));
    }
  }

  Future<String?> exportSubscriptions() async {
    final result = await _repository.exportSubscriptionsToCSV(_filter);
    return result.fold((f) => null, (url) => url);
  }
}

@freezed
class AdminSubscriptionsState with _$AdminSubscriptionsState {
  const factory AdminSubscriptionsState.initial() = AdminSubscriptionsInitial;
  const factory AdminSubscriptionsState.loading() = AdminSubscriptionsLoading;
  const factory AdminSubscriptionsState.loaded({
    required SubscriptionsStats stats,
    required List<AdminSubscription> subscriptions,
    required int totalCount,
    required int currentPage,
    required int totalPages,
    required bool hasMore,
    required AdminSubscriptionFilter filter,
    @Default(false) bool isLoadingMore,
  }) = AdminSubscriptionsLoaded;
  const factory AdminSubscriptionsState.error(String message) = AdminSubscriptionsError;
}