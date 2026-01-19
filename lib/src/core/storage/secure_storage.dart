import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../constants/storage_keys.dart';

/// Service for secure storage operations
@lazySingleton
class SecureStorageService {
  SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  // ==================== Generic Methods ====================

  /// Read a value by key
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Write a value by key
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Delete a value by key
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  // ==================== Specific Methods ====================

  /// Get access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: StorageKeys.accessToken);
  }

  /// Save access token
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: StorageKeys.accessToken, value: token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: StorageKeys.refreshToken);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: StorageKeys.refreshToken, value: token);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: StorageKeys.userId);
  }

  /// Save user ID
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: StorageKeys.userId, value: userId);
  }

  /// Get user role
  Future<String?> getUserRole() async {
    return await _storage.read(key: StorageKeys.userRole);
  }

  /// Save user role
  Future<void> saveUserRole(String role) async {
    await _storage.write(key: StorageKeys.userRole, value: role);
  }

  /// Save tokens (access and refresh)
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
    ]);
  }

  /// Clear all auth data
  Future<void> clearAuth() async {
    await Future.wait([
      _storage.delete(key: StorageKeys.accessToken),
      _storage.delete(key: StorageKeys.refreshToken),
      _storage.delete(key: StorageKeys.tokenExpiry),
      _storage.delete(key: StorageKeys.userId),
      _storage.delete(key: StorageKeys.userRole),
    ]);
  }

  /// Clear all stored data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}