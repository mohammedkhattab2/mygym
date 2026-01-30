// lib/src/features/rewards/data/repositories/rewards_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mygym/src/core/error/failures.dart';
import '../../domain/entities/reward.dart';
import '../../domain/repositories/rewards_repository.dart';

@LazySingleton(as: RewardsRepository)
class RewardsRepositoryImpl implements RewardsRepository {
  
  // Dummy user ID - replace with actual auth
  static const _dummyUserId = 'user_1';

  @override
  Future<Either<Failure, UserRewards>> getUserRewards() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return Right(UserRewards(
      userId: _dummyUserId,
      currentPoints: 2450,
      lifetimePoints: 5200,
      pendingPoints: 100,
      expiringPoints: 300,
      expiringDate: DateTime.now().add(const Duration(days: 30)),
      totalRedemptions: 5,
      referralCount: 3,
      referralCode: 'AHMED2024',
      tier: MembershipTier.silver,
      pointsToNextTier: 2550, // Need 5000 for Gold
    ));
  }

  @override
  Future<Either<Failure, List<RewardItem>>> getRewardItems() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final items = [
      RewardItem(
        id: 'reward_1',
        name: 'Free Day Pass',
        description: 'Get a free day pass to any gym in our network',
        type: RewardType.freeVisit,
        pointsCost: 500,
        isAvailable: true,
        stockCount: null,
        validUntil: DateTime.now().add(const Duration(days: 90)),
      ),
      RewardItem(
        id: 'reward_2',
        name: '20% Discount',
        description: 'Get 20% off your next monthly subscription',
        type: RewardType.discount,
        pointsCost: 1000,
        isAvailable: true,
        stockCount: 50,
        validUntil: DateTime.now().add(const Duration(days: 60)),
      ),
      RewardItem(
        id: 'reward_3',
        name: 'Free Class Pass',
        description: 'Book any premium class for free',
        type: RewardType.classPass,
        pointsCost: 750,
        isAvailable: true,
        stockCount: null,
      ),
      RewardItem(
        id: 'reward_4',
        name: 'Guest Pass',
        description: 'Bring a friend for free for one day',
        type: RewardType.guestPass,
        pointsCost: 400,
        isAvailable: true,
        stockCount: 100,
      ),
      RewardItem(
        id: 'reward_5',
        name: 'Premium T-Shirt',
        description: 'Exclusive MyGym branded workout t-shirt',
        type: RewardType.merchandise,
        pointsCost: 2000,
        isAvailable: true,
        stockCount: 25,
        requiredTier: MembershipTier.gold,
      ),
      RewardItem(
        id: 'reward_6',
        name: 'Water Bottle',
        description: 'Premium insulated water bottle',
        type: RewardType.merchandise,
        pointsCost: 800,
        isAvailable: true,
        stockCount: 50,
      ),
    ];

    return Right(items);
  }

  @override
  Future<Either<Failure, List<PointsTransaction>>> getPointsHistory({
    int? limit,
    int? offset,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final now = DateTime.now();
    
    final transactions = [
      PointsTransaction(
        id: 'txn_1',
        userId: _dummyUserId,
        type: PointsTransactionType.earned,
        points: 50,
        balanceAfter: 2450,
        description: 'Check-in at Downtown Fitness',
        createdAt: now.subtract(const Duration(hours: 2)),
        referenceId: 'visit_123',
        referenceType: 'visit',
      ),
      PointsTransaction(
        id: 'txn_2',
        userId: _dummyUserId,
        type: PointsTransactionType.bonus,
        points: 100,
        balanceAfter: 2400,
        description: 'Weekly workout streak bonus',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      PointsTransaction(
        id: 'txn_3',
        userId: _dummyUserId,
        type: PointsTransactionType.redeemed,
        points: -500,
        balanceAfter: 2300,
        description: 'Redeemed: Free Day Pass',
        createdAt: now.subtract(const Duration(days: 3)),
        referenceId: 'redemption_456',
        referenceType: 'redemption',
      ),
      PointsTransaction(
        id: 'txn_4',
        userId: _dummyUserId,
        type: PointsTransactionType.referral,
        points: 200,
        balanceAfter: 2800,
        description: 'Referral bonus: Mohamed joined',
        createdAt: now.subtract(const Duration(days: 5)),
        referenceId: 'referral_789',
        referenceType: 'referral',
      ),
      PointsTransaction(
        id: 'txn_5',
        userId: _dummyUserId,
        type: PointsTransactionType.earned,
        points: 75,
        balanceAfter: 2600,
        description: 'Attended HIIT Class',
        createdAt: now.subtract(const Duration(days: 7)),
        referenceId: 'class_booking_321',
        referenceType: 'class',
      ),
      PointsTransaction(
        id: 'txn_6',
        userId: _dummyUserId,
        type: PointsTransactionType.earned,
        points: 50,
        balanceAfter: 2525,
        description: 'Check-in at Power House Gym',
        createdAt: now.subtract(const Duration(days: 8)),
        referenceId: 'visit_124',
        referenceType: 'visit',
      ),
      PointsTransaction(
        id: 'txn_7',
        userId: _dummyUserId,
        type: PointsTransactionType.expired,
        points: -100,
        balanceAfter: 2475,
        description: 'Points expired',
        createdAt: now.subtract(const Duration(days: 10)),
      ),
    ];

    return Right(transactions);
  }

  @override
  Future<Either<Failure, Redemption>> redeemReward(String rewardId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Simulate finding the reward
    final rewardsResult = await getRewardItems();
    
    return rewardsResult.fold(
      (failure) => Left(failure),
      (rewards) {
        final reward = rewards.firstWhere(
          (r) => r.id == rewardId,
          orElse: () => throw Exception('Reward not found'),
        );

        final redemption = Redemption(
          id: 'redemption_${DateTime.now().millisecondsSinceEpoch}',
          userId: _dummyUserId,
          reward: reward,
          pointsSpent: reward.pointsCost,
          redeemedAt: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(days: 30)),
          code: 'REDEEM${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
          status: RedemptionStatus.active,
        );

        return Right(redemption);
      },
    );
  }

  @override
  Future<Either<Failure, List<Redemption>>> getRedemptions() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final redemptions = [
      Redemption(
        id: 'redemption_1',
        userId: _dummyUserId,
        reward: const RewardItem(
          id: 'reward_1',
          name: 'Free Day Pass',
          description: 'Get a free day pass to any gym',
          type: RewardType.freeVisit,
          pointsCost: 500,
        ),
        pointsSpent: 500,
        redeemedAt: DateTime.now().subtract(const Duration(days: 5)),
        expiresAt: DateTime.now().add(const Duration(days: 25)),
        code: 'FREEPASS123',
        status: RedemptionStatus.active,
      ),
      Redemption(
        id: 'redemption_2',
        userId: _dummyUserId,
        reward: const RewardItem(
          id: 'reward_2',
          name: '20% Discount',
          description: '20% off subscription',
          type: RewardType.discount,
          pointsCost: 1000,
        ),
        pointsSpent: 1000,
        redeemedAt: DateTime.now().subtract(const Duration(days: 20)),
        usedAt: DateTime.now().subtract(const Duration(days: 15)),
        expiresAt: DateTime.now().subtract(const Duration(days: 10)),
        code: 'DISC20ABC',
        status: RedemptionStatus.used,
      ),
    ];

    return Right(redemptions);
  }

  @override
  Future<Either<Failure, List<Referral>>> getReferrals() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final referrals = [
      Referral(
        id: 'ref_1',
        referrerId: _dummyUserId,
        referrerName: 'Ahmed',
        refereeId: 'user_2',
        refereeName: 'Mohamed Ali',
        referralCode: 'AHMED2024',
        status: ReferralStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        completedAt: DateTime.now().subtract(const Duration(days: 25)),
        pointsEarned: 200,
        bonusPointsEarned: 50,
      ),
      Referral(
        id: 'ref_2',
        referrerId: _dummyUserId,
        referrerName: 'Ahmed',
        refereeId: 'user_3',
        refereeName: 'Sara Hassan',
        referralCode: 'AHMED2024',
        status: ReferralStatus.subscribed,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        pointsEarned: 100,
        bonusPointsEarned: 0,
      ),
      Referral(
        id: 'ref_3',
        referrerId: _dummyUserId,
        referrerName: 'Ahmed',
        refereeId: 'user_4',
        refereeName: 'Omar Khaled',
        referralCode: 'AHMED2024',
        status: ReferralStatus.registered,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        pointsEarned: 0,
        bonusPointsEarned: 0,
      ),
      Referral(
        id: 'ref_4',
        referrerId: _dummyUserId,
        referrerName: 'Ahmed',
        refereeId: null,
        refereeName: null,
        referralCode: 'AHMED2024',
        status: ReferralStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        pointsEarned: 0,
        bonusPointsEarned: 0,
      ),
    ];

    return Right(referrals);
  }

  @override
  Future<Either<Failure, String>> getReferralCode() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return const Right('AHMED2024');
  }

  @override
  Future<Either<Failure, List<PointsEarningRule>>> getEarningRules() async {
    await Future.delayed(const Duration(milliseconds: 200));

    final rules = [
      const PointsEarningRule(
        id: 'rule_1',
        name: 'Gym Check-in',
        description: 'Earn points for every gym visit',
        pointsAmount: 50,
        triggerType: 'visit',
      ),
      const PointsEarningRule(
        id: 'rule_2',
        name: 'Class Attendance',
        description: 'Earn extra points for attending fitness classes',
        pointsAmount: 75,
        triggerType: 'class',
      ),
      const PointsEarningRule(
        id: 'rule_3',
        name: 'Friend Referral',
        description: 'Earn points when your friend subscribes',
        pointsAmount: 200,
        triggerType: 'referral',
      ),
      const PointsEarningRule(
        id: 'rule_4',
        name: 'Weekly Streak',
        description: 'Bonus for visiting 5 days in a week',
        pointsAmount: 100,
        triggerType: 'streak',
      ),
    ];

    return Right(rules);
  }
}