// lib/src/features/rewards/presentation/cubit/rewards_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/reward.dart';

part 'rewards_state.freezed.dart';

@freezed
class RewardsState with _$RewardsState {
  const factory RewardsState({
    // User rewards summary
    UserRewards? userRewards,
    
    // Available rewards
    @Default([]) List<RewardItem> rewardItems,
    @Default([]) List<RewardItem> affordableRewards,
    
    // Points history
    @Default([]) List<PointsTransaction> pointsHistory,
    @Default([]) List<PointsTransaction> recentTransactions,
    
    // Redemptions
    @Default([]) List<Redemption> redemptions,
    @Default([]) List<Redemption> activeRedemptions,
    
    // Referrals
    @Default([]) List<Referral> referrals,
    String? referralCode,
    
    // Earning rules
    @Default([]) List<PointsEarningRule> earningRules,
    
    // Status
    @Default(RewardsStatus.initial) RewardsStatus overviewStatus,
    @Default(RewardsStatus.initial) RewardsStatus rewardsStatus,
    @Default(RewardsStatus.initial) RewardsStatus historyStatus,
    @Default(RewardsStatus.initial) RewardsStatus referralsStatus,
    @Default(RewardsStatus.initial) RewardsStatus redeemStatus,
    
    // Error
    String? errorMessage,
    
    // Success message for redemption
    String? successMessage,
    Redemption? lastRedemption,
  }) = _RewardsState;

  const RewardsState._();

  /// Check if user can afford a reward
  bool canAfford(RewardItem reward) {
    return (userRewards?.currentPoints ?? 0) >= reward.pointsCost;
  }

  /// Get completed referrals count
  int get completedReferralsCount => referrals
      .where((r) => r.status == ReferralStatus.completed)
      .length;

  /// Get total points earned from referrals
  int get totalReferralPoints => referrals
      .fold(0, (sum, r) => sum + r.pointsEarned + r.bonusPointsEarned);

  /// Get tier progress percentage (0.0 - 1.0)
  double get tierProgress {
    if (userRewards == null) return 0.0;
    final current = userRewards!.currentPoints;
    final nextTierMin = userRewards!.tier.nextTier?.minPoints ?? current;
    final currentTierMin = userRewards!.tier.minPoints;
    if (nextTierMin == currentTierMin) return 1.0;
    return ((current - currentTierMin) / (nextTierMin - currentTierMin))
        .clamp(0.0, 1.0);
  }
}

enum RewardsStatus {
  initial,
  loading,
  success,
  failure,
}

/// Extension to get next tier
extension MembershipTierExtension on MembershipTier {
  MembershipTier? get nextTier {
    switch (this) {
      case MembershipTier.bronze:
        return MembershipTier.silver;
      case MembershipTier.silver:
        return MembershipTier.gold;
      case MembershipTier.gold:
        return MembershipTier.platinum;
      case MembershipTier.platinum:
        return null;
    }
  }
}