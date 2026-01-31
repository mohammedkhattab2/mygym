import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/partner/domain/entities/partner_entities.dart';

class ReportSummaryCard extends StatelessWidget {
  final PartnerReport report;
  final ReportPeriod period;
  const ReportSummaryCard({super.key, required this.report, required this.period});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final dateFormat = DateFormat('MMMM d, yyyy');
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withValues(alpha: 0.5),
            colorScheme.secondaryContainer.withValues(alpha:  0.3)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2))
      ),
      child: Row(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary,colorScheme.secondary ]
                ),
                borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.analytics_rounded,
              color: colorScheme.onPrimary,
              size: 28.sp,
            ),
          ),
          SizedBox(width: 16.w,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.gymName,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h,),
                Text(
                  '${period == ReportPeriod.daily ? 'Daily' : 'Weekly'} Report',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 2.h,),
                Text(dateFormat.format(report.reportDate),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
                ),
              ],
            )
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withValues(alpha: 0.2))
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color:Colors.green, size: 14.sp ,),
                  SizedBox(width: 4.w,),
                  Text(
                    "Live",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.green
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
