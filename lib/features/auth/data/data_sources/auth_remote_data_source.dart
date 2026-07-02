import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/user_model.dart';

/// Remote data source for authentication API calls.
class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  /// Login with username, password, and role.
  Future<({String token, UserModel user})> login({
    required String userName,
    required String password,
    required String role,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {
          'userName': userName,
          'password': password,
          'role': role,
        },
      );
      final data = response.data;
      final token = data['token'] as String? ?? '';
      final userJson = data['user'] ?? data;
      final user = UserModel.fromJson(
        userJson is Map<String, dynamic> ? userJson : {'role': role},
      );
      return (token: token, user: user);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Register a new user (patient or doctor). Uses FormData for file upload.
  Future<({String token, UserModel user})> register({
    required Map<String, dynamic> payload,
    String? idCardPath,
  }) async {
    try {
      final formData = FormData.fromMap({
        ...payload,
        if (idCardPath != null)
          'IdCard': await MultipartFile.fromFile(idCardPath),
      });

      final response = await _dio.post(
        ApiEndpoints.register,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      final data = response.data;
      final token = data['token'] as String? ?? '';
      final userJson = data['user'] ?? data;
      final user = UserModel.fromJson(
        userJson is Map<String, dynamic> ? userJson : {},
      );
      return (token: token, user: user);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get the current user's profile.
  Future<UserModel> getProfile() async {
    try {
      final response = await _dio.get(ApiEndpoints.profile);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Update the current user's profile.
  Future<UserModel> updateProfile(Map<String, dynamic> payload) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.profile,
        data: payload,
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Request forgot password OTP.
  Future<String> forgotPassword(String email) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.forgotPassword,
        data: {'email': email},
      );
      return response.data['otp']?.toString() ??
          response.data['message']?.toString() ??
          '';
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Verify OTP code.
  Future<bool> verifyOtp(String email, String otp) async {
    try {
      await _dio.post(
        ApiEndpoints.verifyOtp,
        data: {'email': email, 'otp': otp},
      );
      return true;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Reset password.
  Future<bool> resetPassword(String email, String otp, String newPassword) async {
    try {
      await _dio.post(
        ApiEndpoints.resetPassword,
        data: {
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        },
      );
      return true;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ServerException _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    String message = 'Something went wrong';

    if (e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        message = data['message'] ?? data['title'] ?? message;
      } else if (data is String && data.isNotEmpty) {
        message = data;
      }
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      message = 'Connection timed out';
    } else if (e.type == DioExceptionType.connectionError) {
      message = 'No internet connection';
    }

    if (statusCode == 401 || statusCode == 403) {
      throw UnauthorizedException(message);
    }

    return ServerException(message, statusCode: statusCode);
  }
}
