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

class ClassDetailView extends StatelessWidget {
  final String scheduleId;
  const ClassDetailView({super.key, required this.scheduleId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassesCubit, ClassesState>(
      builder: (context, state) {
        final schedule = state.selectedSchedule;

        if (schedule == null) {
          return Scaffold(
            appBar: AppBar(title: const Text("Class Detail")),
            body: const Center(child: Text("Class not found ")),
          );
        }
        final fitnessClass = schedule.fitnessClass;
        final isBooked = state.isScheduleBooked(schedule.id);
        final booking = state.getBookingForSchedule(schedule.id);

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, fitnessClass),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ClassHeader(schedule: schedule),
                      SizedBox(height: 24.h),
                      _ScheduleInfo(schedule: schedule),
                      SizedBox(height: 24.h),
                      _InstructorCard(instructor: fitnessClass.instructor),
                      SizedBox(height: 24.h),
                      _AboutSection(fitnessClass: fitnessClass),
                      if (fitnessClass.equipment.isNotEmpty) ...[
                        SizedBox(height: 24.h),
                        _EquipmentSection(equipment: fitnessClass.equipment),
                      ],
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _BookingButton(
            schedule: schedule,
            isBooked: isBooked,
            booking: booking,
            isLoading: state.bookingActionStatus == ClassesStatus.loading,
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context, FitnessClass fitnessClass) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    return SliverAppBar(
      expandedHeight: 200.h,
      pinned: true,
      backgroundColor: colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withValues(alpha: 0.3),
                colorScheme.secondary.withValues(alpha: 0.2),
                luxury.gold.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                Text(
                  fitnessClass.category.icon,
                  style: TextStyle(fontSize: 60.sp),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getDiffultyColor(
                      fitnessClass.difficulty,
                    ).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    fitnessClass.difficulty.displayName,
                    style: TextStyle(
                      color: _getDiffultyColor(fitnessClass.difficulty),
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.8),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_back_ios_new, size: 18.sp),
        ),
      ),
    );
  }

  Color _getDiffultyColor(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.beginner:
        return Colors.green;
      case DifficultyLevel.intermediate:
        return Colors.orange;
      case DifficultyLevel.advanced:
        return Colors.red;
      case DifficultyLevel.allLevels:
        return Colors.blue;
    }
  }
}

class _BookingButton extends StatelessWidget {
  final ClassSchedule schedule;
  final bool isBooked;
  final ClassBooking? booking;
  final bool isLoading;

  const _BookingButton({
    required this.schedule,
    required this.isBooked,
    this.booking,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(child: _buildButton(context)),
    );
  }

