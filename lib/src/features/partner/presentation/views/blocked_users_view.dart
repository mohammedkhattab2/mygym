// lib/src/features/partner/presentation/views/blocked_users_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/partner/domain/entities/partner_entities.dart';
import 'package:mygym/src/features/partner/presentation/cubit/blocked_users_cubit.dart';
import 'package:mygym/src/features/partner/presentation/cubit/blocked_users_state.dart';
import 'package:intl/intl.dart';

class BlockedUsersView extends StatelessWidget {
  const BlockedUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(gradient: luxury.backgroundGradient),
        child: SafeArea(
          child: BlocConsumer<BlockedUsersCubit, BlockedUsersState>(
            listener: (context, state) {
              if (state.successMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12.w),
                        Text(state.successMessage!),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
                context.read<BlockedUsersCubit>().clearMessages();
              }
              if (state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.white),
                        SizedBox(width: 12.w),
                        Expanded(child: Text(state.errorMessage!)),
                      ],
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
                context.read<BlockedUsersCubit>().clearMessages();
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  _buildAppBar(context, state),
                  _buildSearchBar(context, state),
                  Expanded(child: _buildContent(context, state)),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: _buildAddButton(context),
    );
  }

  Widget _buildAppBar(BuildContext context, BlockedUsersState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.go(RoutePaths.partnerSettings),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: luxury.surfaceElevated,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: luxury.gold.withValues(alpha:  0.15)),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "BLOCKED",
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  "Users",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha:  0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.red.withValues(alpha:  0.3)),
            ),
            child: Text(
              '${state.blockedCount}',
              style: GoogleFonts.montserrat(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, BlockedUsersState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: luxury.surfaceElevated,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: luxury.gold.withValues(alpha:  0.1)),
        ),
        child: TextField(
          onChanged: (value) => context.read<BlockedUsersCubit>().searchUsers(value),
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: 'Search blocked users...',
            hintStyle: GoogleFonts.inter(
              fontSize: 14.sp,
              color: colorScheme.onSurfaceVariant.withValues(alpha:  0.6),
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: colorScheme.onSurfaceVariant,
              size: 22.sp,
            ),
            suffixIcon: state.isSearching
                ? IconButton(
                    onPressed: () => context.read<BlockedUsersCubit>().clearSearch(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: 20.sp,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, BlockedUsersState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.loadStatus == BlockedUsersStatus.failure) {
      return _buildErrorState(context);
    }

    if (!state.hasBlockedUsers) {
      return _buildEmptyState(context);
    }

    final users = state.filteredUsers;
    
    if (users.isEmpty && state.isSearching) {
      return _buildNoResultsState(context, state.searchQuery);
    }

    return RefreshIndicator(
      onRefresh: () => context.read<BlockedUsersCubit>().loadBlockedUsers(),
      color: context.luxury.gold,
      child: ListView.builder(
        padding: EdgeInsets.all(20.w),
        itemCount: users.length,
        itemBuilder: (context, index) {
          return _BlockedUserCard(
            user: users[index],
            onUnblock: () => _showUnblockDialog(context, users[index]),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha:  0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                size: 64.sp,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'No Blocked Users',
              style: GoogleFonts.playfairDisplay(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'You haven\'t blocked any users yet.\nAll members have full access to your gym.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            OutlinedButton.icon(
              onPressed: () => _showAddBlockDialog(context),
              icon: Icon(Icons.person_add_disabled_rounded, color: luxury.gold),
              label: Text(
                'Block a User',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  color: luxury.gold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                side: BorderSide(color: luxury.gold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState(BuildContext context, String query) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64.sp,
              color: colorScheme.onSurfaceVariant.withValues(alpha:  0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              'No Results Found',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'No blocked users matching "$query"',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.sp,
              color: colorScheme.error,
            ),
            SizedBox(height: 16.h),
            Text(
              'Failed to Load',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Unable to load blocked users.\nPlease try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24.h),
            FilledButton.icon(
              onPressed: () => context.read<BlockedUsersCubit>().loadBlockedUsers(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    final luxury = context.luxury;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [luxury.gold, luxury.gold.withValues(alpha:  0.8)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: luxury.gold.withValues(alpha:  0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () => _showAddBlockDialog(context),
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: const Icon(Icons.person_add_disabled_rounded, color: Colors.white),
        label: Text(
          'Block User',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showUnblockDialog(BuildContext context, BlockedUser user) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: luxury.surfaceElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha:  0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.person_remove_rounded, color: Colors.green, size: 24.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Unblock User',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to unblock ${user.visitorName}?',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'They will regain access to your gym.',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: colorScheme.onSurfaceVariant.withValues(alpha:  0.7),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<BlockedUsersCubit>().unblockUser(user);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: Text(
              'Unblock',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddBlockDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final nameController = TextEditingController();
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: luxury.surfaceElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha:  0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.person_add_disabled_rounded, color: Colors.red, size: 24.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Block User',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'User Name',
                hintText: 'Enter user name',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Reason (Optional)',
                hintText: 'Why are you blocking this user?',
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 48),
                  child: Icon(Icons.notes_rounded),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a user name')),
                );
                return;
              }
              Navigator.pop(dialogContext);
              context.read<BlockedUsersCubit>().blockUser(
                visitorId: 'user_${DateTime.now().millisecondsSinceEpoch}',
                visitorName: nameController.text.trim(),
                reason: reasonController.text.trim().isEmpty 
                    ? null 
                    : reasonController.text.trim(),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              'Block User',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlockedUserCard extends StatelessWidget {
  final BlockedUser user;
  final VoidCallback onUnblock;

  const _BlockedUserCard({
    required this.user,
    required this.onUnblock,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.red.withValues(alpha:  0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:  0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.withValues(alpha:  0.2),
                  Colors.red.withValues(alpha:  0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Center(
              child: Text(
                user.visitorName.isNotEmpty 
                    ? user.visitorName[0].toUpperCase() 
                    : '?',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.visitorName,
                  style: GoogleFonts.montserrat(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 12.sp,
                      color: colorScheme.onSurfaceVariant.withValues(alpha:  0.7),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Blocked ${DateFormat('MMM dd, yyyy').format(user.blockedAt)}',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: colorScheme.onSurfaceVariant.withValues(alpha:  0.7),
                      ),
                    ),
                  ],
                ),
                if (user.reason != null && user.reason!.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha:  0.5),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 12.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: 6.w),
                        Flexible(
                          child: Text(
                            user.reason!,
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 12.w),
          
          // Unblock button
          Container(
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha:  0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.green.withValues(alpha:  0.3)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onUnblock,
                borderRadius: BorderRadius.circular(12.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  child: Text(
                    'Unblock',
                    style: GoogleFonts.montserrat(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}