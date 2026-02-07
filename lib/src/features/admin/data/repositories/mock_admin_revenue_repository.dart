import 'dart:math';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/admin_revenue.dart';
import '../../domain/repositories/admin_revenue_repository.dart';

@LazySingleton(as: AdminRevenueRepository)
class MockAdminRevenueRepository implements AdminRevenueRepository {
  final _random = Random();

  @override
  Future<Either<Failure, RevenueData>> getRevenueData(RevenueFilter filter) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final overview = await getRevenueOverview(filter);
    final chartData = await getChartData(filter);
    final byGym = await getRevenueByGym(filter);
    final transactions = await getTransactions(filter);
    final payouts = await getPendingPayouts();

    return Right(RevenueData(
      overview: overview.getOrElse(() => const RevenueOverview()),
      chartData: chartData.getOrElse(() => []),
      byTier: _generateByTier(),
      byGym: byGym.getOrElse(() => []),
      recentTransactions: transactions.getOrElse(() => []),
      pendingPayouts: payouts.getOrElse(() => []),
    ));
  }

  @override
  Future<Either<Failure, RevenueOverview>> getRevenueOverview(RevenueFilter filter) async {
    await Future.delayed(const Duration(milliseconds: 400));

    return Right(RevenueOverview(
      totalRevenue: 125750.0,
      totalPlatformFees: 37725.0,
      totalGymPayouts: 88025.0,
      pendingPayouts: 12500.0,
      totalTransactions: 342,
      averageTransactionValue: 367.69,
      revenueGrowthPercent: 15.5,
      comparedToPreviousPeriod: 18250.0,
    ));
  }

  @override
  Future<Either<Failure, List<RevenuePeriodData>>> getChartData(RevenueFilter filter) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final List<RevenuePeriodData> data = [];
    final now = DateTime.now();

    // Generate data based on period
    switch (filter.period) {
      case RevenuePeriod.today:
        for (int i = 0; i < 24; i++) {
          data.add(RevenuePeriodData(
            label: '${i.toString().padLeft(2, '0')}:00',
            date: DateTime(now.year, now.month, now.day, i),
            revenue: _random.nextDouble() * 500 + 100,
            platformFees: _random.nextDouble() * 150 + 30,
            gymPayouts: _random.nextDouble() * 350 + 70,
            transactions: _random.nextInt(10) + 1,
          ));
        }
        break;

      case RevenuePeriod.thisWeek:
        final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        for (int i = 0; i < 7; i++) {
          data.add(RevenuePeriodData(
            label: days[i],
            date: now.subtract(Duration(days: now.weekday - 1 - i)),
            revenue: _random.nextDouble() * 5000 + 2000,
            platformFees: _random.nextDouble() * 1500 + 600,
            gymPayouts: _random.nextDouble() * 3500 + 1400,
            transactions: _random.nextInt(50) + 20,
          ));
        }
        break;

      case RevenuePeriod.thisMonth:
      default:
        for (int i = 1; i <= 30; i++) {
          data.add(RevenuePeriodData(
            label: i.toString(),
            date: DateTime(now.year, now.month, i),
            revenue: _random.nextDouble() * 6000 + 3000,
            platformFees: _random.nextDouble() * 1800 + 900,
            gymPayouts: _random.nextDouble() * 4200 + 2100,
            transactions: _random.nextInt(30) + 10,
          ));
        }
    }

    return Right(data);
  }

  List<RevenueByTier> _generateByTier() {
    return [
      const RevenueByTier(
        tierName: 'Premium',
        revenue: 63000,
        subscriptionsCount: 79,
        percentageOfTotal: 50.1,
      ),
      const RevenueByTier(
        tierName: 'Plus',
        revenue: 42500,
        subscriptionsCount: 85,
        percentageOfTotal: 33.8,
      ),
      const RevenueByTier(
        tierName: 'Basic',
        revenue: 20250,
        subscriptionsCount: 67,
        percentageOfTotal: 16.1,
      ),
    ];
  }

  @override
  Future<Either<Failure, List<RevenueByGym>>> getRevenueByGym(RevenueFilter filter) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return const Right([
      RevenueByGym(
        gymId: 'gym_1',
        gymName: 'Gold\'s Gym Cairo',
        city: 'Cairo',
        totalRevenue: 45000,
        platformFees: 13500,
        gymPayout: 31500,
        pendingPayout: 5200,
        visitsCount: 450,
        subscriptionsCount: 85,
        revenueSharePercent: 70,
      ),
      RevenueByGym(
        gymId: 'gym_2',
        gymName: 'Fitness Plus Giza',
        city: 'Giza',
        totalRevenue: 32000,
        platformFees: 11200,
        gymPayout: 20800,
        pendingPayout: 3800,
        visitsCount: 320,
        subscriptionsCount: 62,
        revenueSharePercent: 65,
      ),
      RevenueByGym(
        gymId: 'gym_5',
        gymName: 'Wellness Hub Maadi',
        city: 'Cairo',
        totalRevenue: 28500,
        platformFees: 7125,
        gymPayout: 21375,
        pendingPayout: 2100,
        visitsCount: 285,
        subscriptionsCount: 48,
        revenueSharePercent: 75,
      ),
      RevenueByGym(
        gymId: 'gym_6',
        gymName: 'Elite Fitness Alex',
        city: 'Alexandria',
        totalRevenue: 20250,
        platformFees: 6075,
        gymPayout: 14175,
        pendingPayout: 1400,
        visitsCount: 200,
        subscriptionsCount: 35,
        revenueSharePercent: 70,
      ),
    ]);
  }

  @override
  Future<Either<Failure, List<RevenueTransaction>>> getTransactions(
    RevenueFilter filter, {
    int page = 1,
    int pageSize = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final now = DateTime.now();
    return Right([
      RevenueTransaction(
        id: 'txn_1',
        type: 'subscription',
        userId: 'user_1',
        userName: 'Ahmed Mohamed',
        gymId: 'gym_1',
        gymName: 'Gold\'s Gym Cairo',
        amount: 799,
        platformFee: 239.7,
        gymShare: 559.3,
        paymentMethod: 'Credit Card',
        status: 'completed',
        createdAt: now.subtract(const Duration(hours: 2)),
        subscriptionTier: 'Premium',
        subscriptionDuration: 'Monthly',
      ),
      RevenueTransaction(
        id: 'txn_2',
        type: 'subscription',
        userId: 'user_2',
        userName: 'Sara Ali',
        gymId: 'gym_2',
        gymName: 'Fitness Plus Giza',
        amount: 1299,
        platformFee: 454.65,
        gymShare: 844.35,
        paymentMethod: 'Fawry',
        status: 'completed',
        createdAt: now.subtract(const Duration(hours: 5)),
        subscriptionTier: 'Plus',
        subscriptionDuration: 'Quarterly',
      ),
      RevenueTransaction(
        id: 'txn_3',
        type: 'renewal',
        userId: 'user_6',
        userName: 'Nour Ibrahim',
        gymId: 'gym_5',
        gymName: 'Wellness Hub Maadi',
        amount: 299,
        platformFee: 74.75,
        gymShare: 224.25,
        paymentMethod: 'Vodafone Cash',
        status: 'completed',
        createdAt: now.subtract(const Duration(hours: 8)),
        subscriptionTier: 'Basic',
        subscriptionDuration: 'Monthly',
      ),
      RevenueTransaction(
        id: 'txn_4',
        type: 'subscription',
        userId: 'user_9',
        userName: 'Layla Mostafa',
        gymId: 'gym_1',
        gymName: 'Gold\'s Gym Cairo',
        amount: 2099,
        platformFee: 629.7,
        gymShare: 1469.3,
        paymentMethod: 'InstaPay',
        status: 'completed',
        createdAt: now.subtract(const Duration(days: 1)),
        subscriptionTier: 'Premium',
        subscriptionDuration: 'Quarterly',
      ),
      RevenueTransaction(
        id: 'txn_5',
        type: 'refund',
        userId: 'user_10',
        userName: 'Omar Fathy',
        gymId: 'gym_2',
        gymName: 'Fitness Plus Giza',
        amount: -499,
        platformFee: -149.7,
        gymShare: -349.3,
        paymentMethod: 'Credit Card',
        status: 'refunded',
        createdAt: now.subtract(const Duration(days: 2)),
        subscriptionTier: 'Plus',
        subscriptionDuration: 'Monthly',
      ),
      RevenueTransaction(
        id: 'txn_6',
        type: 'subscription',
        userId: 'user_11',
        userName: 'Yasmin Ahmed',
        amount: 7999,
        platformFee: 2399.7,
        gymShare: 5599.3,
        paymentMethod: 'Credit Card',
        status: 'pending',
        createdAt: now.subtract(const Duration(hours: 1)),
        subscriptionTier: 'Premium',
        subscriptionDuration: 'Yearly',
      ),
    ]);
  }

  @override
  Future<Either<Failure, List<GymPayout>>> getPendingPayouts() async {
    await Future.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now();
    return Right([
      GymPayout(
        id: 'payout_1',
        gymId: 'gym_1',
        gymName: 'Gold\'s Gym Cairo',
        amount: 5200,
        status: 'pending',
        periodStart: now.subtract(const Duration(days: 30)),
        periodEnd: now,
        transactionsCount: 45,
      ),
      GymPayout(
        id: 'payout_2',
        gymId: 'gym_2',
        gymName: 'Fitness Plus Giza',
        amount: 3800,
        status: 'processing',
        periodStart: now.subtract(const Duration(days: 30)),
        periodEnd: now,
        transactionsCount: 32,
      ),
      GymPayout(
        id: 'payout_3',
        gymId: 'gym_5',
        gymName: 'Wellness Hub Maadi',
        amount: 2100,
        status: 'pending',
        periodStart: now.subtract(const Duration(days: 30)),
        periodEnd: now,
        transactionsCount: 24,
      ),
      GymPayout(
        id: 'payout_4',
        gymId: 'gym_6',
        gymName: 'Elite Fitness Alex',
        amount: 1400,
        status: 'pending',
        periodStart: now.subtract(const Duration(days: 30)),
        periodEnd: now,
        transactionsCount: 18,
      ),
    ]);
  }

  @override
  Future<Either<Failure, GymPayout>> processGymPayout(String payoutId) async {
    await Future.delayed(const Duration(milliseconds: 800));

    return Right(GymPayout(
      id: payoutId,
      gymId: 'gym_1',
      gymName: 'Gold\'s Gym Cairo',
      amount: 5200,
      status: 'completed',
      periodStart: DateTime.now().subtract(const Duration(days: 30)),
      periodEnd: DateTime.now(),
      paidAt: DateTime.now(),
      paymentMethod: 'Bank Transfer',
      transactionRef: 'TXN_${DateTime.now().millisecondsSinceEpoch}',
      transactionsCount: 45,
    ));
  }

  @override
  Future<Either<Failure, String>> exportRevenueReport(RevenueFilter filter, String format) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return Right('https://example.com/exports/revenue_report_${DateTime.now().millisecondsSinceEpoch}.$format');
  }
}