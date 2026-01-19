/// Base exception class for the application
abstract class AppException implements Exception {
  const AppException({
    required this.message,
    this.code,
    this.stackTrace,
  });

  final String message;
  final String? code;
  final StackTrace? stackTrace;

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Exception thrown when server returns an error
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
    super.stackTrace,
    this.statusCode,
  });

  final int? statusCode;

  factory ServerException.fromStatusCode(int statusCode, [String? message]) {
    switch (statusCode) {
      case 400:
        return ServerException(
          message: message ?? 'Bad request',
          code: 'BAD_REQUEST',
          statusCode: statusCode,
        );
      case 401:
        return ServerException(
          message: message ?? 'Unauthorized',
          code: 'UNAUTHORIZED',
          statusCode: statusCode,
        );
      case 403:
        return ServerException(
          message: message ?? 'Forbidden',
          code: 'FORBIDDEN',
          statusCode: statusCode,
        );
      case 404:
        return ServerException(
          message: message ?? 'Not found',
          code: 'NOT_FOUND',
          statusCode: statusCode,
        );
      case 409:
        return ServerException(
          message: message ?? 'Conflict',
          code: 'CONFLICT',
          statusCode: statusCode,
        );
      case 422:
        return ServerException(
          message: message ?? 'Validation error',
          code: 'VALIDATION_ERROR',
          statusCode: statusCode,
        );
      case 429:
        return ServerException(
          message: message ?? 'Too many requests',
          code: 'RATE_LIMITED',
          statusCode: statusCode,
        );
      case 500:
        return ServerException(
          message: message ?? 'Internal server error',
          code: 'SERVER_ERROR',
          statusCode: statusCode,
        );
      case 503:
        return ServerException(
          message: message ?? 'Service unavailable',
          code: 'SERVICE_UNAVAILABLE',
          statusCode: statusCode,
        );
      default:
        return ServerException(
          message: message ?? 'Unknown error',
          code: 'UNKNOWN',
          statusCode: statusCode,
        );
    }
  }
}

/// Exception thrown when there's no network connection
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection',
    super.code = 'NO_NETWORK',
  });
}

/// Exception thrown when cache operations fail
class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache error',
    super.code = 'CACHE_ERROR',
  });
}

/// Exception thrown when authentication fails
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code = 'AUTH_ERROR',
  });

  factory AuthException.invalidCredentials() => const AuthException(
        message: 'Invalid credentials',
        code: 'INVALID_CREDENTIALS',
      );

  factory AuthException.tokenExpired() => const AuthException(
        message: 'Token expired',
        code: 'TOKEN_EXPIRED',
      );

  factory AuthException.userNotFound() => const AuthException(
        message: 'User not found',
        code: 'USER_NOT_FOUND',
      );

  factory AuthException.emailAlreadyInUse() => const AuthException(
        message: 'Email already in use',
        code: 'EMAIL_IN_USE',
      );
}

/// Exception thrown when validation fails
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    this.errors = const {},
  });

  final Map<String, List<String>> errors;
}

/// Exception thrown when QR validation fails
class QRException extends AppException {
  const QRException({
    required super.message,
    super.code = 'QR_ERROR',
  });

  factory QRException.expired() => const QRException(
        message: 'QR code expired',
        code: 'QR_EXPIRED',
      );

  factory QRException.alreadyUsed() => const QRException(
        message: 'QR code already used',
        code: 'QR_ALREADY_USED',
      );

  factory QRException.invalidSubscription() => const QRException(
        message: 'Invalid or expired subscription',
        code: 'INVALID_SUBSCRIPTION',
      );

  factory QRException.visitLimitReached() => const QRException(
        message: 'Visit limit reached',
        code: 'VISIT_LIMIT_REACHED',
      );

  factory QRException.outsideGeofence() => const QRException(
        message: 'Not within gym location',
        code: 'OUTSIDE_GEOFENCE',
      );
}

/// Exception thrown for subscription-related errors
class SubscriptionException extends AppException {
  const SubscriptionException({
    required super.message,
    super.code = 'SUBSCRIPTION_ERROR',
  });

  factory SubscriptionException.noActiveSubscription() =>
      const SubscriptionException(
        message: 'No active subscription',
        code: 'NO_SUBSCRIPTION',
      );

  factory SubscriptionException.paymentFailed() => const SubscriptionException(
        message: 'Payment failed',
        code: 'PAYMENT_FAILED',
      );
}

/// Exception thrown for permission-related errors
class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.code = 'PERMISSION_ERROR',
  });

  factory PermissionException.locationDenied() => const PermissionException(
        message: 'Location permission denied',
        code: 'LOCATION_DENIED',
      );

  factory PermissionException.cameraDenied() => const PermissionException(
        message: 'Camera permission denied',
        code: 'CAMERA_DENIED',
      );

  factory PermissionException.notificationsDenied() =>
      const PermissionException(
        message: 'Notification permission denied',
        code: 'NOTIFICATIONS_DENIED',
      );
}

/// Exception thrown when request is unauthorized (401)
class UnauthorizedException extends ServerException {
  const UnauthorizedException({
    super.message = 'Unauthorized',
    super.code = 'UNAUTHORIZED',
    super.statusCode = 401,
  });
}

/// Exception thrown when there's a conflict (409)
class ConflictException extends ServerException {
  const ConflictException({
    super.message = 'Conflict',
    super.code = 'CONFLICT',
    super.statusCode = 409,
  });
}