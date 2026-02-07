import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/subscription_plan.dart';
import '../../domain/entities/admin_subscription.dart';
import '../../domain/repositories/subscription_plans_repository.dart';

@LazySingleton(as: SubscriptionPlansRepository)
class MockSubscriptionPlansRepository implements SubscriptionPlansRepository {
  
  final List<SubscriptionPlan> _mockPlans = [
    SubscriptionPlan(
      id: 'plan_basic',
      name: 'Basic',
      nameAr: 'أساسي',
      description: 'Perfect for beginners who want to explore fitness',
      descriptionAr: 'مثالي للمبتدئين الذين يريدون استكشاف اللياقة البدنية',
      tier: SubscriptionTier.basic,
      monthlyPrice: 299,
      quarterlyPrice: 799,
      yearlyPrice: 2999,
      monthlyVisitLimit: 12,
      quarterlyVisitLimit: 36,
      yearlyVisitLimit: 144,
      unlimitedVisits: false,
      dailyVisitLimit: 1,
      weeklyVisitLimit: 4,
      features: [
        'Access to 50+ gyms',
        '12 visits per month',
        'Basic workout tracking',
        'Email support',
      ],
      featuresAr: [
        'الوصول إلى أكثر من 50 صالة',
        '12 زيارة شهرياً',
        'تتبع التمارين الأساسي',
        'دعم عبر البريد الإلكتروني',
      ],
      isActive: true,
      isPopular: false,
      sortOrder: 1,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    ),
    SubscriptionPlan(
      id: 'plan_plus',
      name: 'Plus',
      nameAr: 'بلس',
      description: 'Great for regular gym-goers who want more flexibility',
      descriptionAr: 'رائع لرواد الصالة المنتظمين الذين يريدون المزيد من المرونة',
      tier: SubscriptionTier.plus,
      monthlyPrice: 499,
      quarterlyPrice: 1299,
      yearlyPrice: 4999,
      monthlyVisitLimit: 24,
      quarterlyVisitLimit: 72,
      yearlyVisitLimit: 288,
      unlimitedVisits: false,
      dailyVisitLimit: 1,
      weeklyVisitLimit: 7,
      features: [
        'Access to 100+ gyms',
        '24 visits per month',
        'Advanced workout tracking',
        'Nutrition tips',
        'Priority support',
        'Guest passes (2/month)',
      ],
      featuresAr: [
        'الوصول إلى أكثر من 100 صالة',
        '24 زيارة شهرياً',
        'تتبع التمارين المتقدم',
        'نصائح غذائية',
        'دعم أولوية',
        'تصاريح ضيوف (2 شهرياً)',
      ],
      isActive: true,
      isPopular: true,
      sortOrder: 2,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    ),
    SubscriptionPlan(
      id: 'plan_premium',
      name: 'Premium',
      nameAr: 'بريميوم',
      description: 'Ultimate access for fitness enthusiasts',
      descriptionAr: 'الوصول المطلق لعشاق اللياقة البدنية',
      tier: SubscriptionTier.premium,
      monthlyPrice: 799,
      quarterlyPrice: 2099,
      yearlyPrice: 7999,
      unlimitedVisits: true,
      dailyVisitLimit: 2,
      weeklyVisitLimit: 14,
      features: [
        'Access to ALL gyms',
        'Unlimited visits',
        'Personal trainer sessions (2/month)',
        'Premium workout plans',
        'Nutrition consultation',
        '24/7 VIP support',
        'Guest passes (4/month)',
        'Spa & wellness access',
      ],
      featuresAr: [
        'الوصول إلى جميع الصالات',
        'زيارات غير محدودة',
        'جلسات مدرب شخصي (2 شهرياً)',
        'خطط تمارين متميزة',
        'استشارة غذائية',
        'دعم VIP على مدار الساعة',
        'تصاريح ضيوف (4 شهرياً)',
        'الوصول إلى السبا والعافية',
      ],
      isActive: true,
      isPopular: false,
      sortOrder: 3,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    ),
  ];

