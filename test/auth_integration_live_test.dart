import 'package:care360/core/config/app_config.dart';
import 'package:care360/core/storage/secure_storage_service.dart';
import 'package:care360/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:care360/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Live integration test against the real backend.
/// Run with: flutter test test/auth_integration_live_test.dart --dart-define=RUN_LIVE_TESTS=true
void main() {
  final runLive = const bool.fromEnvironment('RUN_LIVE_TESTS');

  group('Live auth integration', () {
    late Dio dio;
    late AuthRemoteDataSource dataSource;
    late AuthRepositoryImpl repository;
    late String email;

    setUpAll(() {
      if (!runLive) return;
      dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.apiBaseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {'Content-Type': 'application/json'},
        ),
      );
      dataSource = AuthRemoteDataSource(dio);
      repository = AuthRepositoryImpl(
        dataSource,
        SecureStorageService(),
      );
      email = 'live${DateTime.now().millisecondsSinceEpoch}@care360.test';
    });

    test('register patient then login via AuthRemoteDataSource', () async {
      if (!runLive) return;

      await dataSource.register(
        payload: {
          'FullName': 'Live Test User',
          'Email': email,
          'Phone': '12345678901',
          'Password': 'Test123!',
          'Role': 'patient',
          'Age': 28,
          'Gender': 'Male',
        },
      );

      final loginResult = await dataSource.login(
        userName: email,
        password: 'Test123!',
        role: 'patient',
      );

      expect(loginResult.token, isNotEmpty);
      expect(loginResult.user.id, isNotEmpty);
      expect(loginResult.user.name, isNotEmpty);
    }, skip: !runLive);

    test('register patient via AuthRepositoryImpl auto-signs in', () async {
      if (!runLive) return;

      final uniqueEmail =
          'repo${DateTime.now().millisecondsSinceEpoch}@care360.test';
      final result = await repository.registerPatient(
        fullName: 'Repository User',
        email: uniqueEmail,
        phone: '12345678901',
        password: 'Test123!',
        age: 29,
        gender: 'Male',
      );

      expect(result.isRight(), isTrue);
      await result.fold(
        (failure) async => fail('Expected success but got ${failure.message}'),
        (data) async {
          expect(data.token, isNotEmpty);
          expect(data.user.email, uniqueEmail);
          expect(await repository.isLoggedIn(), isTrue);
        },
      );
    }, skip: !runLive);
  });
}
