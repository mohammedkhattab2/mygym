import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/partner/domain/entities/partner_entities.dart';
import 'package:mygym/src/features/partner/presentation/widget/setting/settings_card.dart';

class WorkingHoursSection extends StatelessWidget {
  final GymWorkingHours workingHours;
  final Function(int dayOfWeek) onDayTap;
  const WorkingHoursSection({
    super.key,
    required this.workingHours,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final fullDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return SettingsCard(
      title: "Working Hours",
      icon: Icons.schedule_rounded,
      iconColor: Colors.indigo,
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: workingHours.isOpenNow()
              ? Colors.green.withValues(alpha: 0.1)
              : Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: workingHours.isOpenNow() ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              workingHours.isOpenNow() ? "Open Now" : "Closed ",
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: workingHours.isOpenNow() ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
      children: [
        ...List.generate(7, (index) {
          final dayNum = index + 1;
          final schedule = workingHours.schedule[dayNum];
          final isToday = DateTime.now().weekday == dayNum;

          return GestureDetector(
            onTap: () => onDayTap(dayNum),
            child: Container(
              margin: EdgeInsets.only(bottom: index<6 ? 10.h : 0),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color:  isToday
                     ? luxury.gold.withValues(alpha: 0.08)
                     : colorScheme.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isToday
                       ? luxury.gold.withValues(alpha: 0.3)
                       : colorScheme.outline.withValues(alpha: 0.1),
                  width: isToday ? 1.5 : 1 
                )
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 45.w,
                    child: Text(
                      days[index],
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: isToday ? FontWeight.w700 : FontWeight.w600,
                        color: isToday ? luxury.gold : null
                      ),
                    ),
                  ),
                  if (isToday)...[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: luxury.gold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4)
                      ),
                      child: Text(
                        "TODAY",
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w700,
                          color: luxury.gold,
                          letterSpacing: 0.5
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w,),
                  ],
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: schedule?.isClosed == true 
                           ? Colors.red.withValues(alpha: 0.1)
                           : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8.r)
                    ),
                    child: Text(
                      schedule?.isClosed == true
                          ? "Closed"
                          : '${schedule?.formattedOpenTime ?? '--'} - ${schedule?.formattedCloseTime ?? '--'}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: schedule?.isClosed == true 
                               ? Colors.red
                               :colorScheme.onSurface
                        ),
                    ),
                  ),
                  SizedBox(width: 8.w,),
                  Icon(
                    Icons.edit_rounded,
                    size: 16.sp,
                    color: colorScheme.onSurfaceVariant,
                  )
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
