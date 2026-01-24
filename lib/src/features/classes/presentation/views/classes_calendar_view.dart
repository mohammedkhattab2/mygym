import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/features/classes/domain/entities/fitness_class.dart';
import 'package:mygym/src/features/classes/presentation/cubit/classes_cubit.dart';
import 'package:table_calendar/table_calendar.dart';

class ClassesCalendarView extends StatelessWidget {
  const ClassesCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text(
          "Classes",
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.surfaceDark,
      ),
      body: BlocBuilder<ClassesCubit, ClassesState>(
        builder: (context, state) {
          if (state.isLoading && state.schedules.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              _buildCalender(context, state),
              const Divider(height: 1),
              Expanded(child: _buildClassesList(context, state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCalender(BuildContext context, ClassesState state) {
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
          titleTextStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondaryDark,
            fontWeight: FontWeight.bold,
          ),
          weekendStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        calendarStyle: CalendarStyle(
          defaultTextStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
          weekendTextStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.bold,
          ),
          todayDecoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          selectedTextStyle: AppTextStyles.bodySmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          todayTextStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.bold,
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

  Widget _buildClassesList(BuildContext context, ClassesState state) {
    final classes = state.schedulesForSelectedDay;
    if (classes.isEmpty) {
      return Center(
        child: Text(
          "No classes for this day.",
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondaryDark,
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
          child: _buildClassCard(context, sched),
        );
      },
    );
  }

  Widget _buildClassCard(BuildContext context, ClassSchedule sched) {
    final c = sched.fitnessClass;
    final start =
        '${sched.startTime.hour.toString().padLeft(2, '0')}:${sched.startTime.minute.toString().padLeft(2, '0')}';
    final end =
        '${sched.endTime.hour.toString().padLeft(2, '0')}:${sched.endTime.minute.toString().padLeft(2, '0')}';
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(c.category.icon, style: AppTextStyles.badgeLarge),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  c.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            '${c.gymName} • ${c.instructor.name}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondaryDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '$start - $end • ${c.durationMinutes} mins',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondaryDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              _buildChip(c.difficulty.displayName),
              SizedBox(width: 6.w),
              _buildChip(
                sched.isFull ? "full" : '${sched.spotsLeft} spots left',
              ),
            ],
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: !sched.isBookable
                  ? null
                  : () {
                      context.read<ClassesCubit>().bookClass(sched.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                      ),shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)
                      )
                    ),
              child: Text(
                sched.isFull
                   ? " Join waitlist"
                   : (sched.hasStarted ? "Started" : "Book"),
                   style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                   ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String lable) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Text(
        lable,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondaryDark,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
