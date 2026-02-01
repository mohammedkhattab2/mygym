import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/features/partner/domain/entities/partner_entities.dart';
import 'package:mygym/src/features/partner/presentation/widget/setting/limit_card.dart';
import 'package:mygym/src/features/partner/presentation/widget/setting/settings_card.dart';

class VisitLimitsSection extends StatelessWidget {
  final PartnerSettings settings;
  const VisitLimitsSection({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SettingsCard(
      title: "Visit Limits", 
      icon: Icons.event_repeat_rounded, 
      iconColor: Colors.orange, 
      children: [
        Row(
          children: [
            Expanded(
              child: LimitCard(
                icon: Icons.today_rounded,
                label: 'Daily Limit',
                value: '${settings.maxDailyVisitsPerUser}',
                unit: 'visits/day',
                color: Colors.blue,
              )
              ),
              SizedBox(width: 12.w,),
              Expanded(
                child:LimitCard(
                  icon: Icons.date_range_rounded, 
                  label: "Weekly limit", 
                  value: '${settings.maxWeeklyVisitsPerUser}', 
                  unit: 'visits/week', 
                  color: Colors.teal
                  ) 
              )
          ],
        ),
        SizedBox(height: 16.h,),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.orange.withValues(alpha: 0.2))
          ),
          child: Row(
            children: [
              Icon(Icons.info_rounded, color: Colors.orange, size: 18.sp,),
              SizedBox(width: 10.w,),
              Expanded(
                child: Text(
                  'Contact support to modify visit limits',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.orange.shade700,
                  ),
                )
                )
            ],
          ),
        )
      ]
      );
  }
}