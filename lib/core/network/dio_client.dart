import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/app_config.dart';
import '../storage/secure_storage_service.dart';
import 'auth_interceptor.dart';

/// Configures and provides the singleton Dio HTTP client.
class DioClient {
  DioClient._();

  static Dio? _instance;

  /// Initializes Dio with auth interceptor and logging.
  /// Must be called after DI setup so [SecureStorageService] is available.
  static Dio init(SecureStorageService storage) {
    _instance = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    )..interceptors.addAll([
        AuthInterceptor(storage),
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          compact: true,
        ),
      ]);
    return _instance!;
  }

  /// Returns the existing Dio instance. Throws if [init] was not called.
  static Dio get instance {
    if (_instance == null) {
      throw StateError('DioClient.init() must be called before accessing instance');
    }
    return _instance!;
  }
}
