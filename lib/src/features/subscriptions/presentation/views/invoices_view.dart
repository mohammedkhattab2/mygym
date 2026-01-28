import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/subscriptions/domain/entities/subscription.dart';
import 'package:mygym/src/features/subscriptions/presentation/cubit/subscriptions_cubit.dart';
import 'package:mygym/src/features/subscriptions/presentation/cubit/subscriptions_state.dart';

class InvoicesView extends StatelessWidget {
  const InvoicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionsCubit, SubscriptionsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: _buildBody(context, state),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Payment History",
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SubscriptionsState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    if (state.invoicesStatus == SubscriptionsStatus.loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 48.w,
              height: 48.w,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "Loading invoices...",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: luxury.textTertiary,
              ),
            ),
          ],
        ),
      );
    }

    if (state.invoices.isEmpty) {
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
                  color: isDark
                      ? luxury.surfaceElevated
                      : colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  size: 48,
                  color: luxury.textMuted,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                "No Invoices Yet",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Your payment history will appear here\nonce you make a purchase",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: luxury.textTertiary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: luxury.backgroundGradient,
      ),
      child: Column(
        children: [
          // Summary header
          _buildSummaryHeader(context, state),
          
          // Invoices list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: state.invoices.length,
              itemBuilder: (context, index) {
                final invoice = state.invoices[index];
                return _InvoiceCard(invoice: invoice);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(BuildContext context, SubscriptionsState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    final totalPaid = state.invoices
        .where((i) => i.status == InvoiceStatus.paid)
        .fold<double>(0, (sum, i) => sum + i.amount);

    final paidCount = state.invoices
        .where((i) => i.status == InvoiceStatus.paid)
        .length;

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: luxury.cardGradient,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? luxury.borderLight : colorScheme.outline.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Spent",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: luxury.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "${totalPaid.toStringAsFixed(0)} EGP",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 40.h,
            color: isDark ? luxury.borderLight : colorScheme.outline.withValues(alpha: 0.3),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Transactions",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: luxury.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "$paidCount paid",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
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

class _InvoiceCard extends StatelessWidget {
  final Invoice invoice;

  const _InvoiceCard({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isDark ? luxury.surfaceElevated : colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? luxury.borderLight : colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.tag_rounded,
                          size: 16,
                          color: luxury.textTertiary,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'INV-${invoice.id.length >= 8 ? invoice.id.substring(0, 8).toUpperCase() : invoice.id.toUpperCase()}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      dateFormat.format(invoice.createdAt),
                      style: TextStyle(
                        color: luxury.textTertiary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                _StatusBadge(status: invoice.status),
              ],
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              child: Divider(
                color: isDark ? luxury.borderLight : colorScheme.outline.withValues(alpha: 0.2),
                height: 1,
              ),
            ),
            
            // Amount and payment method row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amount",
                      style: TextStyle(
                        color: luxury.textTertiary,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      invoice.formattedAmount,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: invoice.status == InvoiceStatus.paid
                            ? luxury.success
                            : null,
                      ),
                    ),
                  ],
                ),
                if (invoice.provider != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Payment Method",
                        style: TextStyle(
                          color: luxury.textTertiary,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            _getProviderIcon(invoice.provider!),
                            size: 16,
                            color: luxury.textTertiary,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            invoice.provider!.displayName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
            
            // Download button
            if (invoice.downloadUrl != null) ...[
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Download invoice PDF
                  },
                  icon: Icon(Icons.download_rounded, size: 18),
                  label: const Text("Download Invoice"),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    side: BorderSide(
                      color: colorScheme.primary.withValues(alpha: 0.5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getProviderIcon(PaymentProvider provider) {
    switch (provider) {
      case PaymentProvider.paymob:
        return Icons.credit_card_rounded;
      case PaymentProvider.instapay:
        return Icons.phone_android_rounded;
      case PaymentProvider.kashier:
        return Icons.account_balance_rounded;
      case PaymentProvider.wallet:
        return Icons.account_balance_wallet_rounded;
      default:
        return Icons.payment_rounded;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final InvoiceStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    
    Color backgroundColor;
    Color textColor;
    String text;
    IconData icon;

    switch (status) {
      case InvoiceStatus.paid:
        backgroundColor = luxury.success.withValues(alpha: 0.12);
        textColor = luxury.success;
        text = "Paid";
        icon = Icons.check_circle_rounded;
        break;
      case InvoiceStatus.pending:
        backgroundColor = luxury.warning.withValues(alpha: 0.12);
        textColor = luxury.warning;
        text = 'Pending';
        icon = Icons.hourglass_empty_rounded;
        break;
      case InvoiceStatus.failed:
        backgroundColor = Theme.of(context).colorScheme.error.withValues(alpha: 0.12);
        textColor = Theme.of(context).colorScheme.error;
        text = 'Failed';
        icon = Icons.error_rounded;
        break;
      case InvoiceStatus.refunded:
        backgroundColor = luxury.info.withValues(alpha: 0.12);
        textColor = luxury.info;
        text = 'Refunded';
        icon = Icons.replay_rounded;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: textColor,
          ),
          SizedBox(width: 6.w),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
