// lib/src/features/rewards/presentation/cubit/rewards_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/reward.dart';
import '../../domain/repositories/rewards_repository.dart';
import 'rewards_state.dart';

@injectable
class RewardsCubit extends Cubit<RewardsState> {
  final RewardsRepository _repository;

  RewardsCubit(this._repository) : super(const RewardsState());

  // ═══════════════════════════════════════════════════════════════════════════
  // LOAD OVERVIEW
  // ═══════════════════════════════════════════════════════════════════════════

  /// Load all rewards overview data
  Future<void> loadOverview() async {
    emit(state.copyWith(overviewStatus: RewardsStatus.loading));

    try {
      // Load user rewards
      final userRewardsResult = await _repository.getUserRewards();
      
      await userRewardsResult.fold(
        (failure) {
          emit(state.copyWith(
            overviewStatus: RewardsStatus.failure,
            errorMessage: failure.message,
          ));
        },
        (userRewards) async {
          // Load reward items
          final rewardsResult = await _repository.getRewardItems();
          
          rewardsResult.fold(
            (failure) {
              emit(state.copyWith(
                overviewStatus: RewardsStatus.failure,
                errorMessage: failure.message,
              ));
            },
            (rewards) {
              // Filter affordable rewards
              final affordable = rewards
                  .where((r) => r.pointsCost <= userRewards.currentPoints)
                  .toList();

              emit(state.copyWith(
                overviewStatus: RewardsStatus.success,
                userRewards: userRewards,
                rewardItems: rewards,
                affordableRewards: affordable,
                referralCode: userRewards.referralCode,
              ));
            },
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(
        overviewStatus: RewardsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOAD REWARDS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Load available reward items
  Future<void> loadRewardItems() async {
    emit(state.copyWith(rewardsStatus: RewardsStatus.loading));

    final result = await _repository.getRewardItems();

    result.fold(
      (failure) => emit(state.copyWith(
        rewardsStatus: RewardsStatus.failure,
        errorMessage: failure.message,
      )),
      (rewards) {
        final affordable = state.userRewards != null
            ? rewards
                .where((r) => r.pointsCost <= state.userRewards!.currentPoints)
                .toList()
            : <RewardItem>[];

        emit(state.copyWith(
          rewardsStatus: RewardsStatus.success,
          rewardItems: rewards,
          affordableRewards: affordable,
        ));
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOAD POINTS HISTORY
  // ═══════════════════════════════════════════════════════════════════════════

  /// Load points transaction history
  Future<void> loadPointsHistory() async {
    emit(state.copyWith(historyStatus: RewardsStatus.loading));

    final result = await _repository.getPointsHistory();

    result.fold(
      (failure) => emit(state.copyWith(
        historyStatus: RewardsStatus.failure,
        errorMessage: failure.message,
      )),
      (transactions) {
        // Get recent (last 5)
        final recent = transactions.take(5).toList();

        emit(state.copyWith(
          historyStatus: RewardsStatus.success,
          pointsHistory: transactions,
          recentTransactions: recent,
        ));
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOAD REFERRALS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Load referrals
  Future<void> loadReferrals() async {
    emit(state.copyWith(referralsStatus: RewardsStatus.loading));

    try {
      final referralsResult = await _repository.getReferrals();
      final codeResult = await _repository.getReferralCode();

      referralsResult.fold(
        (failure) => emit(state.copyWith(
          referralsStatus: RewardsStatus.failure,
          errorMessage: failure.message,
        )),
        (referrals) {
          codeResult.fold(
            (failure) => emit(state.copyWith(
              referralsStatus: RewardsStatus.success,
              referrals: referrals,
            )),
            (code) => emit(state.copyWith(
              referralsStatus: RewardsStatus.success,
              referrals: referrals,
              referralCode: code,
            )),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(
        referralsStatus: RewardsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REDEEM REWARD
  // ═══════════════════════════════════════════════════════════════════════════

  /// Redeem a reward
  Future<bool> redeemReward(String rewardId) async {
    emit(state.copyWith(
      redeemStatus: RewardsStatus.loading,
      successMessage: null,
      lastRedemption: null,
    ));

    final result = await _repository.redeemReward(rewardId);

    return result.fold(
      (failure) {
        emit(state.copyWith(
          redeemStatus: RewardsStatus.failure,
          errorMessage: failure.message,
        ));
        return false;
      },
      (redemption) {
        // Update user points
        final updatedUserRewards = state.userRewards != null
            ? UserRewards(
                userId: state.userRewards!.userId,
                currentPoints: state.userRewards!.currentPoints - redemption.pointsSpent,
                lifetimePoints: state.userRewards!.lifetimePoints,
                pendingPoints: state.userRewards!.pendingPoints,
                expiringPoints: state.userRewards!.expiringPoints,
                expiringDate: state.userRewards!.expiringDate,
                totalRedemptions: state.userRewards!.totalRedemptions + 1,
                referralCount: state.userRewards!.referralCount,
                referralCode: state.userRewards!.referralCode,
                tier: state.userRewards!.tier,
                pointsToNextTier: state.userRewards!.pointsToNextTier,
              )
            : null;

        // Update affordable rewards
        final affordable = updatedUserRewards != null
            ? state.rewardItems
                .where((r) => r.pointsCost <= updatedUserRewards.currentPoints)
                .toList()
            : state.affordableRewards;

        emit(state.copyWith(
          redeemStatus: RewardsStatus.success,
          userRewards: updatedUserRewards,
          affordableRewards: affordable,
          lastRedemption: redemption,
          successMessage: 'Reward redeemed successfully!',
        ));
        return true;
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOAD REDEMPTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Load user's redemptions
  Future<void> loadRedemptions() async {
    final result = await _repository.getRedemptions();

    result.fold(
      (failure) {},
      (redemptions) {
        final active = redemptions
            .where((r) => r.status == RedemptionStatus.active)
            .toList();

        emit(state.copyWith(
          redemptions: redemptions,
          activeRedemptions: active,
        ));
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOAD EARNING RULES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Load points earning rules
  Future<void> loadEarningRules() async {
    final result = await _repository.getEarningRules();

    result.fold(
      (failure) {},
      (rules) => emit(state.copyWith(earningRules: rules)),
    );
  }

  /// Clear messages
  void clearMessages() {
    emit(state.copyWith(
      successMessage: null,
      errorMessage: null,
    ));
  }
}