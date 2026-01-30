import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/luxury_theme_extension.dart';
import '../../domain/entities/fitness_class.dart';
import '../cubit/classes_cubit.dart';
import '../cubit/classes_state.dart';

/// Premium Class Schedule View
/// 
/// Shows this week's classes in a horizontal day selector
/// with vertical list of classes for the selected day.
class ClassScheduleView extends StatefulWidget {
  const ClassScheduleView({super.key});

  @override
  State<ClassScheduleView> createState() => _ClassScheduleViewState();
}

class _ClassScheduleViewState extends State<ClassScheduleView> {
  int _selectedDayIndex = 0;

  @override
  void initState() {
    super.initState();
    // Find today's index
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    _selectedDayIndex = now.difference(startOfWeek).inDays.clamp(0, 6);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: luxury.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              SizedBox(height: 16.h),
              _buildDaySelector(context),
              SizedBox(height: 16.h),
              Expanded(
                child: BlocBuilder<ClassesCubit, ClassesState>(
                  builder: (context, state) {
                    if (state.scheduleStatus == ClassesStatus.loading) {
                      return _buildLoadingState(luxury);
                    }

                    if (state.scheduleStatus == ClassesStatus.failure) {
                      return _buildErrorState(context, state.errorMessage);
                    }

                    if (state.weekSchedule.isEmpty) {
                      return _buildEmptyState(context);
                    }

                    final daySchedule = _selectedDayIndex < state.weekSchedule.length
                        ? state.weekSchedule[_selectedDayIndex]
                        : null;

                    if (daySchedule == null || daySchedule.isEmpty) {
                      return _buildNoDayClasses(context);
                    }

                    return _buildClassesList(context, state, daySchedule);
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
    final colorScheme = Theme.of(context).colorScheme;
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
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FITNESS',
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'Classes',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          // Calendar button
          GestureDetector(
            onTap: () => context.push('/member/classes/calendar'),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: luxury.surfaceElevated,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: luxury.gold.withValues(alpha: 0.15)),
              ),
              child: Icon(
                Icons.calendar_month,
                size: 20.sp,
                color: luxury.gold,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          // My Bookings button
          GestureDetector(
            onTap: () => context.push('/member/classes/bookings'),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.event_available,
                size: 20.sp,
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    
    return Container(
      height: 80.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final day = startOfWeek.add(Duration(days: index));
          final isSelected = index == _selectedDayIndex;
          final isToday = day.day == now.day && 
                          day.month == now.month && 
                          day.year == now.year;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDayIndex = index;
              });
            },
            child: Container(
              width: 55.w,
              margin: EdgeInsets.only(right: 8.w),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [colorScheme.primary, colorScheme.secondary],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    : null,
                color: isSelected ? null : luxury.surfaceElevated,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isToday && !isSelected
                      ? luxury.gold
                      : luxury.gold.withValues(alpha: 0.1),
                  width: isToday && !isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(day).toUpperCase(),
                    style: GoogleFonts.montserrat(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    day.day.toString(),
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                    ),
                  ),
                  if (isToday)
                    Container(
                      margin: EdgeInsets.only(top: 4.h),
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: isSelected ? colorScheme.onPrimary : luxury.gold,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(LuxuryThemeExtension luxury) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: luxury.gold),
          SizedBox(height: 16.h),
          Text(
            'Loading classes...',
            style: TextStyle(color: luxury.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
          SizedBox(height: 16.h),
          Text(message ?? 'Failed to load classes'),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => context.read<ClassesCubit>().loadThisWeekSchedule(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fitness_center, size: 64.sp, color: Colors.grey[400]),
          SizedBox(height: 16.h),
          Text(
            'No Classes Available',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Check back later for new classes',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDayClasses(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64.sp,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            'No Classes Today',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try selecting another day',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildClassesList(
    BuildContext context,
    ClassesState state,
    DaySchedule daySchedule,
  ) {
    return RefreshIndicator(
      onRefresh: () => context.read<ClassesCubit>().loadThisWeekSchedule(),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: daySchedule.classes.length,
        itemBuilder: (context, index) {
          final schedule = daySchedule.classes[index];
          final isBooked = state.isScheduleBooked(schedule.id);
          
          return _ClassCard(
            schedule: schedule,
            isBooked: isBooked,
            onTap: () {
              context.read<ClassesCubit>().selectSchedule(schedule);
              context.push('/member/classes/detail/${schedule.id}');
            },
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// CLASS CARD
// ═══════════════════════════════════════════════════════════════════════════════

class _ClassCard extends StatelessWidget {
  final ClassSchedule schedule;
  final bool isBooked;
  final VoidCallback onTap;

  const _ClassCard({
    required this.schedule,
    required this.isBooked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final fitnessClass = schedule.fitnessClass;
    final timeFormat = DateFormat('h:mm a');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: luxury.surfaceElevated,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isBooked
                ? Colors.green.withValues(alpha: 0.3)
                : schedule.isCancelled
                    ? Colors.red.withValues(alpha: 0.3)
                    : luxury.gold.withValues(alpha: 0.1),
            width: isBooked || schedule.isCancelled ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Time column
            SizedBox(
              width: 60.w,
              child: Column(
                children: [
                  Text(
                    timeFormat.format(schedule.startTime),
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    width: 1,
                    height: 20.h,
                    color: colorScheme.outline.withValues(alpha: 0.3),
                  ),
                  Text(
                    timeFormat.format(schedule.endTime),
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            
            // Divider
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12.w),
              width: 1,
              height: 60.h,
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
            
            // Class info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        fitnessClass.category.icon,
                        style: TextStyle(fontSize: 18.sp),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          fitnessClass.name,
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            decoration: schedule.isCancelled
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 14.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        fitnessClass.instructor.name,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Icon(
                        Icons.location_on,
                        size: 14.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        schedule.room ?? fitnessClass.gymName,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      _buildDifficultyChip(fitnessClass.difficulty),
                      SizedBox(width: 8.w),
                      _buildSpotsChip(schedule),
                      const Spacer(),
                      if (isBooked)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 12.sp,
                                color: Colors.green,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Booked',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (schedule.isCancelled)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Cancelled',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Arrow
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(DifficultyLevel level) {
    Color color;
    switch (level) {
      case DifficultyLevel.beginner:
        color = Colors.green;
        break;
      case DifficultyLevel.intermediate:
        color = Colors.orange;
        break;
      case DifficultyLevel.advanced:
        color = Colors.red;
        break;
      case DifficultyLevel.allLevels:
        color = Colors.blue;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        level.displayName,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSpotsChip(ClassSchedule schedule) {
    final isFull = schedule.isFull;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isFull
            ? Colors.orange.withValues(alpha: 0.1)
            : Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isFull ? 'Full' : '${schedule.spotsLeft} spots',
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          color: isFull ? Colors.orange : Colors.green,
        ),
      ),
    );
  }
}