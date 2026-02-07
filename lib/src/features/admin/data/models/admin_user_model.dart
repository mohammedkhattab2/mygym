import '../../domain/entities/admin_user.dart';

class AdminUserModel extends AdminUser {
  const AdminUserModel({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
    super.avatarUrl,
    required super.role,
    required super.status,
    required super.subscriptionStatus,
    super.subscriptionTier,
    required super.createdAt,
    super.lastActiveAt,
    super.totalVisits,
    super.totalSpent,
    super.city,
    super.linkedGymId,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      avatarUrl: json['avatar_url'],
      role: UserRole.values.firstWhere(
        (r) => r.name == json['role'],
        orElse: () => UserRole.member,
      ),
      status: UserStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => UserStatus.active,
      ),
      subscriptionStatus: UserSubscriptionStatus.values.firstWhere(
        (s) => s.name == json['subscription_status'],
        orElse: () => UserSubscriptionStatus.none,
      ),
      subscriptionTier: json['subscription_tier'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      lastActiveAt: json['last_active_at'] != null 
          ? DateTime.tryParse(json['last_active_at']) 
          : null,
      totalVisits: json['total_visits'] ?? 0,
      totalSpent: (json['total_spent'] ?? 0).toDouble(),
      city: json['city'],
      linkedGymId: json['linked_gym_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar_url': avatarUrl,
      'role': role.name,
      'status': status.name,
      'subscription_status': subscriptionStatus.name,
      'subscription_tier': subscriptionTier,
      'created_at': createdAt.toIso8601String(),
      'last_active_at': lastActiveAt?.toIso8601String(),
      'total_visits': totalVisits,
      'total_spent': totalSpent,
      'city': city,
      'linked_gym_id': linkedGymId,
    };
  }

  factory AdminUserModel.fromEntity(AdminUser entity) {
    return AdminUserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      avatarUrl: entity.avatarUrl,
      role: entity.role,
      status: entity.status,
      subscriptionStatus: entity.subscriptionStatus,
      subscriptionTier: entity.subscriptionTier,
      createdAt: entity.createdAt,
      lastActiveAt: entity.lastActiveAt,
      totalVisits: entity.totalVisits,
      totalSpent: entity.totalSpent,
      city: entity.city,
      linkedGymId: entity.linkedGymId,
    );
  }
}

class UsersStatsModel extends UsersStats {
  const UsersStatsModel({
    super.totalUsers,
    super.activeUsers,
    super.suspendedUsers,
    super.blockedUsers,
    super.totalMembers,
    super.totalPartners,
    super.totalAdmins,
    super.usersWithActiveSubscription,
    super.newUsersThisMonth,
    super.newUsersThisWeek,
  });

  factory UsersStatsModel.fromJson(Map<String, dynamic> json) {
    return UsersStatsModel(
      totalUsers: json['total_users'] ?? 0,
      activeUsers: json['active_users'] ?? 0,
      suspendedUsers: json['suspended_users'] ?? 0,
      blockedUsers: json['blocked_users'] ?? 0,
      totalMembers: json['total_members'] ?? 0,
      totalPartners: json['total_partners'] ?? 0,
      totalAdmins: json['total_admins'] ?? 0,
      usersWithActiveSubscription: json['users_with_active_subscription'] ?? 0,
      newUsersThisMonth: json['new_users_this_month'] ?? 0,
      newUsersThisWeek: json['new_users_this_week'] ?? 0,
    );
  }
}