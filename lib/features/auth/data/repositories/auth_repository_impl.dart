import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/user_model.dart';

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
      await _saveAuthSession(result.token, result.user);
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
    return _registerAndSignIn(
      payload: {
        'FullName': fullName,
        'Email': email,
        'Phone': phone,
        'Password': password,
        'Role': 'patient',
        if (age != null) 'Age': age,
        if (gender != null) 'Gender': gender,
      },
      email: email,
      password: password,
      role: 'patient',
    );
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
    return _registerAndSignIn(
      payload: {
        'FullName': fullName,
        'Email': email,
        'Phone': phone,
        'Password': password,
        'Role': 'doctor',
        'Specialization': specialization,
        if (experienceYears != null) 'ExperienceYears': experienceYears,
        if (gender != null) 'Gender': gender,
        if (clinicAddress != null) 'ClinicAddress': clinicAddress,
      },
      email: email,
      password: password,
      role: 'doctor',
      idCardPath: idCardPath,
    );
  }

  Future<Either<Failure, ({String token, UserEntity user})>> _registerAndSignIn({
    required Map<String, dynamic> payload,
    required String email,
    required String password,
    required String role,
    String? idCardPath,
  }) async {
    try {
      final registrationResult = await _remoteDataSource.register(
        payload: payload,
        idCardPath: idCardPath,
      );

      // Force the correct role in the model regardless of what backend returned.
      final forcedUser = UserModel(
        id: registrationResult.user.id,
        name: registrationResult.user.name,
        email: registrationResult.user.email,
        role: role,
        phone: registrationResult.user.phone,
        age: registrationResult.user.age,
        gender: registrationResult.user.gender,
        specialization: registrationResult.user.specialization,
        experienceYears: registrationResult.user.experienceYears,
        clinicAddress: registrationResult.user.clinicAddress,
        profileImageUrl: registrationResult.user.profileImageUrl,
      );

      if (registrationResult.token.isNotEmpty) {
        await _saveAuthSession(registrationResult.token, forcedUser);
        return Right((
          token: registrationResult.token,
          user: forcedUser.toEntity(),
        ));
      }

      // Backend register returns only a success message — sign in explicitly.
      final loginResult = await _remoteDataSource.login(
        userName: email,
        password: password,
        role: role,
      );
      // Force the correct role on the login result too.
      final forcedLoginUser = UserModel(
        id: loginResult.user.id,
        name: loginResult.user.name,
        email: loginResult.user.email,
        role: role,
        phone: loginResult.user.phone,
        age: loginResult.user.age,
        gender: loginResult.user.gender,
        specialization: loginResult.user.specialization,
        experienceYears: loginResult.user.experienceYears,
        clinicAddress: loginResult.user.clinicAddress,
        profileImageUrl: loginResult.user.profileImageUrl,
      );
      await _saveAuthSession(loginResult.token, forcedLoginUser);
      return Right((
        token: loginResult.token,
        user: forcedLoginUser.toEntity(),
      ));
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<void> _saveAuthSession(String token, UserModel user) async {
    await _storage.saveSession(
      token: token,
      role: user.role,
      userId: user.id,
      userName: user.name,
      userEmail: user.email,
      userPhone: user.phone,
    );
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
      final result = await _remoteDataSource.resetPassword(
        email,
        otp,
        newPassword,
      );
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
