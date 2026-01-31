import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/partner/domain/entities/partner_entities.dart';
import 'package:mygym/src/features/partner/presentation/widget/reports/growth_badge.dart';

class RevenueReportCard extends StatelessWidget {
  final RevenueSummary revenue;
  const RevenueReportCard({super.key, required this.revenue});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final numberFormat = NumberFormat('#,###');
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            luxury.gold.withValues(alpha: 0.15),
            luxury.gold.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: luxury.gold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: luxury.gold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.payment_rounded, color: luxury.gold,size: 20.sp, ),
              ),
              SizedBox(width: 12.w,),
              Text(
                "Revenue Report",
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              GrowthBadge(growth: revenue.growthPercentage),
            ],
          ),
          SizedBox(height: 24.h,),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              children: [
                Text(
                  "Total Revenue",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 8.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      numberFormat.format(revenue.totalRevenue),
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w700,
                        color: luxury.gold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 6.h, left: 4.w),
                      child: Text(
                        revenue.currency,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: luxury.gold
                        ),
                      ),
                      )
                  ],
                ),
                ],
            ),
          ),
          SizedBox(height: 16.h,),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.2))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                            Icon(
                        Icons.account_balance_rounded,
                        size: 14.sp,
                        color: Colors.green,
                      ),
                      SizedBox(width: 6.w,),
                      Text(
                        "Your Share",
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: colorScheme.onSurfaceVariant
                        ),
                      )
                        ],
                      ),
                      SizedBox(height: 8.h,),
                      Text(
                        '${numberFormat.format(revenue.netRevenue)} ${revenue.currency}',
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.green
                        ),
                      ),
                      SizedBox(height: 4.h,),
                      Text(
                        '${(revenue.revenueShare * 100).toInt()}% of total',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.green.withValues(alpha: 0.8)
                        ),
                      )
                    ],
                  ),
                )
                ),
                SizedBox(width: 12.w,),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.receipt_long_rounded,size: 14.sp,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(width: 6.w,),
                            Text(
                              "Platform Fee",
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 8.h,),
                        Text(
                          '${numberFormat.format(revenue.totalRevenue - revenue.netRevenue)} ${revenue.currency}',
                          style: GoogleFonts.inter(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 4.h,),
                        Text(
                          '${((1 - revenue.revenueShare) * 100).toInt()}% of total',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        )
                      ],
                    ),
                  )
                  )
            ],
          ),
          SizedBox(height: 16.h,),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10.r)
            ),
            child: Row(
              children: [
                Icon(
                  Icons.compare_arrows_rounded,
                  size: 18.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: 10.w,),
                Expanded(
                  child: Text(
                    'Previous period: ${numberFormat.format(revenue.previousPeriodRevenue)} ${revenue.currency}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
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
