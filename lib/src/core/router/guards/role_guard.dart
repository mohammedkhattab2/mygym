import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../storage/secure_storage.dart';
import '../route_paths.dart';

/// User roles in the application
enum UserRole {
  guest,
  member,
  partner,
  admin,
}

/// Guard to check user role and redirect accordingly
@lazySingleton
class RoleGuard {
  RoleGuard(this._secureStorage);
  
  final SecureStorageService _secureStorage;

  /// Current user role (cached)
  UserRole currentRole = UserRole.guest;

  /// Update role from storage
  Future<void> refreshRole() async {
    final roleString = await _secureStorage.getUserRole();
    currentRole = _parseRole(roleString);
  }

  /// Parse role string to enum
  UserRole _parseRole(String? role) {
    switch (role?.toLowerCase()) {
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

  /// Check if user has required role
  Future<String?> canActivate(
    BuildContext context,
    String location,
    List<UserRole> allowedRoles,
  ) async {
    await refreshRole();
    
    if (!allowedRoles.contains(currentRole)) {
      // Redirect based on current role
      return _getDefaultRouteForRole(currentRole);
    }
    
    return null; // Allowed
  }

  /// Get default route for a given role
  String _getDefaultRouteForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return RoutePaths.adminDashboard;
      case UserRole.partner:
        return RoutePaths.partnerDashboard;
      case UserRole.member:
        return RoutePaths.memberHome;
      case UserRole.guest:
        return RoutePaths.login;
    }
  }

  /// Check if current user is admin
  bool get isAdmin => currentRole == UserRole.admin;

  /// Check if current user is partner
  bool get isPartner => currentRole == UserRole.partner;

  /// Check if current user is member
  bool get isMember => currentRole == UserRole.member;

  /// Check if current user is guest
  bool get isGuest => currentRole == UserRole.guest;
}