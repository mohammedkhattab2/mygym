import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/features/subscriptions/domain/entities/subscription.dart';
import 'package:mygym/src/features/subscriptions/presentation/views/widget/info_chip.dart';

class CurrentSubscriptionCard extends StatelessWidget {
  final UserSubscription subscription;
  const CurrentSubscriptionCard({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    final colorSchame = Theme.of(context).colorScheme;
    return Card(
      color:colorSchame.primaryContainer ,
      child:  Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: colorSchame.primary,),
                SizedBox(width: 8.w,),
                Text(
                  "Current Subscription",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorSchame.onPrimaryContainer,
                  ),
                )
              ],
            ),
            SizedBox(height: 12.h,),
            Text(
              subscription.bundleName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorSchame.onPrimaryContainer,
              ),
            ),
            SizedBox(height: 8.h,),
            Row(
              children: [
                InfoChip(
                  icon: Icons.calendar_today, 
                  label: '${subscription.daysUntilExpiry} days left',
                  ),
                  SizedBox(width: 8.w,),
                  if (subscription.remainingVisits != null)
                  InfoChip(
                    icon: Icons.fitness_center, 
                    label: '${subscription.remainingVisits} visits left',
                    )
              ],
            ),
            if (subscription.isExpiringSoon)...[
              SizedBox(height: 12.h,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 6.h),
                decoration: BoxDecoration(
                  color:  Colors.orange.withValues(alpha:  0.2),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.warning, color: Colors.orange, size: 16,),
                    SizedBox(width: 4.w,),
                    const Text(
                      "Expiring Soon!",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              )
            ]
          ],
        ),
        ),
    );
  }
}
