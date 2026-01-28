import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/subscriptions/domain/entities/subscription.dart';

import '../cubit/subscriptions_cubit.dart';
import '../cubit/subscriptions_state.dart';

class PaymentWebView extends StatelessWidget {
  const PaymentWebView({super.key});

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    final colorScheme = context.colorScheme;
    final isDark = context.isDarkMode;

    return BlocBuilder<SubscriptionsCubit, SubscriptionsState>(
      builder: (context, state) {
        final session = state.checkoutSession;
        final bundle = state.selectedBundle;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: CustomScrollView(
            slivers: [
              // Premium App Bar
              SliverAppBar(
                expandedHeight: 140.h,
                pinned: true,
                backgroundColor: colorScheme.surface,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? LinearGradient(
                              colors: [
                                luxury.gold.withOpacity(0.12),
                                colorScheme.surface,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                          : LinearGradient(
                              colors: [
                                luxury.goldLight.withOpacity(0.3),
                                colorScheme.surface,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: isDark ? luxury.surfaceElevated : colorScheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? luxury.borderLight : colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 18.sp,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  onPressed: () => _showCancelConfirmation(context),
                ),
                title: Text(
                  "Complete Payment",
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Content
              SliverPadding(
                padding: EdgeInsets.all(20.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 20.h),

                    // Demo Badge
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: luxury.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(
                            color: luxury.warning.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.science_rounded,
                              color: luxury.warning,
                              size: 18.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "DEMO MODE",
                              style: context.textTheme.labelLarge?.copyWith(
                                color: luxury.warning,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Payment Icon with Glow
                    Center(
                      child: Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          gradient: luxury.goldGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: luxury.gold.withOpacity(0.4),
                              blurRadius: 40,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 56.sp,
                          color: isDark ? AppColors.backgroundDark : Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Title
                    Center(
                      child: Text(
                        "Secure Payment",
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Text(
                          "This is a demo payment screen.\nNo real transaction will be processed.",
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: luxury.textTertiary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),

                    // Order Details Card
                    _LuxuryOrderCard(
                      bundle: bundle,
                      session: session,
                    ),
                    SizedBox(height: 24.h),

                    // Demo Card Input
                    _LuxuryDemoCardInput(),
                    SizedBox(height: 32.h),

                    // Security Badge
                    _SecurityBadge(),
                    SizedBox(height: 40.h),

                    // Action Buttons
                    _LuxurySuccessButton(
                      onPressed: () => _simulateSuccessPayment(context),
                    ),
                    SizedBox(height: 16.h),
                    _LuxuryFailureButton(
                      onPressed: () => _simulateFailedPayment(context),
                    ),
                    SizedBox(height: 40.h),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _simulateSuccessPayment(BuildContext context) async {
    final luxury = context.luxury;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: isDark ? luxury.surfaceElevated : colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
          side: BorderSide(
            color: isDark ? luxury.borderLight : colorScheme.outline.withOpacity(0.1),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 48.w,
                height: 48.w,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: colorScheme.primary,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                "Processing Payment...",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Please wait",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: luxury.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Simulate delay
    await Future.delayed(const Duration(seconds: 2));

    // Verify payment
    if (context.mounted) {
      final cubit = context.read<SubscriptionsCubit>();
      final sessionId = cubit.state.checkoutSession?.sessionId ?? '';
      await cubit.verifyPayment(sessionId);
    }

    // Close loading dialog
    if (context.mounted) Navigator.of(context).pop();

    // Show success dialog
    if (context.mounted) {
      _showSuccessDialog(context);
    }
  }

  void _showSuccessDialog(BuildContext context) {
    final luxury = Theme.of(context).extension<LuxuryThemeExtension>()!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: isDark ? luxury.surfaceElevated : colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
          side: BorderSide(
            color: luxury.success.withOpacity(0.3),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: luxury.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: luxury.success,
                  size: 48.sp,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                "Payment Successful!",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: luxury.success,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Your subscription is now active.\nEnjoy your premium access!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: luxury.textTertiary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.energyGradient,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go('/member/home');
                      },
                      borderRadius: BorderRadius.circular(14.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.explore_rounded,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Start Exploring",
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _simulateFailedPayment(BuildContext context) {
    final luxury = Theme.of(context).extension<LuxuryThemeExtension>()!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: isDark ? luxury.surfaceElevated : colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
          side: BorderSide(
            color: colorScheme.error.withOpacity(0.3),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: colorScheme.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_rounded,
                  color: colorScheme.error,
                  size: 48.sp,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                "Payment Failed",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.error,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "The payment could not be processed.\nPlease try again.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: luxury.textTertiary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.pop();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        side: BorderSide(
                          color: isDark ? luxury.borderLight : colorScheme.outline.withOpacity(0.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        "Go Back",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        "Try Again",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context) {
    final luxury = Theme.of(context).extension<LuxuryThemeExtension>()!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: isDark ? luxury.surfaceElevated : colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
          side: BorderSide(
            color: isDark ? luxury.borderLight : colorScheme.outline.withOpacity(0.1),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: luxury.warning.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: luxury.warning,
                  size: 32.sp,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                "Cancel Payment?",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Are you sure you want to cancel?\nYour payment will not be processed.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: luxury.textTertiary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.pop();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        foregroundColor: colorScheme.error,
                        side: BorderSide(color: colorScheme.error.withOpacity(0.5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: const Text("Continue"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LuxuryOrderCard extends StatelessWidget {
  final SubscriptionBundle? bundle;
  final CheckoutSession? session;

  const _LuxuryOrderCard({this.bundle, this.session});

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    final colorScheme = context.colorScheme;
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? luxury.surfaceElevated : colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? luxury.borderGold : luxury.gold.withOpacity(0.2),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: luxury.gold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.shopping_bag_rounded,
                  color: luxury.gold,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                "Order Details",
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _OrderRow(
            icon: Icons.workspace_premium_rounded,
            label: "Plan",
            value: bundle?.name ?? "N/A",
          ),
          _OrderRow(
            icon: Icons.calendar_today_rounded,
            label: "Duration",
            value: bundle?.period.displayName ?? "N/A",
          ),
          _OrderRow(
            icon: Icons.payment_rounded,
            label: "Provider",
            value: session?.provider.displayName ?? "N/A",
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Divider(
              color: isDark ? luxury.borderLight : colorScheme.outline.withOpacity(0.15),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Amount",
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "${session?.amount.toStringAsFixed(0) ?? '0'} ${session?.currency ?? 'EGP'}",
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: luxury.gold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _OrderRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18.sp,
            color: luxury.textTertiary,
          ),
          SizedBox(width: 12.w),
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: luxury.textTertiary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LuxuryDemoCardInput extends StatelessWidget {
  const _LuxuryDemoCardInput();

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    final colorScheme = context.colorScheme;
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? luxury.surfaceElevated : colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? luxury.borderLight : colorScheme.outline.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.credit_card_rounded,
                  color: colorScheme.primary,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                "Card Details",
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: luxury.textMuted.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  "Demo",
                  style: context.textTheme.labelSmall?.copyWith(
                    color: luxury.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _DemoTextField(
            label: "Card Number",
            value: "4242 4242 4242 4242",
            icon: Icons.credit_card_rounded,
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _DemoTextField(
                  label: "Expiry",
                  value: "12/28",
                  icon: Icons.calendar_month_rounded,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _DemoTextField(
                  label: "CVV",
                  value: "123",
                  icon: Icons.lock_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DemoTextField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DemoTextField({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark ? luxury.surfacePremium : context.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18.sp,
            color: luxury.textMuted,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: luxury.textMuted,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    letterSpacing: label == "Card Number" ? 2 : 0,
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

class _SecurityBadge extends StatelessWidget {
  const _SecurityBadge();

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.verified_user_rounded,
          size: 16.sp,
          color: luxury.success,
        ),
        SizedBox(width: 8.w),
        Text(
          "256-bit SSL Encrypted • Secure Payment",
          style: context.textTheme.labelSmall?.copyWith(
            color: luxury.textTertiary,
          ),
        ),
      ],
    );
  }
}

class _LuxurySuccessButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LuxurySuccessButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.energyGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: luxury.success.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 18.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 22.sp,
                ),
                SizedBox(width: 10.w),
                Text(
                  "Simulate Successful Payment",
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LuxuryFailureButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LuxuryFailureButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    final colorScheme = context.colorScheme;
    final isDark = context.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? luxury.surfaceElevated : colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.error.withOpacity(0.4),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 18.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel_rounded,
                  color: colorScheme.error,
                  size: 22.sp,
                ),
                SizedBox(width: 10.w),
                Text(
                  "Simulate Failed Payment",
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}