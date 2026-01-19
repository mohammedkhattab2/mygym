import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../models/user_model.dart';

/// Remote data source for authentication API calls
///
/// Uses Dio for HTTP requests. All methods throw [DioException] on network errors.
abstract class AuthRemoteDataSource {
  /// Sign in with email and password
  Future<AuthResponseModel> signInWithEmail(Map<String, dynamic> body);

  /// Register new user with email and password
  Future<AuthResponseModel> register(Map<String, dynamic> body);

  /// Sign in with social provider (Google/Apple)
  Future<AuthResponseModel> signInWithSocial(SocialLoginModel body);

  /// Request OTP for phone number
  Future<void> requestOtp(OtpRequestModel body);

  /// Verify OTP and sign in
  Future<AuthResponseModel> verifyOtp(OtpVerifyModel body);

  /// Refresh access token
  Future<AuthResponseModel> refreshToken(Map<String, dynamic> body);

  /// Get current user profile
  Future<UserModel> getCurrentUser();

  /// Update user profile
  Future<UserModel> updateProfile(Map<String, dynamic> body);

  /// Update user's city and interests (onboarding)
  Future<UserModel> updatePreferences(Map<String, dynamic> body);

  /// Sign out (invalidate token on server)
  Future<void> signOut();

  /// Request password reset
  Future<void> requestPasswordReset(Map<String, dynamic> body);

  /// Delete user account
  Future<void> deleteAccount();
}

/// Implementation of [AuthRemoteDataSource] using Dio
@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<AuthResponseModel> signInWithEmail(Map<String, dynamic> body) async {
    final response = await _dio.post(ApiEndpoints.login, data: body);
    return AuthResponseModel.fromJson(response.data);
  }

  @override
  Future<AuthResponseModel> register(Map<String, dynamic> body) async {
    final response = await _dio.post(ApiEndpoints.register, data: body);
    return AuthResponseModel.fromJson(response.data);
  }

  @override
  Future<AuthResponseModel> signInWithSocial(SocialLoginModel body) async {
    final response = await _dio.post(
      ApiEndpoints.socialLogin,
      data: body.toJson(),
    );
    return AuthResponseModel.fromJson(response.data);
  }

  @override
  Future<void> requestOtp(OtpRequestModel body) async {
    await _dio.post(ApiEndpoints.requestOtp, data: body.toJson());
  }

  @override
  Future<AuthResponseModel> verifyOtp(OtpVerifyModel body) async {
    final response = await _dio.post(
      ApiEndpoints.verifyOtp,
      data: body.toJson(),
    );
    return AuthResponseModel.fromJson(response.data);
  }

  @override
  Future<AuthResponseModel> refreshToken(Map<String, dynamic> body) async {
    final response = await _dio.post(ApiEndpoints.refreshToken, data: body);
    return AuthResponseModel.fromJson(response.data);
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await _dio.get(ApiEndpoints.userProfile);
    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> updateProfile(Map<String, dynamic> body) async {
    final response = await _dio.put(ApiEndpoints.userProfile, data: body);
    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> updatePreferences(Map<String, dynamic> body) async {
    final response = await _dio.put(ApiEndpoints.updatePreferences, data: body);
    return UserModel.fromJson(response.data);
  }

  @override
  Future<void> signOut() async {
    await _dio.post(ApiEndpoints.logout);
  }

  @override
  Future<void> requestPasswordReset(Map<String, dynamic> body) async {
    await _dio.post(ApiEndpoints.forgotPassword, data: body);
  }

  @override
  Future<void> deleteAccount() async {
    await _dio.delete(ApiEndpoints.deleteAccount);
  }
}

/// Firebase Auth helper for social sign-in
///
/// Handles Firebase Authentication flows and returns ID tokens
/// that can be sent to the backend for verification.
@lazySingleton
class FirebaseAuthHelper {
  /// Sign in with Google and return ID token
  Future<String?> signInWithGoogle() async {
    // Implementation will use firebase_auth and google_sign_in packages
    // 1. Trigger Google Sign-In flow
    // 2. Get GoogleSignInAuthentication
    // 3. Create Firebase credential
    // 4. Sign in to Firebase
    // 5. Return ID token
    throw UnimplementedError('Implement with Firebase Auth');
  }

  /// Sign in with Apple and return ID token
  Future<String?> signInWithApple() async {
    // Implementation will use firebase_auth and sign_in_with_apple packages
    // 1. Request Apple credential
    // 2. Create Firebase credential
    // 3. Sign in to Firebase
    // 4. Return ID token
    throw UnimplementedError('Implement with Firebase Auth');
  }

  /// Verify phone number and trigger OTP
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    // Implementation will use firebase_auth
    // 1. Call verifyPhoneNumber
    // 2. Handle codeSent callback
    // 3. Handle verificationFailed callback
    throw UnimplementedError('Implement with Firebase Auth');
  }

  /// Verify OTP code
  Future<String?> verifyOtpCode({
    required String verificationId,
    required String smsCode,
  }) async {
    // Implementation will use firebase_auth
    // 1. Create PhoneAuthCredential
    // 2. Sign in to Firebase
    // 3. Return ID token
    throw UnimplementedError('Implement with Firebase Auth');
  }

  /// Sign out from Firebase
  Future<void> signOut() async {
    // Call FirebaseAuth.instance.signOut()
    throw UnimplementedError('Implement with Firebase Auth');
  }

  /// Get current Firebase user's ID token
  Future<String?> getIdToken() async {
    // Return currentUser?.getIdToken()
    throw UnimplementedError('Implement with Firebase Auth');
  }
}