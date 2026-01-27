import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/features/subscriptions/domain/entities/subscription.dart';

class BundleCard extends StatelessWidget {
  final SubscriptionBundle bundle;
  final bool isCurrentPlan;
  final VoidCallback onSelect;

  const BundleCard({super.key, required this.bundle, this.isCurrentPlan = false, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: bundle.isPopular? 4:1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: bundle.isPopular
        ?BorderSide(color: colorScheme.primary,width: 2)
        :BorderSide.none,
      ),
      child: Column(
        children: [
          if (bundle.isPopular)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 6.h),
            color: colorScheme.primary,
            child: const Text(
              "⭐ MOST POPULAR",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bundle.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          bundle.period.displayName,
                          style: TextStyle(color: Colors.grey[600]),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (bundle.originalPrice != null)...[
                          Text(
                            bundle.formattedOriginalPrice!,
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          )
                        ],
                        Text(
                          bundle.formattedPrice,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 16.h,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        bundle.isUnlimited? Icons.all_inclusive : Icons.confirmation_number,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      SizedBox(width: 8.w,),
                      Text(
                        bundle.visitsText,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 16.h,),
                ...bundle.features.take(4).map((feature)=> Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    children: [
                      Icon(Icons.check, size: 18, color: Colors.green[600], ),
                      SizedBox(width: 8.w,),
                      Expanded(child: Text(feature)),
                    ],
                  ),
                  )),
                  SizedBox(height: 16.h,),
                  SizedBox(
                    width: double.infinity,
                    child: isCurrentPlan
                    ? OutlinedButton(
                      onPressed: null, 
                      child: const Text("Current Plan"),
                      )
                      : FilledButton(
                        onPressed: onSelect, 
                        child: Text(
                          isCurrentPlan ? "Current Plan" : "Select Plan",
                        )
                        )
                  )
              ],
             ),
            )
        ],
      ),
    );
  }
}
