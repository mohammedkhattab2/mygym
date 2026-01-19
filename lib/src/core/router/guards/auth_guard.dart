import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../storage/secure_storage.dart';

/// Guard to check if user is authenticated
@lazySingleton
class AuthGuard {
  AuthGuard(this._secureStorage);
  
  final SecureStorageService _secureStorage;

  /// Returns redirect path if not authenticated, null if allowed
  Future<String?> canActivate(BuildContext context, String location) async {
    final token = await _secureStorage.getAccessToken();
    
    if (token == null || token.isEmpty) {
      // Not authenticated, redirect to login
      return '/auth/login';
    }
    
    return null; // Allowed
  }

  /// Check if user is authenticated (synchronous check with cached value)
  bool isAuthenticated = false;

  /// Update authentication state
  Future<void> checkAuthState() async {
    final token = await _secureStorage.getAccessToken();
    isAuthenticated = token != null && token.isNotEmpty;
  }
}