// lib/src/features/rewards/presentation/views/rewards_list_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/luxury_theme_extension.dart';
import '../../domain/entities/reward.dart';
import '../cubit/rewards_cubit.dart';
import '../cubit/rewards_state.dart';

class RewardsListView extends StatefulWidget {
  const RewardsListView({super.key});

  @override
  State<RewardsListView> createState() => _RewardsListViewState();
}

class _RewardsListViewState extends State<RewardsListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RewardsCubit>().loadOverview();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(gradient: luxury.backgroundGradient),
        child: SafeArea(
          child: BlocConsumer<RewardsCubit, RewardsState>(
            listener: (context, state) {
              if (state.successMessage != null) {
                _showRedemptionSuccess(context, state);
              }
              if (state.redeemStatus == RewardsStatus.failure &&
                  state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: colorScheme.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildAppBar(context)),
                  
                  if (state.overviewStatus == RewardsStatus.loading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.overviewStatus == RewardsStatus.failure)
                    SliverFillRemaining(
                      child: _buildErrorState(context, state.errorMessage),
                    )
                  else ...[
                    // Points Summary Card
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: _PointsSummaryCard(userRewards: state.userRewards),
                      ),
                    ),
                    
                    SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                    
                    // Quick Actions
                    SliverToBoxAdapter(
                      child: _QuickActions(referralCode: state.referralCode),
                    ),
                    
                    SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                    
                    // Available Rewards
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: _SectionHeader(
                          title: 'Available Rewards',
                          subtitle: '${state.rewardItems.length} rewards',
                        ),
                      ),
                    ),
                    
                    SliverToBoxAdapter(child: SizedBox(height: 12.h)),
                    
                    // Rewards Grid
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12.h,
                          crossAxisSpacing: 12.w,
                          childAspectRatio: 0.85,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final reward = state.rewardItems[index];
                            return _RewardCard(
                              reward: reward,
                              canAfford: state.canAfford(reward),
                              onRedeem: () => _confirmRedeem(context, reward),
                            );
                          },
                          childCount: state.rewardItems.length,
                        ),
                      ),
                    ),
                    
                    SliverToBoxAdapter(child: SizedBox(height: 40.h)),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: luxury.surfaceElevated,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: luxury.gold.withValues(alpha: 0.15)),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 18.sp,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MY',
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'Rewards',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/member/rewards/history'),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.history,
                size: 20.sp,
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
          SizedBox(height: 16.h),
          Text(message ?? 'Failed to load rewards'),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => context.read<RewardsCubit>().loadOverview(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _confirmRedeem(BuildContext context, RewardItem reward) {
    final colorScheme = Theme.of(context).colorScheme;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Redeem Reward?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are about to redeem:'),
            SizedBox(height: 8.h),
            Text(
              reward.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              'Cost: ${reward.pointsCost} points',
              style: TextStyle(color: colorScheme.primary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<RewardsCubit>().redeemReward(reward.id);
            },
            child: const Text('Redeem'),
          ),
        ],
      ),
    );
  }

  void _showRedemptionSuccess(BuildContext context, RewardsState state) {
    final redemption = state.lastRedemption;
    if (redemption == null) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 64),
        title: const Text('Reward Redeemed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(redemption.reward.name),
            if (redemption.code != null) ...[
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          redemption.code!,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: redemption.code!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Code copied!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<RewardsCubit>().clearMessages();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// POINTS SUMMARY CARD
// ═══════════════════════════════════════════════════════════════════════════════

class _PointsSummaryCard extends StatelessWidget {
  final UserRewards? userRewards;

  const _PointsSummaryCard({this.userRewards});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final rewards = userRewards;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.15),
            luxury.gold.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: luxury.gold.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CURRENT BALANCE',
                      style: GoogleFonts.montserrat(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: luxury.gold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${rewards?.currentPoints ?? 0}',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 6.h, left: 4.w),
                          child: Text(
                            'points',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Tier badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: _getTierColor(rewards?.tier).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: _getTierColor(rewards?.tier).withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.star,
                      color: _getTierColor(rewards?.tier),
                      size: 24.sp,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      rewards?.tier.displayName ?? 'Bronze',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: _getTierColor(rewards?.tier),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (rewards?.expiringPoints != null && rewards!.expiringPoints > 0) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.schedule, size: 16.sp, color: Colors.orange),
                  SizedBox(width: 8.w),
                  Text(
                    '${rewards.expiringPoints} points expiring soon',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getTierColor(MembershipTier? tier) {
    switch (tier) {
      case MembershipTier.bronze:
        return const Color(0xFFCD7F32);
      case MembershipTier.silver:
        return const Color(0xFFC0C0C0);
      case MembershipTier.gold:
        return const Color(0xFFFFD700);
      case MembershipTier.platinum:
        return const Color(0xFFE5E4E2);
      default:
        return const Color(0xFFCD7F32);
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// QUICK ACTIONS
// ═══════════════════════════════════════════════════════════════════════════════

class _QuickActions extends StatelessWidget {
  final String? referralCode;

  const _QuickActions({this.referralCode});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        children: [
          _QuickActionCard(
            icon: Icons.people,
            label: 'Referrals',
            color: Colors.purple,
            onTap: () => context.push('/member/rewards/referrals'),
          ),
          SizedBox(width: 12.w),
          _QuickActionCard(
            icon: Icons.history,
            label: 'History',
            color: Colors.blue,
            onTap: () => context.push('/member/rewards/history'),
          ),
          SizedBox(width: 12.w),
          _QuickActionCard(
            icon: Icons.card_giftcard,
            label: 'My Vouchers',
            color: Colors.green,
            onTap: () => context.push('/member/rewards/vouchers'),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: luxury.surfaceElevated,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22.sp),
            SizedBox(height: 6.h),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION HEADER
// ═══════════════════════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionHeader({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Row(
      children: [
        ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [luxury.gold, luxury.goldLight],
            ).createShader(bounds);
          },
          child: Icon(Icons.card_giftcard, size: 18.sp, color: Colors.white),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            letterSpacing: 0.5,
          ),
        ),
        if (subtitle != null) ...[
          const Spacer(),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 12.sp,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// REWARD CARD
// ═══════════════════════════════════════════════════════════════════════════════

class _RewardCard extends StatelessWidget {
  final RewardItem reward;
  final bool canAfford;
  final VoidCallback onRedeem;

  const _RewardCard({
    required this.reward,
    required this.canAfford,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: canAfford
              ? luxury.gold.withValues(alpha: 0.3)
              : colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                reward.type.icon,
                style: TextStyle(fontSize: 24.sp),
              ),
              const Spacer(),
              if (reward.hasLimitedStock)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${reward.stockCount} left',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            reward.name,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            '${reward.pointsCost} pts',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: canAfford ? luxury.gold : colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: canAfford && reward.isAvailable ? onRedeem : null,
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                backgroundColor: canAfford ? luxury.gold : null,
                foregroundColor: canAfford ? Colors.black : null,
              ),
              child: Text(
                canAfford ? 'Redeem' : 'Need more pts',
                style: TextStyle(fontSize: 12.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}