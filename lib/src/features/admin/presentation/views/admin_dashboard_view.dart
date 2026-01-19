import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/admin_gym.dart';
import '../bloc/admin_dashboard_cubit.dart';
import '../widgets/admin_gym_table.dart';
import '../widgets/admin_stats_cards.dart';
import '../widgets/gym_form_dialog.dart';

/// Admin Dashboard View
/// Web layout with NavigationRail and data tables
class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<AdminDashboardCubit>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Navigation Rail for web
          _buildNavigationRail(),
          
          // Vertical divider
          const VerticalDivider(thickness: 1, width: 1),
          
          // Main content area
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRail() {
    return NavigationRail(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() => _selectedIndex = index);
      },
      extended: MediaQuery.of(context).size.width > 1200,
      minExtendedWidth: 200,
      backgroundColor: AppColors.surface,
      leading: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          children: [
            Icon(
              Icons.fitness_center,
              size: 32.sp,
              color: AppColors.primary,
            ),
            SizedBox(height: 8.h),
            if (MediaQuery.of(context).size.width > 1200)
              Text(
                'MyGym Admin',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.store_outlined),
          selectedIcon: Icon(Icons.store),
          label: Text('Gyms'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.people_outlined),
          selectedIcon: Icon(Icons.people),
          label: Text('Users'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.subscriptions_outlined),
          selectedIcon: Icon(Icons.subscriptions),
          label: Text('Subscriptions'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics),
          label: Text('Reports'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
      trailing: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _handleLogout(),
              tooltip: 'Logout',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return BlocConsumer<AdminDashboardCubit, AdminDashboardState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: AppColors.error,
            ),
          );
          context.read<AdminDashboardCubit>().clearMessages();
        }
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: AppColors.success,
            ),
          );
          context.read<AdminDashboardCubit>().clearMessages();
        }
        if (state.isFormOpen) {
          _showGymFormDialog(state.selectedGym);
        }
      },
      builder: (context, state) {
        switch (_selectedIndex) {
          case 0:
            return _buildDashboardContent(state);
          case 1:
            return _buildGymsContent(state);
          case 2:
            return _buildUsersContent();
          case 3:
            return _buildSubscriptionsContent();
          case 4:
            return _buildReportsContent();
          case 5:
            return _buildSettingsContent();
          default:
            return _buildDashboardContent(state);
        }
      },
    );
  }

  Widget _buildDashboardContent(AdminDashboardState state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dashboard Overview',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => context.read<AdminDashboardCubit>().loadDashboardStats(),
                    tooltip: 'Refresh',
                  ),
                  SizedBox(width: 8.w),
                  _buildDateRangePicker(),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Stats cards
          if (state.isLoadingStats)
            const Center(child: CircularProgressIndicator())
          else if (state.stats != null)
            AdminStatsCards(stats: state.stats!),

          SizedBox(height: 32.h),

          // Quick actions
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 16.w,
            runSpacing: 16.h,
            children: [
              _buildQuickActionCard(
                icon: Icons.add_business,
                title: 'Add New Gym',
                onTap: () => context.read<AdminDashboardCubit>().openAddGymForm(),
              ),
              _buildQuickActionCard(
                icon: Icons.pending_actions,
                title: 'Pending Approvals',
                badge: state.stats?.pendingGyms.toString(),
                onTap: () {
                  setState(() => _selectedIndex = 1);
                  context.read<AdminDashboardCubit>().filterByStatus(GymStatus.pending);
                },
              ),
              _buildQuickActionCard(
                icon: Icons.download,
                title: 'Export Report',
                onTap: () => context.read<AdminDashboardCubit>().exportToCSV(),
              ),
            ],
          ),

          SizedBox(height: 32.h),

          // Recent gyms table
          Text(
            'Recent Gyms',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          if (state.gyms != null && state.gyms!.gyms.isNotEmpty)
            AdminGymTable(
              gyms: state.gyms!.gyms.take(5).toList(),
              isCompact: true,
              onView: (gym) => _showGymDetails(gym),
              onEdit: (gym) => context.read<AdminDashboardCubit>().openEditGymForm(gym),
              onStatusChange: (gym, status) => 
                  context.read<AdminDashboardCubit>().changeGymStatus(gym.id, status),
            ),
        ],
      ),
    );
  }

  Widget _buildGymsContent(AdminDashboardState state) {
    return Column(
      children: [
        // Header with filters
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Gym Management',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => context.read<AdminDashboardCubit>().openAddGymForm(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Gym'),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _buildFiltersRow(state),
            ],
          ),
        ),

        // Table
        Expanded(
          child: state.isLoadingGyms
              ? const Center(child: CircularProgressIndicator())
              : state.gyms != null
                  ? AdminGymTable(
                      gyms: state.gyms!.gyms,
                      isCompact: false,
                      onView: (gym) => _showGymDetails(gym),
                      onEdit: (gym) => context.read<AdminDashboardCubit>().openEditGymForm(gym),
                      onDelete: (gym) => _confirmDeleteGym(gym),
                      onStatusChange: (gym, status) => 
                          context.read<AdminDashboardCubit>().changeGymStatus(gym.id, status),
                      onSort: (sortBy, ascending) =>
                          context.read<AdminDashboardCubit>().sortGyms(sortBy, ascending: ascending),
                    )
                  : const Center(child: Text('No gyms found')),
        ),

        // Pagination
        if (state.gyms != null)
          _buildPagination(state),
      ],
    );
  }

  Widget _buildFiltersRow(AdminDashboardState state) {
    return Row(
      children: [
        // Search
        SizedBox(
          width: 300.w,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search gyms...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
            onChanged: (value) => context.read<AdminDashboardCubit>().searchGyms(value),
          ),
        ),
        SizedBox(width: 16.w),

        // Status filter
        SizedBox(
          width: 150.w,
          child: DropdownButtonFormField<GymStatus?>(
            // ignore: deprecated_member_use
            value: state.filter.status,
            decoration: InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('All')),
              ...GymStatus.values.map((status) => DropdownMenuItem(
                value: status,
                child: Text(status.displayName),
              )),
            ],
            onChanged: (status) => context.read<AdminDashboardCubit>().filterByStatus(status),
          ),
        ),
        SizedBox(width: 16.w),

        // City filter
        SizedBox(
          width: 150.w,
          child: DropdownButtonFormField<String?>(
            // ignore: deprecated_member_use
            value: state.filter.city,
            decoration: InputDecoration(
              labelText: 'City',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('All Cities')),
              ...state.cities.map((city) => DropdownMenuItem(
                value: city.id,
                child: Text(city.name),
              )),
            ],
            onChanged: (city) => context.read<AdminDashboardCubit>().filterByCity(city),
          ),
        ),

        const Spacer(),

        // Export button
        OutlinedButton.icon(
          onPressed: () => context.read<AdminDashboardCubit>().exportToCSV(),
          icon: const Icon(Icons.download),
          label: const Text('Export CSV'),
        ),
      ],
    );
  }

  Widget _buildPagination(AdminDashboardState state) {
    final gyms = state.gyms!;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Showing ${gyms.gyms.length} of ${gyms.totalCount} gyms'),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: gyms.currentPage > 1
                    ? () => context.read<AdminDashboardCubit>().goToPage(gyms.currentPage - 1)
                    : null,
              ),
              Text('Page ${gyms.currentPage} of ${gyms.totalPages}'),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: gyms.hasMore
                    ? () => context.read<AdminDashboardCubit>().goToPage(gyms.currentPage + 1)
                    : null,
              ),
            ],
          ),
          DropdownButton<int>(
            value: state.filter.pageSize,
            items: [10, 20, 50, 100].map((size) => DropdownMenuItem(
              value: size,
              child: Text('$size per page'),
            )).toList(),
            onChanged: (size) {
              if (size != null) {
                context.read<AdminDashboardCubit>().changePageSize(size);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUsersContent() {
    return Center(
      child: Text(
        'Users Management - Coming Soon',
        style: TextStyle(fontSize: 18.sp),
      ),
    );
  }

  Widget _buildSubscriptionsContent() {
    return Center(
      child: Text(
        'Subscriptions Management - Coming Soon',
        style: TextStyle(fontSize: 18.sp),
      ),
    );
  }

  Widget _buildReportsContent() {
    return Center(
      child: Text(
        'Reports & Analytics - Coming Soon',
        style: TextStyle(fontSize: 18.sp),
      ),
    );
  }

  Widget _buildSettingsContent() {
    return Center(
      child: Text(
        'Admin Settings - Coming Soon',
        style: TextStyle(fontSize: 18.sp),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    String? badge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 180.w,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(icon, color: AppColors.primary),
                ),
                if (badge != null)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangePicker() {
    return OutlinedButton.icon(
      onPressed: () {
        // TODO: Implement date range picker
      },
      icon: const Icon(Icons.calendar_today, size: 18),
      label: const Text('Last 30 days'),
    );
  }

  void _showGymFormDialog(AdminGym? gym) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GymFormDialog(
        gym: gym,
        cities: context.read<AdminDashboardCubit>().state.cities,
        facilities: context.read<AdminDashboardCubit>().state.facilities,
        onSave: (formData) {
          if (gym != null) {
            context.read<AdminDashboardCubit>().updateGym(gym.id, formData);
          } else {
            context.read<AdminDashboardCubit>().addGym(formData);
          }
        },
        onCancel: () => context.read<AdminDashboardCubit>().closeForm(),
      ),
    );
  }

  void _showGymDetails(AdminGym gym) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(gym.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow('City', gym.city),
              _detailRow('Address', gym.address),
              _detailRow('Status', gym.status.displayName),
              _detailRow('Date Added', gym.dateAdded.toString()),
              _detailRow('Total Visits', gym.stats.totalVisits.toString()),
              _detailRow('Active Subscribers', gym.stats.activeSubscribers.toString()),
              _detailRow('Rating', '${gym.stats.averageRating} (${gym.stats.totalReviews} reviews)'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AdminDashboardCubit>().openEditGymForm(gym);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _confirmDeleteGym(AdminGym gym) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Gym'),
        content: Text('Are you sure you want to delete "${gym.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AdminDashboardCubit>().deleteGym(gym.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}