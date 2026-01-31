import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/partner/domain/entities/partner_entities.dart';
import 'package:mygym/src/features/partner/presentation/widget/reports/growth_badge.dart';
import 'package:mygym/src/features/partner/presentation/widget/reports/report_stat_item.dart';

class VisitReportCard extends StatelessWidget {
  final VisitSummary visitSummary;
  const VisitReportCard({super.key, required this.visitSummary});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.people_rounded, color: Colors.blue, size: 20.sp, ),
              ),
              SizedBox(width: 12.w,),
              Text(
                "Visits Report",
                style: GoogleFonts.montserrat(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              GrowthBadge(growth: visitSummary.growthPercentage)
            ],
          ),
          SizedBox(height: 24.h,),
          Row(
            children: [
              Expanded(
                child: ReportStatItem(
                  icon: Icons.login_rounded,
                  label: 'Total Visits',
                  value: visitSummary.totalVisits.toString(),
                  color: Colors.blue,
                )
                ),
                SizedBox(width: 12.w,),
                Expanded(
                  child: ReportStatItem(
                    icon: Icons.person_rounded, 
                    label: "Unique Visitors", 
                    value: visitSummary.uniqueVisitors.toString(), 
                    color: Colors.purple
                    )
                  )
            ],
          ),
          SizedBox(height: 12.h,),
          Row(
            children: [
              Expanded(
                child: ReportStatItem(
                  icon: Icons.repeat_rounded, 
                  label: "Avg per User", 
                  value: visitSummary.averageVisitsPerUser.toStringAsFixed(1), 
                  color: Colors.teal,
                  )
                ),
                SizedBox(width: 12.w,),
                Expanded(
                  child: ReportStatItem(
                    icon: Icons.history_rounded, 
                    label: "Previous Period", 
                    value: visitSummary.previousPeriodVisits.toString(), 
                    color: Colors.grey
                    )
                  )

            ],
          )
        ],
      ),
    );
  }
}
