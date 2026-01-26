import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/luxury_theme_extension.dart';
import '../../domain/entities/admin_gym.dart';

/// Admin gym data table widget
class AdminGymTable extends StatelessWidget {
  final List<AdminGym> gyms;
  final bool isCompact;
  final void Function(AdminGym gym)? onView;
  final void Function(AdminGym gym)? onEdit;
  final void Function(AdminGym gym)? onDelete;
  final void Function(AdminGym gym, GymStatus status)? onStatusChange;
  final void Function(AdminGymSortBy sortBy, bool ascending)? onSort;

  const AdminGymTable({
    super.key,
    required this.gyms,
    this.isCompact = false,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.onStatusChange,
    this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    if (gyms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.store_outlined,
              size: 64.sp,
              color: luxury.textTertiary,
            ),
            SizedBox(height: 16.h),
            Text(
              'No gyms found',
              style: TextStyle(
                fontSize: 16.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(colorScheme.surface),
          dataRowMinHeight: 60.h,
          dataRowMaxHeight: 80.h,
          columnSpacing: 24.w,
          horizontalMargin: 16.w,
          columns: _buildColumns(context),
          rows: gyms.map((gym) => _buildRow(context, gym)).toList(),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns(BuildContext context) {
    final columns = <DataColumn>[
      DataColumn(
        label: _SortableHeader(
          title: 'Name',
          sortBy: AdminGymSortBy.name,
          onSort: onSort,
        ),
      ),
      DataColumn(
        label: _SortableHeader(
          title: 'City',
          sortBy: AdminGymSortBy.city,
          onSort: onSort,
        ),
      ),
      DataColumn(
        label: _SortableHeader(
          title: 'Status',
          sortBy: AdminGymSortBy.status,
          onSort: onSort,
        ),
      ),
      DataColumn(
        label: _SortableHeader(
          title: 'Date Added',
          sortBy: AdminGymSortBy.dateAdded,
          onSort: onSort,
        ),
      ),
    ];

    if (!isCompact) {
      columns.addAll([
        DataColumn(
          label: _SortableHeader(
            title: 'Visits',
            sortBy: AdminGymSortBy.totalVisits,
            onSort: onSort,
          ),
          numeric: true,
        ),
        DataColumn(
          label: _SortableHeader(
            title: 'Rating',
            sortBy: AdminGymSortBy.rating,
            onSort: onSort,
          ),
          numeric: true,
        ),
        DataColumn(
          label: _SortableHeader(
            title: 'Revenue',
            sortBy: AdminGymSortBy.revenue,
            onSort: onSort,
          ),
          numeric: true,
        ),
      ]);
    }

    columns.add(
      const DataColumn(
        label: Text('Actions'),
      ),
    );

    return columns;
  }

  DataRow _buildRow(BuildContext context, AdminGym gym) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    final cells = <DataCell>[
      DataCell(
        InkWell(
          onTap: () => onView?.call(gym),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (gym.imageUrls.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    gym.imageUrls.first,
                    width: 40.w,
                    height: 40.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, e, st) => Container(
                      width: 40.w,
                      height: 40.w,
                      color: colorScheme.outline.withValues(alpha: 0.3),
                      child: Icon(Icons.store, size: 20.sp, color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                )
              else
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.store,
                    size: 20.sp,
                    color: colorScheme.primary,
                  ),
                ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    gym.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (gym.partnerEmail != null)
                    Text(
                      gym.partnerEmail!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      DataCell(Text(gym.city, style: TextStyle(color: colorScheme.onSurface))),
      DataCell(_StatusBadge(status: gym.status)),
      DataCell(Text(_formatDate(gym.dateAdded), style: TextStyle(color: colorScheme.onSurface))),
    ];

    if (!isCompact) {
      cells.addAll([
        DataCell(Text(gym.stats.totalVisits.toString(), style: TextStyle(color: colorScheme.onSurface))),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, size: 16.sp, color: luxury.gold),
              SizedBox(width: 4.w),
              Text('${gym.stats.averageRating.toStringAsFixed(1)} (${gym.stats.totalReviews})', style: TextStyle(color: colorScheme.onSurface)),
            ],
          ),
        ),
        DataCell(Text('\$${gym.stats.totalRevenue.toStringAsFixed(2)}', style: TextStyle(color: colorScheme.onSurface))),
      ]);
    }

    cells.add(
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility_outlined),
              onPressed: () => onView?.call(gym),
              tooltip: 'View Details',
              iconSize: 20.sp,
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => onEdit?.call(gym),
              tooltip: 'Edit',
              iconSize: 20.sp,
            ),
            PopupMenuButton<GymStatus>(
              icon: Icon(Icons.more_vert, size: 20.sp),
              tooltip: 'More Actions',
              onSelected: (status) => onStatusChange?.call(gym, status),
              itemBuilder: (context) => [
                if (gym.status != GymStatus.active)
                  const PopupMenuItem(
                    value: GymStatus.active,
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Activate'),
                      ],
                    ),
                  ),
                if (gym.status != GymStatus.blocked)
                  const PopupMenuItem(
                    value: GymStatus.blocked,
                    child: Row(
                      children: [
                        Icon(Icons.block, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Block'),
                      ],
                    ),
                  ),
                if (gym.status != GymStatus.suspended)
                  const PopupMenuItem(
                    value: GymStatus.suspended,
                    child: Row(
                      children: [
                        Icon(Icons.pause_circle, color: Colors.orange),
                        SizedBox(width: 8),
                        Text('Suspend'),
                      ],
                    ),
                  ),
                if (onDelete != null) ...[
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: null,
                    onTap: () => onDelete?.call(gym),
                    child: const Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );

    return DataRow(cells: cells);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Sortable header widget
class _SortableHeader extends StatelessWidget {
  final String title;
  final AdminGymSortBy sortBy;
  final void Function(AdminGymSortBy sortBy, bool ascending)? onSort;

  const _SortableHeader({
    required this.title,
    required this.sortBy,
    this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return InkWell(
      onTap: () => onSort?.call(sortBy, true),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(width: 4.w),
          Icon(Icons.unfold_more, size: 16.sp, color: colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}

/// Status badge widget
class _StatusBadge extends StatelessWidget {
  final GymStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(context);
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            status.displayName,
            style: TextStyle(
              color: statusColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    switch (status) {
      case GymStatus.pending:
        return luxury.gold;
      case GymStatus.active:
        return luxury.success;
      case GymStatus.blocked:
        return colorScheme.error;
      case GymStatus.suspended:
        return colorScheme.onSurfaceVariant;
    }
  }
}