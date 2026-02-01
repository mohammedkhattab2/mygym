import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/partner/domain/entities/partner_entities.dart';
import 'package:mygym/src/features/partner/presentation/widget/setting/time_picker_section.dart';

class EditHoursBottomSheet extends StatefulWidget {
  final String dayName;
  final int dayOfWeek;
  final DaySchedule? currentSchedule;
  final Function(DaySchedule schedule) onSave;
  const EditHoursBottomSheet({
    super.key,
    required this.dayName,
    required this.dayOfWeek,
    required this.currentSchedule,
    required this.onSave,
  });

  @override
  State<EditHoursBottomSheet> createState() => _EditHoursBottomSheetState();
}

class _EditHoursBottomSheetState extends State<EditHoursBottomSheet> {
  late bool _isClosed;
  late int _openHour;
  late int _openMinute;
  late int _closeHour;
  late int _closeMinute;

  @override
  void initState() {
    super.initState();
    _isClosed = widget.currentSchedule?.isClosed ?? false;
    _openHour = widget.currentSchedule?.openHour ?? 6;
    _openMinute = widget.currentSchedule?.openMinute ?? 0;
    _closeHour = widget.currentSchedule?.closeHour ?? 22;
    _closeMinute = widget.currentSchedule?.closeMinute ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    return Container(
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20.w,
          20.h,
          20.w,
          MediaQuery.of(context).viewInsets.bottom + 20.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.schedule_rounded,
                    color: Colors.purple,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Edit Hours",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      widget.dayName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: _isClosed
                    ? Colors.red.withValues(alpha: 0.1)
                    : colorScheme.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: _isClosed
                      ? Colors.red.withValues(alpha: 0.3)
                      : colorScheme.outline.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: _isClosed
                          ? Colors.red.withValues(alpha: 0.15)
                          : Colors.green.withValues(alpha: 0.15),
                    ),
                    child: Icon(
                      _isClosed ? Icons.lock_rounded : Icons.lock_open_rounded,
                      color: _isClosed ? Colors.red : Colors.green,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Closed for the day",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _isClosed
                              ? " Gym will be closed for this day"
                              : " Gym is open for this day",
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isClosed,
                    onChanged: (value) => setState(() => _isClosed = value),
                    activeThumbColor: Colors.red,
                    activeTrackColor: Colors.red.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
            if (!_isClosed) ...[
              SizedBox(height: 20.h),
              TimePickerSection(
                label: "Opening Time",
                icon: Icons.login_rounded,
                iconColor: Colors.green,
                hour: _openHour,
                minute: _openMinute,
                onHourChanged: (h) => setState(() => _openHour = h),
                onMinuteChanged: (m) => setState(() => _openMinute = m),
              ),
              SizedBox(height: 16.h),
              TimePickerSection(
                label: 'Closing Time',
                icon: Icons.logout_rounded,
                iconColor: Colors.red,
                hour: _closeHour,
                minute: _closeMinute,
                onHourChanged: (h) => setState(() => _closeHour = h),
                onMinuteChanged: (m) => setState(() => _closeMinute = m),
              ),
              SizedBox(height: 16.h),
              _buildDurationInfo(),
            ],
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      side: BorderSide(
                        color: colorScheme.outline.withValues(alpha: 0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: _saveSchedule,
                    icon: const Icon(Icons.save_rounded),
                    label: const Text("Save Changes"),
                    style: FilledButton.styleFrom(
                      backgroundColor: luxury.gold,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationInfo() {
    final colorScheme = Theme.of(context).colorScheme;

    final openMinutes = _openHour * 60 + _openMinute;
    final closeMinutes = _closeHour * 60 + _closeMinute;
    final durationMinutes = closeMinutes - openMinutes;

    final isValid = durationMinutes > 0;
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isValid
            ? Colors.blue.withValues(alpha: 0.08)
            : Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isValid
              ? Colors.blue.withValues(alpha: 0.2)
              : Colors.red.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.timer_rounded : Icons.error_outline_rounded,
            color: isValid ? Colors.blue : Colors.red,
            size: 18.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              isValid
                  ? 'Total hours: ${hours}h ${minutes > 0 ? '${minutes}m' : ''}'
                  : "Closing time must be after opening time",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: isValid ? Colors.blue : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveSchedule() {
    if (!_isClosed) {
      final openMinutes = _openHour * 60 + _openMinute;
      final closeMinutes = _closeHour * 60 + _closeMinute;

      if (closeMinutes <= openMinutes) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                SizedBox(width: 12.w),
                const Text("Closing time must be after opening time"),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    }
    final schedule = _isClosed
        ? DaySchedule.closed()
        : DaySchedule(
            openHour: _openHour,
            openMinute: _openMinute,
            closeHour: _closeHour,
            closeMinute: _closeMinute,
          );
    widget.onSave(schedule);
  }
}
