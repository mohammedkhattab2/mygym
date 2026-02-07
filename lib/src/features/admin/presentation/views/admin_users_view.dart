import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mygym/src/features/admin/presentation/bloc/admin_users_cubit.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/luxury_theme_extension.dart';
import '../../domain/entities/admin_user.dart';
import '../widgets/user_status_badge.dart';
import '../widgets/user_role_badge.dart';
import '../widgets/user_details_dialog.dart';

class AdminUsersView extends StatefulWidget {
  const AdminUsersView({super.key});

  @override
  State<AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<AdminUsersView> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedIds = {};
  final ScrollController _scrollController = ScrollController();
  
  UserRole? _selectedRole;
  UserStatus? _selectedStatus;
  UserSubscriptionStatus? _selectedSubscription;

  @override
  void initState() {
    super.initState();
    context.read<AdminUsersCubit>().loadInitial();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF0A0A0F),
                    const Color(0xFF0F0F18),
                    const Color(0xFF0A0A0F),
                  ]
                : [
                    const Color(0xFFFFFBF8),
                    const Color(0xFFF8F5FF),
                    const Color(0xFFFFFBF8),
                  ],
          ),
        ),
        child: Stack(
          children: [
            ..._buildBackgroundOrbs(isDark),
            BlocBuilder<AdminUsersCubit, AdminUsersState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => _buildLoadingState(context),
              error: (message) => _buildErrorState(context, message),
              loaded: (stats, users, totalUsers, currentPage, totalPages, hasMore, filter, isLoadingMore, selectedIds) {
                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // Floating Header
                    SliverToBoxAdapter(
                      child: _buildFloatingHeader(context, stats, totalUsers),
                    ),
                    
                    // Content Area
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      sliver: users.isEmpty
                          ? SliverToBoxAdapter(child: _buildEmptyState(context))
                          : SliverToBoxAdapter(
                              child: _buildUserCards(context, users, isLoadingMore),
                            ),
                    ),
                    
                    // Pagination
                    if (totalPages > 1)
                      SliverToBoxAdapter(
                        child: _buildPagination(context, currentPage, totalPages, hasMore),
                      ),
                    
                    // Bottom spacing
                    SliverToBoxAdapter(child: SizedBox(height: 40.h)),
                  ],
                );
              },
            );
          },
        ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBackgroundOrbs(bool isDark) {
    return [
      Positioned(
        top: -80.r,
        right: -40.r,
        child: Container(
          width: 250.r,
          height: 250.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: isDark
                  ? [
                      AppColors.primary.withValues(alpha: 0.12),
                      AppColors.primary.withValues(alpha: 0.04),
                      Colors.transparent,
                    ]
                  : [
                      AppColors.primary.withValues(alpha: 0.06),
                      AppColors.primary.withValues(alpha: 0.02),
                      Colors.transparent,
                    ],
            ),
          ),
        ),
      ),
      Positioned(
        top: 400.r,
        left: -100.r,
        child: Container(
          width: 200.r,
          height: 200.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: isDark
                  ? [
                      AppColors.gold.withValues(alpha: 0.1),
                      AppColors.gold.withValues(alpha: 0.03),
                      Colors.transparent,
                    ]
                  : [
                      AppColors.gold.withValues(alpha: 0.05),
                      AppColors.gold.withValues(alpha: 0.015),
                      Colors.transparent,
                    ],
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 100.r,
        right: -60.r,
        child: Container(
          width: 180.r,
          height: 180.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: isDark
                  ? [
                      AppColors.secondary.withValues(alpha: 0.08),
                      AppColors.secondary.withValues(alpha: 0.02),
                      Colors.transparent,
                    ]
                  : [
                      AppColors.secondary.withValues(alpha: 0.04),
                      AppColors.secondary.withValues(alpha: 0.01),
                      Colors.transparent,
                    ],
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildFloatingHeader(BuildContext context, UsersStats stats, int totalUsers) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Compact Header Row
          _buildCompactHeader(context, stats, totalUsers),
          
          SizedBox(height: 16.h),
          
          // Quick Stats Strip
          _buildQuickStatsStrip(context, stats),
          
          SizedBox(height: 16.h),
          
          // Search & Filters Card
          _buildSearchFiltersCard(context),
          
          // Bulk Actions
          if (_selectedIds.isNotEmpty) ...[
            SizedBox(height: 12.h),
            _buildBulkActionsBar(context),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactHeader(BuildContext context, UsersStats stats, int totalUsers) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF1E1B4B).withValues(alpha: 0.95),
                      const Color(0xFF312E81).withValues(alpha: 0.85),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.95),
                      const Color(0xFFF5F0FF).withValues(alpha: 0.9),
                    ],
            ),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: isDark
                  ? AppColors.gold.withValues(alpha: 0.25)
                  : AppColors.gold.withValues(alpha: 0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: -4,
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 450;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Animated Icon Container
                      Container(
                        width: isCompact ? 48.r : 56.r,
                        height: isCompact ? 48.r : 56.r,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              luxury.gold,
                              luxury.gold.withValues(alpha: 0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                          boxShadow: [
                            BoxShadow(
                              color: luxury.gold.withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.people_alt_rounded,
                          size: isCompact ? 24.sp : 28.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Title Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 10.w,
                              runSpacing: 6.h,
                              children: [
                                Text(
                                  'Users',
                                  style: GoogleFonts.inter(
                                    fontSize: isCompact ? 22.sp : 26.sp,
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onSurface,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: luxury.gold.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Text(
                                    '$totalUsers',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                      color: luxury.gold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Manage roles, permissions & subscriptions',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Action Buttons
                      if (!isCompact) ...[
                        SizedBox(width: 12.w),
                        _buildHeaderAction(
                          context,
                          icon: Icons.refresh_rounded,
                          onTap: () => context.read<AdminUsersCubit>().loadInitial(),
                        ),
                      ],
                      SizedBox(width: 8.w),
                      _buildExportButtonCompact(context),
                    ],
                  ),
                  if (isCompact) ...[
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        _buildHeaderAction(
                          context,
                          icon: Icons.refresh_rounded,
                          onTap: () => context.read<AdminUsersCubit>().loadInitial(),
                        ),
                        SizedBox(width: 8.w),
                        _buildOnlineIndicator(context),
                      ],
                    ),
                  ] else ...[
                    SizedBox(height: 0.h),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderAction(BuildContext context, {required IconData icon, required VoidCallback onTap}) {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            size: 18.sp,
            color: luxury.gold,
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineIndicator(BuildContext context) {
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.success.withValues(alpha: 0.5),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            'Live',
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportButtonCompact(BuildContext context) {
    final luxury = context.luxury;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final url = await context.read<AdminUsersCubit>().exportUsers();
          if (url != null && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Export ready: $url')),
            );
          }
        },
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [luxury.gold, luxury.gold.withValues(alpha: 0.85)],
            ),
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: luxury.gold.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.download_rounded,
                color: Colors.white,
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                'Export',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStatsStrip(BuildContext context, UsersStats stats) {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildMiniStatChip(
            context,
            icon: Icons.groups_rounded,
            value: '${stats.totalUsers}',
            label: 'Total',
            color: luxury.gold,
            isMain: true,
          ),
          SizedBox(width: 10.w),
          _buildMiniStatChip(
            context,
            icon: Icons.verified_rounded,
            value: '${stats.activeUsers}',
            label: 'Active',
            color: AppColors.success,
          ),
          SizedBox(width: 10.w),
          _buildMiniStatChip(
            context,
            icon: Icons.person_rounded,
            value: '${stats.totalMembers}',
            label: 'Members',
            color: AppColors.info,
          ),
          SizedBox(width: 10.w),
          _buildMiniStatChip(
            context,
            icon: Icons.store_rounded,
            value: '${stats.totalPartners}',
            label: 'Partners',
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStatChip(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    bool isMain = false,
  }) {
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: isMain
            ? LinearGradient(
                colors: [
                  color.withValues(alpha: isDark ? 0.2 : 0.15),
                  color.withValues(alpha: isDark ? 0.1 : 0.08),
                ],
              )
            : null,
        color: isMain ? null : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isMain
              ? color.withValues(alpha: 0.3)
              : (isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06)),
        ),
        boxShadow: isMain
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(icon, size: 14.sp, color: color),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: isMain ? color : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFiltersCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1E1B4B).withValues(alpha: 0.9),
                  const Color(0xFF312E81).withValues(alpha: 0.75),
                ]
              : [
                  Colors.white.withValues(alpha: 0.95),
                  const Color(0xFFF5F0FF).withValues(alpha: 0.9),
                ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? AppColors.gold.withValues(alpha: 0.25)
              : AppColors.gold.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Field
          Container(
            height: 44.h,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: luxury.gold.withValues(alpha: 0.1),
              ),
            ),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Search by name, email or phone...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 18.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          size: 16.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          context.read<AdminUsersCubit>().searchUsers('');
                          setState(() {});
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              onChanged: (value) {
                context.read<AdminUsersCubit>().searchUsers(value);
                setState(() {});
              },
            ),
          ),
          
          SizedBox(height: 12.h),
          
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Role Filter
                _buildFilterChip<UserRole?>(
                  context,
                  value: _selectedRole,
                  hint: 'Role',
                  icon: Icons.badge_rounded,
                  color: AppColors.info,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Roles')),
                    ...UserRole.values.map((role) => DropdownMenuItem(
                      value: role,
                      child: Text(role.displayName),
                    )),
                  ],
                  onChanged: (v) {
                    setState(() => _selectedRole = v);
                    context.read<AdminUsersCubit>().filterByRole(v);
                  },
                ),
                
                SizedBox(width: 8.w),
                
                // Status Filter
                _buildFilterChip<UserStatus?>(
                  context,
                  value: _selectedStatus,
                  hint: 'Status',
                  icon: Icons.toggle_on_rounded,
                  color: AppColors.success,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Status')),
                    ...UserStatus.values.map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.displayName),
                    )),
                  ],
                  onChanged: (v) {
                    setState(() => _selectedStatus = v);
                    context.read<AdminUsersCubit>().filterByStatus(v);
                  },
                ),
                
                SizedBox(width: 8.w),
                
                // Subscription Filter
                _buildFilterChip<UserSubscriptionStatus?>(
                  context,
                  value: _selectedSubscription,
                  hint: 'Subscription',
                  icon: Icons.card_membership_rounded,
                  color: AppColors.warning,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All')),
                    ...UserSubscriptionStatus.values.map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(s.name.toUpperCase()),
                    )),
                  ],
                  onChanged: (v) {
                    setState(() => _selectedSubscription = v);
                    context.read<AdminUsersCubit>().filterBySubscription(v);
                  },
                ),
                
                // Clear Filters
                if (_hasActiveFilters) ...[
                  SizedBox(width: 8.w),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _clearFilters,
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        height: 36.h,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: AppColors.error.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.filter_alt_off_rounded,
                              size: 14.sp,
                              color: AppColors.error,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Clear',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip<T>(
    BuildContext context, {
    required T value,
    required String hint,
    required IconData icon,
    required Color color,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Container(
      height: 36.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: value != null
            ? color.withValues(alpha: isDark ? 0.15 : 0.1)
            : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.03)),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: value != null
              ? color.withValues(alpha: 0.3)
              : (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: value != null ? color : colorScheme.onSurfaceVariant),
          SizedBox(width: 6.w),
          DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              hint: Text(
                hint,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: value != null ? color : colorScheme.onSurfaceVariant,
                size: 16.sp,
              ),
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: value != null ? color : colorScheme.onSurface,
              ),
              dropdownColor: isDark ? const Color(0xFF1E1B4B) : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildBulkActionsBar(BuildContext context) {
    final luxury = context.luxury;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            luxury.gold.withValues(alpha: isDark ? 0.12 : 0.08),
            luxury.gold.withValues(alpha: isDark ? 0.06 : 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: luxury.gold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: luxury.gold,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_selectedIds.length} selected',
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: luxury.gold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Choose an action',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildBulkAction('Activate', Icons.check_circle_outline, AppColors.success,
                    () => _bulkUpdateStatus(UserStatus.active)),
                  SizedBox(width: 8.w),
                  _buildBulkAction('Suspend', Icons.pause_circle_outline, AppColors.warning,
                    () => _bulkUpdateStatus(UserStatus.suspended)),
                  SizedBox(width: 8.w),
                  _buildBulkAction('Block', Icons.block_rounded, AppColors.error,
                    () => _bulkUpdateStatus(UserStatus.blocked)),
                  SizedBox(width: 8.w),
                  _buildBulkAction('Clear', Icons.close_rounded, colorScheme.onSurfaceVariant,
                    () => setState(() => _selectedIds.clear())),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulkAction(String label, IconData icon, Color color, VoidCallback onTap) {
    final isDark = context.isDarkMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.15 : 0.1),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: color.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16.sp, color: color),
              SizedBox(width: 8.w),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExportButton(BuildContext context) {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final url = await context.read<AdminUsersCubit>().exportUsers();
          if (url != null && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Export ready: $url')),
            );
          }
        },
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [luxury.gold, luxury.gold.withValues(alpha: 0.85)],
            ),
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: luxury.gold.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.download_rounded,
                color: Colors.white,
                size: 20.sp,
              ),
              SizedBox(width: 10.w),
              Text(
                'Export',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCards(BuildContext context, List<AdminUser> users, bool isLoadingMore) {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: luxury.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.list_alt_rounded,
                  size: 20.sp,
                  color: luxury.gold,
                ),
              ),
              SizedBox(width: 14.w),
              Flexible(
                child: Text(
                  'Users Directory',
                  style: GoogleFonts.raleway(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: luxury.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: BoxDecoration(
                        color: luxury.gold,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '${users.length} records',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: luxury.gold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // User Cards Grid
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: users.length,
          separatorBuilder: (_, __) => SizedBox(height: 16.h),
          itemBuilder: (context, index) => _buildUserCard(context, users[index]),
        ),
        
        // Loading More Indicator
        if (isLoadingMore)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 24.r,
                    height: 24.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: luxury.gold,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Text(
                    'Loading more...',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: luxury.gold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserCard(BuildContext context, AdminUser user) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;
    final isSelected = _selectedIds.contains(user.id);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showUserDetails(context, user),
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isSelected
                  ? [
                      luxury.gold.withValues(alpha: isDark ? 0.15 : 0.1),
                      luxury.gold.withValues(alpha: isDark ? 0.08 : 0.05),
                    ]
                  : isDark
                      ? [
                          const Color(0xFF1E1B4B).withValues(alpha: 0.9),
                          const Color(0xFF312E81).withValues(alpha: 0.75),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.95),
                          const Color(0xFFF5F0FF).withValues(alpha: 0.9),
                        ],
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected
                  ? luxury.gold.withValues(alpha: 0.4)
                  : luxury.gold.withValues(alpha: isDark ? 0.1 : 0.06),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 500;
              final isMedium = constraints.maxWidth > 350;
              
              if (isWide) {
                // Wide layout - horizontal with all elements
                return Row(
                  children: [
                    // Checkbox
                    _buildCheckbox(user, isSelected, luxury, colorScheme),
                    SizedBox(width: 12.w),
                    // Avatar
                    _buildAvatar(user, luxury, size: 48.r),
                    SizedBox(width: 12.w),
                    // User Info
                    Expanded(
                      child: _buildUserInfo(user, colorScheme),
                    ),
                    SizedBox(width: 12.w),
                    // Role Badge
                    UserRoleBadge(role: user.role),
                    SizedBox(width: 8.w),
                    // Status Badge
                    UserStatusBadge(status: user.status),
                    SizedBox(width: 12.w),
                    // Stats
                    _buildUserStats(user),
                    SizedBox(width: 12.w),
                    // Actions
                    _buildUserActions(context, user),
                  ],
                );
              } else if (isMedium) {
                // Medium layout - two rows
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: checkbox, avatar, name, actions
                    Row(
                      children: [
                        _buildCheckbox(user, isSelected, luxury, colorScheme),
                        SizedBox(width: 10.w),
                        _buildAvatar(user, luxury, size: 44.r),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                user.email,
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        _buildUserActions(context, user),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    // Bottom row: badges and stats
                    Row(
                      children: [
                        UserRoleBadge(role: user.role),
                        SizedBox(width: 8.w),
                        UserStatusBadge(status: user.status),
                        const Spacer(),
                        _buildUserStats(user),
                      ],
                    ),
                  ],
                );
              } else {
                // Narrow layout - stacked
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: checkbox, avatar, actions
                    Row(
                      children: [
                        _buildCheckbox(user, isSelected, luxury, colorScheme),
                        SizedBox(width: 8.w),
                        _buildAvatar(user, luxury, size: 40.r),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            user.name,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildCompactActions(context, user),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // Email
                    Padding(
                      padding: EdgeInsets.only(left: 28.w),
                      child: Text(
                        user.email,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Badges and stats in wrap
                    Padding(
                      padding: EdgeInsets.only(left: 28.w),
                      child: Wrap(
                        spacing: 6.w,
                        runSpacing: 6.h,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          UserRoleBadge(role: user.role),
                          UserStatusBadge(status: user.status),
                          _buildCompactStats(user),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(AdminUser user, bool isSelected, LuxuryThemeExtension luxury, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedIds.remove(user.id);
          } else {
            _selectedIds.add(user.id);
          }
        });
      },
      child: Container(
        width: 22.r,
        height: 22.r,
        decoration: BoxDecoration(
          color: isSelected ? luxury.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: isSelected
                ? luxury.gold
                : colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: isSelected
            ? Icon(
                Icons.check_rounded,
                size: 14.sp,
                color: Colors.white,
              )
            : null,
      ),
    );
  }

  Widget _buildAvatar(AdminUser user, LuxuryThemeExtension luxury, {required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: user.avatarUrl == null
            ? LinearGradient(
                colors: [luxury.gold, luxury.gold.withValues(alpha: 0.7)],
              )
            : null,
        borderRadius: BorderRadius.circular(size * 0.28),
        image: user.avatarUrl != null
            ? DecorationImage(
                image: NetworkImage(user.avatarUrl!),
                fit: BoxFit.cover,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: luxury.gold.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: user.avatarUrl == null
          ? Center(
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: GoogleFonts.raleway(
                  fontSize: size * 0.45,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildUserInfo(AdminUser user, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.name,
          style: GoogleFonts.inter(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 3.h),
        Row(
          children: [
            Icon(
              Icons.email_outlined,
              size: 13.sp,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            SizedBox(width: 5.w),
            Expanded(
              child: Text(
                user.email,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserStats(AdminUser user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.directions_walk_rounded,
              size: 13.sp,
              color: AppColors.info,
            ),
            SizedBox(width: 3.w),
            Text(
              '${user.totalVisits}',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.info,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        Text(
          'EGP ${user.totalSpent.toStringAsFixed(0)}',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactStats(AdminUser user) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.directions_walk_rounded,
            size: 11.sp,
            color: AppColors.info,
          ),
          SizedBox(width: 3.w),
          Text(
            '${user.totalVisits}',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.info,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            'EGP ${user.totalSpent.toStringAsFixed(0)}',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactActions(BuildContext context, AdminUser user) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return PopupMenuButton<String>(
      icon: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          Icons.more_vert_rounded,
          size: 16.sp,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      color: isDark ? const Color(0xFF1E1B4B) : Colors.white,
      elevation: 8,
      itemBuilder: (context) => [
        _buildPopupItem('view', 'View Details', Icons.visibility_outlined, context.luxury.gold),
        const PopupMenuDivider(),
        if (user.status != UserStatus.active)
          _buildPopupItem('activate', 'Activate', Icons.check_circle_outline, AppColors.success),
        if (user.status != UserStatus.suspended)
          _buildPopupItem('suspend', 'Suspend', Icons.pause_circle_outline, AppColors.warning),
        if (user.status != UserStatus.blocked)
          _buildPopupItem('block', 'Block', Icons.block_rounded, AppColors.error),
        const PopupMenuDivider(),
        _buildPopupItem('delete', 'Delete', Icons.delete_outline, AppColors.error),
      ],
      onSelected: (action) {
        if (action == 'view') {
          _showUserDetails(context, user);
        } else {
          _handleUserAction(context, user, action);
        }
      },
    );
  }

  Widget _buildUserActions(BuildContext context, AdminUser user) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // View Button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showUserDetails(context, user),
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: luxury.gold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.visibility_outlined,
                size: 18.sp,
                color: luxury.gold,
              ),
            ),
          ),
        ),
        
        SizedBox(width: 8.w),
        
        // More Actions
        PopupMenuButton<String>(
          icon: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.more_vert_rounded,
              size: 18.sp,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
          color: isDark ? const Color(0xFF1E1B4B) : Colors.white,
          elevation: 8,
          itemBuilder: (context) => [
            if (user.status != UserStatus.active)
              _buildPopupItem('activate', 'Activate', Icons.check_circle_outline, AppColors.success),
            if (user.status != UserStatus.suspended)
              _buildPopupItem('suspend', 'Suspend', Icons.pause_circle_outline, AppColors.warning),
            if (user.status != UserStatus.blocked)
              _buildPopupItem('block', 'Block', Icons.block_rounded, AppColors.error),
            const PopupMenuDivider(),
            _buildPopupItem('delete', 'Delete', Icons.delete_outline, AppColors.error),
          ],
          onSelected: (action) => _handleUserAction(context, user, action),
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupItem(String value, String label, IconData icon, Color color) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 16.sp, color: color),
          ),
          SizedBox(width: 12.w),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(BuildContext context, int currentPage, int totalPages, bool hasMore) {
    final luxury = context.luxury;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Container(
      margin: EdgeInsets.fromLTRB(24.r, 24.r, 24.r, 0),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1E1B4B).withValues(alpha: 0.9),
                  const Color(0xFF312E81).withValues(alpha: 0.75),
                ]
              : [
                  Colors.white.withValues(alpha: 0.95),
                  const Color(0xFFF5F0FF).withValues(alpha: 0.9),
                ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Page Info
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: luxury.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Page ',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [luxury.gold, luxury.gold.withValues(alpha: 0.8)],
                    ),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    '$currentPage',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  ' of $totalPages',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Navigation Buttons
          _buildPaginationButton(
            context,
            icon: Icons.keyboard_double_arrow_left_rounded,
            enabled: currentPage > 1,
            onTap: () {},
          ),
          SizedBox(width: 8.w),
          _buildPaginationButton(
            context,
            icon: Icons.chevron_left_rounded,
            enabled: currentPage > 1,
            onTap: () {},
          ),
          SizedBox(width: 8.w),
          _buildPaginationButton(
            context,
            icon: Icons.chevron_right_rounded,
            enabled: hasMore,
            onTap: () => context.read<AdminUsersCubit>().loadNextPage(),
          ),
          SizedBox(width: 8.w),
          _buildPaginationButton(
            context,
            icon: Icons.keyboard_double_arrow_right_rounded,
            enabled: hasMore,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationButton(
    BuildContext context, {
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    final luxury = context.luxury;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: enabled
                ? luxury.gold.withValues(alpha: isDark ? 0.15 : 0.1)
                : colorScheme.onSurface.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: enabled
                  ? luxury.gold.withValues(alpha: 0.25)
                  : colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
          child: Icon(
            icon,
            size: 20.sp,
            color: enabled
                ? luxury.gold
                : colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final isDark = context.isDarkMode;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.gold.withValues(alpha: isDark ? 0.2 : 0.1),
                  AppColors.gold.withValues(alpha: isDark ? 0.08 : 0.04),
                  Colors.transparent,
                ],
              ),
            ),
            child: SizedBox(
              width: 48.r,
              height: 48.r,
              child: CircularProgressIndicator(
                color: AppColors.gold,
                strokeWidth: 3,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: isDark
                  ? [Colors.white, const Color(0xFFE8E0FF)]
                  : [const Color(0xFF1A1A2E), const Color(0xFF312E81)],
            ).createShader(bounds),
            child: Text(
              'Loading users...',
              style: GoogleFonts.raleway(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final luxury = context.luxury;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.error.withValues(alpha: isDark ? 0.2 : 0.1),
                  AppColors.error.withValues(alpha: isDark ? 0.08 : 0.04),
                  Colors.transparent,
                ],
              ),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 48.sp,
              color: AppColors.error,
            ),
          ),
          SizedBox(height: 20.h),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: isDark
                  ? [Colors.white, const Color(0xFFE8E0FF)]
                  : [const Color(0xFF1A1A2E), const Color(0xFF312E81)],
            ).createShader(bounds),
            child: Text(
              'Failed to Load',
              style: GoogleFonts.raleway(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.read<AdminUsersCubit>().loadInitial(),
                borderRadius: BorderRadius.circular(14.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [luxury.gold, luxury.gold.withValues(alpha: 0.85)],
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: luxury.gold.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh_rounded, color: Colors.white, size: 20.sp),
                      SizedBox(width: 10.w),
                      Text(
                        'Try Again',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final luxury = context.luxury;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 60.h),
          Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.gold.withValues(alpha: isDark ? 0.15 : 0.08),
                  AppColors.gold.withValues(alpha: isDark ? 0.06 : 0.03),
                  Colors.transparent,
                ],
              ),
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
              ).createShader(bounds),
              child: Icon(
                Icons.person_search_rounded,
                size: 56.sp,
                color: Colors.white,
              ),
            ),
          ),
          
          SizedBox(height: 24.h),
          
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: isDark
                  ? [Colors.white, const Color(0xFFE8E0FF)]
                  : [const Color(0xFF1A1A2E), const Color(0xFF312E81)],
            ).createShader(bounds),
            child: Text(
              'No Users Found',
              style: GoogleFonts.raleway(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          
          SizedBox(height: 8.h),
          
          Text(
            'Try adjusting your filters or search terms',
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
            
            if (_hasActiveFilters) ...[
              SizedBox(height: 32.h),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _clearFilters,
                  borderRadius: BorderRadius.circular(14.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [luxury.gold, luxury.gold.withValues(alpha: 0.85)],
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                      boxShadow: [
                        BoxShadow(
                          color: luxury.gold.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.filter_alt_off_rounded, color: Colors.white, size: 20.sp),
                        SizedBox(width: 10.w),
                        Text(
                          'Clear Filters',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  bool get _hasActiveFilters =>
      _selectedRole != null ||
      _selectedStatus != null ||
      _selectedSubscription != null ||
      _searchController.text.isNotEmpty;

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedRole = null;
      _selectedStatus = null;
      _selectedSubscription = null;
    });
    context.read<AdminUsersCubit>().clearFilters();
  }

  void _bulkUpdateStatus(UserStatus status) async {
    final count = await context.read<AdminUsersCubit>().bulkUpdateStatus(_selectedIds.toList(), status);
    if (mounted) {
      setState(() => _selectedIds.clear());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$count users updated'), backgroundColor: AppColors.success),
      );
    }
  }

  void _handleUserAction(BuildContext context, AdminUser user, String action) async {
    final cubit = context.read<AdminUsersCubit>();
    
    switch (action) {
      case 'activate':
        await cubit.updateUserStatus(user.id, UserStatus.active);
        break;
      case 'suspend':
        await cubit.updateUserStatus(user.id, UserStatus.suspended);
        break;
      case 'block':
        await cubit.updateUserStatus(user.id, UserStatus.blocked);
        break;
      case 'delete':
        _showDeleteConfirmation(context, user);
        break;
    }
  }

  void _showUserDetails(BuildContext context, AdminUser user) {
    showDialog(
      context: context,
      builder: (ctx) => UserDetailsDialog(user: user),
    );
  }

  void _showDeleteConfirmation(BuildContext context, AdminUser user) {
    final luxury = context.luxury;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400.w,
          padding: EdgeInsets.all(28.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF1E1B4B), const Color(0xFF312E81)]
                  : [Colors.white, const Color(0xFFF5F0FF)],
            ),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: AppColors.error.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 40.sp,
                  color: AppColors.error,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Delete User',
                style: GoogleFonts.raleway(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 12.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  children: [
                    const TextSpan(text: 'Are you sure you want to delete '),
                    TextSpan(
                      text: user.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const TextSpan(text: '?\nThis action cannot be undone.'),
                  ],
                ),
              ),
              SizedBox(height: 28.h),
              Row(
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pop(ctx),
                        borderRadius: BorderRadius.circular(14.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: colorScheme.onSurface.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          Navigator.pop(ctx);
                          await context.read<AdminUsersCubit>().deleteUser(user.id);
                        },
                        borderRadius: BorderRadius.circular(14.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.error, AppColors.error.withValues(alpha: 0.85)],
                            ),
                            borderRadius: BorderRadius.circular(14.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.error.withValues(alpha: 0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Delete',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
