import 'package:care360/core/config/app_config.dart';
import 'package:care360/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('doctor registration live test', () async {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    final dataSource = AuthRemoteDataSource(dio);
    final email = 'doctor${DateTime.now().millisecondsSinceEpoch}@care360.test';

    print('Registering doctor with email: $email');
    try {
      final registerResult = await dataSource.register(
        payload: {
          'FullName': 'Dr. Live Test',
          'Email': email,
          'Phone': '12345678901',
          'Password': 'Test123!',
          'Role': 'doctor',
          'Specialization': 'Pneumonia',
          'ExperienceYears': 8,
          'Gender': 'Male',
          'ClinicAddress': '123 Clinic Ave',
        },
      );
      print('Registration Result token: ${registerResult.token}');
      print('Registration Result user: ${registerResult.user.toJson()}');
    } catch (e) {
      print('Registration Error: $e');
    }

    print('Attempting to login registered doctor...');
    try {
      final loginResult = await dataSource.login(
        userName: email,
        password: 'Test123!',
        role: 'doctor',
      );
      print('Login Result token: ${loginResult.token}');
      print('Login Result user: ${loginResult.user.toJson()}');
    } catch (e) {
      print('Login Error: $e');
    }
  });
}
