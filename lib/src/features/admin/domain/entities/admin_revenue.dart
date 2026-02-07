/// Revenue period for filtering
enum RevenuePeriod {
  today,
  thisWeek,
  thisMonth,
  thisQuarter,
  thisYear,
  custom,
}

extension RevenuePeriodX on RevenuePeriod {
  String get displayName {
    switch (this) {
      case RevenuePeriod.today: return 'Today';
      case RevenuePeriod.thisWeek: return 'This Week';
      case RevenuePeriod.thisMonth: return 'This Month';
      case RevenuePeriod.thisQuarter: return 'This Quarter';
      case RevenuePeriod.thisYear: return 'This Year';
      case RevenuePeriod.custom: return 'Custom';
    }
  }
}

/// Revenue Overview Statistics
class RevenueOverview {
  final double totalRevenue;
  final double totalPlatformFees;
  final double totalGymPayouts;
  final double pendingPayouts;
  final int totalTransactions;
  final double averageTransactionValue;
  final double revenueGrowthPercent;
  final double comparedToPreviousPeriod;

  const RevenueOverview({
    this.totalRevenue = 0,
    this.totalPlatformFees = 0,
    this.totalGymPayouts = 0,
    this.pendingPayouts = 0,
    this.totalTransactions = 0,
    this.averageTransactionValue = 0,
    this.revenueGrowthPercent = 0,
    this.comparedToPreviousPeriod = 0,
  });
}

/// Revenue by period (for charts)
class RevenuePeriodData {
  final String label; // "Jan", "Week 1", "Mon", etc.
  final DateTime date;
  final double revenue;
  final double platformFees;
  final double gymPayouts;
  final int transactions;

  const RevenuePeriodData({
    required this.label,
    required this.date,
    required this.revenue,
    required this.platformFees,
    required this.gymPayouts,
    required this.transactions,
  });
}

/// Revenue by subscription tier
class RevenueByTier {
  final String tierName;
  final double revenue;
  final int subscriptionsCount;
  final double percentageOfTotal;

  const RevenueByTier({
    required this.tierName,
    required this.revenue,
    required this.subscriptionsCount,
    required this.percentageOfTotal,
  });
}

/// Revenue by gym
class RevenueByGym {
  final String gymId;
  final String gymName;
  final String city;
  final double totalRevenue;
  final double platformFees;
  final double gymPayout;
  final double pendingPayout;
  final int visitsCount;
  final int subscriptionsCount;
  final double revenueSharePercent;

  const RevenueByGym({
    required this.gymId,
    required this.gymName,
    required this.city,
    required this.totalRevenue,
    required this.platformFees,
    required this.gymPayout,
    this.pendingPayout = 0,
    required this.visitsCount,
    required this.subscriptionsCount,
    required this.revenueSharePercent,
  });
}

/// Transaction record
class RevenueTransaction {
  final String id;
  final String type; // subscription, renewal, refund
  final String userId;
  final String userName;
  final String? gymId;
  final String? gymName;
  final double amount;
  final double platformFee;
  final double gymShare;
  final String paymentMethod;
  final String status; // completed, pending, failed, refunded
  final DateTime createdAt;
  final String? subscriptionTier;
  final String? subscriptionDuration;

  const RevenueTransaction({
    required this.id,
    required this.type,
    required this.userId,
    required this.userName,
    this.gymId,
    this.gymName,
    required this.amount,
    required this.platformFee,
    required this.gymShare,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.subscriptionTier,
    this.subscriptionDuration,
  });
}

/// Payout record
class GymPayout {
  final String id;
  final String gymId;
  final String gymName;
  final double amount;
  final String status; // pending, processing, completed, failed
  final DateTime periodStart;
  final DateTime periodEnd;
  final DateTime? paidAt;
  final String? paymentMethod;
  final String? transactionRef;
  final int transactionsCount;

  const GymPayout({
    required this.id,
    required this.gymId,
    required this.gymName,
    required this.amount,
    required this.status,
    required this.periodStart,
    required this.periodEnd,
    this.paidAt,
    this.paymentMethod,
    this.transactionRef,
    required this.transactionsCount,
  });
}

/// Revenue filter
class RevenueFilter {
  final RevenuePeriod period;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? gymId;
  final String? subscriptionTier;
  final String? paymentMethod;

  const RevenueFilter({
    this.period = RevenuePeriod.thisMonth,
    this.startDate,
    this.endDate,
    this.gymId,
    this.subscriptionTier,
    this.paymentMethod,
  });

  RevenueFilter copyWith({
    RevenuePeriod? period,
    DateTime? startDate,
    DateTime? endDate,
    String? gymId,
    String? subscriptionTier,
    String? paymentMethod,
  }) {
    return RevenueFilter(
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      gymId: gymId ?? this.gymId,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  DateTime get effectiveStartDate {
    if (startDate != null) return startDate!;
    final now = DateTime.now();
    switch (period) {
      case RevenuePeriod.today:
        return DateTime(now.year, now.month, now.day);
      case RevenuePeriod.thisWeek:
        return now.subtract(Duration(days: now.weekday - 1));
      case RevenuePeriod.thisMonth:
        return DateTime(now.year, now.month, 1);
      case RevenuePeriod.thisQuarter:
        final quarter = ((now.month - 1) ~/ 3) * 3 + 1;
        return DateTime(now.year, quarter, 1);
      case RevenuePeriod.thisYear:
        return DateTime(now.year, 1, 1);
      case RevenuePeriod.custom:
        return now.subtract(const Duration(days: 30));
    }
  }

  DateTime get effectiveEndDate {
    return endDate ?? DateTime.now();
  }
}

/// Complete revenue data
class RevenueData {
  final RevenueOverview overview;
  final List<RevenuePeriodData> chartData;
  final List<RevenueByTier> byTier;
  final List<RevenueByGym> byGym;
  final List<RevenueTransaction> recentTransactions;
  final List<GymPayout> pendingPayouts;

  const RevenueData({
    required this.overview,
    required this.chartData,
    required this.byTier,
    required this.byGym,
    required this.recentTransactions,
    required this.pendingPayouts,
  });
}