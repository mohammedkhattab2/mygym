/// Subscription bundle entity
/// 
/// Represents different subscription plans available for users.
class SubscriptionBundle {
  final String id;
  final String name;
  final String nameAr;
  final String? description;
  final BundleType type;
  final BundlePeriod period;
  final double price;
  final double? originalPrice; // For showing discounts
  final String currency;
  final int? visitLimit; // Null for unlimited
  final List<String> features;
  final List<String> includedFacilities;
  final bool isPopular;
  final bool isActive;
  final int? durationDays;
  final String? gymId; // Null for network-wide bundles

  const SubscriptionBundle({
    required this.id,
    required this.name,
    required this.nameAr,
    this.description,
    required this.type,
    required this.period,
    required this.price,
    this.originalPrice,
    this.currency = 'EGP',
    this.visitLimit,
    this.features = const [],
    this.includedFacilities = const [],
    this.isPopular = false,
    this.isActive = true,
    this.durationDays,
    this.gymId,
  });

  /// Calculate discount percentage
  int? get discountPercentage {
    if (originalPrice == null || originalPrice! <= price) return null;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  /// Get formatted price
  String get formattedPrice => '${price.toStringAsFixed(0)} $currency';

  /// Get formatted original price
  String? get formattedOriginalPrice {
    if (originalPrice == null) return null;
    return '${originalPrice!.toStringAsFixed(0)} $currency';
  }

  /// Check if unlimited visits
  bool get isUnlimited => visitLimit == null;

  /// Get visits display text
  String get visitsText {
    if (isUnlimited) return 'Unlimited';
    return '$visitLimit visits';
  }
}

/// Bundle type enum
enum BundleType {
  basic,
  plus,
  premium,
  custom,
}

/// Bundle period enum
enum BundlePeriod {
  perVisit,
  weekly,
  monthly,
  quarterly,
  yearly,
}

extension BundlePeriodExtension on BundlePeriod {
  String get displayName {
    switch (this) {
      case BundlePeriod.perVisit:
        return 'Per Visit';
      case BundlePeriod.weekly:
        return 'Weekly';
      case BundlePeriod.monthly:
        return 'Monthly';
      case BundlePeriod.quarterly:
        return 'Quarterly';
      case BundlePeriod.yearly:
        return 'Yearly';
    }
  }

  int get durationDays {
    switch (this) {
      case BundlePeriod.perVisit:
        return 1;
      case BundlePeriod.weekly:
        return 7;
      case BundlePeriod.monthly:
        return 30;
      case BundlePeriod.quarterly:
        return 90;
      case BundlePeriod.yearly:
        return 365;
    }
  }
}

/// Active user subscription
class UserSubscription {
  final String id;
  final String bundleId;
  final String bundleName;
  final SubscriptionStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final int? totalVisits;
  final int? usedVisits;
  final int? remainingVisits;
  final bool autoRenew;
  final DateTime? nextBillingDate;
  final double? nextBillingAmount;
  final PaymentMethod? paymentMethod;
  final String? gymId; // Null for network-wide

  const UserSubscription({
    required this.id,
    required this.bundleId,
    required this.bundleName,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.totalVisits,
    this.usedVisits,
    this.remainingVisits,
    this.autoRenew = false,
    this.nextBillingDate,
    this.nextBillingAmount,
    this.paymentMethod,
    this.gymId,
  });

  /// Check if subscription is active and not expired
  bool get isValid => 
      status == SubscriptionStatus.active && 
      DateTime.now().isBefore(endDate);

  /// Check if has remaining visits (or unlimited)
  bool get hasVisitsRemaining {
    if (remainingVisits == null) return true; // Unlimited
    return remainingVisits! > 0;
  }

  /// Days until expiry
  int get daysUntilExpiry {
    final now = DateTime.now();
    return endDate.difference(now).inDays;
  }

  /// Check if expiring soon (within 7 days)
  bool get isExpiringSoon => 
      isValid && daysUntilExpiry <= 7;

  /// Visit usage percentage
  double? get usagePercentage {
    if (totalVisits == null || usedVisits == null) return null;
    return (usedVisits! / totalVisits!) * 100;
  }
}

/// Subscription status enum
enum SubscriptionStatus {
  active,
  expired,
  cancelled,
  paused,
  pending,
}

/// Payment method for subscription
class PaymentMethod {
  final String id;
  final PaymentProvider provider;
  final String? lastFourDigits;
  final String? brand; // Visa, Mastercard, etc.
  final bool isDefault;

  const PaymentMethod({
    required this.id,
    required this.provider,
    this.lastFourDigits,
    this.brand,
    this.isDefault = false,
  });
}

/// Payment provider enum
enum PaymentProvider {
  kashier,
  instapay,
  paymob,
  paytabs,
  wallet,
}

extension PaymentProviderExtension on PaymentProvider {
  String get displayName {
    switch (this) {
      case PaymentProvider.kashier:
        return 'Kashier';
      case PaymentProvider.instapay:
        return 'InstaPay';
      case PaymentProvider.paymob:
        return 'Paymob';
      case PaymentProvider.paytabs:
        return 'PayTabs';
      case PaymentProvider.wallet:
        return 'Wallet';
    }
  }

  String get iconPath {
    switch (this) {
      case PaymentProvider.kashier:
        return 'assets/icons/payment/kashier.svg';
      case PaymentProvider.instapay:
        return 'assets/icons/payment/instapay.svg';
      case PaymentProvider.paymob:
        return 'assets/icons/payment/paymob.svg';
      case PaymentProvider.paytabs:
        return 'assets/icons/payment/paytabs.svg';
      case PaymentProvider.wallet:
        return 'assets/icons/payment/wallet.svg';
    }
  }
}

/// Invoice entity
class Invoice {
  final String id;
  final String subscriptionId;
  final double amount;
  final String currency;
  final InvoiceStatus status;
  final DateTime createdAt;
  final DateTime? paidAt;
  final PaymentProvider? provider;
  final String? transactionId;
  final String? downloadUrl;

  const Invoice({
    required this.id,
    required this.subscriptionId,
    required this.amount,
    this.currency = 'EGP',
    required this.status,
    required this.createdAt,
    this.paidAt,
    this.provider,
    this.transactionId,
    this.downloadUrl,
  });

  String get formattedAmount => '${amount.toStringAsFixed(2)} $currency';
}

/// Invoice status
enum InvoiceStatus {
  pending,
  paid,
  failed,
  refunded,
}

/// Payment checkout session
class CheckoutSession {
  final String sessionId;
  final String paymentUrl;
  final PaymentProvider provider;
  final double amount;
  final String currency;
  final DateTime expiresAt;
  final Map<String, dynamic>? metadata;

  const CheckoutSession({
    required this.sessionId,
    required this.paymentUrl,
    required this.provider,
    required this.amount,
    this.currency = 'EGP',
    required this.expiresAt,
    this.metadata,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}