import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

/// Authentication Cubit for managing auth state
@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(AuthState.initial());

  final AuthRepository _authRepository;

  /// Check authentication status on app start
  Future<void> checkAuthStatus() async {
    try {
      emit(AuthState.loading());
      
      final isLoggedIn = await _authRepository.isLoggedIn();
      
      if (isLoggedIn) {
        final result = await _authRepository.getCurrentUser();
        result.fold(
          (failure) => emit(AuthState.unauthenticated()),
          (user) => emit(AuthState.authenticated(user)),
        );
      } else {
        emit(AuthState.unauthenticated());
      }
    } catch (e) {
      emit(AuthState.unauthenticated());
    }
  }

  /// Sign in with email and password
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthState.loading());
      
      final result = await _authRepository.signInWithEmail(
        email: email,
        password: password,
      );
      
      result.fold(
        (failure) => emit(AuthState.error(failure.message)),
        (user) => emit(AuthState.authenticated(user)),
      );
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      emit(AuthState.loading());
      
      final result = await _authRepository.signInWithGoogle();
      
      result.fold(
        (failure) => emit(AuthState.error(failure.message)),
        (user) => emit(AuthState.authenticated(user)),
      );
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  /// Sign in with Apple
  Future<void> signInWithApple() async {
    try {
      emit(AuthState.loading());
      
      final result = await _authRepository.signInWithApple();
      
      result.fold(
        (failure) => emit(AuthState.error(failure.message)),
        (user) => emit(AuthState.authenticated(user)),
      );
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  /// Send OTP to phone number
  Future<void> sendOtp({required String phone}) async {
    try {
      emit(AuthState.loading());
      
      final result = await _authRepository.requestOtp(phone: phone);
      
      result.fold(
        (failure) => emit(AuthState.error(failure.message)),
        (_) => emit(AuthState.otpSent(phone)),
      );
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  /// Verify OTP code
  Future<void> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      emit(AuthState.otpVerifying(phone));
      
      final result = await _authRepository.verifyOtp(
        phone: phone,
        otp: otp,
      );
      
      result.fold(
        (failure) => emit(AuthState.error(failure.message)),
        (user) => emit(AuthState.authenticated(user)),
      );
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  /// Continue as guest
  Future<void> continueAsGuest() async {
    try {
      emit(AuthState.loading());
      
      final result = await _authRepository.continueAsGuest();
      
      result.fold(
        (failure) => emit(AuthState.error(failure.message)),
        (user) => emit(AuthState.authenticated(user)),
      );
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  /// Register with email
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      emit(AuthState.loading());
      
      final result = await _authRepository.register(
        email: email,
        password: password,
        name: name,
      );
      
      result.fold(
        (failure) => emit(AuthState.error(failure.message)),
        (user) => emit(AuthState.authenticated(user)),
      );
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  /// Update preferences (complete onboarding)
  Future<void> updatePreferences({
    required String city,
    required List<String> interests,
  }) async {
    try {
      emit(AuthState.loading());
      
      final result = await _authRepository.updatePreferences(
        city: city,
        interests: interests,
      );
      
      result.fold(
        (failure) => emit(AuthState.error(failure.message)),
        (user) => emit(AuthState.authenticated(user)),
      );
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }
  /// Update user profile (name / phone / photoUrl)
  Future<void> updateProfile({
    String? name,
    String? phone,
    String? photoUrl,
  }) async {
    try {
      final result = await _authRepository.updateProfile(
        name: name,
        phone: phone,
        photoUrl: photoUrl,
      );

      result.fold(
        (failure) {
          emit(AuthState.error(failure.message));
        },
        (user) {
          emit(AuthState.authenticated(user));
        },
      );
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      emit(AuthState.loading());
      
      final result = await _authRepository.signOut();
      
      result.fold(
        (failure) => emit(AuthState.error(failure.message)),
        (_) => emit(AuthState.unauthenticated()),
      );
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  /// Request password reset
  Future<void> requestPasswordReset({required String email}) async {
    try {
      emit(AuthState.loading());
      
      final result = await _authRepository.requestPasswordReset(email: email);
      
      result.fold(
        (failure) => emit(AuthState.error(failure.message)),
        (_) => emit(AuthState.unauthenticated()),
      );
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  /// Clear error
  void clearError() {
    if (state.hasError) {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: null,
      ));
    }
  }
}