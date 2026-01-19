import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../config/app_config.dart';
import '../constants/app_constants.dart';

/// Injectable Dio client for API requests
@lazySingleton
class DioClient {
  late final Dio _dio;
  late final Dio _uploadDio;

  DioClient() {
    _dio = _createDio();
    _uploadDio = _createUploadDio();
  }

  /// Get the configured Dio instance
  Dio get dio => _dio;

  /// Get the Dio instance for file uploads
  Dio get uploadDio => _uploadDio;

  /// Create a configured Dio instance
  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.instance.apiBaseUrl,
        connectTimeout: AppConstants.connectionTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    return dio;
  }

  /// Create a Dio instance for file uploads
  Dio _createUploadDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.instance.apiBaseUrl,
        connectTimeout: const Duration(minutes: 5),
        receiveTimeout: const Duration(minutes: 5),
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    return dio;
  }

  /// Add an interceptor to the Dio instance
  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  /// Static factory for creating standalone Dio instances (for testing)
  static Dio createDio() {
    return Dio(
      BaseOptions(
        baseUrl: AppConfig.instance.apiBaseUrl,
        connectTimeout: AppConstants.connectionTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }
}