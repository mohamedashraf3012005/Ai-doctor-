import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/secure_storage_service.dart';

/// Dio interceptor that attaches JWT Bearer token to every outgoing request.
class AuthInterceptor extends Interceptor {
  final SecureStorageService _storage;

  AuthInterceptor(this._storage);

  static const _publicAuthPaths = {
    'auth/login',
    'auth/register',
    'auth/forgot-password',
    'auth/verify-otp',
    'auth/reset-password',
  };

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final path = options.path.replaceFirst(RegExp(r'^/'), '');
    final isPublicAuth = _publicAuthPaths.contains(path);

    if (!isPublicAuth) {
      final token = await _storage.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } else {
      options.headers.remove('Authorization');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      debugPrint('AuthInterceptor: Unauthorized — clearing session');
      _storage.clearAll();
    }
    handler.next(err);
  }
}
