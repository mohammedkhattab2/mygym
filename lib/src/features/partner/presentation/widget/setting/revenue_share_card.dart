import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

class RevenueShareCard extends StatelessWidget {
  final double percentage;
  const RevenueShareCard({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            luxury.gold.withValues(alpha: 0.2),
            luxury.gold.withValues(alpha: 0.08)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: luxury.gold.withValues(alpha: 0.3,), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: luxury.gold.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ]
      ),
      child: Row(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [luxury.gold,luxury.goldLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: [
                  BoxShadow(
                    color: luxury.gold.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
            ),
            child: Center(
              child: Icon(
                Icons.pie_chart_rounded,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(width: 16.w,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Revenue Share",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 4.h,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${percentage.toInt()}',
                      style:GoogleFonts.playfairDisplay(
                        fontSize: 42.sp,
                        fontWeight: FontWeight.w700,
                        color: luxury.gold,
                        height: 1,
                      ) ,
                    ),
                    Padding(
                  padding: EdgeInsets.only(bottom: 6.h, left: 2.w),
                  child: Text(
                    "%",
                    style: GoogleFonts.inter(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: luxury.gold,
                    ),
                  ),
                  )
                  ],
                ),
                SizedBox(height: 4.h,),
                Text(
                  'Your earnings from each visit',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: colorScheme.onSurfaceVariant,
                  ) ,
                )
              ],
            ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Icon(Icons.verified_rounded, color: Colors.green,size: 18.sp,),
                  SizedBox(height: 2.h,),
                  Text(
                    "Active",
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.green,
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
