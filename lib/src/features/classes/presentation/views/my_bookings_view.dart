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

class MyBookingsView extends StatefulWidget {
  const MyBookingsView({super.key});

  @override
  State<MyBookingsView> createState() => _MyBookingsViewState();
}

class _MyBookingsViewState extends State<MyBookingsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Load bookings
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClassesCubit>().loadMyBookings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
              _buildTabBar(context),
              Expanded(
                child: BlocBuilder<ClassesCubit, ClassesState>(
                  builder: (context, state) {
                    if (state.bookingsStatus == ClassesStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.bookingsStatus == ClassesStatus.failure) {
                      return _buildErrorState(context, state.errorMessage);
                    }

                    return TabBarView(
                      controller: _tabController,
                      children: [
                        _UpcomingBookingsTab(bookings: state.upcomingBookings),
                        _PastBookingsTab(bookings: state.pastBookings),
                      ],
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
                  'MY',
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'Bookings',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(10.r),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: colorScheme.onPrimary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        labelStyle: GoogleFonts.inter(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        padding: EdgeInsets.all(4.w),
        tabs: const [
          Tab(text: 'Upcoming'),
          Tab(text: 'Past'),
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
          Text(message ?? 'Failed to load bookings'),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => context.read<ClassesCubit>().loadMyBookings(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// UPCOMING BOOKINGS TAB
// ═══════════════════════════════════════════════════════════════════════════════

class _UpcomingBookingsTab extends StatelessWidget {
  final List<ClassBooking> bookings;

  const _UpcomingBookingsTab({required this.bookings});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return _EmptyState(
        icon: Icons.event_available,
        title: 'No Upcoming Bookings',
        subtitle: 'Browse classes and book your next workout!',
        actionLabel: 'Browse Classes',
        onAction: () => context.go('/member/classes'),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<ClassesCubit>().loadMyBookings(),
      child: ListView.builder(
        padding: EdgeInsets.all(20.w),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return _BookingCard(
            booking: bookings[index],
            isUpcoming: true,
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// PAST BOOKINGS TAB
// ═══════════════════════════════════════════════════════════════════════════════

class _PastBookingsTab extends StatelessWidget {
  final List<ClassBooking> bookings;

  const _PastBookingsTab({required this.bookings});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return _EmptyState(
        icon: Icons.history,
        title: 'No Past Bookings',
        subtitle: 'Your completed classes will appear here',
        actionLabel: null,
        onAction: null,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _BookingCard(
          booking: bookings[index],
          isUpcoming: false,
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// BOOKING CARD
// ═══════════════════════════════════════════════════════════════════════════════

class _BookingCard extends StatelessWidget {
  final ClassBooking booking;
  final bool isUpcoming;

  const _BookingCard({
    required this.booking,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final schedule = booking.schedule;
    final fitnessClass = schedule.fitnessClass;
    
    final dateFormat = DateFormat('EEE, MMM d');
    final timeFormat = DateFormat('h:mm a');

    return GestureDetector(
      onTap: () {
        context.read<ClassesCubit>().selectSchedule(schedule);
        context.push('/member/classes/detail/${schedule.id}');
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: luxury.surfaceElevated,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: _getStatusColor(booking.status).withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fitnessClass.name,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        fitnessClass.gymName,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(status: booking.status),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16.sp,
                          color: luxury.gold,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          dateFormat.format(schedule.startTime),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 20.h,
                    color: colorScheme.outline.withValues(alpha: 0.3),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16.sp,
                          color: luxury.gold,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          timeFormat.format(schedule.startTime),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isUpcoming && booking.canCancel) ...[
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _cancelBooking(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text('Cancel Booking'),
                    ),
                  ),
                ],
              ),
            ],
            if (booking.isOnWaitlist) ...[
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.info_outline, size: 14.sp, color: Colors.orange),
                  SizedBox(width: 6.w),
                  Text(
                    'Waitlist position: #${booking.waitlistPosition}',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.waitlisted:
        return Colors.orange;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.completed:
        return Colors.blue;
      case BookingStatus.noShow:
        return Colors.grey;
    }
  }

  void _cancelBooking(BuildContext context) async {
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
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await context.read<ClassesCubit>().cancelBooking(booking.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Booking cancelled' : 'Failed to cancel'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STATUS BADGE
// ═══════════════════════════════════════════════════════════════════════════════

class _StatusBadge extends StatelessWidget {
  final BookingStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status) {
      case BookingStatus.confirmed:
        color = Colors.green;
        text = 'Confirmed';
        break;
      case BookingStatus.waitlisted:
        color = Colors.orange;
        text = 'Waitlist';
        break;
      case BookingStatus.cancelled:
        color = Colors.red;
        text = 'Cancelled';
        break;
      case BookingStatus.completed:
        color = Colors.blue;
        text = 'Completed';
        break;
      case BookingStatus.noShow:
        color = Colors.grey;
        text = 'No Show';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// EMPTY STATE
// ═══════════════════════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64.sp,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 14.sp,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 24.h),
              FilledButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}