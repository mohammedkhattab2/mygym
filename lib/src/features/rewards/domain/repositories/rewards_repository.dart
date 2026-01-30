// lib/src/features/rewards/domain/repositories/rewards_repository.dart

import 'package:dartz/dartz.dart';
import 'package:mygym/src/core/error/failures.dart';
import '../entities/reward.dart';

abstract class RewardsRepository {
  /// Get user rewards summary
  Future<Either<Failure, UserRewards>> getUserRewards();

  /// Get available reward items
  Future<Either<Failure, List<RewardItem>>> getRewardItems();

  /// Get points transaction history
  Future<Either<Failure, List<PointsTransaction>>> getPointsHistory({
    int? limit,
    int? offset,
  });

  /// Redeem a reward
  Future<Either<Failure, Redemption>> redeemReward(String rewardId);

  /// Get user's redemptions
  Future<Either<Failure, List<Redemption>>> getRedemptions();

  /// Get referrals
  Future<Either<Failure, List<Referral>>> getReferrals();

  /// Generate or get referral code
  Future<Either<Failure, String>> getReferralCode();

  /// Get points earning rules
  Future<Either<Failure, List<PointsEarningRule>>> getEarningRules();
}