  final List<Promotion> _mockPromotions = [
    Promotion(
      id: 'promo_1',
      name: 'Summer Sale',
      nameAr: 'تخفيضات الصيف',
      description: 'Get 30% off on all yearly subscriptions',
      descriptionAr: 'احصل على خصم 30% على جميع الاشتراكات السنوية',
      type: PromotionType.seasonal,
      discountValue: 30,
      isPercentage: true,
      promoCode: 'SUMMER30',
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: DateTime.now().add(const Duration(days: 20)),
      usageLimit: 100,
      usageCount: 45,
      applicableDurations: ['yearly'],
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    Promotion(
      id: 'promo_2',
      name: 'First Timer',
      nameAr: 'المشترك الجديد',
      description: '20% off your first subscription',
      descriptionAr: 'خصم 20% على اشتراكك الأول',
      type: PromotionType.firstTime,
      discountValue: 20,
      isPercentage: true,
      promoCode: 'WELCOME20',
      startDate: DateTime.now().subtract(const Duration(days: 100)),
      endDate: DateTime.now().add(const Duration(days: 265)),
      isFirstTimeOnly: true,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
    ),
    Promotion(
      id: 'promo_3',
      name: 'Flash Deal',
      nameAr: 'عرض سريع',
      description: 'Limited time: 50 EGP off Plus plan',
      descriptionAr: 'لفترة محدودة: خصم 50 جنيه على خطة بلس',
      type: PromotionType.flashSale,
      discountValue: 50,
      isPercentage: false,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 3)),
      usageLimit: 50,
      usageCount: 12,
      applicablePlanIds: ['plan_plus'],
      isActive: true,
      createdAt: DateTime.now(),
    ),
    Promotion(
      id: 'promo_4',
      name: 'Refer a Friend',
      nameAr: 'دعوة صديق',
      description: 'Both you and your friend get 15% off',
      descriptionAr: 'أنت وصديقك تحصلان على خصم 15%',
      type: PromotionType.referral,
      discountValue: 15,
      isPercentage: true,
      promoCode: 'REFER15',
      startDate: DateTime.now().subtract(const Duration(days: 200)),
      endDate: DateTime.now().add(const Duration(days: 165)),
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // PLANS
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<Either<Failure, List<SubscriptionPlan>>> getAllPlans() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final sorted = List<SubscriptionPlan>.from(_mockPlans)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return Right(sorted);
  }

