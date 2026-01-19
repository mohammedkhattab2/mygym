import '../../domain/entities/user.dart';

/// Authentication states
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
  otpSent,
  otpVerifying,
}

/// Auth state for the auth cubit
class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.phoneNumber,
    this.isOnboardingComplete = false,
  });

  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final String? phoneNumber;
  final bool isOnboardingComplete;

  /// Initial state
  factory AuthState.initial() => const AuthState();

  /// Loading state
  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);

  /// Authenticated state
  factory AuthState.authenticated(User user) => AuthState(
        status: AuthStatus.authenticated,
        user: user,
        isOnboardingComplete: user.hasCompletedOnboarding,
      );

  /// Unauthenticated state
  factory AuthState.unauthenticated() => const AuthState(
        status: AuthStatus.unauthenticated,
      );

  /// Error state
  factory AuthState.error(String message) => AuthState(
        status: AuthStatus.error,
        errorMessage: message,
      );

  /// OTP sent state
  factory AuthState.otpSent(String phoneNumber) => AuthState(
        status: AuthStatus.otpSent,
        phoneNumber: phoneNumber,
      );

  /// OTP verifying state
  factory AuthState.otpVerifying(String phoneNumber) => AuthState(
        status: AuthStatus.otpVerifying,
        phoneNumber: phoneNumber,
      );

  /// Copy with method for immutability
  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    String? phoneNumber,
    bool? isOnboardingComplete,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
    );
  }

  /// Check if loading
  bool get isLoading => status == AuthStatus.loading;

  /// Check if authenticated
  bool get isAuthenticated => status == AuthStatus.authenticated;

  /// Check if unauthenticated
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;

  /// Check if error
  bool get hasError => status == AuthStatus.error;

  /// Check if OTP sent
  bool get isOtpSent => status == AuthStatus.otpSent;

  /// Check if OTP verifying
  bool get isOtpVerifying => status == AuthStatus.otpVerifying;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState &&
        other.status == status &&
        other.user == user &&
        other.errorMessage == errorMessage &&
        other.phoneNumber == phoneNumber &&
        other.isOnboardingComplete == isOnboardingComplete;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        user.hashCode ^
        errorMessage.hashCode ^
        phoneNumber.hashCode ^
        isOnboardingComplete.hashCode;
  }

  @override
  String toString() {
    return 'AuthState(status: $status, user: $user, errorMessage: $errorMessage)';
  }
}