import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

class TimePickerSection extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final int hour;
  final int minute;
  final Function(int) onHourChanged;
  final Function(int) onMinuteChanged;
  const TimePickerSection({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.hour,
    required this.minute,
    required this.onHourChanged,
    required this.onMinuteChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 16.sp),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: iconColor.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: hour,
                      isExpanded: true,
                      icon: Icon(Icons.keyboard_arrow_down, color: iconColor),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      items: List.generate(24, (i) {
                        final period = i >= 12 ? "PM" : "AM";
                        final displayHour = i == 0 ? 12 : (i > 12 ? i - 12 : i);
                        return DropdownMenuItem(
                          value: i,
                          child: Text("$displayHour $period"),
                        );
                      }),
                      onChanged: (value) {
                        if (value != null) onHourChanged(value);
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  ":",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: iconColor,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: minute,
                      isExpanded: true,
                      icon: Icon(Icons.keyboard_arrow_down, color: iconColor),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      items: [0, 15, 30, 45].map((m) {
                        return DropdownMenuItem(
                          value: m, 
                          child: Text(m.toString().padLeft(2,"0")),
                          );
                      }).toList(),
                      onChanged: (value){
                        if (value != null) onMinuteChanged(value);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
