import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/admin/domain/entities/admin_gym.dart';
import 'package:mygym/src/features/admin/presentation/bloc/admin_dashboard_cubit.dart';
import 'package:mygym/src/features/admin/presentation/widgets/action_icon_button.dart';
import 'package:mygym/src/features/admin/presentation/widgets/bulk_action_button.dart';
import 'package:mygym/src/features/admin/presentation/widgets/gym_status_badge.dart';
import 'package:mygym/src/features/admin/presentation/widgets/pagination_button.dart';
import 'package:mygym/src/features/admin/presentation/widgets/popup_menu_item_content.dart';

class AdminGymsTableView extends StatefulWidget {
  const AdminGymsTableView({super.key});

  @override
  State<AdminGymsTableView> createState() => _AdminGymsTableViewState();
}

class _AdminGymsTableViewState extends State<AdminGymsTableView> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedIds = {};
  GymStatus? _selectedStatus;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<AdminCubit>();
    if (cubit.state is AdminInitial) {
      cubit.loadInitial();
    }
    cubit.loadFormData().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            // Background magical orbs
            ..._buildBackgroundOrbs(isDark),
            // Main content
            BlocBuilder<AdminCubit, AdminState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const SizedBox.shrink(),
                  loading: () => _buildLoadingState(context),
                  error: (message) => _buildErrorState(context, message),
                  loaded: (
                    stats,
                    gyms,
                    totalGyms,
                    currentPage,
                    totalPages,
                    hasMore,
                    filter,
                    isLoadingMore,
                    selectedIds,
                  ) {
                    return Column(
                      children: [
                        _buildHeaderSection(context, totalGyms, stats),
                        Expanded(
                          child: _buildTableSection(context, gyms, isLoadingMore),
                        ),
                        if (totalPages >= 1)
                          _buildPagination(
                            context,
                            currentPage,
                            totalPages,
                            hasMore,
                          ),
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
        top: 300.r,
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
        bottom: 50.r,
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

  Widget _buildHeaderSection(
    BuildContext context,
    int totalGyms,
    AdminDashboardStats stats,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Container(
      margin: EdgeInsets.fromLTRB(20.r, 16.r, 20.r, 12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Title + Add button
          _buildTitleRow(context, totalGyms, stats),
          SizedBox(height: 16.h),
          // Stats cards row
          _buildStatsCards(context, totalGyms, stats),
          SizedBox(height: 16.h),
          // Search and filters card
          _buildFiltersCard(context),
          // Bulk actions
          if (_selectedIds.isNotEmpty) ...[
            SizedBox(height: 12.h),
            _buildBulkActions(context),
          ],
        ],
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context, int totalGyms, AdminDashboardStats stats) {
    final isDark = context.isDarkMode;

    return Row(
      children: [
        // Title with icon
        Expanded(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.gold.withValues(alpha: isDark ? 0.25 : 0.15),
                      AppColors.gold.withValues(alpha: isDark ? 0.1 : 0.05),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: isDark ? 0.4 : 0.25),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: isDark ? 0.2 : 0.1),
                      blurRadius: 12,
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
                  ).createShader(bounds),
                  child: Icon(
                    Icons.fitness_center_rounded,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: isDark
                            ? [Colors.white, const Color(0xFFE8E0FF)]
                            : [const Color(0xFF1A1A2E), const Color(0xFF312E81)],
                      ).createShader(bounds),
                      child: Text(
                        "Gym Management",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Manage all registered gyms",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        _buildAddGymButton(context),
      ],
    );
  }

  Widget _buildStatsCards(BuildContext context, int totalGyms, AdminDashboardStats stats) {
    final isDark = context.isDarkMode;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatCard(
            value: '$totalGyms',
            label: 'Total Gyms',
            icon: Icons.storefront_rounded,
            color: AppColors.primary,
            isDark: isDark,
          ),
          SizedBox(width: 12.w),
          _buildStatCard(
            value: '${stats.activeGyms}',
            label: 'Active',
            icon: Icons.check_circle_outline_rounded,
            color: AppColors.success,
            isDark: isDark,
          ),
          SizedBox(width: 12.w),
          _buildStatCard(
            value: '${stats.pendingGyms}',
            label: 'Pending',
            icon: Icons.pending_outlined,
            color: AppColors.warning,
            isDark: isDark,
          ),
          SizedBox(width: 12.w),
          _buildStatCard(
            value: '${stats.blockedGyms}',
            label: 'Blocked',
            icon: Icons.block_rounded,
            color: AppColors.error,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    final secondaryColor = HSLColor.fromColor(color)
        .withLightness((HSLColor.fromColor(color).lightness + 0.15).clamp(0.0, 1.0))
        .toColor();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1E1B4B).withValues(alpha: 0.9),
                  const Color(0xFF312E81).withValues(alpha: 0.7),
                ]
              : [
                  Colors.white.withValues(alpha: 0.95),
                  const Color(0xFFF5F0FF).withValues(alpha: 0.9),
                ],
        ),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.35 : 0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isDark ? 0.15 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: isDark ? 0.25 : 0.15),
                  color.withValues(alpha: isDark ? 0.12 : 0.08),
                ],
              ),
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [color, secondaryColor],
              ).createShader(bounds),
              child: Icon(icon, color: Colors.white, size: 18.sp),
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [color, secondaryColor],
                ).createShader(bounds),
                child: Text(
                  value,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1E1B4B).withValues(alpha: 0.85),
                  const Color(0xFF312E81).withValues(alpha: 0.7),
                ]
              : [
                  Colors.white.withValues(alpha: 0.95),
                  const Color(0xFFF8F5FF).withValues(alpha: 0.9),
                ],
        ),
        border: Border.all(
          color: isDark
              ? AppColors.gold.withValues(alpha: 0.2)
              : AppColors.gold.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search row
          _buildSearchField(context),
          SizedBox(height: 12.h),
          // Filters row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatusFilter(context),
                SizedBox(width: 10.w),
                _buildCityFilter(context),
                if (_selectedStatus != null ||
                    _selectedCity != null ||
                    _searchController.text.isNotEmpty) ...[
                  SizedBox(width: 10.w),
                  _buildClearFiltersButton(context),
                ],
              ],
            ),
          ),
        ],
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
              "Loading Gyms...",
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
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.r),
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
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [AppColors.error, const Color(0xFFF87171)],
              ).createShader(bounds),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48.sp,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            "Failed to load gyms",
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: GoogleFonts.raleway(
              fontSize: 14.sp,
              color: luxury.textTertiary,
            ),
          ),
          SizedBox(height: 24.h),
          _buildRetryButton(context),
        ],
      ),
    );
  }

  Widget _buildRetryButton(BuildContext context) {
    final isDark = context.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: isDark ? 0.4 : 0.25),
            blurRadius: 16,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.read<AdminCubit>().loadInitial(),
          borderRadius: BorderRadius.circular(14.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh_rounded, color: Colors.white, size: 18.sp),
                SizedBox(width: 8.w),
                Text(
                  "Retry",
                  style: GoogleFonts.raleway(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddGymButton(BuildContext context) {
    final isDark = context.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFD700), Color(0xFFD4A574), Color(0xFFFFD700)],
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: isDark ? 0.5 : 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go(RoutePaths.adminAddGym),
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  child: Icon(Icons.add_rounded, color: Colors.white, size: 18.sp),
                ),
                SizedBox(width: 10.w),
                Text(
                  "Add New Gym",
                  style: GoogleFonts.raleway(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Container(
      width: 320.w,
      height: 48.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.white.withValues(alpha: 0.08),
                  Colors.white.withValues(alpha: 0.04),
                ]
              : [
                  Colors.white.withValues(alpha: 0.9),
                  Colors.white.withValues(alpha: 0.7),
                ],
        ),
        border: Border.all(
          color: isDark
              ? AppColors.gold.withValues(alpha: 0.2)
              : AppColors.gold.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.inter(fontSize: 14.sp, color: colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: "Search by name, city, address...",
          hintStyle: GoogleFonts.inter(
            fontSize: 14.sp,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          prefixIcon: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [AppColors.gold, AppColors.goldLight],
            ).createShader(bounds),
            child: Icon(
              Icons.search_rounded,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close_rounded, size: 18.sp),
                  onPressed: () {
                    _searchController.clear();
                    context.read<AdminCubit>().searchGyms("");
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
        onChanged: (value) {
          context.read<AdminCubit>().searchGyms(value);
        },
      ),
    );
  }

  Widget _buildStatusFilter(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      height: 48.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.white.withValues(alpha: 0.08),
                  Colors.white.withValues(alpha: 0.04),
                ]
              : [
                  Colors.white.withValues(alpha: 0.9),
                  Colors.white.withValues(alpha: 0.7),
                ],
        ),
        border: Border.all(
          color: isDark
              ? AppColors.gold.withValues(alpha: 0.2)
              : AppColors.gold.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<GymStatus?>(
          value: _selectedStatus,
          hint: Text(
            "All Status",
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          icon: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [AppColors.gold, AppColors.goldLight],
            ).createShader(bounds),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
            ),
          ),
          style: GoogleFonts.inter(fontSize: 14.sp, color: colorScheme.onSurface),
          dropdownColor: isDark ? const Color(0xFF1E1B4B) : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          items: [
            DropdownMenuItem<GymStatus?>(
              value: null,
              child: Text("All Status"),
            ),
            ...GymStatus.values.map(
              (status) => DropdownMenuItem(
                value: status,
                child: Row(
                  children: [
                    GymStatusBadge(status: status, isCompact: true, showIcon: false),
                  ],
                ),
              ),
            ),
          ],
          onChanged: (value) {
            setState(() => _selectedStatus = value);
            context.read<AdminCubit>().filterByStatus(value);
          },
        ),
      ),
    );
  }

  Widget _buildCityFilter(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;
    final cities = context.read<AdminCubit>().cities;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      height: 48.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.white.withValues(alpha: 0.08),
                  Colors.white.withValues(alpha: 0.04),
                ]
              : [
                  Colors.white.withValues(alpha: 0.9),
                  Colors.white.withValues(alpha: 0.7),
                ],
        ),
        border: Border.all(
          color: isDark
              ? AppColors.gold.withValues(alpha: 0.2)
              : AppColors.gold.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCity,
          hint: Text(
            "All Cities",
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          icon: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [AppColors.gold, AppColors.goldLight],
            ).createShader(bounds),
            child: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
          ),
          style: GoogleFonts.inter(fontSize: 14.sp, color: colorScheme.onSurface),
          dropdownColor: isDark ? const Color(0xFF1E1B4B) : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          items: [
            const DropdownMenuItem<String>(value: null, child: Text("All Cities")),
            ...cities.map(
              (city) => DropdownMenuItem(value: city.name, child: Text(city.name)),
            ),
          ],
          onChanged: (value) {
            setState(() => _selectedCity = value);
            context.read<AdminCubit>().filterByCity(value);
          },
        ),
      ),
    );
  }

  Widget _buildClearFiltersButton(BuildContext context) {
    final isDark = context.isDarkMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _clearFilters,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            gradient: LinearGradient(
              colors: [
                AppColors.error.withValues(alpha: isDark ? 0.15 : 0.1),
                AppColors.error.withValues(alpha: isDark ? 0.08 : 0.05),
              ],
            ),
            border: Border.all(
              color: AppColors.error.withValues(alpha: isDark ? 0.3 : 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.clear_all_rounded, size: 16.sp, color: AppColors.error),
              SizedBox(width: 6.w),
              Text(
                "Clear Filters",
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
    );
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedStatus = null;
      _selectedCity = null;
    });
    context.read<AdminCubit>().clearFilters();
  }

  Widget _buildBulkActions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.gold.withValues(alpha: isDark ? 0.15 : 0.1),
            AppColors.gold.withValues(alpha: isDark ? 0.08 : 0.05),
          ],
        ),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: isDark ? 0.35 : 0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: isDark ? 0.15 : 0.08),
            blurRadius: 12,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
            ).createShader(bounds),
            child: Icon(Icons.check_circle_rounded, color: Colors.white, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Text(
            '${_selectedIds.length} selected',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.gold,
            ),
          ),
          const Spacer(),
          BulkActionButton(
            icon: Icons.check_circle_outline,
            label: 'Activate',
            color: AppColors.success,
            onTap: () => _bulkUpdateStatus(GymStatus.active),
          ),
          SizedBox(width: 10.w),
          BulkActionButton(
            icon: Icons.block_rounded,
            label: 'Block',
            color: AppColors.error,
            onTap: () => _bulkUpdateStatus(GymStatus.blocked),
          ),
          SizedBox(width: 10.w),
          BulkActionButton(
            icon: Icons.close_rounded,
            label: 'Clear',
            color: colorScheme.onSurfaceVariant,
            onTap: () => setState(() => _selectedIds.clear()),
          ),
        ],
      ),
    );
  }

  void _bulkUpdateStatus(GymStatus status) async {
    final count = await context.read<AdminCubit>().bulkUpdateStatus(
      _selectedIds.toList(),
      status,
    );
    if (mounted) {
      setState(() => _selectedIds.clear());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$count gyms updated'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Widget _buildTableSection(
    BuildContext context,
    List<AdminGym> gyms,
    bool isLoadingMore,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    if (gyms.isEmpty) {
      return _buildEmptyState(context);
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1E1B4B).withValues(alpha: 0.9),
                  const Color(0xFF312E81).withValues(alpha: 0.8),
                ]
              : [
                  Colors.white.withValues(alpha: 0.95),
                  const Color(0xFFF5F0FF).withValues(alpha: 0.9),
                ],
        ),
        border: Border.all(
          color: isDark
              ? AppColors.gold.withValues(alpha: 0.2)
              : AppColors.gold.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width - 48.w,
            ),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                isDark
                    ? AppColors.gold.withValues(alpha: 0.08)
                    : AppColors.gold.withValues(alpha: 0.05),
              ),
              dataRowColor: WidgetStateProperty.resolveWith((state) {
                if (state.contains(WidgetState.selected)) {
                  return AppColors.gold.withValues(alpha: isDark ? 0.12 : 0.08);
                }
                if (state.contains(WidgetState.hovered)) {
                  return AppColors.gold.withValues(alpha: isDark ? 0.06 : 0.04);
                }
                return null;
              }),
              headingRowHeight: 60.h,
              dataRowMinHeight: 76.h,
              dataRowMaxHeight: 76.h,
              horizontalMargin: 28.w,
              columnSpacing: 36.w,
              showCheckboxColumn: true,
              columns: _buildColumns(context),
              rows: gyms.map((gym) => _buildDataRow(context, gym)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(28.r),
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
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [AppColors.gold, AppColors.goldLight],
              ).createShader(bounds),
              child: Icon(
                Icons.fitness_center_outlined,
                size: 56.sp,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 28.h),
          Text(
            "No Gyms Found",
            style: GoogleFonts.cormorantGaramond(
              fontSize: 26.sp,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Try adjusting your filters or add a new gym",
            style: GoogleFonts.raleway(
              fontSize: 14.sp,
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
            ),
          ),
          SizedBox(height: 28.h),
          _buildAddGymButton(context),
        ],
      ),
    );
  }

  List<DataColumn> _buildColumns(BuildContext context) {
    final isDark = context.isDarkMode;

    Widget buildColumnLabel(String text) {
      return ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: isDark
              ? [AppColors.gold, AppColors.goldLight]
              : [const Color(0xFF1A1A2E), const Color(0xFF312E81)],
        ).createShader(bounds),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      );
    }

    return [
      DataColumn(label: buildColumnLabel("GYM")),
      DataColumn(label: buildColumnLabel("CITY")),
      DataColumn(label: buildColumnLabel("STATUS")),
      DataColumn(label: buildColumnLabel("DATE ADDED")),
      DataColumn(label: buildColumnLabel("VISITS"), numeric: true),
      DataColumn(label: buildColumnLabel("REVENUE"), numeric: true),
      DataColumn(label: buildColumnLabel("ACTIONS")),
    ];
  }

  DataRow _buildDataRow(BuildContext context, AdminGym gym) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return DataRow(
      selected: _selectedIds.contains(gym.id),
      onSelectChanged: (selected) {
        setState(() {
          if (selected == true) {
            _selectedIds.add(gym.id);
          } else {
            _selectedIds.remove(gym.id);
          }
        });
      },
      cells: [
        DataCell(
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.gold.withValues(alpha: 0.6),
                      AppColors.goldLight.withValues(alpha: 0.4),
                    ],
                  ),
                ),
                child: Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: isDark ? const Color(0xFF1E1B4B) : Colors.white,
                    image: gym.imageUrls.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(gym.imageUrls.first),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: gym.imageUrls.isEmpty
                      ? Center(
                          child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [AppColors.gold, AppColors.goldLight],
                            ).createShader(bounds),
                            child: Icon(
                              Icons.fitness_center_rounded,
                              color: Colors.white,
                              size: 22.sp,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
              SizedBox(width: 14.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gym.name,
                    style: GoogleFonts.raleway(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    gym.address.length > 30
                        ? '${gym.address.substring(0, 30)}...'
                        : gym.address,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            gym.city,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        DataCell(GymStatusBadge(status: gym.status)),
        DataCell(
          Text(
            DateFormat('MMM d, yyyy').format(gym.dateAdded),
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        DataCell(
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
            ).createShader(bounds),
            child: Text(
              '${gym.stats.totalVisits}',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        DataCell(
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [AppColors.success, const Color(0xFF34D399)],
            ).createShader(bounds),
            child: Text(
              'EGP ${_formatNumber(gym.stats.totalRevenue)}',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ActionIconButton(
                icon: Icons.edit_outlined,
                tooltip: 'Edit',
                color: AppColors.info,
                onTap: () => context.go('${RoutePaths.adminEditGym}/${gym.id}'),
              ),
              SizedBox(width: 6.w),
              ActionIconButton(
                icon: Icons.visibility_outlined,
                tooltip: "View",
                color: AppColors.gold,
                onTap: () => _showGymDetails(context, gym),
              ),
              SizedBox(width: 6.w),
              _buildMoreMenu(context, gym),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoreMenu(BuildContext context, AdminGym gym) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return PopupMenuButton<String>(
      icon: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          gradient: LinearGradient(
            colors: [
              colorScheme.onSurfaceVariant.withValues(alpha: isDark ? 0.15 : 0.1),
              colorScheme.onSurfaceVariant.withValues(alpha: isDark ? 0.08 : 0.05),
            ],
          ),
        ),
        child: Icon(
          Icons.more_vert_rounded,
          color: colorScheme.onSurfaceVariant,
          size: 18.sp,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      color: isDark ? const Color(0xFF1E1B4B) : Colors.white,
      elevation: 8,
      itemBuilder: (context) => [
        if (gym.status != GymStatus.active)
          PopupMenuItem(
            value: "activate",
            child: PopupMenuItemContent(
              icon: Icons.check_circle_outline,
              label: 'Activate',
              color: AppColors.success,
            ),
          ),
        if (gym.status != GymStatus.blocked)
          PopupMenuItem(
            value: "block",
            child: PopupMenuItemContent(
              icon: Icons.block_rounded,
              label: 'Block',
              color: AppColors.error,
            ),
          ),
        if (gym.status != GymStatus.suspended)
          PopupMenuItem(
            value: 'suspend',
            child: PopupMenuItemContent(
              icon: Icons.pause_circle_outline,
              label: 'Suspend',
              color: AppColors.warning,
            ),
          ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'delete',
          child: PopupMenuItemContent(
            icon: Icons.delete_outline,
            label: 'Delete',
            color: AppColors.error,
          ),
        ),
      ],
      onSelected: (value) => _handleGymAction(context, gym, value),
    );
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toStringAsFixed(0);
  }

  void _showGymDetails(BuildContext context, AdminGym gym) {
    // Show gym details dialog or navigate
  }

  void _handleGymAction(BuildContext context, AdminGym gym, String action) async {
    final cubit = context.read<AdminCubit>();

    switch (action) {
      case 'activate':
        await cubit.changeGymStatus(gym.id, GymStatus.active);
        break;
      case 'block':
        await cubit.changeGymStatus(gym.id, GymStatus.blocked);
        break;
      case 'suspend':
        await cubit.changeGymStatus(gym.id, GymStatus.suspended);
        break;
      case 'delete':
        _showDeleteConfirmation(context, gym);
        break;
    }
  }

  void _showDeleteConfirmation(BuildContext context, AdminGym gym) {
    final isDark = context.isDarkMode;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1B4B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text(
          'Delete ${gym.name}?',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          "This action cannot be undone.",
          style: GoogleFonts.raleway(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Cancel",
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              gradient: LinearGradient(
                colors: [AppColors.error, const Color(0xFFF87171)],
              ),
            ),
            child: TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await context.read<AdminCubit>().deleteGym(gym.id);
              },
              child: Text(
                "Delete",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(
    BuildContext context,
    int currentPage,
    int totalPages,
    bool hasMore,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Container(
      margin: EdgeInsets.all(24.r),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1E1B4B).withValues(alpha: 0.9),
                  const Color(0xFF312E81).withValues(alpha: 0.8),
                ]
              : [
                  Colors.white.withValues(alpha: 0.95),
                  const Color(0xFFF5F0FF).withValues(alpha: 0.9),
                ],
        ),
        border: Border.all(
          color: isDark
              ? AppColors.gold.withValues(alpha: 0.2)
              : AppColors.gold.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PaginationButton(
            icon: Icons.chevron_left_rounded,
            enabled: currentPage > 1,
            onTap: () {
              final cubit = context.read<AdminCubit>();
              cubit.loadGyms(
                filter: cubit.currentFilter.copyWith(page: currentPage - 1),
              );
            },
          ),
          SizedBox(width: 20.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              gradient: LinearGradient(
                colors: [
                  AppColors.gold.withValues(alpha: isDark ? 0.15 : 0.1),
                  AppColors.gold.withValues(alpha: isDark ? 0.08 : 0.05),
                ],
              ),
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Text(
                  "Page ",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                  ),
                ),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
                  ).createShader(bounds),
                  child: Text(
                    "$currentPage",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  " of $totalPages",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20.w),
          PaginationButton(
            icon: Icons.chevron_right_rounded,
            enabled: hasMore,
            onTap: () => context.read<AdminCubit>().loadNextPage(),
          ),
        ],
      ),
    );
  }
}

class _SparkleData {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double size;

  _SparkleData({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.size,
  });
}
