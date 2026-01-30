import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/classes/domain/entities/fitness_class.dart';
import 'package:mygym/src/features/classes/presentation/cubit/classes_cubit.dart';
import 'package:mygym/src/features/classes/presentation/cubit/classes_state.dart';
import 'package:table_calendar/table_calendar.dart';

class ClassesCalendarView extends StatefulWidget {
  const ClassesCalendarView({super.key});

  @override
  State<ClassesCalendarView> createState() => _ClassesCalendarViewState();
}

class _ClassesCalendarViewState extends State<ClassesCalendarView> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(gradient: luxury.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: BlocBuilder<ClassesCubit, ClassesState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildCalendar(context, state),
                          SizedBox(height: 16.h),
                          _buildSelectedDate(context, state),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final colorscheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: luxury.surfaceElevated,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: luxury.gold.withValues(alpha: 0.15)),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 18.sp,
                color: colorscheme.onSurface,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "CLASS",
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  "CALENDAR",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: colorscheme.surface,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/member/classes/bookings'),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: colorscheme.primaryContainer,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.event_available,
                size: 20.sp,
                color: colorscheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(BuildContext context, ClassesState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final daysWithClasses = <DateTime>{};
    for (final schedul in state.schedules) {
      daysWithClasses.add(
        DateTime(
          schedul.startTime.year,
          schedul.startTime.month,
          schedul.startTime.day,
        ),
      );
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: luxury.gold.withValues(alpha: 0.1)),
      ),
      child: TableCalendar(
        focusedDay: _focusedDay,
        firstDay: DateTime.now().subtract(const Duration(days: 30)),
        lastDay: DateTime.now().add(const Duration(days: 90)),
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          _loadSchedulesForMonth(selectedDay);
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
          _loadSchedulesForMonth(focusedDay);
        },
        eventLoader: (day) {
          final dayOnly = DateTime(day.year, day.month, day.day);
          if (daysWithClasses.contains(dayOnly)) {
            return ["class"];
          }
          return [];
        },
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          selectedDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.secondary],
            ),
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
          weekendTextStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          markerDecoration: BoxDecoration(
            color: luxury.gold,
            shape: BoxShape.circle,
          ),
          markersMaxCount: 1,
          markerSize: 6,
          markerMargin: const EdgeInsets.only(top: 6),
          outsideDaysVisible: false,
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: true,
          formatButtonDecoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          formatButtonTextStyle: TextStyle(
            color: colorScheme.onPrimaryContainer,
            fontSize: 12.sp,
          ),
          titleCentered: true,
          titleTextStyle: GoogleFonts.playfairDisplay(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: colorScheme.onSurface,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: colorScheme.onSurface,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
          weekendStyle: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedDate(BuildContext context, ClassesState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final dateFormat = DateFormat('EEEE, MMMM d');
    final timeFormat = DateFormat('h:mm a');

    final selectedDayClasses = state.schedules.where((s) {
      return s.startTime.year == _selectedDay.year &&
          s.startTime.month == _selectedDay.month &&
          s.startTime.day == _selectedDay.day;
    }).toList();

    selectedDayClasses.sort((a, b) => a.startTime.compareTo(b.startTime));
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Icon(Icons.event, size: 18.sp, color: luxury.gold),
                SizedBox(width: 8.w),
                Text(
                  dateFormat.format(_selectedDay),
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  '${selectedDayClasses.length} classes',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          if (selectedDayClasses.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                color: luxury.surfaceElevated,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 48.sp,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "No classes on this day",
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            )
          else
            ...selectedDayClasses.map((schedual) {
              final fitnessClass = schedual.fitnessClass;
              final isBooked = state.isScheduleBooked(schedual.id);
              return GestureDetector(
                onTap: (){
                  context.read<ClassesCubit>().selectSchedule(schedual);
                  context.push('/member/classes/detail/${schedual.id}');
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: luxury.surfaceElevated,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: isBooked
                      ? Colors.green.withValues(alpha: 0.3)
                      :luxury.gold.withValues(alpha: 0.1)
                    )
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Text(
                            fitnessClass.category.icon,
                            style: TextStyle(fontSize: 24.sp),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fitnessClass.name,
                              style: GoogleFonts.inter(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4.h,),
                            Text(
                              '${timeFormat.format(schedual.startTime)} • ${fitnessClass.instructor.name}',
                               style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 12.sp
                               ),
                            )
                          ],
                        )
                        ),
                        if (isBooked)
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w,),
                        Icon(
                          Icons.chevron_right,
                          color: colorScheme.onSurfaceVariant,
                        )
                    ],
                  ),
                ) ,
              );
            }),
            SizedBox(height: 24.h,),
            
        ],
      ),
    );
  }

  void _loadSchedulesForMonth(DateTime day) {
    final startOfMonth = DateTime(day.year, day.month, 1);
    final endOfMonth = DateTime(day.year, day.month + 1, 0);
    context.read<ClassesCubit>().loadSchedule(
      startDate: startOfMonth,
      endDate: endOfMonth,
    );
  }
}
