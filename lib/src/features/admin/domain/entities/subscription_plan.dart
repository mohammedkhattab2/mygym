import 'package:mygym/src/features/admin/domain/entities/admin_subscription.dart';

/// Subscription Plan Entity - الخطط اللي الأدمن بيعملها
class SubscriptionPlan {
  final String id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final SubscriptionTier tier;
  final double monthlyPrice;
  final double quarterlyPrice;
  final double yearlyPrice;
  final int? monthlyVisitLimit;
  final int? quarterlyVisitLimit;
  final int? yearlyVisitLimit;
  final bool unlimitedVisits;
  final int dailyVisitLimit;
  final int weeklyVisitLimit;
  final List<String> features;
  final List<String> featuresAr;
  final List<String> includedGymIds; // جيمات معينة أو فاضي = كل الجيمات
  final bool isActive;
  final bool isPopular;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.tier,
    required this.monthlyPrice,
    required this.quarterlyPrice,
    required this.yearlyPrice,
    this.monthlyVisitLimit,
    this.quarterlyVisitLimit,
    this.yearlyVisitLimit,
    this.unlimitedVisits = false,
    this.dailyVisitLimit = 1,
    this.weeklyVisitLimit = 7,
    required this.features,
    required this.featuresAr,
    this.includedGymIds = const [],
    this.isActive = true,
    this.isPopular = false,
    this.sortOrder = 0,
    required this.createdAt,
    this.updatedAt,
  });

  double getPriceForDuration(SubscriptionDuration duration) {
    switch (duration) {
      case SubscriptionDuration.monthly:
        return monthlyPrice;
      case SubscriptionDuration.quarterly:
        return quarterlyPrice;
      case SubscriptionDuration.yearly:
        return yearlyPrice;
    }
  }

  int? getVisitLimitForDuration(SubscriptionDuration duration) {
    if (unlimitedVisits) return null;
    switch (duration) {
      case SubscriptionDuration.monthly:
        return monthlyVisitLimit;
      case SubscriptionDuration.quarterly:
        return quarterlyVisitLimit;
      case SubscriptionDuration.yearly:
        return yearlyVisitLimit;
    }
  }

  SubscriptionPlan copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    SubscriptionTier? tier,
    double? monthlyPrice,
    double? quarterlyPrice,
    double? yearlyPrice,
    int? monthlyVisitLimit,
    int? quarterlyVisitLimit,
    int? yearlyVisitLimit,
    bool? unlimitedVisits,
    int? dailyVisitLimit,
    int? weeklyVisitLimit,
    List<String>? features,
    List<String>? featuresAr,
    List<String>? includedGymIds,
    bool? isActive,
    bool? isPopular,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      tier: tier ?? this.tier,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      quarterlyPrice: quarterlyPrice ?? this.quarterlyPrice,
      yearlyPrice: yearlyPrice ?? this.yearlyPrice,
      monthlyVisitLimit: monthlyVisitLimit ?? this.monthlyVisitLimit,
      quarterlyVisitLimit: quarterlyVisitLimit ?? this.quarterlyVisitLimit,
      yearlyVisitLimit: yearlyVisitLimit ?? this.yearlyVisitLimit,
      unlimitedVisits: unlimitedVisits ?? this.unlimitedVisits,
      dailyVisitLimit: dailyVisitLimit ?? this.dailyVisitLimit,
      weeklyVisitLimit: weeklyVisitLimit ?? this.weeklyVisitLimit,
      features: features ?? this.features,
      featuresAr: featuresAr ?? this.featuresAr,
      includedGymIds: includedGymIds ?? this.includedGymIds,
      isActive: isActive ?? this.isActive,
      isPopular: isPopular ?? this.isPopular,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Promotion/Offer Entity - العروض
class Promotion {
  final String id;
  final String name;
  final String nameAr;
  final String? description;
  final String? descriptionAr;
  final PromotionType type;
  final double discountValue; // نسبة أو مبلغ
  final bool isPercentage;
  final String? promoCode;
  final DateTime startDate;
  final DateTime endDate;
  final int? usageLimit;
  final int usageCount;
  final List<String> applicablePlanIds; // فاضي = كل الخطط
  final List<String> applicableDurations; // monthly, quarterly, yearly
  final double? minPurchaseAmount;
  final bool isActive;
  final bool isFirstTimeOnly;
  final DateTime createdAt;

  const Promotion({
    required this.id,
    required this.name,
    required this.nameAr,
    this.description,
    this.descriptionAr,
    required this.type,
    required this.discountValue,
    this.isPercentage = true,
    this.promoCode,
    required this.startDate,
    required this.endDate,
    this.usageLimit,
    this.usageCount = 0,
    this.applicablePlanIds = const [],
    this.applicableDurations = const [],
    this.minPurchaseAmount,
    this.isActive = true,
    this.isFirstTimeOnly = false,
    required this.createdAt,
  });

