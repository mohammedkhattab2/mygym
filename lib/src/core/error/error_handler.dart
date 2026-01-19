import 'package:dio/dio.dart';
import 'exceptions.dart';
import 'failures.dart';

/// Global error handler for mapping exceptions to failures
class ErrorHandler {
  ErrorHandler._();

  /// Convert an exception to a Failure
  static Failure handleException(Object exception) {
    if (exception is Failure) {
      return exception;
    }

    if (exception is AppException) {
      return _mapAppException(exception);
    }

    if (exception is DioException) {
      return _mapDioException(exception);
    }

    return UnexpectedFailure(exception.toString());
  }

  /// Map AppException to Failure
  static Failure _mapAppException(AppException exception) {
    if (exception is ServerException) {
      return ServerFailure(
        exception.message,
        code: exception.code,
        statusCode: exception.statusCode,
      );
    }

    if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    }

    if (exception is CacheException) {
      return CacheFailure(exception.message);
    }

    if (exception is AuthException) {
      return AuthFailure(exception.message, code: exception.code);
    }

    if (exception is ValidationException) {
      return ValidationFailure(exception.message, errors: exception.errors);
    }

    if (exception is QRException) {
      return QRFailure(exception.message, code: exception.code);
    }

    if (exception is SubscriptionException) {
      return SubscriptionFailure(exception.message, code: exception.code);
    }

    if (exception is PermissionException) {
      return PermissionFailure(exception.message, code: exception.code);
    }

    return UnexpectedFailure(exception.message);
  }

  /// Map DioException to Failure
  static Failure _mapDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerFailure(
          'Connection timeout. Please try again.',
          code: 'TIMEOUT',
        );

      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.badCertificate:
        return const ServerFailure(
          'Security certificate error',
          code: 'CERTIFICATE_ERROR',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(exception.response);

      case DioExceptionType.cancel:
        return const ServerFailure(
          'Request cancelled',
          code: 'CANCELLED',
        );

      case DioExceptionType.unknown:
        if (exception.error.toString().contains('SocketException')) {
          return const NetworkFailure();
        }
        return UnexpectedFailure(exception.message ?? 'Unknown error');
    }
  }

  /// Handle bad response from server
  static Failure _handleBadResponse(Response? response) {
    if (response == null) {
      return const ServerFailure('No response from server');
    }

    final statusCode = response.statusCode ?? 0;
    String message = 'Server error';

    // Try to extract error message from response
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      message = data['message'] as String? ??
          data['error'] as String? ??
          'Server error';

      // Handle validation errors
      if (statusCode == 422 && data['errors'] != null) {
        final errors = _parseValidationErrors(data['errors']);
        return ValidationFailure(message, errors: errors);
      }
    }

    // Handle specific status codes
    switch (statusCode) {
      case 401:
        return AuthFailure.unauthorized();
      case 403:
        return const AuthFailure('Access forbidden', code: 'FORBIDDEN');
      case 404:
        return ServerFailure(message, code: 'NOT_FOUND', statusCode: statusCode);
      case 409:
        return ServerFailure(message, code: 'CONFLICT', statusCode: statusCode);
      case 429:
        return const ServerFailure(
          'Too many requests. Please try again later.',
          code: 'RATE_LIMITED',
        );
      case 500:
      case 502:
      case 503:
        return const ServerFailure(
          'Server is currently unavailable. Please try again later.',
          code: 'SERVER_ERROR',
        );
      default:
        return ServerFailure(message, statusCode: statusCode);
    }
  }

  /// Parse validation errors from response
  static Map<String, List<String>> _parseValidationErrors(dynamic errors) {
    final result = <String, List<String>>{};

    if (errors is Map<String, dynamic>) {
      errors.forEach((key, value) {
        if (value is List) {
          result[key] = value.map((e) => e.toString()).toList();
        } else if (value is String) {
          result[key] = [value];
        }
      });
    }

    return result;
  }

  /// Get user-friendly error message
  static String getUserFriendlyMessage(Failure failure) {
    // You can customize messages based on failure type or code
    return failure.message;
  }
}