import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

class RevenueBundleCard extends StatelessWidget {
  final Map<String, double> revenueByBundle;
  final String currency;
  const RevenueBundleCard({
    super.key,
    required this.revenueByBundle,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final numberFormat = NumberFormat('#,###');

    if (revenueByBundle.isEmpty) return const SizedBox.shrink();

    final total = revenueByBundle.values.fold(0.0, (a, b) => a + b);
    final sortedEntries = revenueByBundle.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final colors = [
      luxury.gold,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.orange,
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
                  color: luxury.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.monetization_on_rounded,
                  color: luxury.gold,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                "Revenue by bundle",
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ...sortedEntries.asMap().entries.map((entry) {
            final index = entry.key;
            final bundel = entry.value.key;
            final amount = entry.value.value;
            final percent = total > 0 ? (amount / total) : 0.0;
            final color = colors[index % colors.length];

            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: color.withValues(alpha: 0.2))
              ),
              child: Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2)
                    ),
                  ),
                  SizedBox(width: 14.w,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bundel,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h,),
                        Text(
                          '${(percent * 100).toStringAsFixed(1)}% of total',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        )
                      ],
                    )
                    ),
                    Text(
                      '${numberFormat.format(amount)} $currency',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: color
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
