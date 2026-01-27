import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mygym/src/features/subscriptions/domain/entities/subscription.dart';
import 'package:mygym/src/features/subscriptions/domain/repositories/subscription_repository.dart';
import 'package:mygym/src/features/subscriptions/presentation/cubit/subscriptions_cubit.dart';
import 'package:mygym/src/features/subscriptions/presentation/cubit/subscriptions_state.dart';

class CheckoutView extends StatelessWidget {
  final String bundleId;
  const CheckoutView({super.key, required this.bundleId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubscriptionsCubit, SubscriptionsState>(
      listener: (context, state) {
        if (state.checkoutStatus == SubscriptionsStatus.success &&
            state.checkoutSession != null) {
          context.push('/member/subscriptions/payment');
        }
      },
      builder: (context, state) {
        final bundel =
            state.selectedBundle ??
            state.bundles.where((b) => b.id == bundleId).firstOrNull;
        if (bundel == null) {
          return Scaffold(
            appBar: AppBar(title: const Text("Checkout")),
            body: const Center(child: Text("Bundle not found")),
          );
        }
        return Scaffold(
          appBar: AppBar(title: const Text("Checkout")),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BundleSummaryCard(bundle: bundel),
                SizedBox(height: 24.h),
                _PromoCodeSection(
                  promoCode: state.promoCode,
                  promoResult: state.promoResult,
                  isLoading: state.promoStatus == SubscriptionsStatus.loading,
                ),
                SizedBox(height: 24.h,),
                Text(
                  "Payment Method",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h,),
                _PaymentMethodSection(
                  
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PromoCodeSection extends StatelessWidget {
  final String promoCode;
  final PromoCodeResult? promoResult;
  final bool isLoading;
  const _PromoCodeSection({
    super.key,
    required this.promoCode,
    this.promoResult,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SubscriptionsCubit>();
    final hasValidPromo = promoResult?.isValid == true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Promo Code",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 8.h,),
        Row(
          children: [
            Expanded(
              child: TextField(
                enabled: !hasValidPromo,
                decoration: InputDecoration(
                  hintText: "Enter Promo Code",
                  prefixIcon: const Icon(Icons.local_offer),
                  border: OutlineInputBorder(
                    borderRadius:BorderRadius.circular(12) 
                    ),
                  suffixIcon: hasValidPromo
                  ?IconButton(
                    onPressed: () => cubit.clearPromoCode(), 
                    icon: const Icon(Icons.close)
                    )
                    :null,
                ),
                onChanged: cubit.updatePromoCode,
              )
              ),
              SizedBox(width: 12.w,),
              FilledButton(
                onPressed: isLoading || hasValidPromo || promoCode.isEmpty
                ? null
                :() => cubit.applyPromoCode(), 
                child: isLoading
                     ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2,),
                     )
                     : const Text("Apply")
                )
          ],
        ),
        if (promoResult != null)...[
          SizedBox(height: 8.h,),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: promoResult!.isValid
              ? Colors.green.withValues(alpha: 0.1)
              : Colors.red.withValues(alpha:  0.1),
              borderRadius: BorderRadius.circular(8)
            ),
            child: Row(
              children: [
                Icon(
                  promoResult!.isValid? Icons.check_circle : Icons.error,
                  color: promoResult!.isValid? Colors.green : Colors.red,
                  size: 20,
                ),
                SizedBox(width: 8.w,),
                Text(
                  promoResult!.isValid
                  ? 'Promo applied! You save ${promoResult!.discountPercentage?.toInt()}%'
                  : promoResult!.errorMessage?? "invalid code",
                  style: TextStyle(
                    color: promoResult!.isValid? Colors.green : Colors.red
                  ),

                )

              ],

            ),
          )

        ]
      ],
    );
  }
}

class _BundleSummaryCard extends StatelessWidget {
  final SubscriptionBundle bundle;
  const _BundleSummaryCard({required this.bundle});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.fitness_center,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bundle.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${bundle.period.displayName} • ${bundle.visitsText}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (bundle.originalPrice != null)
                  Text(
                    bundle.formattedOriginalPrice!,
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                Text(
                  bundle.formattedPrice,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: .bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
