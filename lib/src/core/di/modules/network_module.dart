import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../config/app_config.dart';
import '../../constants/app_constants.dart';
import '../../network/interceptors/auth_interceptor.dart';
import '../../network/interceptors/error_interceptor.dart';

/// Network module for dependency injection
@module
abstract class NetworkModule {
  /// Provide Dio instance
  @lazySingleton
  Dio get dio {
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

    // Add interceptors
    dio.interceptors.addAll([
      AuthInterceptor(),
      ErrorInterceptor(),
      if (!AppConfig.instance.isRelease)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
    ]);

    return dio;
  }
}