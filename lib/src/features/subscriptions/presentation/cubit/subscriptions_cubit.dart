import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';
import 'subscriptions_state.dart';

@injectable
class SubscriptionsCubit extends Cubit<SubscriptionsState> {
  final SubscriptionRepository _repository;

  SubscriptionsCubit(this._repository) : super(const SubscriptionsState());

  // ═══════════════════════════════════════════════════════════════════════════
  // LOAD DATA
  // ═══════════════════════════════════════════════════════════════════════════

  /// Load bundles and current subscription
  Future<void> loadInitial() async {
    await Future.wait([
      loadBundles(),
      loadCurrentSubscription(),
    ]);
  }

  /// Load available bundles
  Future<void> loadBundles({String? gymId}) async {
    emit(state.copyWith(bundlesStatus: SubscriptionsStatus.loading));

    final result = await _repository.getBundles(gymId: gymId);

    result.fold(
      (failure) => emit(state.copyWith(
        bundlesStatus: SubscriptionsStatus.failure,
        errorMessage: failure.message,
      )),
      (bundles) => emit(state.copyWith(
        bundlesStatus: SubscriptionsStatus.success,
        bundles: bundles,
      )),
    );
  }

  /// Load current user subscription
  Future<void> loadCurrentSubscription() async {
    emit(state.copyWith(subscriptionStatus: SubscriptionsStatus.loading));

    final result = await _repository.getCurrentSubscription();

    result.fold(
      (failure) => emit(state.copyWith(
        subscriptionStatus: SubscriptionsStatus.failure,
        errorMessage: failure.message,
      )),
      (subscription) => emit(state.copyWith(
        subscriptionStatus: SubscriptionsStatus.success,
        currentSubscription: subscription,
      )),
    );
  }

  /// Load invoices
  Future<void> loadInvoices() async {
    emit(state.copyWith(invoicesStatus: SubscriptionsStatus.loading));

    final result = await _repository.getInvoices();

    result.fold(
      (failure) => emit(state.copyWith(
        invoicesStatus: SubscriptionsStatus.failure,
        errorMessage: failure.message,
      )),
      (invoices) => emit(state.copyWith(
        invoicesStatus: SubscriptionsStatus.success,
        invoices: invoices,
      )),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SELECTION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Select a bundle for checkout
  void selectBundle(SubscriptionBundle bundle) {
    emit(state.copyWith(
      selectedBundle: bundle,
      promoCode: '',
      promoResult: null,
    ));
  }

  /// Clear selected bundle
  void clearSelection() {
    emit(state.copyWith(
      selectedBundle: null,
      selectedProvider: null,
      promoCode: '',
      promoResult: null,
      checkoutSession: null,
    ));
  }

  /// Select payment provider
  void selectPaymentProvider(PaymentProvider provider) {
    emit(state.copyWith(selectedProvider: provider));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PROMO CODE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Update promo code input
  void updatePromoCode(String code) {
    emit(state.copyWith(promoCode: code, promoResult: null));
  }

  /// Apply promo code
  Future<void> applyPromoCode() async {
    if (state.promoCode.isEmpty || state.selectedBundle == null) return;

    emit(state.copyWith(promoStatus: SubscriptionsStatus.loading));

    final result = await _repository.applyPromoCode(
      bundleId: state.selectedBundle!.id,
      code: state.promoCode,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        promoStatus: SubscriptionsStatus.failure,
        errorMessage: failure.message,
      )),
      (promoResult) => emit(state.copyWith(
        promoStatus: SubscriptionsStatus.success,
        promoResult: promoResult,
      )),
    );
  }

  /// Clear promo code
  void clearPromoCode() {
    emit(state.copyWith(
      promoCode: '',
      promoResult: null,
    ));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CHECKOUT
  // ═══════════════════════════════════════════════════════════════════════════

  /// Create checkout session
  Future<void> createCheckout() async {
    debugPrint('📦 createCheckout() called');
    debugPrint('   selectedBundle: ${state.selectedBundle?.name}');
    debugPrint('   selectedProvider: ${state.selectedProvider}');
    if (state.selectedBundle == null || state.selectedProvider == null) {
      debugPrint('❌ Missing bundle or provider');
      emit(state.copyWith(
        errorMessage: 'Please select a bundle and payment method',
      ));
      return;
    }
    debugPrint('⏳ Setting status to loading...');

    emit(state.copyWith(checkoutStatus: SubscriptionsStatus.loading));

    final result = await _repository.createCheckoutSession(
      bundleId: state.selectedBundle!.id,
      provider: state.selectedProvider!,
      promoCode: state.promoResult?.isValid == true ? state.promoCode : null,
    );

    result.fold(
      (failure) {
        debugPrint('❌ Checkout failed: ${failure.message}');
        emit(state.copyWith(
        checkoutStatus: SubscriptionsStatus.failure,
        errorMessage: failure.message,
      ));
      },
      (session) {
        debugPrint('✅ Checkout session created: ${session.sessionId}');
        emit(state.copyWith(
        checkoutStatus: SubscriptionsStatus.success,
        checkoutSession: session,
      ));
      },
    );
  }

  /// Verify payment after returning from payment gateway
  Future<bool> verifyPayment(String sessionId) async {
    emit(state.copyWith(checkoutStatus: SubscriptionsStatus.loading));

    final result = await _repository.verifyPayment(sessionId: sessionId);

    return result.fold(
      (failure) {
        emit(state.copyWith(
          checkoutStatus: SubscriptionsStatus.failure,
          errorMessage: failure.message,
        ));
        return false;
      },
      (subscription) {
        emit(state.copyWith(
          checkoutStatus: SubscriptionsStatus.success,
          currentSubscription: subscription,
          selectedBundle: null,
          checkoutSession: null,
        ));
        return true;
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SUBSCRIPTION MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════

  /// Cancel subscription
  Future<bool> cancelSubscription() async {
    if (state.currentSubscription == null) return false;

    emit(state.copyWith(subscriptionStatus: SubscriptionsStatus.loading));

    final result = await _repository.cancelSubscription(
      state.currentSubscription!.id,
    );

    return result.fold(
      (failure) {
        emit(state.copyWith(
          subscriptionStatus: SubscriptionsStatus.failure,
          errorMessage: failure.message,
        ));
        return false;
      },
      (_) {
        emit(state.copyWith(
          subscriptionStatus: SubscriptionsStatus.success,
          currentSubscription: null,
        ));
        return true;
      },
    );
  }

  /// Toggle auto-renewal
  Future<void> toggleAutoRenew(bool enabled) async {
    if (state.currentSubscription == null) return;

    final result = await _repository.toggleAutoRenew(
      subscriptionId: state.currentSubscription!.id,
      enabled: enabled,
    );

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (subscription) => emit(state.copyWith(currentSubscription: subscription)),
    );
  }
}