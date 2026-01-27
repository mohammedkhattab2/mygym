import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/subscription.dart';

/// Repository interface for subscription operations
abstract class SubscriptionRepository {
  /// Get available subscription bundles
  Future<Either<Failure, List<SubscriptionBundle>>> getBundles({
    String? gymId,
  });

  /// Get bundle by ID
  Future<Either<Failure, SubscriptionBundle>> getBundleById(String bundleId);

  /// Get current user subscription
  Future<Either<Failure, UserSubscription?>> getCurrentSubscription();

  /// Get user subscription history
  Future<Either<Failure, List<UserSubscription>>> getSubscriptionHistory();

  /// Create checkout session for a bundle
  Future<Either<Failure, CheckoutSession>> createCheckoutSession({
    required String bundleId,
    required PaymentProvider provider,
    String? promoCode,
  });

  /// Verify payment status
  Future<Either<Failure, UserSubscription>> verifyPayment({
    required String sessionId,
  });

  /// Cancel subscription
  Future<Either<Failure, void>> cancelSubscription(String subscriptionId);

  /// Toggle auto-renewal
  Future<Either<Failure, UserSubscription>> toggleAutoRenew({
    required String subscriptionId,
    required bool enabled,
  });

  /// Get invoices
  Future<Either<Failure, List<Invoice>>> getInvoices({
    int page = 1,
    int limit = 20,
  });

  /// Get invoice by ID
  Future<Either<Failure, Invoice>> getInvoiceById(String invoiceId);

  /// Apply promo code
  Future<Either<Failure, PromoCodeResult>> applyPromoCode({
    required String bundleId,
    required String code,
  });
}

/// Promo code validation result
class PromoCodeResult {
  final bool isValid;
  final String? errorMessage;
  final double? discountAmount;
  final double? discountPercentage;
  final double? finalPrice;

  const PromoCodeResult({
    required this.isValid,
    this.errorMessage,
    this.discountAmount,
    this.discountPercentage,
    this.finalPrice,
  });
}