import 'package:dio/dio.dart';

import '../../di/injection.dart';
import '../../storage/secure_storage.dart';

/// Interceptor to add authentication headers to requests
class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get token from secure storage
    final secureStorage = getIt<SecureStorageService>();
    final token = await secureStorage.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized - token expired
    if (err.response?.statusCode == 401) {
      // TODO: Implement token refresh logic
      // For now, just pass the error
    }

    handler.next(err);
  }
}