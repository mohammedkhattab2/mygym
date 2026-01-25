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