/// User entity representing authenticated user
class User {
  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.name,
    this.phoneNumber,
    this.phone,
    this.photoUrl,
    this.role = UserRole.member,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.createdAt,
    this.lastLoginAt,
    this.city,
    this.selectedCity,
    this.interests = const [],
    this.subscriptionStatus,
    this.remainingVisits,
    this.points = 0,
    this.referralCode,
  });

  final String id;
  final String email;
  final String? displayName;
  final String? name;
  final String? phoneNumber;
  final String? phone;
  final String? photoUrl;
  final UserRole role;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;
  final String? city;
  final String? selectedCity;
  final List<String> interests;
  final String? subscriptionStatus;
  final int? remainingVisits;
  final int points;
  final String? referralCode;

  /// Check if user has completed onboarding
  bool get hasCompletedOnboarding => (city != null || selectedCity != null) && interests.isNotEmpty;

  /// Check if user is guest
  bool get isGuest => role == UserRole.guest;

  /// Check if user is admin
  bool get isAdmin => role == UserRole.admin;

  /// Check if user is partner
  bool get isPartner => role == UserRole.partner;

  /// Check if user is member
  bool get isMember => role == UserRole.member;

  /// Create a copy with updated fields
  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? name,
    String? phoneNumber,
    String? phone,
    String? photoUrl,
    UserRole? role,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? city,
    String? selectedCity,
    List<String>? interests,
    String? subscriptionStatus,
    int? remainingVisits,
    int? points,
    String? referralCode,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      city: city ?? this.city,
      selectedCity: selectedCity ?? this.selectedCity,
      interests: interests ?? this.interests,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      remainingVisits: remainingVisits ?? this.remainingVisits,
      points: points ?? this.points,
      referralCode: referralCode ?? this.referralCode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, email: $email, displayName: $displayName, role: $role)';
  }
}

/// User roles in the application
enum UserRole {
  guest,
  member,
  partner,
  admin,
}

/// Extension to convert string to UserRole
extension UserRoleExtension on String {
  UserRole toUserRole() {
    switch (toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'partner':
        return UserRole.partner;
      case 'member':
        return UserRole.member;
      default:
        return UserRole.guest;
    }
  }
}

/// Extension to convert UserRole to string
extension UserRoleStringExtension on UserRole {
  String toRoleString() {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.partner:
        return 'partner';
      case UserRole.member:
        return 'member';
      case UserRole.guest:
        return 'guest';
    }
  }
}