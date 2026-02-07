/// Subscription status
enum SubscriptionStatus {
  active,
  expired,
  cancelled,
  paused,
  pendingPayment,
}

extension SubscriptionStatusX on SubscriptionStatus {
  String get displayName {
    switch (this) {
      case SubscriptionStatus.active: return 'Active';
      case SubscriptionStatus.expired: return 'Expired';
      case SubscriptionStatus.cancelled: return 'Cancelled';
      case SubscriptionStatus.paused: return 'Paused';
      case SubscriptionStatus.pendingPayment: return 'Pending Payment';
    }
  }
}

/// Subscription tier
enum SubscriptionTier {
  basic,
  plus,
  premium,
}

extension SubscriptionTierX on SubscriptionTier {
  String get displayName {
    switch (this) {
      case SubscriptionTier.basic: return 'Basic';
      case SubscriptionTier.plus: return 'Plus';
      case SubscriptionTier.premium: return 'Premium';
    }
  }
}

/// Subscription duration
enum SubscriptionDuration {
  monthly,
  quarterly,
  yearly,
}

extension SubscriptionDurationX on SubscriptionDuration {
  String get displayName {
    switch (this) {
      case SubscriptionDuration.monthly: return 'Monthly';
      case SubscriptionDuration.quarterly: return 'Quarterly';
      case SubscriptionDuration.yearly: return 'Yearly';
    }
  }
  
  int get months {
    switch (this) {
      case SubscriptionDuration.monthly: return 1;
      case SubscriptionDuration.quarterly: return 3;
      case SubscriptionDuration.yearly: return 12;
    }
  }
}

/// Admin Subscription entity
class AdminSubscription {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String? userAvatarUrl;
  final SubscriptionTier tier;
  final SubscriptionDuration duration;
  final SubscriptionStatus status;
  final double price;
  final double platformFee;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? cancelledAt;
  final DateTime createdAt;
  final int visitsUsed;
  final int? visitLimit;
  final String paymentMethod;
  final String? paymentId;
  final bool autoRenew;

  const AdminSubscription({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    this.userAvatarUrl,
    required this.tier,
    required this.duration,
    required this.status,
    required this.price,
    required this.platformFee,
    required this.startDate,
    required this.endDate,
    this.cancelledAt,
    required this.createdAt,
    this.visitsUsed = 0,
    this.visitLimit,
    required this.paymentMethod,
    this.paymentId,
    this.autoRenew = true,
  });

  double get gymShare => price - platformFee;
  
  int get daysRemaining {
    final now = DateTime.now();
    if (endDate.isBefore(now)) return 0;
    return endDate.difference(now).inDays;
  }
  
  bool get isExpiringSoon => daysRemaining > 0 && daysRemaining <= 7;

  AdminSubscription copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userEmail,
    String? userAvatarUrl,
    SubscriptionTier? tier,
    SubscriptionDuration? duration,
    SubscriptionStatus? status,
    double? price,
    double? platformFee,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? cancelledAt,
    DateTime? createdAt,
    int? visitsUsed,
    int? visitLimit,
    String? paymentMethod,
    String? paymentId,
    bool? autoRenew,
  }) {
    return AdminSubscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      tier: tier ?? this.tier,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      price: price ?? this.price,
      platformFee: platformFee ?? this.platformFee,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      createdAt: createdAt ?? this.createdAt,
      visitsUsed: visitsUsed ?? this.visitsUsed,
      visitLimit: visitLimit ?? this.visitLimit,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentId: paymentId ?? this.paymentId,
      autoRenew: autoRenew ?? this.autoRenew,
    );
  }
}

/// Subscription filter
class AdminSubscriptionFilter {
  final String? searchQuery;
  final SubscriptionStatus? status;
  final SubscriptionTier? tier;
  final SubscriptionDuration? duration;
  final DateTime? startDateFrom;
  final DateTime? startDateTo;
  final bool? expiringOnly;
  final AdminSubscriptionSortBy sortBy;
  final bool sortAscending;
  final int page;
  final int pageSize;

  const AdminSubscriptionFilter({
    this.searchQuery,
    this.status,
    this.tier,
    this.duration,
    this.startDateFrom,
    this.startDateTo,
    this.expiringOnly,
    this.sortBy = AdminSubscriptionSortBy.createdAt,
    this.sortAscending = false,
    this.page = 1,
    this.pageSize = 20,
  });

  AdminSubscriptionFilter copyWith({
    String? searchQuery,
    SubscriptionStatus? status,
    SubscriptionTier? tier,
    SubscriptionDuration? duration,
    DateTime? startDateFrom,
    DateTime? startDateTo,
    bool? expiringOnly,
    AdminSubscriptionSortBy? sortBy,
    bool? sortAscending,
    int? page,
    int? pageSize,
  }) {
    return AdminSubscriptionFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
      tier: tier ?? this.tier,
      duration: duration ?? this.duration,
      startDateFrom: startDateFrom ?? this.startDateFrom,
      startDateTo: startDateTo ?? this.startDateTo,
      expiringOnly: expiringOnly ?? this.expiringOnly,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

enum AdminSubscriptionSortBy {
  userName,
  tier,
  status,
  startDate,
  endDate,
  price,
  createdAt,
}

/// Paginated subscriptions
class PaginatedSubscriptions {
  final List<AdminSubscription> subscriptions;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  const PaginatedSubscriptions({
    required this.subscriptions,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
  });
}

/// Subscription statistics
class SubscriptionsStats {
  final int totalSubscriptions;
  final int activeSubscriptions;
  final int expiredSubscriptions;
  final int cancelledSubscriptions;
  final int expiringThisWeek;
  final double totalRevenue;
  final double revenueThisMonth;
  final double platformEarnings;
  final int basicCount;
  final int plusCount;
  final int premiumCount;
  final double averageSubscriptionValue;
  final double renewalRate;

  const SubscriptionsStats({
    this.totalSubscriptions = 0,
    this.activeSubscriptions = 0,
    this.expiredSubscriptions = 0,
    this.cancelledSubscriptions = 0,
    this.expiringThisWeek = 0,
    this.totalRevenue = 0,
    this.revenueThisMonth = 0,
    this.platformEarnings = 0,
    this.basicCount = 0,
    this.plusCount = 0,
    this.premiumCount = 0,
    this.averageSubscriptionValue = 0,
    this.renewalRate = 0,
  });
}