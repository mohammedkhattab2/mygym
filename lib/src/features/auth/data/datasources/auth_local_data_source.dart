import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/user_model.dart';

/// Local data source for caching authentication data
/// 
/// Uses:
/// - [SecureStorageService] for tokens (encrypted)
/// - [Hive] for user data cache (fast access)
@lazySingleton
class AuthLocalDataSource {
  final SecureStorageService _secureStorage;
  final Box<String> _userBox;

  AuthLocalDataSource(
    this._secureStorage,
    @Named('userBox') this._userBox,
  );

  // ==================== Token Management ====================

  /// Save access token securely
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(StorageKeys.accessToken, token);
  }

  /// Get saved access token
  Future<String?> getAccessToken() async {
    return _secureStorage.read(StorageKeys.accessToken);
  }

  /// Save refresh token securely
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(StorageKeys.refreshToken, token);
  }

  /// Get saved refresh token
  Future<String?> getRefreshToken() async {
    return _secureStorage.read(StorageKeys.refreshToken);
  }

  /// Save token expiry timestamp
  Future<void> saveTokenExpiry(DateTime expiry) async {
    await _secureStorage.write(
      StorageKeys.tokenExpiry,
      expiry.toIso8601String(),
    );
  }

  /// Get token expiry timestamp
  Future<DateTime?> getTokenExpiry() async {
    final expiryString = await _secureStorage.read(StorageKeys.tokenExpiry);
    if (expiryString != null) {
      return DateTime.tryParse(expiryString);
    }
    return null;
  }

  /// Check if token is expired
  Future<bool> isTokenExpired() async {
    final expiry = await getTokenExpiry();
    if (expiry == null) return true;
    return DateTime.now().isAfter(expiry);
  }

  /// Clear all tokens
  Future<void> clearTokens() async {
    await _secureStorage.delete(StorageKeys.accessToken);
    await _secureStorage.delete(StorageKeys.refreshToken);
    await _secureStorage.delete(StorageKeys.tokenExpiry);
  }

  // ==================== User Data Management ====================

  /// Cache user data
  Future<void> cacheUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _userBox.put(StorageKeys.cachedUser, userJson);
  }

  /// Get cached user data
  UserModel? getCachedUser() {
    final userJson = _userBox.get(StorageKeys.cachedUser);
    if (userJson != null) {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    }
    return null;
  }

  /// Clear cached user data
  Future<void> clearCachedUser() async {
    await _userBox.delete(StorageKeys.cachedUser);
  }

  // ==================== Session Management ====================

  /// Check if user is logged in (has valid token)
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    if (token == null) return false;
    
    final isExpired = await isTokenExpired();
    return !isExpired;
  }

  /// Save complete auth response (tokens + user)
  Future<void> saveAuthResponse(AuthResponseModel response) async {
    await saveAccessToken(response.accessToken);
    
    if (response.refreshToken != null) {
      await saveRefreshToken(response.refreshToken!);
    }
    
    if (response.expiresIn != null) {
      final expiry = DateTime.now().add(
        Duration(seconds: response.expiresIn!),
      );
      await saveTokenExpiry(expiry);
    }
    
    await cacheUser(response.user);
  }

  /// Clear all auth data (logout)
  Future<void> clearAllAuthData() async {
    await clearTokens();
    await clearCachedUser();
    await _secureStorage.delete(StorageKeys.isOnboardingComplete);
  }

  // ==================== Onboarding State ====================

  /// Check if onboarding is complete
  Future<bool> isOnboardingComplete() async {
    final value = await _secureStorage.read(StorageKeys.isOnboardingComplete);
    return value == 'true';
  }

  /// Mark onboarding as complete
  Future<void> setOnboardingComplete() async {
    await _secureStorage.write(StorageKeys.isOnboardingComplete, 'true');
  }

  // ==================== Guest Mode ====================

  /// Check if user is in guest mode
  bool isGuestMode() {
    final user = getCachedUser();
    return user?.roleString == 'guest';
  }

  /// Save guest user session
  Future<void> saveGuestSession() async {
    final guestUser = UserModel(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      email: '',
      roleString: 'guest',
    );
    await cacheUser(guestUser);
  }

  // ==================== FCM Token ====================

  /// Save FCM token for push notifications
  Future<void> saveFcmToken(String token) async {
    await _secureStorage.write(StorageKeys.fcmToken, token);
  }

  /// Get saved FCM token
  Future<String?> getFcmToken() async {
    return _secureStorage.read(StorageKeys.fcmToken);
  }

}