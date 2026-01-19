import 'package:equatable/equatable.dart';

/// Base failure class for functional error handling with Either
abstract class Failure extends Equatable {
  const Failure({
    required this.message,
    this.code,
  });

  final String message;
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

/// Failure for server/API errors
class ServerFailure extends Failure {
  const ServerFailure(
    String message, {
    super.code,
    this.statusCode,
  }) : super(message: message);

  final int? statusCode;

  @override
  List<Object?> get props => [message, code, statusCode];
}

/// Failure for network errors
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No internet connection'])
      : super(message: message, code: 'NO_NETWORK');
}

/// Failure for cache errors
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error'])
      : super(message: message, code: 'CACHE_ERROR');
}

/// Failure for authentication errors
class AuthFailure extends Failure {
  const AuthFailure(String message, {String? code})
      : super(message: message, code: code ?? 'AUTH_ERROR');

  factory AuthFailure.invalidCredentials() => const AuthFailure(
        'Invalid credentials',
        code: 'INVALID_CREDENTIALS',
      );

  factory AuthFailure.tokenExpired() => const AuthFailure(
        'Session expired. Please login again.',
        code: 'TOKEN_EXPIRED',
      );

  factory AuthFailure.userNotFound() => const AuthFailure(
        'User not found',
        code: 'USER_NOT_FOUND',
      );

  factory AuthFailure.unauthorized() => const AuthFailure(
        'Unauthorized access',
        code: 'UNAUTHORIZED',
      );
}

/// Failure for validation errors
class ValidationFailure extends Failure {
  const ValidationFailure(
    String message, {
    this.errors = const {},
  }) : super(message: message, code: 'VALIDATION_ERROR');

  final Map<String, List<String>> errors;

  @override
  List<Object?> get props => [message, code, errors];
}

/// Failure for QR-related errors
class QRFailure extends Failure {
  const QRFailure(String message, {String? code})
      : super(message: message, code: code ?? 'QR_ERROR');

  factory QRFailure.expired() => const QRFailure(
        'QR code has expired',
        code: 'QR_EXPIRED',
      );

  factory QRFailure.alreadyUsed() => const QRFailure(
        'QR code has already been used',
        code: 'QR_ALREADY_USED',
      );

  factory QRFailure.invalidSubscription() => const QRFailure(
        'Your subscription is not valid for this gym',
        code: 'INVALID_SUBSCRIPTION',
      );

  factory QRFailure.visitLimitReached() => const QRFailure(
        'You have reached your visit limit',
        code: 'VISIT_LIMIT_REACHED',
      );

  factory QRFailure.outsideGeofence() => const QRFailure(
        'You must be at the gym location to check in',
        code: 'OUTSIDE_GEOFENCE',
      );
}

/// Failure for subscription-related errors
class SubscriptionFailure extends Failure {
  const SubscriptionFailure(String message, {String? code})
      : super(message: message, code: code ?? 'SUBSCRIPTION_ERROR');

  factory SubscriptionFailure.noActiveSubscription() =>
      const SubscriptionFailure(
        'You don\'t have an active subscription',
        code: 'NO_SUBSCRIPTION',
      );

  factory SubscriptionFailure.paymentFailed() => const SubscriptionFailure(
        'Payment failed. Please try again.',
        code: 'PAYMENT_FAILED',
      );

  factory SubscriptionFailure.alreadySubscribed() => const SubscriptionFailure(
        'You already have an active subscription',
        code: 'ALREADY_SUBSCRIBED',
      );
}

/// Failure for permission-related errors
class PermissionFailure extends Failure {
  const PermissionFailure(String message, {String? code})
      : super(message: message, code: code ?? 'PERMISSION_ERROR');

  factory PermissionFailure.locationDenied() => const PermissionFailure(
        'Location permission is required for this feature',
        code: 'LOCATION_DENIED',
      );

  factory PermissionFailure.cameraDenied() => const PermissionFailure(
        'Camera permission is required for QR scanning',
        code: 'CAMERA_DENIED',
      );

  factory PermissionFailure.notificationsDenied() => const PermissionFailure(
        'Notification permission is required for alerts',
        code: 'NOTIFICATIONS_DENIED',
      );
}

/// Generic unexpected failure
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([String message = 'An unexpected error occurred'])
      : super(message: message, code: 'UNEXPECTED_ERROR');
}