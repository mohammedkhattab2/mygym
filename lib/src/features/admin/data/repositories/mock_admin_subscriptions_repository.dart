import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/admin_subscription.dart';
import '../../domain/repositories/admin_subscriptions_repository.dart';

@LazySingleton(as: AdminSubscriptionsRepository)
@Environment('dev') // For development/testing only
class MockAdminSubscriptionsRepository implements AdminSubscriptionsRepository {
  
  final List<AdminSubscription> _mockSubscriptions = [
    AdminSubscription(
      id: 'sub_1',
      userId: 'user_1',
      userName: 'Ahmed Mohamed',
      userEmail: 'ahmed@example.com',
      tier: SubscriptionTier.premium,
      duration: SubscriptionDuration.monthly,
      status: SubscriptionStatus.active,
      price: 500,
      platformFee: 150,
      startDate: DateTime.now().subtract(const Duration(days: 15)),
      endDate: DateTime.now().add(const Duration(days: 15)),
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      visitsUsed: 8,
      visitLimit: null,
      paymentMethod: 'Credit Card',
      paymentId: 'pay_123',
      autoRenew: true,
    ),
    AdminSubscription(
      id: 'sub_2',
      userId: 'user_2',
      userName: 'Sara Ali',
      userEmail: 'sara@example.com',
      tier: SubscriptionTier.plus,
      duration: SubscriptionDuration.quarterly,
      status: SubscriptionStatus.active,
      price: 1200,
      platformFee: 360,
      startDate: DateTime.now().subtract(const Duration(days: 60)),
      endDate: DateTime.now().add(const Duration(days: 30)),
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      visitsUsed: 24,
      visitLimit: 36,
      paymentMethod: 'Fawry',
      paymentId: 'pay_456',
      autoRenew: true,
    ),
    AdminSubscription(
      id: 'sub_3',
      userId: 'user_6',
      userName: 'Nour Ibrahim',
      userEmail: 'nour@example.com',
      tier: SubscriptionTier.basic,
      duration: SubscriptionDuration.monthly,
      status: SubscriptionStatus.active,
      price: 300,
      platformFee: 90,
      startDate: DateTime.now().subtract(const Duration(days: 25)),
      endDate: DateTime.now().add(const Duration(days: 5)),
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      visitsUsed: 10,
      visitLimit: 12,
      paymentMethod: 'Vodafone Cash',
      autoRenew: false,
    ),
    AdminSubscription(
      id: 'sub_4',
      userId: 'user_4',
      userName: 'Mohamed Hassan',
      userEmail: 'mohamed@example.com',
      tier: SubscriptionTier.basic,
      duration: SubscriptionDuration.monthly,
      status: SubscriptionStatus.expired,
      price: 300,
      platformFee: 90,
      startDate: DateTime.now().subtract(const Duration(days: 60)),
      endDate: DateTime.now().subtract(const Duration(days: 30)),
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      visitsUsed: 12,
      visitLimit: 12,
      paymentMethod: 'Credit Card',
      autoRenew: false,
    ),
    AdminSubscription(
      id: 'sub_5',
      userId: 'user_8',
      userName: 'Youssef Khaled',
      userEmail: 'youssef@example.com',
      tier: SubscriptionTier.plus,
      duration: SubscriptionDuration.yearly,
      status: SubscriptionStatus.cancelled,
      price: 4000,
      platformFee: 1200,
      startDate: DateTime.now().subtract(const Duration(days: 180)),
      endDate: DateTime.now().add(const Duration(days: 185)),
      cancelledAt: DateTime.now().subtract(const Duration(days: 10)),
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
      visitsUsed: 56,
      paymentMethod: 'Credit Card',
      autoRenew: false,
    ),
    AdminSubscription(
      id: 'sub_6',
      userId: 'user_9',
      userName: 'Layla Mostafa',
      userEmail: 'layla@example.com',
      tier: SubscriptionTier.premium,
      duration: SubscriptionDuration.quarterly,
      status: SubscriptionStatus.active,
      price: 1400,
      platformFee: 420,
      startDate: DateTime.now().subtract(const Duration(days: 45)),
      endDate: DateTime.now().add(const Duration(days: 45)),
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      visitsUsed: 18,
      paymentMethod: 'InstaPay',
      autoRenew: true,
    ),
    AdminSubscription(
      id: 'sub_7',
      userId: 'user_10',
      userName: 'Omar Fathy',
      userEmail: 'omar@example.com',
      tier: SubscriptionTier.basic,
      duration: SubscriptionDuration.monthly,
      status: SubscriptionStatus.paused,
      price: 300,
      platformFee: 90,
      startDate: DateTime.now().subtract(const Duration(days: 20)),
      endDate: DateTime.now().add(const Duration(days: 10)),
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      visitsUsed: 5,
      visitLimit: 12,
      paymentMethod: 'Fawry',
      autoRenew: true,
    ),
  ];

  @override
  Future<Either<Failure, PaginatedSubscriptions>> getSubscriptions(AdminSubscriptionFilter filter) async {
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      var filtered = List<AdminSubscription>.from(_mockSubscriptions);

      if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
        final query = filter.searchQuery!.toLowerCase();
        filtered = filtered.where((s) =>
            s.userName.toLowerCase().contains(query) ||
            s.userEmail.toLowerCase().contains(query) ||
            s.id.contains(query)).toList();
      }

      if (filter.status != null) {
        filtered = filtered.where((s) => s.status == filter.status).toList();
      }

      if (filter.tier != null) {
        filtered = filtered.where((s) => s.tier == filter.tier).toList();
      }

