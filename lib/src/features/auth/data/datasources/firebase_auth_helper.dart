import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Helper class for Firebase Authentication with social providers
@lazySingleton
class FirebaseAuthHelper {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  FirebaseAuthHelper() : _firebaseAuth = firebase_auth.FirebaseAuth.instance;

  /// Get current Firebase user
  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

  /// Check if user is signed in
  bool get isSignedIn => currentUser != null;

  // ============================================
  // GOOGLE SIGN-IN
  // ============================================

  /// Sign in with Google and return Firebase ID token
  /// Returns null if cancelled
  Future<String?> signInWithGoogle() async {
    try {
      // Use FirebaseAuth's OAuth provider-based sign-in.
      // This avoids relying on the google_sign_in plugin API surface.
      final provider = firebase_auth.GoogleAuthProvider();

      // Request basic profile scopes (mainly relevant on web / desktop).
      provider
        ..addScope('email')
        ..addScope('profile');

      final userCredential = await _firebaseAuth.signInWithProvider(provider);

      // Return the ID token for backend verification
      return await userCredential.user?.getIdToken();
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      rethrow;
    }
  }

  // ============================================
  // APPLE SIGN-IN
  // ============================================

  /// Sign in with Apple and return Firebase ID token
  /// Returns null if cancelled
  Future<String?> signInWithApple() async {
    try {
      // Check if Apple Sign-In is available (iOS only, or macOS)
      if (!Platform.isIOS && !Platform.isMacOS) {
        throw UnsupportedError('Apple Sign-In is only available on iOS/macOS');
      }

      // Request Apple credentials
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create OAuthCredential
      final oAuthCredential =
          firebase_auth.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase
      final userCredential =
          await _firebaseAuth.signInWithCredential(oAuthCredential);

      // Update display name if available (Apple only provides on first sign-in)
      if (appleCredential.givenName != null) {
        await userCredential.user?.updateDisplayName(
          '${appleCredential.givenName} ${appleCredential.familyName ?? ''}'
              .trim(),
        );
      }

      // Return the ID token for backend verification
      return await userCredential.user?.getIdToken();
    } catch (e) {
      debugPrint('Apple Sign-In Error: $e');
      rethrow;
    }
  }

  // ============================================
  // PHONE AUTH (OTP)
  // ============================================

  /// Send OTP to phone number
  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(firebase_auth.PhoneAuthCredential credential)
        onAutoVerify,
    required Function(String error) onError,
    int? resendToken,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      forceResendingToken: resendToken,
      verificationCompleted: (credential) {
        // Auto-verification (Android only)
        onAutoVerify(credential);
      },
      verificationFailed: (e) {
        onError(e.message ?? 'Verification failed');
      },
      codeSent: (verificationId, resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (verificationId) {
        // Timeout
      },
    );
  }

  /// Verify OTP and sign in
  Future<String?> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    try {
      final credential = firebase_auth.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      return await userCredential.user?.getIdToken();
    } catch (e) {
      debugPrint('OTP Verification Error: $e');
      rethrow;
    }
  }

  // ============================================
  // SIGN OUT
  // ============================================

  /// Sign out from all providers
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // ============================================
  // HELPERS
  // ============================================

  /// Get current user's ID token (for backend verification)
  Future<String?> getIdToken() async {
    return await currentUser?.getIdToken();
  }

  /// Get current user's ID token (force refresh)
  Future<String?> getIdTokenForced() async {
    return await currentUser?.getIdToken(true);
  }
}