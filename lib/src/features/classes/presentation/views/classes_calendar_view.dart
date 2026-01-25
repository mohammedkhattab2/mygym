import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/classes/domain/entities/fitness_class.dart';
import 'package:mygym/src/features/classes/presentation/cubit/classes_cubit.dart';
import 'package:table_calendar/table_calendar.dart';

class ClassesCalendarView extends StatelessWidget {
  const ClassesCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "Classes",
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.surface,
      ),
      body: BlocBuilder<ClassesCubit, ClassesState>(
        builder: (context, state) {
          if (state.isLoading && state.schedules.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }
          return Column(
            children: [
              _CalendarWidget(state: state),
              const Divider(height: 1),
              Expanded(child: _ClassesList(state: state)),
            ],
          );
        },
      ),
    );
  }
}

class _CalendarWidget extends StatelessWidget {
  final ClassesState state;

  const _CalendarWidget({required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: TableCalendar<ClassSchedule>(
        focusedDay: state.focusedDay,
        firstDay: DateTime.now().subtract(const Duration(days: 365)),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        selectedDayPredicate: (day) {
          final d = DateTime(day.year, day.month, day.day);
          final sel = DateTime(
            state.selectedDay.year,
            state.selectedDay.month,
            state.selectedDay.day,
          );
          return d == sel;
        },
        calendarFormat: CalendarFormat.twoWeeks,
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ) ?? const TextStyle(),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ) ?? const TextStyle(),
          weekendStyle: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ) ?? const TextStyle(),
        ),
        calendarStyle: CalendarStyle(
          defaultTextStyle: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ) ?? const TextStyle(),
          weekendTextStyle: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ) ?? const TextStyle(),
          todayDecoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          selectedTextStyle: textTheme.bodySmall?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ) ?? const TextStyle(),
          todayTextStyle: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ) ?? const TextStyle(),
          selectedDecoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        eventLoader: (day) {
          final d = DateTime(day.year, day.month, day.day);
          return state.schedules.where((s) {
            final sd = DateTime(
              s.startTime.year,
              s.startTime.month,
              s.startTime.day,
            );
            return sd == d;
          }).toList();
        },
        onDaySelected: (selectedDay, focusedDay) {
          context.read<ClassesCubit>().onDaySelected(selectedDay, focusedDay);
        },
      ),
    );
  }
}

class _ClassesList extends StatelessWidget {
  final ClassesState state;

  const _ClassesList({required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    final classes = state.schedulesForSelectedDay;
    if (classes.isEmpty) {
      return Center(
        child: Text(
          "No classes for this day.",
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final sched = classes[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: _ClassCard(schedule: sched),
        );
      },
    );
  }
}

class _ClassCard extends StatelessWidget {
  final ClassSchedule schedule;

  const _ClassCard({required this.schedule});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final textTheme = Theme.of(context).textTheme;
    
    final c = schedule.fitnessClass;
    final start =
        '${schedule.startTime.hour.toString().padLeft(2, '0')}:${schedule.startTime.minute.toString().padLeft(2, '0')}';
    final end =
        '${schedule.endTime.hour.toString().padLeft(2, '0')}:${schedule.endTime.minute.toString().padLeft(2, '0')}';
    
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(c.category.icon, style: TextStyle(fontSize: 20.sp)),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  c.name,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            '${c.gymName} • ${c.instructor.name}',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '$start - $end • ${c.durationMinutes} mins',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              _ClassChip(label: c.difficulty.displayName),
              SizedBox(width: 6.w),
              _ClassChip(
                label: schedule.isFull ? "Full" : '${schedule.spotsLeft} spots left',
              ),
            ],
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: !schedule.isBookable
                  ? null
                  : () {
                      context.read<ClassesCubit>().bookClass(schedule.id);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                schedule.isFull
                    ? "Join waitlist"
                    : (schedule.hasStarted ? "Started" : "Book"),
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClassChip extends StatelessWidget {
  final String label;

  const _ClassChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
