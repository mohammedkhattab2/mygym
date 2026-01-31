import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/partner/domain/entities/partner_entities.dart';

class DailyBreakdownCard extends StatelessWidget {
  final List<DailyStats> dailystats;
  const DailyBreakdownCard({super.key, required this.dailystats});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final dateFormat = DateFormat('EEE, MMM d');
    final numberFormat = NumberFormat('#,###');

    if (dailystats.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: luxury.gold.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.calendar_view_day_rounded,
                  color: Colors.orange,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                "Daily Breakdown",
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Text(
                '${dailystats.length} days',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    "Date",
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Visit",
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "New",
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "Revenue",
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          ...dailystats.asMap().entries.map((entry) {
            final index = entry.key;
            final stat = entry.value;
            final isLast = index == dailystats.length - 1;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: isLast? luxury.gold.withValues(alpha: 0.05) : null,
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.1) ,
                    width: isLast ? 0:1 ,
                  )
                ),
                borderRadius: isLast ? BorderRadius.circular(8.r) : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        if(isLast)
                        Container(
                          width: 6.w,
                          height: 6.w,
                          margin: EdgeInsets.only(right: 6.w),
                          decoration: BoxDecoration(
                            color: luxury.gold,
                            shape: BoxShape.circle
                          ),
                        ),
                        Text(
                          dateFormat.format(stat.date),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: isLast? FontWeight.w700 : FontWeight.w500,
                            color: isLast ? luxury.gold : null
                          ),
                        )
                      ],
                    )
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Icon(Icons.people, size: 12.sp,color: Colors.blue.withValues(alpha: 0.7), ),
                         SizedBox(width: 4.w,),
                         Text(
                          stat.visits.toString(),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                         )
                      ],
                    )
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_add, size: 12.sp, color: Colors.green.withValues(alpha: 0.7), ),
                          SizedBox(width: 4.w,),
                          Text(
                            '+${stat.newUsers}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.green
                            ),
                          )
                        ],
                      )
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          '${numberFormat.format(stat.revenue)} EGP',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: luxury.gold
                          ),
                          textAlign: TextAlign.end,
                        )
                        )
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
