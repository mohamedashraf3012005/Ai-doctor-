import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';

/// Implementation of [AuthRepository] connecting remote data source with domain.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _storage;

  AuthRepositoryImpl(this._remoteDataSource, this._storage);

  @override
  Future<Either<Failure, ({String token, UserEntity user})>> login({
    required String userName,
    required String password,
    required String role,
  }) async {
    try {
      final result = await _remoteDataSource.login(
        userName: userName,
        password: password,
        role: role,
      );
      await _storage.saveSession(
        token: result.token,
        role: result.user.role,
        userId: result.user.id,
        userName: result.user.name,
        userEmail: result.user.email,
        userPhone: result.user.phone,
      );
      return Right((token: result.token, user: result.user.toEntity()));
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ({String token, UserEntity user})>> registerPatient({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    int? age,
    String? gender,
  }) async {
    try {
      final payload = {
        'FullName': fullName,
        'Email': email,
        'Phone': phone,
        'Password': password,
        'Role': 'patient',
        if (age != null) 'Age': age,
        if (gender != null) 'Gender': gender,
      };
      final result = await _remoteDataSource.register(payload: payload);
      await _storage.saveSession(
        token: result.token,
        role: 'patient',
        userId: result.user.id,
        userName: result.user.name,
        userEmail: result.user.email,
        userPhone: result.user.phone,
      );
      return Right((token: result.token, user: result.user.toEntity()));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ({String token, UserEntity user})>> registerDoctor({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String specialization,
    int? experienceYears,
    String? gender,
    String? clinicAddress,
    String? idCardPath,
  }) async {
    try {
      final payload = {
        'FullName': fullName,
        'Email': email,
        'Phone': phone,
        'Password': password,
        'Role': 'doctor',
        'Specialization': specialization,
        if (experienceYears != null) 'ExperienceYears': experienceYears,
        if (gender != null) 'Gender': gender,
        if (clinicAddress != null) 'ClinicAddress': clinicAddress,
      };
      final result = await _remoteDataSource.register(
        payload: payload,
        idCardPath: idCardPath,
      );
      await _storage.saveSession(
        token: result.token,
        role: 'doctor',
        userId: result.user.id,
        userName: result.user.name,
        userEmail: result.user.email,
        userPhone: result.user.phone,
      );
      return Right((token: result.token, user: result.user.toEntity()));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final user = await _remoteDataSource.getProfile();
      return Right(user.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? fullName,
    String? phone,
    int? age,
    String? gender,
    String? password,
  }) async {
    try {
      final payload = <String, dynamic>{
        if (fullName != null) 'fullName': fullName,
        if (phone != null) 'phone': phone,
        if (age != null) 'age': age,
        if (gender != null) 'gender': gender,
        if (password != null && password.isNotEmpty) 'password': password,
      };
      final user = await _remoteDataSource.updateProfile(payload);
      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    try {
      final otp = await _remoteDataSource.forgotPassword(email);
      return Right(otp);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final result = await _remoteDataSource.verifyOtp(email, otp);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final result =
          await _remoteDataSource.resetPassword(email, otp, newPassword);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<bool> isLoggedIn() => _storage.isLoggedIn;

  @override
  Future<void> logout() => _storage.clearAll();
}
