// lib/src/features/rewards/presentation/views/my_vouchers_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/luxury_theme_extension.dart';
import '../../domain/entities/reward.dart';
import '../cubit/rewards_cubit.dart';
import '../cubit/rewards_state.dart';

class MyVouchersView extends StatefulWidget {
  const MyVouchersView({super.key});

  @override
  State<MyVouchersView> createState() => _MyVouchersViewState();
}

class _MyVouchersViewState extends State<MyVouchersView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RewardsCubit>().loadRedemptions();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          child: Column(
            children: [
              _buildAppBar(context),
              SizedBox(height: 16.h),
              _buildTabBar(context),
              SizedBox(height: 16.h),
              Expanded(
                child: BlocBuilder<RewardsCubit, RewardsState>(
                  builder: (context, state) {
                    // Loading state
                    if (state.overviewStatus == RewardsStatus.loading &&
                        state.redemptions.isEmpty) {
                      return _buildLoadingState(luxury);
                    }

                    // Split vouchers by status
                    final activeVouchers = state.redemptions
                        .where((r) => r.status == RedemptionStatus.active)
                        .toList();
                    
                    final usedVouchers = state.redemptions
                        .where((r) => 
                            r.status == RedemptionStatus.used ||
                            r.status == RedemptionStatus.expired ||
                            r.status == RedemptionStatus.cancelled)
                        .toList();

                    // Sort by date
                    activeVouchers.sort((a, b) => a.expiresAt.compareTo(b.expiresAt));
                    usedVouchers.sort((a, b) => (b.usedAt ?? b.expiresAt)
                        .compareTo(a.usedAt ?? a.expiresAt));

                    return TabBarView(
                      controller: _tabController,
                      children: [
                        _VouchersList(
                          vouchers: activeVouchers,
                          isActive: true,
                          emptyMessage: 'No active vouchers',
                          emptySubtitle: 'Redeem rewards to get vouchers!',
                        ),
                        _VouchersList(
                          vouchers: usedVouchers,
                          isActive: false,
                          emptyMessage: 'No used vouchers',
                          emptySubtitle: 'Your used vouchers will appear here',
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
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
                  'Vouchers',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          // Info button
          GestureDetector(
            onTap: () => _showHowToUseDialog(context),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: luxury.surfaceElevated,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: luxury.gold.withValues(alpha: 0.15)),
              ),
              child: Icon(
                Icons.info_outline,
                size: 20.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return BlocBuilder<RewardsCubit, RewardsState>(
      builder: (context, state) {
        final activeCount = state.redemptions
            .where((r) => r.status == RedemptionStatus.active)
            .length;
        final usedCount = state.redemptions
            .where((r) => 
                r.status == RedemptionStatus.used ||
                r.status == RedemptionStatus.expired ||
                r.status == RedemptionStatus.cancelled)
            .length;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: luxury.surfaceElevated,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: luxury.gold.withValues(alpha: 0.1)),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.secondary],
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: colorScheme.onPrimary,
            unselectedLabelColor: colorScheme.onSurfaceVariant,
            labelStyle: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            padding: EdgeInsets.all(4.w),
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Active'),
                    if (activeCount > 0) ...[
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          activeCount.toString(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('History'),
                    if (usedCount > 0) ...[
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: colorScheme.outline.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          usedCount.toString(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingState(LuxuryThemeExtension luxury) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: luxury.gold),
          SizedBox(height: 16.h),
          Text(
            'Loading vouchers...',
            style: TextStyle(color: luxury.textTertiary),
          ),
        ],
      ),
    );
  }

  void _showHowToUseDialog(BuildContext context) {
    final luxury = context.luxury;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Icon(Icons.help_outline, color: luxury.gold),
            SizedBox(width: 12.w),
            const Text('How to Use Vouchers'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HowToStep(
              number: '1',
              title: 'Copy the code',
              description: 'Tap on the voucher code to copy it',
              icon: Icons.copy,
            ),
            SizedBox(height: 12.h),
            _HowToStep(
              number: '2',
              title: 'Use at checkout',
              description: 'Enter the code when making a payment',
              icon: Icons.shopping_cart,
            ),
            SizedBox(height: 12.h),
            _HowToStep(
              number: '3',
              title: 'Show at gym',
              description: 'Or show the voucher at the gym reception',
              icon: Icons.qr_code,
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.orange, size: 18.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Vouchers expire after 30 days',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// HOW TO STEP
// ═══════════════════════════════════════════════════════════════════════════════

class _HowToStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final IconData icon;

  const _HowToStep({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
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
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// VOUCHERS LIST
// ═══════════════════════════════════════════════════════════════════════════════

class _VouchersList extends StatelessWidget {
  final List<Redemption> vouchers;
  final bool isActive;
  final String emptyMessage;
  final String emptySubtitle;

  const _VouchersList({
    required this.vouchers,
    required this.isActive,
    required this.emptyMessage,
    required this.emptySubtitle,
  });

  @override
  Widget build(BuildContext context) {
    if (vouchers.isEmpty) {
      return _EmptyState(
        message: emptyMessage,
        subtitle: emptySubtitle,
        icon: isActive ? Icons.card_giftcard : Icons.history,
        showButton: isActive,
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<RewardsCubit>().loadRedemptions(),
      color: context.luxury.gold,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: vouchers.length + 1, // +1 for summary card
        itemBuilder: (context, index) {
          if (index == 0) {
            return _SummaryCard(
              count: vouchers.length,
              isActive: isActive,
            );
          }
          return _VoucherCard(
            voucher: vouchers[index - 1],
            isActive: isActive,
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SUMMARY CARD
// ═══════════════════════════════════════════════════════════════════════════════

class _SummaryCard extends StatelessWidget {
  final int count;
  final bool isActive;

  const _SummaryCard({
    required this.count,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [Colors.green.withValues(alpha: 0.1), Colors.green.withValues(alpha: 0.05)]
              : [
                  colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isActive
              ? Colors.green.withValues(alpha: 0.2)
              : colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.green.withValues(alpha: 0.15)
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              isActive ? Icons.card_giftcard : Icons.history,
              color: isActive ? Colors.green : colorScheme.onSurfaceVariant,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isActive ? 'Active Vouchers' : 'Voucher History',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  isActive
                      ? 'You have $count voucher${count == 1 ? '' : 's'} to use'
                      : '$count voucher${count == 1 ? '' : 's'} in history',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            count.toString(),
            style: GoogleFonts.playfairDisplay(
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: isActive ? Colors.green : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// VOUCHER CARD
// ═══════════════════════════════════════════════════════════════════════════════

class _VoucherCard extends StatelessWidget {
  final Redemption voucher;
  final bool isActive;

  const _VoucherCard({
    required this.voucher,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final dateFormat = DateFormat('MMM d, yyyy');
    final reward = voucher.reward;

    // Check if expiring soon (within 7 days)
    final isExpiringSoon = isActive &&
        voucher.expiresAt.difference(DateTime.now()).inDays <= 7;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isActive
              ? isExpiringSoon
                  ? Colors.orange.withValues(alpha: 0.4)
                  : Colors.green.withValues(alpha: 0.3)
              : colorScheme.outline.withValues(alpha: 0.15),
          width: isExpiringSoon ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ═══════════════════════════════════════════════════════════════════
          // HEADER
          // ═══════════════════════════════════════════════════════════════════
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isActive
                    ? [
                        Colors.green.withValues(alpha: 0.08),
                        Colors.green.withValues(alpha: 0.03),
                      ]
                    : [
                        colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
                      ],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? LinearGradient(
                            colors: [
                              _getTypeColor(reward.type).withValues(alpha: 0.2),
                              _getTypeColor(reward.type).withValues(alpha: 0.1),
                            ],
                          )
                        : null,
                    color: isActive ? null : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Center(
                    child: Text(
                      reward.type.icon,
                      style: TextStyle(fontSize: 28.sp),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                
                // Title & Type
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reward.name,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: isActive ? null : colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: _getTypeColor(reward.type).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              reward.type.displayName,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: _getTypeColor(reward.type),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '${voucher.pointsSpent} pts',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: luxury.gold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Status Badge
                _StatusBadge(status: voucher.status),
              ],
            ),
          ),

          // ═══════════════════════════════════════════════════════════════════
          // CODE SECTION (Active vouchers only)
          // ═══════════════════════════════════════════════════════════════════
          if (voucher.code != null && isActive) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: colorScheme.surface,
              ),
              child: Column(
                children: [
                  Text(
                    'YOUR VOUCHER CODE',
                    style: GoogleFonts.montserrat(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  GestureDetector(
                    onTap: () => _copyCode(context, voucher.code!),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            luxury.gold.withValues(alpha: 0.15),
                            luxury.gold.withValues(alpha: 0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: luxury.gold.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            voucher.code!,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 4,
                              color: luxury.gold,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: luxury.gold.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.copy_rounded,
                              color: luxury.gold,
                              size: 18.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Tap to copy',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ═══════════════════════════════════════════════════════════════════
          // EXPIRING SOON WARNING
          // ═══════════════════════════════════════════════════════════════════
          if (isExpiringSoon) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              color: Colors.orange.withValues(alpha: 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_amber_rounded, 
                    color: Colors.orange, 
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Expires in ${voucher.expiresAt.difference(DateTime.now()).inDays} days!',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ═══════════════════════════════════════════════════════════════════
          // FOOTER
          // ═══════════════════════════════════════════════════════════════════
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
            ),
            child: Row(
              children: [
                // Date info
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getDateIcon(),
                        size: 14.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 6.w),
                      Flexible(
                        child: Text(
                          _getDateText(dateFormat),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                
                // Redeemed date
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.redeem,
                        size: 14.sp,
                        color: luxury.gold,
                      ),
                      SizedBox(width: 6.w),
                      Flexible(
                        child: Text(
                          'Redeemed: ${dateFormat.format(voucher.redeemedAt)}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: luxury.gold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getDateIcon() {
    switch (voucher.status) {
      case RedemptionStatus.active:
        return Icons.timer_outlined;
      case RedemptionStatus.used:
        return Icons.check_circle_outline;
      case RedemptionStatus.expired:
        return Icons.timer_off_outlined;
      case RedemptionStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  String _getDateText(DateFormat format) {
    switch (voucher.status) {
      case RedemptionStatus.active:
        return 'Expires: ${format.format(voucher.expiresAt)}';
      case RedemptionStatus.used:
        return 'Used: ${format.format(voucher.usedAt ?? voucher.expiresAt)}';
      case RedemptionStatus.expired:
        return 'Expired: ${format.format(voucher.expiresAt)}';
      case RedemptionStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color _getTypeColor(RewardType type) {
    switch (type) {
      case RewardType.points:
        return Colors.amber;
      case RewardType.freeVisit:
        return Colors.green;
      case RewardType.discount:
        return Colors.purple;
      case RewardType.merchandise:
        return Colors.blue;
      case RewardType.classPass:
        return Colors.teal;
      case RewardType.guestPass:
        return Colors.orange;
    }
  }

  void _copyCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    HapticFeedback.mediumImpact();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12.w),
            Text('Code "$code" copied!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STATUS BADGE
// ═══════════════════════════════════════════════════════════════════════════════

class _StatusBadge extends StatelessWidget {
  final RedemptionStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, text, icon) = _getStatusInfo();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14.sp),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  (Color, String, IconData) _getStatusInfo() {
    switch (status) {
      case RedemptionStatus.active:
        return (Colors.green, 'Active', Icons.check_circle);
      case RedemptionStatus.used:
        return (Colors.blue, 'Used', Icons.verified);
      case RedemptionStatus.expired:
        return (Colors.red, 'Expired', Icons.timer_off);
      case RedemptionStatus.cancelled:
        return (Colors.grey, 'Cancelled', Icons.cancel);
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// EMPTY STATE
// ═══════════════════════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  final String message;
  final String subtitle;
  final IconData icon;
  final bool showButton;

  const _EmptyState({
    required this.message,
    required this.subtitle,
    required this.icon,
    this.showButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48.sp,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              message,
              style: GoogleFonts.playfairDisplay(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 14.sp,
              ),
            ),
            if (showButton) ...[
              SizedBox(height: 32.h),
              FilledButton.icon(
                onPressed: () => context.go('/member/rewards'),
                icon: const Icon(Icons.card_giftcard),
                label: const Text('Browse Rewards'),
                style: FilledButton.styleFrom(
                  backgroundColor: luxury.gold,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}