  @override
  Future<Either<Failure, SubscriptionPlan>> getPlanById(String planId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      final plan = _mockPlans.firstWhere((p) => p.id == planId);
      return Right(plan);
    } catch (e) {
      return const Left(ServerFailure('Plan not found'));
    }
  }

  @override
  Future<Either<Failure, SubscriptionPlan>> createPlan(SubscriptionPlanFormData data) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    final newPlan = SubscriptionPlan(
      id: 'plan_${DateTime.now().millisecondsSinceEpoch}',
      name: data.name,
      nameAr: data.nameAr,
      description: data.description,
      descriptionAr: data.descriptionAr,
      tier: data.tier,
      monthlyPrice: data.monthlyPrice,
      quarterlyPrice: data.quarterlyPrice,
      yearlyPrice: data.yearlyPrice,
      monthlyVisitLimit: data.monthlyVisitLimit,
      quarterlyVisitLimit: data.quarterlyVisitLimit,
      yearlyVisitLimit: data.yearlyVisitLimit,
      unlimitedVisits: data.unlimitedVisits,
      dailyVisitLimit: data.dailyVisitLimit,
      weeklyVisitLimit: data.weeklyVisitLimit,
      features: data.features,
      featuresAr: data.featuresAr,
      includedGymIds: data.includedGymIds,
      isActive: data.isActive,
      isPopular: data.isPopular,
      sortOrder: data.sortOrder,
      createdAt: DateTime.now(),
    );
    
    _mockPlans.add(newPlan);
    return Right(newPlan);
  }

  @override
  Future<Either<Failure, SubscriptionPlan>> updatePlan(String planId, SubscriptionPlanFormData data) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    final index = _mockPlans.indexWhere((p) => p.id == planId);
    if (index == -1) {
      return const Left(ServerFailure('Plan not found'));
    }

    final updatedPlan = _mockPlans[index].copyWith(
      name: data.name,
      nameAr: data.nameAr,
      description: data.description,
      descriptionAr: data.descriptionAr,
      tier: data.tier,
      monthlyPrice: data.monthlyPrice,
      quarterlyPrice: data.quarterlyPrice,
      yearlyPrice: data.yearlyPrice,
      monthlyVisitLimit: data.monthlyVisitLimit,
      quarterlyVisitLimit: data.quarterlyVisitLimit,
      yearlyVisitLimit: data.yearlyVisitLimit,
      unlimitedVisits: data.unlimitedVisits,
      dailyVisitLimit: data.dailyVisitLimit,
      weeklyVisitLimit: data.weeklyVisitLimit,
      features: data.features,
      featuresAr: data.featuresAr,
      includedGymIds: data.includedGymIds,
      isActive: data.isActive,
      isPopular: data.isPopular,
      sortOrder: data.sortOrder,
      updatedAt: DateTime.now(),
    );

    _mockPlans[index] = updatedPlan;
    return Right(updatedPlan);
  }

  @override
  Future<Either<Failure, void>> deletePlan(String planId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockPlans.removeWhere((p) => p.id == planId);
    return const Right(null);
  }

  @override
  Future<Either<Failure, SubscriptionPlan>> togglePlanStatus(String planId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    final index = _mockPlans.indexWhere((p) => p.id == planId);
    if (index == -1) {
      return const Left(ServerFailure('Plan not found'));
    }

    final updated = _mockPlans[index].copyWith(
      isActive: !_mockPlans[index].isActive,
      updatedAt: DateTime.now(),
    );
    _mockPlans[index] = updated;
    return Right(updated);
  }

  @override
  Future<Either<Failure, void>> reorderPlans(List<String> planIds) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    for (int i = 0; i < planIds.length; i++) {
      final index = _mockPlans.indexWhere((p) => p.id == planIds[i]);
      if (index != -1) {
        _mockPlans[index] = _mockPlans[index].copyWith(sortOrder: i + 1);
      }
    }
    return const Right(null);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PROMOTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<Either<Failure, List<Promotion>>> getAllPromotions() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Right(_mockPromotions);
  }

  @override
  Future<Either<Failure, Promotion>> getPromotionById(String promotionId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      final promo = _mockPromotions.firstWhere((p) => p.id == promotionId);
      return Right(promo);
    } catch (e) {
      return const Left(ServerFailure('Promotion not found'));
    }
  }

  @override
  Future<Either<Failure, Promotion>> createPromotion(PromotionFormData data) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    final newPromo = Promotion(
      id: 'promo_${DateTime.now().millisecondsSinceEpoch}',
      name: data.name,
      nameAr: data.nameAr,
      description: data.description,
      descriptionAr: data.descriptionAr,
      type: data.type,
      discountValue: data.discountValue,
      isPercentage: data.isPercentage,
      promoCode: data.promoCode,
      startDate: data.startDate,
      endDate: data.endDate,
      usageLimit: data.usageLimit,
      applicablePlanIds: data.applicablePlanIds,
      applicableDurations: data.applicableDurations,
      minPurchaseAmount: data.minPurchaseAmount,
      isActive: data.isActive,
      isFirstTimeOnly: data.isFirstTimeOnly,
      createdAt: DateTime.now(),
    );
    
    _mockPromotions.add(newPromo);
    return Right(newPromo);
  }

  @override
  Future<Either<Failure, Promotion>> updatePromotion(String promotionId, PromotionFormData data) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    final index = _mockPromotions.indexWhere((p) => p.id == promotionId);
    if (index == -1) {
      return const Left(ServerFailure('Promotion not found'));
    }

    final updated = _mockPromotions[index].copyWith(
      name: data.name,
      nameAr: data.nameAr,
      description: data.description,
      descriptionAr: data.descriptionAr,
      type: data.type,
      discountValue: data.discountValue,
      isPercentage: data.isPercentage,
      promoCode: data.promoCode,
      startDate: data.startDate,
      endDate: data.endDate,
      usageLimit: data.usageLimit,
      applicablePlanIds: data.applicablePlanIds,
      applicableDurations: data.applicableDurations,
      minPurchaseAmount: data.minPurchaseAmount,
      isActive: data.isActive,
      isFirstTimeOnly: data.isFirstTimeOnly,
    );

    _mockPromotions[index] = updated;
    return Right(updated);
  }

  @override
  Future<Either<Failure, void>> deletePromotion(String promotionId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockPromotions.removeWhere((p) => p.id == promotionId);
    return const Right(null);
  }

  @override
  Future<Either<Failure, Promotion>> togglePromotionStatus(String promotionId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    final index = _mockPromotions.indexWhere((p) => p.id == promotionId);
    if (index == -1) {
      return const Left(ServerFailure('Promotion not found'));
    }

    final updated = _mockPromotions[index].copyWith(
      isActive: !_mockPromotions[index].isActive,
    );
    _mockPromotions[index] = updated;
    return Right(updated);
  }

  @override
  Future<Either<Failure, Promotion>> validatePromoCode(String code) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    try {
      final promo = _mockPromotions.firstWhere(
        (p) => p.promoCode?.toUpperCase() == code.toUpperCase() && p.isCurrentlyActive,
      );
      return Right(promo);
    } catch (e) {
      return const Left(ServerFailure('Invalid or expired promo code'));
    }
  }
}