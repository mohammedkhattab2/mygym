/// User role enum
enum UserRole {
  member,
  partner,
  admin,
}

extension UserRoleX on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.member: return 'Member';
      case UserRole.partner: return 'Partner';
      case UserRole.admin: return 'Admin';
    }
  }
}

/// User status enum
enum UserStatus {
  active,
  suspended,
  blocked,
}

extension UserStatusX on UserStatus {
  String get displayName {
    switch (this) {
      case UserStatus.active: return 'Active';
      case UserStatus.suspended: return 'Suspended';
      case UserStatus.blocked: return 'Blocked';
    }
  }
}

/// Subscription status for users
enum UserSubscriptionStatus {
  none,
  active,
  expired,
  cancelled,
}

/// Admin User entity
class AdminUser {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final UserRole role;
  final UserStatus status;
  final UserSubscriptionStatus subscriptionStatus;
  final String? subscriptionTier;
  final DateTime createdAt;
  final DateTime? lastActiveAt;
  final int totalVisits;
  final double totalSpent;
  final String? city;
  final String? linkedGymId; // For partners

  const AdminUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    required this.role,
    required this.status,
    required this.subscriptionStatus,
    this.subscriptionTier,
    required this.createdAt,
    this.lastActiveAt,
    this.totalVisits = 0,
    this.totalSpent = 0,
    this.city,
    this.linkedGymId,
  });

  AdminUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    UserRole? role,
    UserStatus? status,
    UserSubscriptionStatus? subscriptionStatus,
    String? subscriptionTier,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    int? totalVisits,
    double? totalSpent,
    String? city,
    String? linkedGymId,
  }) {
    return AdminUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      totalVisits: totalVisits ?? this.totalVisits,
      totalSpent: totalSpent ?? this.totalSpent,
      city: city ?? this.city,
      linkedGymId: linkedGymId ?? this.linkedGymId,
    );
  }
}

/// Filter for admin users list
class AdminUserFilter {
  final String? searchQuery;
  final UserRole? role;
  final UserStatus? status;
  final UserSubscriptionStatus? subscriptionStatus;
  final String? city;
  final AdminUserSortBy sortBy;
  final bool sortAscending;
  final int page;
  final int pageSize;

  const AdminUserFilter({
    this.searchQuery,
    this.role,
    this.status,
    this.subscriptionStatus,
    this.city,
    this.sortBy = AdminUserSortBy.createdAt,
    this.sortAscending = false,
    this.page = 1,
    this.pageSize = 20,
  });

  AdminUserFilter copyWith({
    String? searchQuery,
    UserRole? role,
    UserStatus? status,
    UserSubscriptionStatus? subscriptionStatus,
    String? city,
    AdminUserSortBy? sortBy,
    bool? sortAscending,
    int? page,
    int? pageSize,
  }) {
    return AdminUserFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      role: role ?? this.role,
      status: status ?? this.status,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      city: city ?? this.city,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  AdminUserFilter clearFilters() {
    return const AdminUserFilter();
  }
}

/// Sort options
enum AdminUserSortBy {
  name,
  email,
  createdAt,
  lastActiveAt,
  totalVisits,
  totalSpent,
}

/// Paginated users response
class PaginatedUsers {
  final List<AdminUser> users;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  const PaginatedUsers({
    required this.users,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
  });
}

/// User statistics for dashboard
class UsersStats {
  final int totalUsers;
  final int activeUsers;
  final int suspendedUsers;
  final int blockedUsers;
  final int totalMembers;
  final int totalPartners;
  final int totalAdmins;
  final int usersWithActiveSubscription;
  final int newUsersThisMonth;
  final int newUsersThisWeek;

  const UsersStats({
    this.totalUsers = 0,
    this.activeUsers = 0,
    this.suspendedUsers = 0,
    this.blockedUsers = 0,
    this.totalMembers = 0,
    this.totalPartners = 0,
    this.totalAdmins = 0,
    this.usersWithActiveSubscription = 0,
    this.newUsersThisMonth = 0,
    this.newUsersThisWeek = 0,
  });
}