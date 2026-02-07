import '../../domain/entities/admin_subscription.dart';

class AdminSubscriptionModel extends AdminSubscription {
  const AdminSubscriptionModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.userEmail,
    super.userAvatarUrl,
    required super.tier,
    required super.duration,
    required super.status,
    required super.price,
    required super.platformFee,
    required super.startDate,
    required super.endDate,
    super.cancelledAt,
    required super.createdAt,
    super.visitsUsed,
    super.visitLimit,
    required super.paymentMethod,
    super.paymentId,
    super.autoRenew,
  });

  factory AdminSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return AdminSubscriptionModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      userEmail: json['user_email'] ?? '',
      userAvatarUrl: json['user_avatar_url'],
      tier: SubscriptionTier.values.firstWhere(
        (t) => t.name == json['tier'],
        orElse: () => SubscriptionTier.basic,
      ),
      duration: SubscriptionDuration.values.firstWhere(
        (d) => d.name == json['duration'],
        orElse: () => SubscriptionDuration.monthly,
      ),
      status: SubscriptionStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => SubscriptionStatus.active,
      ),
      price: (json['price'] ?? 0).toDouble(),
      platformFee: (json['platform_fee'] ?? 0).toDouble(),
      startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['end_date'] ?? '') ?? DateTime.now(),
      cancelledAt: json['cancelled_at'] != null 
          ? DateTime.tryParse(json['cancelled_at']) 
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      visitsUsed: json['visits_used'] ?? 0,
      visitLimit: json['visit_limit'],
      paymentMethod: json['payment_method'] ?? 'Unknown',
      paymentId: json['payment_id'],
      autoRenew: json['auto_renew'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'user_email': userEmail,
      'user_avatar_url': userAvatarUrl,
      'tier': tier.name,
      'duration': duration.name,
      'status': status.name,
      'price': price,
      'platform_fee': platformFee,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'cancelled_at': cancelledAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'visits_used': visitsUsed,
      'visit_limit': visitLimit,
      'payment_method': paymentMethod,
      'payment_id': paymentId,
      'auto_renew': autoRenew,
    };
  }

  factory AdminSubscriptionModel.fromEntity(AdminSubscription entity) {
    return AdminSubscriptionModel(
      id: entity.id,
      userId: entity.userId,
      userName: entity.userName,
      userEmail: entity.userEmail,
      userAvatarUrl: entity.userAvatarUrl,
      tier: entity.tier,
      duration: entity.duration,
      status: entity.status,
      price: entity.price,
      platformFee: entity.platformFee,
      startDate: entity.startDate,
      endDate: entity.endDate,
      cancelledAt: entity.cancelledAt,
      createdAt: entity.createdAt,
      visitsUsed: entity.visitsUsed,
      visitLimit: entity.visitLimit,
      paymentMethod: entity.paymentMethod,
      paymentId: entity.paymentId,
      autoRenew: entity.autoRenew,
    );
  }
}

class SubscriptionsStatsModel extends SubscriptionsStats {
  const SubscriptionsStatsModel({
    super.totalSubscriptions,
    super.activeSubscriptions,
    super.expiredSubscriptions,
    super.cancelledSubscriptions,
    super.expiringThisWeek,
    super.totalRevenue,
    super.revenueThisMonth,
    super.platformEarnings,
    super.basicCount,
    super.plusCount,
    super.premiumCount,
    super.averageSubscriptionValue,
    super.renewalRate,
  });

  factory SubscriptionsStatsModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionsStatsModel(
      totalSubscriptions: json['total_subscriptions'] ?? 0,
      activeSubscriptions: json['active_subscriptions'] ?? 0,
      expiredSubscriptions: json['expired_subscriptions'] ?? 0,
      cancelledSubscriptions: json['cancelled_subscriptions'] ?? 0,
      expiringThisWeek: json['expiring_this_week'] ?? 0,
      totalRevenue: (json['total_revenue'] ?? 0).toDouble(),
      revenueThisMonth: (json['revenue_this_month'] ?? 0).toDouble(),
      platformEarnings: (json['platform_earnings'] ?? 0).toDouble(),
      basicCount: json['basic_count'] ?? 0,
      plusCount: json['plus_count'] ?? 0,
      premiumCount: json['premium_count'] ?? 0,
      averageSubscriptionValue: (json['average_subscription_value'] ?? 0).toDouble(),
      renewalRate: (json['renewal_rate'] ?? 0).toDouble(),
    );
  }
}