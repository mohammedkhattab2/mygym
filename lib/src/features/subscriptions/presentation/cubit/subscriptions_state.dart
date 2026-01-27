import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';

part 'subscriptions_state.freezed.dart';

@freezed
class SubscriptionsState with _$SubscriptionsState {
  const factory SubscriptionsState({
    // Data
    @Default([]) List<SubscriptionBundle> bundles,
    UserSubscription? currentSubscription,
    @Default([]) List<Invoice> invoices,
    
    // Selected items
    SubscriptionBundle? selectedBundle,
    PaymentProvider? selectedProvider,
    
    // Promo code
    @Default('') String promoCode,
    PromoCodeResult? promoResult,
    
    // Checkout
    CheckoutSession? checkoutSession,
    
    // Loading states
    @Default(SubscriptionsStatus.initial) SubscriptionsStatus bundlesStatus,
    @Default(SubscriptionsStatus.initial) SubscriptionsStatus subscriptionStatus,
    @Default(SubscriptionsStatus.initial) SubscriptionsStatus checkoutStatus,
    @Default(SubscriptionsStatus.initial) SubscriptionsStatus invoicesStatus,
    @Default(SubscriptionsStatus.initial) SubscriptionsStatus promoStatus,
    
    // Error
    String? errorMessage,
  }) = _SubscriptionsState;

  const SubscriptionsState._();

  /// Check if user has active subscription
  bool get hasActiveSubscription =>
      currentSubscription != null && currentSubscription!.isValid;

  /// Get final price after promo
  double? get finalPrice {
    if (selectedBundle == null) return null;
    if (promoResult?.isValid == true && promoResult?.finalPrice != null) {
      return promoResult!.finalPrice;
    }
    return selectedBundle!.price;
  }

  /// Get discount amount
  double? get discountAmount {
    if (promoResult?.isValid == true) {
      return promoResult?.discountAmount;
    }
    if (selectedBundle?.discountPercentage != null) {
      return (selectedBundle!.originalPrice ?? 0) - selectedBundle!.price;
    }
    return null;
  }
}

enum SubscriptionsStatus {
  initial,
  loading,
  success,
  failure,
}