import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

class SubscriptionBreakdownCard extends StatelessWidget {
  final Map<String, int> visitsByType;
  const SubscriptionBreakdownCard({super.key, required this.visitsByType});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    if (visitsByType.isEmpty) return const SizedBox.shrink();

    final total = visitsByType.values.fold(0, (a, b) => a + b);
    final sortedEntries = visitsByType.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.pink,
    ];

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
                  color: Colors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.pie_chart_rounded,
                  color: Colors.purple,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                "Visits by Subscription ",
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "$total total",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          ...sortedEntries.asMap().entries.map((entry) {
            final index = entry.key;
            final type = entry.value.key;
            final count = entry.value.value;
            final percent = total > 0 ? (count / total) : 0.0;
            final color = colors[index % colors.length];

            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 14.w,
                        height: 14.w,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(width: 10.w,),
                      Expanded(
                        child: Text(
                          type,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),                        
                        ),
                        Text(
                          "$count Visits",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: color
                          ),
                          ),
                          SizedBox(width: 8.w,),
                          Container(
                            width: 45.w,
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${(percent * 100).toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          )
                        
                    ],
                  ),
                  SizedBox(height: 8.h,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percent,
                      minHeight: 8.h,
                      backgroundColor: colorScheme.outline.withValues(alpha: 0.15),
                      color: color,
                    ),
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
