// lib/src/features/rewards/presentation/views/referrals_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/luxury_theme_extension.dart';
import '../../domain/entities/reward.dart';
import '../cubit/rewards_cubit.dart';
import '../cubit/rewards_state.dart';

class ReferralsView extends StatefulWidget {
  const ReferralsView({super.key});

  @override
  State<ReferralsView> createState() => _ReferralsViewState();
}

class _ReferralsViewState extends State<ReferralsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RewardsCubit>().loadReferrals();
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
                  
                  if (state.referralsStatus == RewardsStatus.loading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else ...[
                    // Referral Code Card
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: _ReferralCodeCard(
                          referralCode: state.referralCode ?? 'LOADING...',
                        ),
                      ),
                    ),
                    
                    SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                    
                    // Stats
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: _ReferralStats(
                          totalReferrals: state.referrals.length,
                          completedReferrals: state.completedReferralsCount,
                          totalPoints: state.totalReferralPoints,
                        ),
                      ),
                    ),
                    
                    SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                    
                    // How it works
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: _HowItWorks(),
                      ),
                    ),
                    
                    SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                    
                    // Referrals List
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: _SectionHeader(
                          title: 'Your Referrals',
                          count: state.referrals.length,
                        ),
                      ),
                    ),
                    
                    SliverToBoxAdapter(child: SizedBox(height: 12.h)),
                    
                    if (state.referrals.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: _EmptyReferrals(),
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final referral = state.referrals[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 6.h,
                              ),
                              child: _ReferralCard(referral: referral),
                            );
                          },
                          childCount: state.referrals.length,
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
                  'INVITE FRIENDS',
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'Referrals',
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
// REFERRAL CODE CARD
// ═══════════════════════════════════════════════════════════════════════════════

class _ReferralCodeCard extends StatelessWidget {
  final String referralCode;

  const _ReferralCodeCard({required this.referralCode});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withValues(alpha: 0.15),
            Colors.blue.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            'YOUR REFERRAL CODE',
            style: GoogleFonts.montserrat(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: Colors.purple,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      referralCode,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 4,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: referralCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Code copied!')),
                    );
                  },
                  icon: Icon(
                    Icons.copy,
                    color: Colors.purple,
                    size: 22.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: referralCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Code copied!')),
                    );
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.purple,
                    side: const BorderSide(color: Colors.purple),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () async {
                    await SharePlus.instance.share(
                      ShareParams(
                        text: 'Join MyGym with my referral code: $referralCode and get exclusive rewards! 🏋️‍♂️',
                        subject: 'Join MyGym',
                      ),
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// REFERRAL STATS
// ═══════════════════════════════════════════════════════════════════════════════

class _ReferralStats extends StatelessWidget {
  final int totalReferrals;
  final int completedReferrals;
  final int totalPoints;

  const _ReferralStats({
    required this.totalReferrals,
    required this.completedReferrals,
    required this.totalPoints,
  });

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.people,
            value: totalReferrals.toString(),
            label: 'Total',
            color: Colors.blue,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle,
            value: completedReferrals.toString(),
            label: 'Completed',
            color: Colors.green,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _StatCard(
            icon: Icons.stars,
            value: totalPoints.toString(),
            label: 'Points',
            color: luxury.gold,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// HOW IT WORKS
// ═══════════════════════════════════════════════════════════════════════════════

class _HowItWorks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    final steps = [
      ('Share your code', Icons.share, 'Send your unique code to friends'),
      ('Friend signs up', Icons.person_add, 'They register using your code'),
      ('Friend subscribes', Icons.card_membership, 'They get a subscription'),
      ('Both earn points', Icons.stars, 'You both get reward points!'),
    ];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: luxury.gold.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How It Works',
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 16.h),
          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == steps.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          step.$2,
                          size: 18.sp,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 24.h,
                        color: colorScheme.outline.withValues(alpha: 0.3),
                      ),
                  ],
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.$1,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          step.$3,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
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
          child: Icon(Icons.people, size: 18.sp, color: Colors.white),
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// REFERRAL CARD
// ═══════════════════════════════════════════════════════════════════════════════

class _ReferralCard extends StatelessWidget {
  final Referral referral;

  const _ReferralCard({required this.referral});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: _getStatusColor(referral.status).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: colorScheme.primaryContainer,
            child: Text(
              (referral.refereeName ?? '?')[0].toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  referral.refereeName ?? 'Pending...',
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    _StatusBadge(status: referral.status),
                    if (referral.pointsEarned > 0) ...[
                      SizedBox(width: 8.w),
                      Text(
                        '+${referral.pointsEarned} pts',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Icon(
            _getStatusIcon(referral.status),
            color: _getStatusColor(referral.status),
            size: 24.sp,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ReferralStatus status) {
    switch (status) {
      case ReferralStatus.pending:
        return Colors.grey;
      case ReferralStatus.registered:
        return Colors.blue;
      case ReferralStatus.subscribed:
        return Colors.orange;
      case ReferralStatus.completed:
        return Colors.green;
      case ReferralStatus.expired:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(ReferralStatus status) {
    switch (status) {
      case ReferralStatus.pending:
        return Icons.hourglass_empty;
      case ReferralStatus.registered:
        return Icons.person_add;
      case ReferralStatus.subscribed:
        return Icons.card_membership;
      case ReferralStatus.completed:
        return Icons.check_circle;
      case ReferralStatus.expired:
        return Icons.cancel;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final ReferralStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _getStatusColor(ReferralStatus status) {
    switch (status) {
      case ReferralStatus.pending:
        return Colors.grey;
      case ReferralStatus.registered:
        return Colors.blue;
      case ReferralStatus.subscribed:
        return Colors.orange;
      case ReferralStatus.completed:
        return Colors.green;
      case ReferralStatus.expired:
        return Colors.red;
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// EMPTY REFERRALS
// ═══════════════════════════════════════════════════════════════════════════════

class _EmptyReferrals extends StatelessWidget {
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
            Icons.people_outline,
            size: 48.sp,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          SizedBox(height: 12.h),
          Text(
            'No referrals yet',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Share your code and start earning!',
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