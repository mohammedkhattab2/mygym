import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';

@LazySingleton(as: SubscriptionRepository)
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  // ignore: unused_field - will be used when backend is available
  final DioClient _dioClient;
  // ignore: unused_field - will be used when backend is available
  final NetworkInfo _networkInfo;

  // Local cache for current subscription
  UserSubscription? _cachedSubscription;

  SubscriptionRepositoryImpl(this._dioClient, this._networkInfo);

  @override
  Future<Either<Failure, List<SubscriptionBundle>>> getBundles({
    String? gymId,
  }) async {
    // Return dummy data for development
    return Right(_getDummyBundles());
  }

  @override
  Future<Either<Failure, SubscriptionBundle>> getBundleById(String bundleId) async {
    final bundles = _getDummyBundles();
    try {
      final bundle = bundles.firstWhere((b) => b.id == bundleId);
      return Right(bundle);
    } catch (_) {
      return const Left(NotFoundFailure('Bundle not found'));
    }
  }

  @override
  Future<Either<Failure, UserSubscription?>> getCurrentSubscription() async {
    // Return dummy subscription for development
    return Right(_getDummyCurrentSubscription());
  }

  @override
  Future<Either<Failure, List<UserSubscription>>> getSubscriptionHistory() async {
    return Right(_getDummySubscriptionHistory());
  }

  @override
  Future<Either<Failure, CheckoutSession>> createCheckoutSession({
    required String bundleId,
    required PaymentProvider provider,
    String? promoCode,
  }) async {
    // Return dummy checkout session
    final session = CheckoutSession(
      sessionId: 'session_${DateTime.now().millisecondsSinceEpoch}',
      paymentUrl: 'https://checkout.example.com/pay?session=demo',
      provider: provider,
      amount: 299.0,
      expiresAt: DateTime.now().add(const Duration(minutes: 30)),
      metadata: {'bundleId': bundleId},
    );
    return Right(session);
  }

  @override
  Future<Either<Failure, UserSubscription>> verifyPayment({
    required String sessionId,
  }) async {
    // Simulate successful payment
    await Future.delayed(const Duration(seconds: 2));
    
    final subscription = UserSubscription(
      id: 'sub_${DateTime.now().millisecondsSinceEpoch}',
      bundleId: 'bundle_2',
      bundleName: 'Plus Monthly',
      status: SubscriptionStatus.active,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      totalVisits: 12,
      usedVisits: 0,
      remainingVisits: 12,
      autoRenew: true,
    );
    
    _cachedSubscription = subscription;
    return Right(subscription);
  }

  @override
  Future<Either<Failure, void>> cancelSubscription(String subscriptionId) async {
    await Future.delayed(const Duration(seconds: 1));
    _cachedSubscription = null;
    return const Right(null);
  }

  @override
  Future<Either<Failure, UserSubscription>> toggleAutoRenew({
    required String subscriptionId,
    required bool enabled,
  }) async {
    if (_cachedSubscription == null) {
      return const Left(NotFoundFailure('No active subscription'));
    }
    
    // In real implementation, this would update the backend
    return Right(_cachedSubscription!);
  }

  @override
  Future<Either<Failure, List<Invoice>>> getInvoices({
    int page = 1,
    int limit = 20,
  }) async {
    return Right(_getDummyInvoices());
  }

  @override
  Future<Either<Failure, Invoice>> getInvoiceById(String invoiceId) async {
    final invoices = _getDummyInvoices();
    try {
      final invoice = invoices.firstWhere((i) => i.id == invoiceId);
      return Right(invoice);
    } catch (_) {
      return const Left(NotFoundFailure('Invoice not found'));
    }
  }

  @override
  Future<Either<Failure, PromoCodeResult>> applyPromoCode({
    required String bundleId,
    required String code,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Simulate promo code validation
    if (code.toUpperCase() == 'MYGYM20') {
      return const Right(PromoCodeResult(
        isValid: true,
        discountPercentage: 20,
        discountAmount: 59.8,
        finalPrice: 239.2,
      ));
    }
    
    return const Right(PromoCodeResult(
      isValid: false,
      errorMessage: 'Invalid promo code',
    ));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DUMMY DATA
  // ═══════════════════════════════════════════════════════════════════════════

  List<SubscriptionBundle> _getDummyBundles() {
    return [
      const SubscriptionBundle(
        id: 'bundle_1',
        name: 'Basic',
        nameAr: 'أساسي',
        description: 'Perfect for occasional gym-goers',
        type: BundleType.basic,
        period: BundlePeriod.monthly,
        price: 149,
        visitLimit: 4,
        features: [
          '4 visits per month',
          'Access to all partner gyms',
          'Basic equipment access',
        ],
        includedFacilities: ['weights', 'cardio', 'locker'],
        isActive: true,
        durationDays: 30,
      ),
      const SubscriptionBundle(
        id: 'bundle_2',
        name: 'Plus',
        nameAr: 'بلس',
        description: 'Most popular choice for regular fitness',
        type: BundleType.plus,
        period: BundlePeriod.monthly,
        price: 299,
        originalPrice: 349,
        visitLimit: 12,
        features: [
          '12 visits per month',
          'Access to all partner gyms',
          'Full equipment access',
          'Group classes included',
          'Towel service',
        ],
        includedFacilities: ['weights', 'cardio', 'locker', 'classes', 'towel'],
        isPopular: true,
        isActive: true,
        durationDays: 30,
      ),
      const SubscriptionBundle(
        id: 'bundle_3',
        name: 'Premium',
        nameAr: 'بريميوم',
        description: 'Unlimited access for fitness enthusiasts',
        type: BundleType.premium,
        period: BundlePeriod.monthly,
        price: 499,
        originalPrice: 599,
        visitLimit: null, // Unlimited
        features: [
          'Unlimited visits',
          'Access to all partner gyms',
          'Full equipment access',
          'All group classes',
          'Pool & Sauna access',
          'Personal trainer session (1/month)',
          'Priority booking',
        ],
        includedFacilities: ['weights', 'cardio', 'locker', 'classes', 'towel', 'pool', 'sauna', 'trainer'],
        isActive: true,
        durationDays: 30,
      ),
      const SubscriptionBundle(
        id: 'bundle_4',
        name: 'Annual Premium',
        nameAr: 'بريميوم سنوي',
        description: 'Best value - Save 2 months!',
        type: BundleType.premium,
        period: BundlePeriod.yearly,
        price: 4990,
        originalPrice: 5988,
        visitLimit: null,
        features: [
          'Unlimited visits for 12 months',
          'All Premium benefits',
          'Save 2 months worth',
          'Freeze subscription (up to 30 days)',
          'Guest passes (2/month)',
        ],
        includedFacilities: ['weights', 'cardio', 'locker', 'classes', 'towel', 'pool', 'sauna', 'trainer'],
        isActive: true,
        durationDays: 365,
      ),
    ];
  }

  UserSubscription? _getDummyCurrentSubscription() {
    return UserSubscription(
      id: 'sub_123',
      bundleId: 'bundle_2',
      bundleName: 'Plus Monthly',
      status: SubscriptionStatus.active,
      startDate: DateTime.now().subtract(const Duration(days: 15)),
      endDate: DateTime.now().add(const Duration(days: 15)),
      totalVisits: 12,
      usedVisits: 5,
      remainingVisits: 7,
      autoRenew: true,
      nextBillingDate: DateTime.now().add(const Duration(days: 15)),
      nextBillingAmount: 299,
      paymentMethod: const PaymentMethod(
        id: 'pm_1',
        provider: PaymentProvider.paymob,
        lastFourDigits: '4242',
        brand: 'Visa',
        isDefault: true,
      ),
    );
  }

  List<UserSubscription> _getDummySubscriptionHistory() {
    return [
      UserSubscription(
        id: 'sub_122',
        bundleId: 'bundle_1',
        bundleName: 'Basic Monthly',
        status: SubscriptionStatus.expired,
        startDate: DateTime.now().subtract(const Duration(days: 60)),
        endDate: DateTime.now().subtract(const Duration(days: 30)),
        totalVisits: 4,
        usedVisits: 4,
        remainingVisits: 0,
      ),
    ];
  }

  List<Invoice> _getDummyInvoices() {
    return [
      Invoice(
        id: 'inv_003',
        subscriptionId: 'sub_123',
        amount: 299,
        status: InvoiceStatus.paid,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        paidAt: DateTime.now().subtract(const Duration(days: 15)),
        provider: PaymentProvider.paymob,
        transactionId: 'txn_abc123',
      ),
      Invoice(
        id: 'inv_002',
        subscriptionId: 'sub_122',
        amount: 149,
        status: InvoiceStatus.paid,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        paidAt: DateTime.now().subtract(const Duration(days: 45)),
        provider: PaymentProvider.instapay,
        transactionId: 'txn_xyz789',
      ),
      Invoice(
        id: 'inv_001',
        subscriptionId: 'sub_121',
        amount: 149,
        status: InvoiceStatus.paid,
        createdAt: DateTime.now().subtract(const Duration(days: 75)),
        paidAt: DateTime.now().subtract(const Duration(days: 75)),
        provider: PaymentProvider.kashier,
        transactionId: 'txn_def456',
      ),
    ];
  }
}

/// Custom failure for not found items
class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Not found'])
      : super(message: message, code: 'NOT_FOUND');
}