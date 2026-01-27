import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mygym/src/features/subscriptions/presentation/cubit/subscriptions_cubit.dart';
import 'package:mygym/src/features/subscriptions/presentation/cubit/subscriptions_state.dart';
import 'package:mygym/src/features/subscriptions/presentation/views/widget/bundle_card.dart';
import 'package:mygym/src/features/subscriptions/presentation/views/widget/current_subscription_card.dart';
import 'package:mygym/src/features/subscriptions/presentation/views/widget/features_comparison.dart';
import 'package:mygym/src/features/subscriptions/presentation/views/widget/welcome_header.dart';

class BundlesView extends StatelessWidget {
  const BundlesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionsCubit, SubscriptionsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context, state),
          body: _buildBody(context, state),
        );
      },
    );
  }

  PreferredSizeWidget? _buildAppBar(
    BuildContext context,
    SubscriptionsState state,
  ) {
    return AppBar(
      title: const Text("Subscriptions Plans"),
      actions: [
        if (state.hasActiveSubscription)
          TextButton.icon(
            onPressed: () => context.push('/member/subscriptions/invoices'),
            icon: const Icon(Icons.receipt_long),
            label: const Text("Invoices"),
          ),
      ],
    );
  }

  Widget? _buildBody(BuildContext context, SubscriptionsState state) {
    if (state.bundlesStatus == SubscriptionsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.bundlesStatus == SubscriptionsStatus.failure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(state.errorMessage ?? "Failed to load bundles"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<SubscriptionsCubit>().loadBundles(),
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.hasActiveSubscription)...[
            CurrentSubscriptionCard(subscription : state.currentSubscription!),
            SizedBox(height: 24.h,),
            Text(
              "Upgrade Your Plan",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.w,),
          ]else...[
            WelcomeHeader(),
            SizedBox(height: 24.h,)
          ],
          ...state.bundles.map((bundle)=>
          Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: BundleCard(
              bundle: bundle, 
              isCurrentPlan: state.currentSubscription?.bundleId == bundle.id,
              onSelect: (){
                context.read<SubscriptionsCubit>().selectBundle(bundle);
                    context.push('/member/subscriptions/checkout/${bundle.id}');
              }
              ),
          )
          ),
          SizedBox(height: 24.h,),
          FeaturesComparison(bundles: state.bundles),

        ],
      ),
    );
  }
}
