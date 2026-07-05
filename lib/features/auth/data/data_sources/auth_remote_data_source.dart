import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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
      final payload = _buildLoginPayload(
        userName: userName,
        password: password,
        role: role,
      );
      debugPrint('Auth login payload: $payload');
      final response = await _dio.post(ApiEndpoints.login, data: payload);
      debugPrint('Auth login response: ${response.data}');
      return _parseAuthResponse(response.data, fallbackRole: role);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Register a new user (patient or doctor).
  ///
  /// The backend accepts `[FromForm]` only; JSON bodies are ignored and surface
  /// misleading validation errors such as "Email is already registered."
  Future<({String token, UserModel user})> register({
    required Map<String, dynamic> payload,
    String? idCardPath,
  }) async {
    try {
      final compatiblePayload = _buildRegisterPayload(payload);
      debugPrint('Auth register payload: $compatiblePayload');
      final formMap = Map<String, dynamic>.from(compatiblePayload);
      if (idCardPath != null) {
        formMap['IdCard'] = await MultipartFile.fromFile(idCardPath);
      }
      final response = await _dio.post(
        ApiEndpoints.register,
        data: FormData.fromMap(formMap),
        options: Options(contentType: 'multipart/form-data'),
      );
      debugPrint('Auth register response: ${response.data}');
      final fallbackRole = (payload['Role'] ?? payload['role'] ?? 'patient')
          .toString()
          .toLowerCase();
      return _parseAuthResponse(response.data, fallbackRole: fallbackRole);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Map<String, dynamic> _buildLoginPayload({
    required String userName,
    required String password,
    required String role,
  }) {
    final normalizedEmail = userName.trim();
    final normalizedRole = role.trim().isEmpty ? 'patient' : role.trim().toLowerCase();
    return {
      'Email': normalizedEmail,
      'Password': password,
      'Role': normalizedRole,
    };
  }

  Map<String, dynamic> _buildRegisterPayload(Map<String, dynamic> payload) {
    final formFields = <String, String>{};

    void setField(String key, dynamic value) {
      if (value == null) return;
      final text = value.toString().trim();
      if (text.isEmpty) return;
      formFields[key] = text;
    }

    setField('FullName', payload['FullName'] ?? payload['fullName'] ?? payload['name']);
    setField('Email', payload['Email'] ?? payload['email'] ?? payload['userName']);
    setField('Phone', payload['Phone'] ?? payload['phone']);
    setField('Password', payload['Password'] ?? payload['password']);
    setField(
      'Role',
      (payload['Role'] ?? payload['role'] ?? 'patient').toString().toLowerCase(),
    );
    setField('Age', payload['Age'] ?? payload['age']);
    setField('Gender', payload['Gender'] ?? payload['gender']);
    setField(
      'Specialization',
      payload['Specialization'] ?? payload['specialization'],
    );
    setField(
      'ExperienceYears',
      payload['ExperienceYears'] ?? payload['experienceYears'],
    );
    setField(
      'ClinicAddress',
      payload['ClinicAddress'] ?? payload['clinicAddress'],
    );

    return formFields;
  }

  ({String token, UserModel user}) _parseAuthResponse(
    dynamic data, {
    required String fallbackRole,
  }) {
    final payload = data is Map<String, dynamic>
        ? data
        : (data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{});

    final candidate = payload['data'] is Map<String, dynamic>
        ? payload['data'] as Map<String, dynamic>
        : payload['result'] is Map<String, dynamic>
        ? payload['result'] as Map<String, dynamic>
        : payload;

    final token =
        candidate['token']?.toString() ?? payload['token']?.toString() ?? '';

    if (candidate['user'] is Map) {
      final userJson = candidate['user'] is Map<String, dynamic>
          ? candidate['user'] as Map<String, dynamic>
          : Map<String, dynamic>.from(candidate['user'] as Map);
      return (token: token, user: UserModel.fromJson(userJson));
    }

    if (token.isNotEmpty ||
        candidate.containsKey('userId') ||
        candidate.containsKey('fullName')) {
      return (
        token: token,
        user: UserModel.fromJson({
          'id': candidate['userId'] ?? candidate['id'],
          'fullName': candidate['fullName'] ?? candidate['name'],
          'email': candidate['email'],
          'role': candidate['role'] ?? fallbackRole,
          'phone': candidate['phoneNumber'] ?? candidate['phone'],
        }),
      );
    }

    return (
      token: token,
      user: UserModel.fromJson({'role': fallbackRole}),
    );
  }

  /// Get the current user's profile.
  Future<UserModel> getProfile() async {
    try {
      final response = await _dio.get(ApiEndpoints.profile);
      return _parseUserResponse(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Update the current user's profile.
  Future<UserModel> updateProfile(Map<String, dynamic> payload) async {
    try {
      final response = await _dio.put(ApiEndpoints.profile, data: payload);
      return _parseUserResponse(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  UserModel _parseUserResponse(dynamic data) {
    if (data is Map) {
      final map = data is Map<String, dynamic>
          ? data
          : Map<String, dynamic>.from(data);
      if (map['data'] is Map) {
        return UserModel.fromJson(
          Map<String, dynamic>.from(map['data'] as Map),
        );
      }
      if (map['user'] is Map) {
        return UserModel.fromJson(
          Map<String, dynamic>.from(map['user'] as Map),
        );
      }
      return UserModel.fromJson(map);
    }
    throw ServerException('Unexpected profile response');
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
  Future<bool> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    try {
      await _dio.post(
        ApiEndpoints.resetPassword,
        data: {'email': email, 'otp': otp, 'newPassword': newPassword},
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
      message = _extractErrorMessage(e.response!.data);
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

  String _extractErrorMessage(dynamic data) {
    if (data is String && data.isNotEmpty) {
      return data;
    }

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final flattened = <String>[];

      void collectFrom(dynamic value) {
        if (value is String && value.isNotEmpty) {
          flattened.add(value);
          return;
        }
        if (value is List) {
          for (final item in value) {
            collectFrom(item);
          }
          return;
        }
        if (value is Map) {
          for (final nestedValue in value.values) {
            collectFrom(nestedValue);
          }
        }
      }

      for (final key in [
        'errors',
        'error',
        'messages',
        'validationErrors',
        'details',
      ]) {
        if (map.containsKey(key)) {
          collectFrom(map[key]);
        }
      }

      if (flattened.isNotEmpty) {
        return flattened.join(' ');
      }

      final directMessage =
          map['message'] ?? map['title'] ?? map['detail'] ?? map['error'];
      if (directMessage is String && directMessage.isNotEmpty) {
        return directMessage;
      }

      for (final entry in map.entries) {
        final key = entry.key.toLowerCase();
        if (key == 'message' ||
            key == 'title' ||
            key == 'detail' ||
            key == 'error') {
          continue;
        }
        collectFrom(entry.value);
      }

      if (flattened.isNotEmpty) {
        return flattened.join(' ');
      }
    }

    return 'Something went wrong';
  }
}