      if (filter.duration != null) {
        filtered = filtered.where((s) => s.duration == filter.duration).toList();
      }

      if (filter.expiringOnly == true) {
        filtered = filtered.where((s) => s.isExpiringSoon && s.status == SubscriptionStatus.active).toList();
      }

      // Sort
      filtered.sort((a, b) {
        int cmp;
        switch (filter.sortBy) {
          case AdminSubscriptionSortBy.userName:
            cmp = a.userName.compareTo(b.userName);
            break;
          case AdminSubscriptionSortBy.tier:
            cmp = a.tier.index.compareTo(b.tier.index);
            break;
          case AdminSubscriptionSortBy.status:
            cmp = a.status.index.compareTo(b.status.index);
            break;
          case AdminSubscriptionSortBy.startDate:
            cmp = a.startDate.compareTo(b.startDate);
            break;
          case AdminSubscriptionSortBy.endDate:
            cmp = a.endDate.compareTo(b.endDate);
            break;
          case AdminSubscriptionSortBy.price:
            cmp = a.price.compareTo(b.price);
            break;
          case AdminSubscriptionSortBy.createdAt:
            cmp = a.createdAt.compareTo(b.createdAt);
            break;
        }
        return filter.sortAscending ? cmp : -cmp;
      });

      final total = filtered.length;
      final totalPages = (total / filter.pageSize).ceil();
      final start = (filter.page - 1) * filter.pageSize;
      final end = start + filter.pageSize;

      final paginated = filtered.sublist(
        start.clamp(0, filtered.length),
        end.clamp(0, filtered.length),
      );

      return Right(PaginatedSubscriptions(
        subscriptions: paginated,
        totalCount: total,
        currentPage: filter.page,
        totalPages: totalPages == 0 ? 1 : totalPages,
        hasMore: filter.page < totalPages,
      ));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminSubscription>> getSubscriptionById(String subscriptionId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final sub = _mockSubscriptions.firstWhere((s) => s.id == subscriptionId);
      return Right(sub);
    } catch (e) {
      return const Left(ServerFailure('Subscription not found'));
    }
  }

  @override
  Future<Either<Failure, SubscriptionsStats>> getSubscriptionsStats() async {
    await Future.delayed(const Duration(milliseconds: 600));

    final active = _mockSubscriptions.where((s) => s.status == SubscriptionStatus.active).length;
    final expired = _mockSubscriptions.where((s) => s.status == SubscriptionStatus.expired).length;
    final cancelled = _mockSubscriptions.where((s) => s.status == SubscriptionStatus.cancelled).length;
    final expiring = _mockSubscriptions.where((s) => s.isExpiringSoon).length;
    
    double totalRevenue = 0;
    double platformEarnings = 0;
    int basic = 0, plus = 0, premium = 0;
    
    for (final s in _mockSubscriptions) {
      totalRevenue += s.price;
      platformEarnings += s.platformFee;
      if (s.tier == SubscriptionTier.basic) basic++;
      if (s.tier == SubscriptionTier.plus) plus++;
      if (s.tier == SubscriptionTier.premium) premium++;
    }

    return Right(SubscriptionsStats(
      totalSubscriptions: _mockSubscriptions.length,
      activeSubscriptions: active,
      expiredSubscriptions: expired,
      cancelledSubscriptions: cancelled,
      expiringThisWeek: expiring,
      totalRevenue: totalRevenue,
      revenueThisMonth: 4500,
      platformEarnings: platformEarnings,
      basicCount: basic,
      plusCount: plus,
      premiumCount: premium,
      averageSubscriptionValue: totalRevenue / _mockSubscriptions.length,
      renewalRate: 72.5,
    ));
  }

  @override
  Future<Either<Failure, AdminSubscription>> cancelSubscription(String subscriptionId, String reason) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final idx = _mockSubscriptions.indexWhere((s) => s.id == subscriptionId);
      if (idx == -1) return const Left(ServerFailure('Not found'));
      
      final updated = _mockSubscriptions[idx].copyWith(
        status: SubscriptionStatus.cancelled,
        cancelledAt: DateTime.now(),
        autoRenew: false,
      );
      _mockSubscriptions[idx] = updated;
      return Right(updated);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminSubscription>> pauseSubscription(String subscriptionId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final idx = _mockSubscriptions.indexWhere((s) => s.id == subscriptionId);
      if (idx == -1) return const Left(ServerFailure('Not found'));
      
      final updated = _mockSubscriptions[idx].copyWith(status: SubscriptionStatus.paused);
      _mockSubscriptions[idx] = updated;
      return Right(updated);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminSubscription>> resumeSubscription(String subscriptionId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final idx = _mockSubscriptions.indexWhere((s) => s.id == subscriptionId);
      if (idx == -1) return const Left(ServerFailure('Not found'));
      
      final updated = _mockSubscriptions[idx].copyWith(status: SubscriptionStatus.active);
      _mockSubscriptions[idx] = updated;
      return Right(updated);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminSubscription>> extendSubscription(String subscriptionId, int days) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final idx = _mockSubscriptions.indexWhere((s) => s.id == subscriptionId);
      if (idx == -1) return const Left(ServerFailure('Not found'));
      
      final current = _mockSubscriptions[idx];
      final updated = current.copyWith(
        endDate: current.endDate.add(Duration(days: days)),
      );
      _mockSubscriptions[idx] = updated;
      return Right(updated);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportSubscriptionsToCSV(AdminSubscriptionFilter filter) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return const Right('https://example.com/exports/subscriptions.csv');
  }

  @override
  Future<Either<Failure, int>> sendRenewalReminders(List<String> subscriptionIds) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return Right(subscriptionIds.length);
  }
}