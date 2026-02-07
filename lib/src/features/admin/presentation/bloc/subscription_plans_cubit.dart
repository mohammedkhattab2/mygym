import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/subscription_plan.dart';
import '../../domain/repositories/subscription_plans_repository.dart';

part 'subscription_plans_cubit.freezed.dart';

@injectable
class SubscriptionPlansCubit extends Cubit<SubscriptionPlansState> {
  final SubscriptionPlansRepository _repository;

  SubscriptionPlansCubit(this._repository) : super(const SubscriptionPlansState.initial());

  Future<void> loadAll() async {
    emit(const SubscriptionPlansState.loading());

    final plansResult = await _repository.getAllPlans();
    final promosResult = await _repository.getAllPromotions();

    plansResult.fold(
      (f) => emit(SubscriptionPlansState.error(f.message)),
      (plans) {
        promosResult.fold(
          (f) => emit(SubscriptionPlansState.error(f.message)),
          (promos) => emit(SubscriptionPlansState.loaded(
            plans: plans,
            promotions: promos,
          )),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PLANS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<bool> createPlan(SubscriptionPlanFormData data) async {
    final result = await _repository.createPlan(data);
    return result.fold(
      (f) => false,
      (plan) {
        _updatePlansInState((plans) => [...plans, plan]);
        return true;
      },
    );
  }

  Future<bool> updatePlan(String planId, SubscriptionPlanFormData data) async {
    final result = await _repository.updatePlan(planId, data);
    return result.fold(
      (f) => false,
      (updated) {
        _updatePlansInState((plans) => plans.map((p) => p.id == planId ? updated : p).toList());
        return true;
      },
    );
  }

  Future<bool> deletePlan(String planId) async {
    final result = await _repository.deletePlan(planId);
    return result.fold(
      (f) => false,
      (_) {
        _updatePlansInState((plans) => plans.where((p) => p.id != planId).toList());
        return true;
      },
    );
  }

  Future<bool> togglePlanStatus(String planId) async {
    final result = await _repository.togglePlanStatus(planId);
    return result.fold(
      (f) => false,
      (updated) {
        _updatePlansInState((plans) => plans.map((p) => p.id == planId ? updated : p).toList());
        return true;
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PROMOTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<bool> createPromotion(PromotionFormData data) async {
    final result = await _repository.createPromotion(data);
    return result.fold(
      (f) => false,
      (promo) {
        _updatePromosInState((promos) => [...promos, promo]);
        return true;
      },
    );
  }

  Future<bool> updatePromotion(String promoId, PromotionFormData data) async {
    final result = await _repository.updatePromotion(promoId, data);
    return result.fold(
      (f) => false,
      (updated) {
        _updatePromosInState((promos) => promos.map((p) => p.id == promoId ? updated : p).toList());
        return true;
      },
    );
  }

  Future<bool> deletePromotion(String promoId) async {
    final result = await _repository.deletePromotion(promoId);
    return result.fold(
      (f) => false,
      (_) {
        _updatePromosInState((promos) => promos.where((p) => p.id != promoId).toList());
        return true;
      },
    );
  }

  Future<bool> togglePromotionStatus(String promoId) async {
    final result = await _repository.togglePromotionStatus(promoId);
    return result.fold(
      (f) => false,
      (updated) {
        _updatePromosInState((promos) => promos.map((p) => p.id == promoId ? updated : p).toList());
        return true;
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  void _updatePlansInState(List<SubscriptionPlan> Function(List<SubscriptionPlan>) updater) {
    final current = state;
    if (current is SubscriptionPlansLoaded) {
      emit(current.copyWith(plans: updater(current.plans)));
    }
  }

  void _updatePromosInState(List<Promotion> Function(List<Promotion>) updater) {
    final current = state;
    if (current is SubscriptionPlansLoaded) {
      emit(current.copyWith(promotions: updater(current.promotions)));
    }
  }
}

@freezed
class SubscriptionPlansState with _$SubscriptionPlansState {
  const factory SubscriptionPlansState.initial() = SubscriptionPlansInitial;
  const factory SubscriptionPlansState.loading() = SubscriptionPlansLoading;
  const factory SubscriptionPlansState.loaded({
    required List<SubscriptionPlan> plans,
    required List<Promotion> promotions,
    @Default(0) int selectedTab, // 0 = Plans, 1 = Promotions
  }) = SubscriptionPlansLoaded;
  const factory SubscriptionPlansState.error(String message) = SubscriptionPlansError;
}