  Widget _buildButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (schedule.isCancelled) {
      return FilledButton(
        onPressed: null,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          backgroundColor: Colors.grey,
        ),
        child: const Text("Class Cancelled"),
      );
    }
    if (schedule.hasStarted) {
      return FilledButton(
        onPressed: null,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.h),
        ),
        child: const Text("Class Started"),
      );
    }
    if (isBooked && booking != null) {
      return Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: booking!.isOnWaitlist
                    ? Colors.orange.withValues(alpha: 0.1)
                    : Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    booking!.isOnWaitlist
                        ? Icons.hourglass_top
                        : Icons.check_circle,
                    color: booking!.isOnWaitlist ? Colors.orange : Colors.green,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    booking!.isOnWaitlist
                        ? 'Waitlist #${booking!.waitlistPosition}'
                        : 'Booked',
                    style: TextStyle(
                      color: booking!.isOnWaitlist
                          ? Colors.orange
                          : Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          OutlinedButton(
            onPressed: isLoading ? null : () => _cancelBooking(context),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
            child: isLoading
                ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Cancel'),
          ),
        ],
      );
    }
    // Not booked - show book button
    return FilledButton.icon(
      onPressed: isLoading ? null : () => _bookClass(context),
      icon: isLoading
          ? SizedBox(
              width: 20.w,
              height: 20.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(schedule.isFull ? Icons.playlist_add : Icons.event_available),
      label: Text(schedule.isFull ? 'Join Waitlist' : 'Book Class'),
      style: FilledButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        backgroundColor: schedule.isFull ? Colors.orange : colorScheme.primary,
      ),
    );
  }
  void _bookClass(BuildContext context) async {
    final cubit = context.read<ClassesCubit>();
    final success = await cubit.bookClass(schedule.id);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? (schedule.isFull ? 'Added to waitlist!' : 'Class booked successfully!')
                : 'Failed to book class',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  void _cancelBooking(BuildContext context) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Booking?'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No, Keep It'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final cubit = context.read<ClassesCubit>();
      final success = await cubit.cancelBooking(booking!.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Booking cancelled' : 'Failed to cancel booking',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
}

class _EquipmentSection extends StatelessWidget {
  final List<String> equipment;
  const _EquipmentSection({required this.equipment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What to Bring",
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 12.h),
        ...equipment.map((item) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20.sp),
                SizedBox(width: 12.w),
                Text(item, style: TextStyle(fontSize: 14.sp)),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  final FitnessClass fitnessClass;
  const _AboutSection({required this.fitnessClass});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About this class",
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          fitnessClass.description,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 14.sp,
            height: 1.6,
          ),
        ),
        if (fitnessClass.tags.isNotEmpty) ...[
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: fitnessClass.tags.map((tag) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '#$tag',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class _InstructorCard extends StatelessWidget {
  final Instructor instructor;
  const _InstructorCard({required this.instructor});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Instructor",
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: luxury.surfaceElevated,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: luxury.gold.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundColor: colorScheme.primaryContainer,
                backgroundImage: instructor.photoUrl != null
                    ? NetworkImage(instructor.photoUrl!)
                    : null,
                child: instructor.photoUrl == null
                    ? Text(
                        instructor.name[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      instructor.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16.sp),
                        SizedBox(width: 4.w),
                        Text(
                          instructor.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '(${instructor.totalReviews} reviews)',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${instructor.totalClasses} classes taught',
                      style: TextStyle(
                        color: luxury.textTertiary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScheduleInfo extends StatelessWidget {
  final ClassSchedule schedule;
  const _ScheduleInfo({required this.schedule});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final dateFormat = DateFormat('EEEE, MMMM d');
    final timeFormat = DateFormat('h:mm a');

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: luxury.gold.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.calendar_today,
            label: "Date",
            value: dateFormat.format(schedule.startTime),
          ),
          Divider(
            height: 24.h,
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
          _InfoRow(
            icon: Icons.access_time,
            label: "Time",
            value:
                '${timeFormat.format(schedule.startTime)} - ${timeFormat.format(schedule.endTime)}',
          ),
          Divider(
            height: 24.h,
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
          _InfoRow(
            label: "Duration",
            value: '${schedule.fitnessClass.durationMinutes} minutes',
            icon: Icons.timer,
          ),
          Divider(
            height: 24.h,
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
          _InfoRow(
            label: "Spots",
            icon: Icons.people,
            value: schedule.isFull
                ? 'Full (${schedule.waitlistCount} on waitlist)'
                : '${schedule.spotsLeft} spots left',
            valueColor: schedule.isFull ? Colors.orange : Colors.green,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18.sp, color: colorScheme.primary),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: luxury.textTertiary, fontSize: 12.sp),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? colorScheme.onSurface,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ClassHeader extends StatelessWidget {
  final ClassSchedule schedule;
  const _ClassHeader({required this.schedule});

  @override
  Widget build(BuildContext context) {
    final fitnessClass = schedule.fitnessClass;
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                fitnessClass.name,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (schedule.isCancelled)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "CANCELLED",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Icon(Icons.location_on, size: 16.sp, color: luxury.gold),
            SizedBox(width: 4.w),
            Text(
              fitnessClass.gymName,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 14.sp,
              ),
            ),
            if (schedule.room != null) ...[
              Text(
                ' • ',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              Text(
                schedule.room!,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 8.h),
        _buildCategoryChip(fitnessClass.category, colorScheme),
      ],
    );
  }

  Widget _buildCategoryChip(ClassCategory category, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(category.icon),
          SizedBox(width: 6.w),
          Text(
            category.displayName,
            style: TextStyle(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
