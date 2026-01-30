import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/subscriptions/domain/entities/subscription.dart';
import 'package:mygym/src/features/subscriptions/domain/repositories/subscription_repository.dart';
import 'package:mygym/src/features/subscriptions/presentation/cubit/subscriptions_cubit.dart';
import 'package:mygym/src/features/subscriptions/presentation/cubit/subscriptions_state.dart';

class CheckoutView extends StatefulWidget {
  final String bundleId;
  const CheckoutView({super.key, required this.bundleId});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<SubscriptionsCubit>();
      if (cubit.state.selectedBundle == null) {
        final bundle = cubit.state.bundles
            .where((b) => b.id == widget.bundleId)
            .firstOrNull;
        if (bundle != null) {
          cubit.selectBundle(bundle);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    final colorScheme = context.colorScheme;
    final isDark = context.isDarkMode;

    return BlocConsumer<SubscriptionsCubit, SubscriptionsState>(
      listenWhen: (previous, current) {
        return previous.checkoutStatus != current.checkoutStatus ||
            previous.checkoutSession != current.checkoutSession;
      },
      listener: (context, state) {
        if (state.checkoutStatus == SubscriptionsStatus.success &&
            state.checkoutSession != null) {
          context.push(
            '/member/subscriptions/payment',
            extra: state.checkoutSession,
          );
        }
        if (state.checkoutStatus == SubscriptionsStatus.failure &&
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
        if (state.selectedBundle == null && state.bundles.isNotEmpty) {
          final bundle = state.bundles.where((b) => b.id == widget.bundleId).firstOrNull;
          if (bundle != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<SubscriptionsCubit>().selectBundle(bundle);
            });
          }
        }

        final bundle =
            state.selectedBundle ??
            state.bundles.where((b) => b.id == widget.bundleId).firstOrNull;

        if (state.bundlesStatus == SubscriptionsStatus.loading) {
          return Scaffold(
            appBar: AppBar(title: const Text("Checkout")),
            body: Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            ),
          );
        }

        if (bundle == null) {
          return Scaffold(
            appBar: AppBar(title: const Text("Checkout")),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 64.sp,
                    color: luxury.textTertiary,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Bundle not found",
                    style: context.textTheme.titleMedium?.copyWith(
                      color: luxury.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: CustomScrollView(
            slivers: [
              // Premium App Bar with gradient
              SliverAppBar(
                expandedHeight: 180.h,
                pinned: true,
                backgroundColor: colorScheme.surface,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? LinearGradient(
                              colors: [
                                colorScheme.primary.withValues(alpha:  0.15),
                                colorScheme.surface,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                          : LinearGradient(
                              colors: [
                                colorScheme.primaryContainer.withValues(alpha:  0.5),
                                colorScheme.surface,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 20.h),
                        child: _PlanHeader(bundle: bundle),
                      ),
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: isDark
                          ? luxury.surfaceElevated
                          : colorScheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? luxury.borderLight : colorScheme.outline.withValues(alpha:  0.2),
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18.sp,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  onPressed: () => context.pop(),
                ),
                title: Text(
                  "Checkout",
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
                    // Promo Code Section
                    _LuxuryPromoCodeSection(
                      promoCode: state.promoCode,
                      promoResult: state.promoResult,
                      isLoading: state.promoStatus == SubscriptionsStatus.loading,
                    ),
                    SizedBox(height: 24.h),

                    // Payment Method Section
                    _LuxuryPaymentMethodSection(
                      selectedProvider: state.selectedProvider,
                      onProviderSelected: (provider) {
                        context.read<SubscriptionsCubit>().selectPaymentProvider(provider);
                      },
                    ),
                    SizedBox(height: 24.h),

                    // Order Summary
                    _LuxuryOrderSummary(
                      bundle: bundle,
                      promoResult: state.promoResult,
                      finalPrice: state.finalPrice ?? bundle.price,
                    ),
                    SizedBox(height: 120.h),
                  ]),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _LuxuryCheckoutButton(
            isLoading: state.checkoutStatus == SubscriptionsStatus.loading,
            isEnabled: state.selectedProvider != null,
            finalPrice: state.finalPrice ?? bundle.price,
            onPressed: () {
              context.read<SubscriptionsCubit>().createCheckout();
            },
          ),
        );
      },
    );
  }
}

class _PlanHeader extends StatelessWidget {
  final SubscriptionBundle bundle;

  const _PlanHeader({required this.bundle});

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    final colorScheme = context.colorScheme;

    return Row(
      children: [
        // Plan Icon
        Container(
          width: 72.w,
          height: 72.w,
          decoration: BoxDecoration(
            gradient: luxury.primaryGradient,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha:  0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.workspace_premium_rounded,
            color: Colors.white,
            size: 36.sp,
          ),
        ),
        SizedBox(width: 16.w),
        // Plan Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                bundle.name,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "${bundle.period.displayName} • ${bundle.visitsText}",
                style: context.textTheme.bodyMedium?.copyWith(
                  color: luxury.textTertiary,
                ),
              ),
            ],
          ),
        ),
        // Price
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (bundle.originalPrice != null)
              Text(
                bundle.formattedOriginalPrice!,
                style: context.textTheme.bodySmall?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: luxury.textMuted,
                ),
              ),
            Text(
              bundle.formattedPrice,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: luxury.gold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LuxuryPromoCodeSection extends StatelessWidget {
  final String promoCode;
  final PromoCodeResult? promoResult;
  final bool isLoading;

  const _LuxuryPromoCodeSection({
    required this.promoCode,
    this.promoResult,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    final colorScheme = context.colorScheme;
    final isDark = context.isDarkMode;
    final cubit = context.read<SubscriptionsCubit>();
    final hasValidPromo = promoResult?.isValid == true;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? luxury.surfaceElevated : colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: hasValidPromo
              ? luxury.success.withValues(alpha:  0.3)
              : (isDark ? luxury.borderLight : colorScheme.outline.withValues(alpha:  0.15)),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha:  0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: hasValidPromo
                      ? luxury.success.withValues(alpha:  0.1)
                      : colorScheme.primary.withValues(alpha:  0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  hasValidPromo ? Icons.check_circle_rounded : Icons.local_offer_rounded,
                  color: hasValidPromo ? luxury.success : colorScheme.primary,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                "Promo Code",
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: TextField(
                  enabled: !hasValidPromo,
                  decoration: InputDecoration(
                    hintText: "Enter code",
                    hintStyle: TextStyle(color: luxury.textMuted),
                    filled: true,
                    fillColor: isDark
                        ? luxury.surfacePremium
                        : colorScheme.surfaceContainerHighest.withValues(alpha:  0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    suffixIcon: hasValidPromo
                        ? IconButton(
                            onPressed: () => cubit.clearPromoCode(),
                            icon: Icon(Icons.close_rounded, color: luxury.textTertiary),
                          )
                        : null,
                  ),
                  onChanged: cubit.updatePromoCode,
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                decoration: BoxDecoration(
                  gradient: isLoading || hasValidPromo || promoCode.isEmpty
                      ? null
                      : luxury.primaryGradient,
                  color: isLoading || hasValidPromo || promoCode.isEmpty
                      ? (isDark ? luxury.surfacePremium : colorScheme.surfaceContainerHighest)
                      : null,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isLoading || hasValidPromo || promoCode.isEmpty
                        ? null
                        : () => cubit.applyPromoCode(),
                    borderRadius: BorderRadius.circular(14.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                      child: isLoading
                          ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.primary,
                              ),
                            )
                          : Text(
                              "Apply",
                              style: context.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isLoading || hasValidPromo || promoCode.isEmpty
                                    ? luxury.textMuted
                                    : Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (promoResult != null) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: promoResult!.isValid
                    ? luxury.success.withValues(alpha:  0.1)
                    : colorScheme.error.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    promoResult!.isValid ? Icons.celebration_rounded : Icons.error_rounded,
                    color: promoResult!.isValid ? luxury.success : colorScheme.error,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      promoResult!.isValid
                          ? 'You save ${promoResult!.discountPercentage?.toInt()}%!'
                          : promoResult!.errorMessage ?? "Invalid code",
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: promoResult!.isValid ? luxury.success : colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
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
}

class _LuxuryPaymentMethodSection extends StatelessWidget {
  final PaymentProvider? selectedProvider;
  final ValueChanged<PaymentProvider> onProviderSelected;

  const _LuxuryPaymentMethodSection({
    required this.selectedProvider,
    required this.onProviderSelected,
  });

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    final colorScheme = context.colorScheme;
    final isDark = context.isDarkMode;

    final providers = [
      (PaymentProvider.paymob, Icons.credit_card_rounded, "Card Payment"),
      (PaymentProvider.instapay, Icons.account_balance_rounded, "InstaPay"),
      (PaymentProvider.kashier, Icons.payments_rounded, "Kashier"),
      (PaymentProvider.wallet, Icons.account_balance_wallet_rounded, "Wallet"),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha:  0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.payment_rounded,
                color: colorScheme.primary,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              "Payment Method",
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ...providers.map((provider) {
          final isSelected = selectedProvider == provider.$1;
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onProviderSelected(provider.$1),
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary.withValues(alpha:  isDark ? 0.15 : 0.08)
                        : (isDark ? luxury.surfaceElevated : colorScheme.surface),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : (isDark ? luxury.borderLight : colorScheme.outline.withValues(alpha:  0.15)),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha:  0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary.withValues(alpha:  0.15)
                              : (isDark
                                  ? luxury.surfacePremium
                                  : colorScheme.surfaceContainerHighest.withValues(alpha:  0.5)),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          provider.$2,
                          color: isSelected ? colorScheme.primary : luxury.textTertiary,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.$1.displayName,
                              style: context.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isSelected ? colorScheme.primary : null,
                              ),
                            ),
                            Text(
                              provider.$3,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: luxury.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? colorScheme.primary : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.primary
                                : (isDark ? luxury.borderLight : colorScheme.outline.withValues(alpha:  0.3)),
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 16.sp,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _LuxuryOrderSummary extends StatelessWidget {
  final SubscriptionBundle bundle;
  final PromoCodeResult? promoResult;
  final double finalPrice;

  const _LuxuryOrderSummary({
    required this.bundle,
    this.promoResult,
    required this.finalPrice,
  });

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
          color: isDark ? luxury.borderGold : luxury.gold.withValues(alpha:  0.2),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha:  0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: luxury.gold.withValues(alpha:  0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: luxury.gold,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                "Order Summary",
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _SummaryRow(
            label: "Subtotal",
            value: bundle.formattedPrice,
          ),
          if (bundle.discountPercentage != null)
            _SummaryRow(
              label: "Bundle Discount",
              value: "-${bundle.discountPercentage}%",
              isDiscount: true,
            ),
          if (promoResult?.isValid == true)
            _SummaryRow(
              label: "Promo Discount",
              value: "-${promoResult!.discountAmount?.toStringAsFixed(0)} EGP",
              isDiscount: true,
            ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Divider(
              color: isDark ? luxury.borderLight : colorScheme.outline.withValues(alpha:  0.15),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "${finalPrice.toStringAsFixed(0)} EGP",
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

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDiscount;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: luxury.textTertiary,
            ),
          ),
          Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDiscount ? luxury.success : null,
              fontWeight: isDiscount ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _LuxuryCheckoutButton extends StatelessWidget {
  final bool isLoading;
  final bool isEnabled;
  final double finalPrice;
  final VoidCallback onPressed;

  const _LuxuryCheckoutButton({
    required this.isLoading,
    required this.isEnabled,
    required this.finalPrice,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    final colorScheme = context.colorScheme;
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? luxury.surfaceElevated : colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: isDark ? luxury.borderLight : colorScheme.outline.withValues(alpha:  0.1),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:  isDark ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: isEnabled && !isLoading ? luxury.primaryGradient : null,
            color: isEnabled && !isLoading
                ? null
                : (isDark ? luxury.surfacePremium : colorScheme.surfaceContainerHighest),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: isEnabled && !isLoading
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha:  0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isEnabled && !isLoading ? onPressed : null,
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 18.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading)
                      SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: isEnabled ? Colors.white : luxury.textMuted,
                        ),
                      )
                    else ...[
                      Icon(
                        Icons.lock_rounded,
                        color: isEnabled ? Colors.white : luxury.textMuted,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Pay ${finalPrice.toStringAsFixed(0)} EGP",
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isEnabled ? Colors.white : luxury.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
