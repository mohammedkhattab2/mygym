import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/partner/domain/entities/partner_entities.dart';

class PeriodSelector extends StatelessWidget {
  final ReportPeriod selectedPeriod;
  final ValueChanged<ReportPeriod> onPeriodChanged;
  const PeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    final periods = [
      (ReportPeriod.daily, 'Today', Icons.today_rounded),
      (ReportPeriod.weekly, 'Week', Icons.date_range_rounded),
    ];
    return Container(
      height: 48.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: luxury.gold.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: periods.map((p) {
          final isSelected = p.$1 == selectedPeriod;
          return Expanded(
            child: GestureDetector(
              onTap: () => onPeriodChanged(p.$1),
              child: Container(
                margin: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                        colors: [colorScheme.primary, colorScheme.secondary],
                        )
                        : null,
                        borderRadius: BorderRadius.circular(10.r)
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        p.$3, 
                        size: 16.sp,
                        color: isSelected
                            ? colorScheme.onPrimary
                            :colorScheme.onSurfaceVariant ,
                      ),
                      SizedBox(width: 6.w,),
                      Text(
                        p.$2,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurfaceVariant
                        ),
                      )
                    ],
                  ),
                ),
              ) ,
            )
            );
        }).toList(),
      ),
    );
  }
}
