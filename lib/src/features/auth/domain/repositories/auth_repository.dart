import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

/// Authentication repository interface
///
/// Uses `Either<Failure, T>` for functional error handling.
/// Left side contains the failure, Right side contains the success value.
abstract class AuthRepository {
  /// Get current authenticated user
  Future<Either<Failure, User>> getCurrentUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Check if onboarding is complete
  Future<bool> isOnboardingComplete();

  /// Check if in guest mode
  bool isGuestMode();

  /// Get access token
  Future<String?> getAccessToken();

  /// Sign in with email and password
  Future<Either<Failure, User>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign in with Google
  Future<Either<Failure, User>> signInWithGoogle();

  /// Sign in with Apple
  Future<Either<Failure, User>> signInWithApple();

  /// Request OTP to phone number
  Future<Either<Failure, void>> requestOtp({required String phone});

  /// Verify OTP code
  Future<Either<Failure, User>> verifyOtp({
    required String phone,
    required String otp,
  });

  /// Continue as guest
  Future<Either<Failure, User>> continueAsGuest();

  /// Register with email and password
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  });

  /// Sign out current user
  Future<Either<Failure, void>> signOut();

  /// Request password reset
  Future<Either<Failure, void>> requestPasswordReset({required String email});

  /// Update user profile
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? phone,
    String? photoUrl,
  });

  /// Update user city and interests (onboarding completion)
  Future<Either<Failure, User>> updatePreferences({
    required String city,
    required List<String> interests,
  });

  /// Delete user account
  Future<Either<Failure, void>> deleteAccount();

  /// Refresh authentication token
  Future<Either<Failure, void>> refreshToken();
}