  bool get isExpired => DateTime.now().isAfter(endDate);
  bool get isNotStarted => DateTime.now().isBefore(startDate);
  bool get isCurrentlyActive => isActive && !isExpired && !isNotStarted;
  bool get hasUsageLimit => usageLimit != null;
  bool get isUsageLimitReached => hasUsageLimit && usageCount >= usageLimit!;

  double calculateDiscount(double originalPrice) {
    if (isPercentage) {
      return originalPrice * (discountValue / 100);
    }
    return discountValue;
  }

  Promotion copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    PromotionType? type,
    double? discountValue,
    bool? isPercentage,
    String? promoCode,
    DateTime? startDate,
    DateTime? endDate,
    int? usageLimit,
    int? usageCount,
    List<String>? applicablePlanIds,
    List<String>? applicableDurations,
    double? minPurchaseAmount,
    bool? isActive,
    bool? isFirstTimeOnly,
    DateTime? createdAt,
  }) {
    return Promotion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      type: type ?? this.type,
      discountValue: discountValue ?? this.discountValue,
      isPercentage: isPercentage ?? this.isPercentage,
      promoCode: promoCode ?? this.promoCode,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      usageLimit: usageLimit ?? this.usageLimit,
      usageCount: usageCount ?? this.usageCount,
      applicablePlanIds: applicablePlanIds ?? this.applicablePlanIds,
      applicableDurations: applicableDurations ?? this.applicableDurations,
      minPurchaseAmount: minPurchaseAmount ?? this.minPurchaseAmount,
      isActive: isActive ?? this.isActive,
      isFirstTimeOnly: isFirstTimeOnly ?? this.isFirstTimeOnly,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum PromotionType {
  discount,      // خصم عادي
  flashSale,     // عرض سريع
  seasonal,      // موسمي (رمضان، صيف، الخ)
  referral,      // إحالة صديق
  firstTime,     // أول اشتراك
  renewal,       // تجديد
  bundle,        // باقة
}

extension PromotionTypeX on PromotionType {
  String get displayName {
    switch (this) {
      case PromotionType.discount: return 'Discount';
      case PromotionType.flashSale: return 'Flash Sale';
      case PromotionType.seasonal: return 'Seasonal';
      case PromotionType.referral: return 'Referral';
      case PromotionType.firstTime: return 'First Time';
      case PromotionType.renewal: return 'Renewal';
      case PromotionType.bundle: return 'Bundle';
    }
  }
}

/// Form data for creating/editing plans
class SubscriptionPlanFormData {
  final String? id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final SubscriptionTier tier;
  final double monthlyPrice;
  final double quarterlyPrice;
  final double yearlyPrice;
  final int? monthlyVisitLimit;
  final int? quarterlyVisitLimit;
  final int? yearlyVisitLimit;
  final bool unlimitedVisits;
  final int dailyVisitLimit;
  final int weeklyVisitLimit;
  final List<String> features;
  final List<String> featuresAr;
  final List<String> includedGymIds;
  final bool isActive;
  final bool isPopular;
  final int sortOrder;

  const SubscriptionPlanFormData({
    this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.tier,
    required this.monthlyPrice,
    required this.quarterlyPrice,
    required this.yearlyPrice,
    this.monthlyVisitLimit,
    this.quarterlyVisitLimit,
    this.yearlyVisitLimit,
    this.unlimitedVisits = false,
    this.dailyVisitLimit = 1,
    this.weeklyVisitLimit = 7,
    required this.features,
    required this.featuresAr,
    this.includedGymIds = const [],
    this.isActive = true,
    this.isPopular = false,
    this.sortOrder = 0,
  });
}

/// Form data for creating/editing promotions
class PromotionFormData {
  final String? id;
  final String name;
  final String nameAr;
  final String? description;
  final String? descriptionAr;
  final PromotionType type;
  final double discountValue;
  final bool isPercentage;
  final String? promoCode;
  final DateTime startDate;
  final DateTime endDate;
  final int? usageLimit;
  final List<String> applicablePlanIds;
  final List<String> applicableDurations;
  final double? minPurchaseAmount;
  final bool isActive;
  final bool isFirstTimeOnly;

  const PromotionFormData({
    this.id,
    required this.name,
    required this.nameAr,
    this.description,
    this.descriptionAr,
    required this.type,
    required this.discountValue,
    this.isPercentage = true,
    this.promoCode,
    required this.startDate,
    required this.endDate,
    this.usageLimit,
    this.applicablePlanIds = const [],
    this.applicableDurations = const [],
    this.minPurchaseAmount,
    this.isActive = true,
    this.isFirstTimeOnly = false,
  });
}