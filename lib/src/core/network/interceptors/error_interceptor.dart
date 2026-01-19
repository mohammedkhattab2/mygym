import 'package:dio/dio.dart';

import '../../error/exceptions.dart';
import '../../utils/logger.dart';

/// Interceptor to handle and transform API errors
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      'API Error: ${err.message}',
      error: err,
      stackTrace: err.stackTrace,
    );

    // Transform DioException to custom exception if needed
    final statusCode = err.response?.statusCode;
    
    if (statusCode != null) {
      final message = _extractErrorMessage(err.response);
      
      switch (statusCode) {
        case 401:
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: AuthException.tokenExpired(),
              type: err.type,
              response: err.response,
            ),
          );
          return;
        case 403:
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: const AuthException(message: 'Access forbidden'),
              type: err.type,
              response: err.response,
            ),
          );
          return;
        case 404:
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: ServerException(message: message ?? 'Resource not found', statusCode: 404),
              type: err.type,
              response: err.response,
            ),
          );
          return;
        case 422:
          final errors = _extractValidationErrors(err.response);
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: ValidationException(message: message ?? 'Validation error', errors: errors),
              type: err.type,
              response: err.response,
            ),
          );
          return;
        case 500:
        case 502:
        case 503:
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: ServerException(message: 'Server error. Please try again later.', statusCode: statusCode),
              type: err.type,
              response: err.response,
            ),
          );
          return;
      }
    }

    // Check for network errors
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const NetworkException(),
          type: err.type,
        ),
      );
      return;
    }

    handler.next(err);
  }

  String? _extractErrorMessage(Response? response) {
    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;
      return data['message'] as String? ?? data['error'] as String?;
    }
    return null;
  }

  Map<String, List<String>> _extractValidationErrors(Response? response) {
    final errors = <String, List<String>>{};
    
    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;
      final errorData = data['errors'];
      
      if (errorData is Map<String, dynamic>) {
        errorData.forEach((key, value) {
          if (value is List) {
            errors[key] = value.map((e) => e.toString()).toList();
          } else if (value is String) {
            errors[key] = [value];
          }
        });
      }
    }
    
    return errors;
  }
}