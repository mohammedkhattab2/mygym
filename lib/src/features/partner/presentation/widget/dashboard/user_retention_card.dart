import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/partner/domain/entities/partner_entities.dart';
import 'package:mygym/src/features/partner/presentation/widget/dashboard/retention_stat.dart';

class UserRetentionCard extends StatelessWidget {
  final UserRetention retention;
  const UserRetentionCard({super.key, required this.retention});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    return Container(
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: luxury.gold.withValues(alpha: 0.1))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha:  0.1),
                  borderRadius: BorderRadius.circular(10.r)
                ),
                child: Icon(
                  Icons.group_rounded,
                  color: Colors.purple,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 12.w,),
              Text(
                "User Retention",
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5
                ),
              )
            ],
          ),
          SizedBox(height: 20.h,),
          Row(
            children: [
              Expanded(
                child: RetentionStat(
                  icon: Icons.people_rounded, 
                  label: " Active Users", 
                  value: retention.totalActiveUsers.toString(), 
                  color: Colors.blue
                  )
                ),
                SizedBox(width: 10.w,),
                Expanded(
                  child: RetentionStat(
                    icon: Icons.person_add_rounded, 
                    label: "New Users", 
                    value: '+${retention.newUsersThisPeriod}', 
                    color: Colors.green
                    )
                  ),
                  SizedBox(width: 10.w,),
                  Expanded(
                    child: RetentionStat(
                      icon: Icons.autorenew_rounded, 
                      label: "Retention", 
                      value: '${retention.retentionRate.toInt()}%', 
                      color: Colors.purple
                      )
                    )
            ],
          ),
          SizedBox(height: 16.h,),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.trending_down_rounded,
                  size: 18.sp,
                  color: retention.churnRate > 10 ? Colors.red : Colors.green,
                ),
                SizedBox(width: 10.w,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Churn Rate",
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: colorScheme.onSurfaceVariant
                        ),
                      ),
                      Text(
                        '${retention.churnRate.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: retention.churnRate > 10 ? Colors.red: Colors.orange,
                        ),
                      ),
                      
                    ],
                  )
                  ), 
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 6.h),
                    decoration: BoxDecoration(
                      color: retention.churnRate>10
                           ? Colors.red.withValues(alpha:  0.1)
                           : Colors.green.withValues(alpha:  0.1),
                      borderRadius: BorderRadius.circular(8.r)
                    ),
                    child: Text(
                      retention.churnRate > 10 ? 'High' : 'Normal',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: retention.churnRate > 10 ? Colors.red : Colors.green
                      ),
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}