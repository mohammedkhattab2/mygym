// lib/src/features/rewards/presentation/views/points_history_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/luxury_theme_extension.dart';
import '../../domain/entities/reward.dart';
import '../cubit/rewards_cubit.dart';
import '../cubit/rewards_state.dart';

class PointsHistoryView extends StatefulWidget {
  const PointsHistoryView({super.key});

  @override
  State<PointsHistoryView> createState() => _PointsHistoryViewState();
}

class _PointsHistoryViewState extends State<PointsHistoryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<RewardsCubit>();
      cubit.loadPointsHistory();
      cubit.loadEarningRules();
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
          child: BlocBuilder<RewardsCubit, RewardsState>(
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildAppBar(context)),
                  
                  if (state.historyStatus == RewardsStatus.loading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else ...[
                    // Points Summary
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: _PointsSummary(userRewards: state.userRewards),
                      ),
                    ),
                    
                    SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                    
                    // Earning Rules
                    if (state.earningRules.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: _EarningRulesSection(rules: state.earningRules),
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                    ],
                    
                    // Transaction History
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: _SectionHeader(
                          title: 'Transaction History',
                          count: state.pointsHistory.length,
                        ),
                      ),
                    ),
                    
                    SliverToBoxAdapter(child: SizedBox(height: 12.h)),
                    
                    if (state.pointsHistory.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: _EmptyHistory(),
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final transaction = state.pointsHistory[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 6.h,
                              ),
                              child: _TransactionCard(transaction: transaction),
                            );
                          },
                          childCount: state.pointsHistory.length,
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
                  'POINTS',
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'History',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// POINTS SUMMARY
// ═══════════════════════════════════════════════════════════════════════════════

class _PointsSummary extends StatelessWidget {
  final UserRewards? userRewards;

  const _PointsSummary({this.userRewards});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: luxury.gold.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              label: 'Current',
              value: '${userRewards?.currentPoints ?? 0}',
              color: colorScheme.primary,
            ),
          ),
          Container(
            width: 1,
            height: 40.h,
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
          Expanded(
            child: _SummaryItem(
              label: 'Lifetime',
              value: '${userRewards?.lifetimePoints ?? 0}',
              color: luxury.gold,
            ),
          ),
          Container(
            width: 1,
            height: 40.h,
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
          Expanded(
            child: _SummaryItem(
              label: 'Pending',
              value: '${userRewards?.pendingPoints ?? 0}',
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// EARNING RULES
// ═══════════════════════════════════════════════════════════════════════════════

class _EarningRulesSection extends StatelessWidget {
  final List<PointsEarningRule> rules;

  const _EarningRulesSection({required this.rules});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            luxury.gold.withValues(alpha: 0.1),
            luxury.gold.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: luxury.gold.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: luxury.gold, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                'How to Earn Points',
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...rules.map((rule) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Text(
                      '+${rule.pointsAmount}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rule.name,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        rule.description,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION HEADER
// ═══════════════════════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const _SectionHeader({required this.title, required this.count});

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
          child: Icon(Icons.history, size: 18.sp, color: Colors.white),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const Spacer(),
        Text(
          '$count transactions',
          style: TextStyle(
            fontSize: 12.sp,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TRANSACTION CARD
// ═══════════════════════════════════════════════════════════════════════════════

class _TransactionCard extends StatelessWidget {
  final PointsTransaction transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');
    final isCredit = transaction.isCredit;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isCredit
              ? Colors.green.withValues(alpha: 0.2)
              : Colors.red.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: isCredit
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              _getTransactionIcon(transaction.type),
              color: isCredit ? Colors.green : Colors.red,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    _TransactionTypeBadge(type: transaction.type),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        dateFormat.format(transaction.createdAt),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isCredit ? '+' : ''}${transaction.points}',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: isCredit ? Colors.green : Colors.red,
                ),
              ),
              Text(
                'Balance: ${transaction.balanceAfter}',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getTransactionIcon(PointsTransactionType type) {
    switch (type) {
      case PointsTransactionType.earned:
        return Icons.add_circle;
      case PointsTransactionType.redeemed:
        return Icons.redeem;
      case PointsTransactionType.expired:
        return Icons.timer_off;
      case PointsTransactionType.bonus:
        return Icons.celebration;
      case PointsTransactionType.referral:
        return Icons.people;
      case PointsTransactionType.adjustment:
        return Icons.tune;
    }
  }
}

class _TransactionTypeBadge extends StatelessWidget {
  final PointsTransactionType type;

  const _TransactionTypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final color = _getTypeColor(type);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _getTypeLabel(type),
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _getTypeColor(PointsTransactionType type) {
    switch (type) {
      case PointsTransactionType.earned:
        return Colors.green;
      case PointsTransactionType.redeemed:
        return Colors.purple;
      case PointsTransactionType.expired:
        return Colors.grey;
      case PointsTransactionType.bonus:
        return Colors.orange;
      case PointsTransactionType.referral:
        return Colors.blue;
      case PointsTransactionType.adjustment:
        return Colors.teal;
    }
  }

  String _getTypeLabel(PointsTransactionType type) {
    switch (type) {
      case PointsTransactionType.earned:
        return 'EARNED';
      case PointsTransactionType.redeemed:
        return 'REDEEMED';
      case PointsTransactionType.expired:
        return 'EXPIRED';
      case PointsTransactionType.bonus:
        return 'BONUS';
      case PointsTransactionType.referral:
        return 'REFERRAL';
      case PointsTransactionType.adjustment:
        return 'ADJUSTMENT';
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// EMPTY HISTORY
// ═══════════════════════════════════════════════════════════════════════════════

class _EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.history,
            size: 48.sp,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          SizedBox(height: 12.h),
          Text(
            'No transactions yet',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Start earning points by checking in!',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}