import 'dart:convert';

import 'package:care360/core/error/exceptions.dart';
import 'package:care360/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class MockHttpClientAdapter implements HttpClientAdapter {
  MockHttpClientAdapter(this.handler);

  final Future<ResponseBody> Function(RequestOptions options) handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('AuthRemoteDataSource', () {
    test('parses login responses wrapped in a data object', () async {
      final dio = Dio();
      dio.httpClientAdapter = MockHttpClientAdapter((_) async {
        return ResponseBody.fromString(
          jsonEncode({
            'success': true,
            'data': {
              'token': 'abc123',
              'user': {
                'fullName': 'Alice Johnson',
                'email': 'alice@example.com',
                'role': 'patient',
              },
            },
          }),
          200,
          headers: {
            'content-type': ['application/json'],
          },
        );
      });

      final dataSource = AuthRemoteDataSource(dio);

      final result = await dataSource.login(
        userName: 'alice',
        password: 'secret',
        role: 'patient',
      );

      expect(result.token, 'abc123');
      expect(result.user.name, 'Alice Johnson');
      expect(result.user.email, 'alice@example.com');
    });

    test('parses register responses wrapped in a result object', () async {
      final dio = Dio();
      dio.httpClientAdapter = MockHttpClientAdapter((_) async {
        return ResponseBody.fromString(
          jsonEncode({
            'result': {
              'token': 'jwt456',
              'user': {
                'fullName': 'Bob Smith',
                'email': 'bob@example.com',
                'role': 'doctor',
              },
            },
          }),
          200,
          headers: {
            'content-type': ['application/json'],
          },
        );
      });

      final dataSource = AuthRemoteDataSource(dio);

      final result = await dataSource.register(
        payload: {'fullName': 'Bob Smith'},
      );

      expect(result.token, 'jwt456');
      expect(result.user.name, 'Bob Smith');
      expect(result.user.role, 'doctor');
    });

    test('sends compatible login payload aliases for the backend', () async {
      Map<String, dynamic>? capturedData;
      final dio = Dio();
      dio.httpClientAdapter = MockHttpClientAdapter((options) async {
        capturedData = options.data is Map<String, dynamic>
            ? options.data as Map<String, dynamic>
            : Map<String, dynamic>.from(options.data as Map);
        return ResponseBody.fromString(
          jsonEncode({
            'token': 'abc123',
            'userId': 'user-1',
            'fullName': 'Alice Johnson',
            'email': 'alice@example.com',
            'role': 'Patient',
          }),
          200,
          headers: {
            'content-type': ['application/json'],
          },
        );
      });

      final dataSource = AuthRemoteDataSource(dio);
      await dataSource.login(
        userName: 'alice@example.com',
        password: 'secret123',
        role: 'patient',
      );

      expect(capturedData, isNotNull);
      expect(capturedData!['Email'], 'alice@example.com');
      expect(capturedData!['Password'], 'secret123');
      expect(capturedData!['Role'], 'patient');
    });

    test('parses flat login responses returned by the backend', () async {
      final dio = Dio();
      dio.httpClientAdapter = MockHttpClientAdapter((_) async {
        return ResponseBody.fromString(
          jsonEncode({
            'token': 'abc123',
            'userId': 'user-1',
            'role': 'Patient',
            'fullName': 'Alice Johnson',
            'phoneNumber': '+201000000001',
          }),
          200,
          headers: {
            'content-type': ['application/json'],
          },
        );
      });

      final dataSource = AuthRemoteDataSource(dio);

      final result = await dataSource.login(
        userName: 'alice@example.com',
        password: 'secret123',
        role: 'patient',
      );

      expect(result.token, 'abc123');
      expect(result.user.id, 'user-1');
      expect(result.user.name, 'Alice Johnson');
      expect(result.user.role, 'patient');
      expect(result.user.phone, '+201000000001');
    });

    test('sends register requests as multipart form-data', () async {
      String? capturedContentType;
      Map<String, dynamic>? capturedFields;
      final dio = Dio();
      dio.httpClientAdapter = MockHttpClientAdapter((options) async {
        capturedContentType = options.contentType;
        final data = options.data;
        if (data is FormData) {
          capturedFields = {
            for (final field in data.fields) field.key: field.value,
          };
        }
        return ResponseBody.fromString(
          jsonEncode({'message': 'Registration successful'}),
          200,
          headers: {
            'content-type': ['application/json'],
          },
        );
      });

      final dataSource = AuthRemoteDataSource(dio);
      await dataSource.register(
        payload: {
          'FullName': 'Carol White',
          'Email': 'carol@example.com',
          'Phone': '+201000000001',
          'Password': 'Secret123!',
          'Role': 'patient',
        },
      );

      expect(capturedContentType, contains('multipart/form-data'));
      expect(capturedFields, isNotNull);
      expect(capturedFields!['FullName'], 'Carol White');
      expect(capturedFields!['Email'], 'carol@example.com');
      expect(capturedFields!['Password'], 'Secret123!');
      expect(capturedFields!['Role'], 'patient');
    });

    test('maps camelCase register input to PascalCase form fields', () async {
      Map<String, dynamic>? capturedFields;
      final dio = Dio();
      dio.httpClientAdapter = MockHttpClientAdapter((options) async {
        final data = options.data;
        if (data is FormData) {
          capturedFields = {
            for (final field in data.fields) field.key: field.value,
          };
        }
        return ResponseBody.fromString(
          jsonEncode({
            'token': 'jwt789',
            'userId': 'user-2',
            'fullName': 'Carol White',
            'email': 'carol@example.com',
            'role': 'Patient',
          }),
          200,
          headers: {
            'content-type': ['application/json'],
          },
        );
      });

      final dataSource = AuthRemoteDataSource(dio);
      await dataSource.register(
        payload: {
          'fullName': 'Carol White',
          'email': 'carol@example.com',
          'phone': '+201000000001',
          'password': 'Secret123!',
          'role': 'patient',
          'age': 30,
          'gender': 'Female',
        },
      );

      expect(capturedFields, isNotNull);
      expect(capturedFields!['FullName'], 'Carol White');
      expect(capturedFields!['Email'], 'carol@example.com');
      expect(capturedFields!['Phone'], '+201000000001');
      expect(capturedFields!['Password'], 'Secret123!');
      expect(capturedFields!['Role'], 'patient');
      expect(capturedFields!['Age'], '30');
      expect(capturedFields!['Gender'], 'Female');
    });

    test(
      'surfaces backend validation errors for registration failures',
      () async {
        final dio = Dio();
        dio.httpClientAdapter = MockHttpClientAdapter((_) async {
          final body = jsonEncode({
            'title': 'One or more validation errors occurred.',
            'errors': {
              'Email': ['Email is already registered.'],
              'UserName': ['UserName is already taken.'],
            },
          });
          return ResponseBody.fromString(
            body,
            400,
            headers: {
              'content-type': ['application/problem+json'],
            },
          );
        });

        final dataSource = AuthRemoteDataSource(dio);

        expect(
          () =>
              dataSource.register(payload: {'Email': 'duplicate@example.com'}),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              contains('Email is already registered'),
            ),
          ),
        );
      },
    );
  });
}
