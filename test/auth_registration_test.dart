import 'package:care360/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:care360/features/auth/data/models/user_model.dart';
import 'package:care360/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:care360/core/storage/secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  test(
    'registerPatient signs in automatically when register has no token',
    () async {
      final remoteDataSource = _FakeAuthRemoteDataSource();
      final repository = AuthRepositoryImpl(
        remoteDataSource,
        SecureStorageService(storage: const FlutterSecureStorage()),
      );

      final result = await repository.registerPatient(
        fullName: 'Ada Lovelace',
        email: 'ada@example.com',
        phone: '+201234567890',
        password: 'secret123',
        age: 37,
        gender: 'Female',
      );

      expect(result.isRight(), isTrue);
      await result.fold(
        (_) async => fail('Expected a successful registration result'),
        (data) async {
          expect(data.token, 'login-token');
          expect(data.user.name, 'Ada Lovelace');
          expect(remoteDataSource.loginCalls, 1);
        },
      );
    },
  );

  test(
    'registerPatient uses the registration response token when available',
    () async {
      final remoteDataSource = _FakeAuthRemoteDataSource(
        registrationToken: 'registration-token',
      );
      final repository = AuthRepositoryImpl(
        remoteDataSource,
        SecureStorageService(storage: const FlutterSecureStorage()),
      );

      final result = await repository.registerPatient(
        fullName: 'Ada Lovelace',
        email: 'ada@example.com',
        phone: '+201234567890',
        password: 'secret123',
        age: 37,
        gender: 'Female',
      );

      expect(result.isRight(), isTrue);
      await result.fold(
        (_) async => fail('Expected a successful registration result'),
        (data) async {
          expect(data.token, 'registration-token');
          expect(data.user.name, 'Ada Lovelace');
          expect(remoteDataSource.loginCalls, 0);
        },
      );
    },
  );
}

class _FakeAuthRemoteDataSource extends AuthRemoteDataSource {
  _FakeAuthRemoteDataSource({this.registrationToken = ''}) : super(Dio());

  final String registrationToken;
  int loginCalls = 0;
  Map<String, dynamic>? lastPayload;

  @override
  Future<({String token, UserModel user})> register({
    required Map<String, dynamic> payload,
    String? idCardPath,
  }) async {
    lastPayload = payload;
    return (
      token: registrationToken,
      user: const UserModel(
        id: 'u-1',
        name: 'Ada Lovelace',
        email: 'ada@example.com',
        role: 'patient',
      ),
    );
  }

  @override
  Future<({String token, UserModel user})> login({
    required String userName,
    required String password,
    required String role,
  }) async {
    loginCalls++;
    return (
      token: 'login-token',
      user: const UserModel(
        id: 'u-1',
        name: 'Ada Lovelace',
        email: 'ada@example.com',
        role: 'patient',
      ),
    );
  }
}
