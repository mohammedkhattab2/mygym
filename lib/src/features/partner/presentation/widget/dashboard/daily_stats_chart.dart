import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/partner/domain/entities/partner_entities.dart';

class DailyStatsChart extends StatelessWidget {
  final List<DailyStats> dailyStats;
  const DailyStatsChart({super.key, required this.dailyStats});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final dateFormat = DateFormat('E');

    if (dailyStats.isEmpty) return const SizedBox.shrink();

    final maxVisits = dailyStats
        .map((s) => s.visits)
        .reduce((a, b) => a > b ? a : b);
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
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: colorScheme.primary,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                "Visits Trend",
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 140.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: dailyStats.asMap().entries.map((entry) {
                final index = entry.key;
                final stat = entry.value;
                final height = maxVisits > 0
                    ? (stat.visits / maxVisits) * 110.h
                    : 0.0;
                final isToday = index == dailyStats.length - 1;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          stat.visits.toString(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: isToday ? luxury.gold : colorScheme.onSurfaceVariant
                          ),
                        ),
                        SizedBox(height: 4.h,),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: height,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isToday
                                      ? [luxury.gold, luxury.goldLight]
                                      : [colorScheme.primary , colorScheme.secondary],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(6.r),
                                  boxShadow: isToday
                                      ? [ BoxShadow(
                                        color: luxury.gold.withValues(alpha:  0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ) ]
                                      :null
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h,),
                        Text(
                          dateFormat.format(stat.date),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                            color: isToday ? luxury.gold : colorScheme.onSurfaceVariant
                          ),
                        )
                      ],
                    ),

                    )
                  );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
