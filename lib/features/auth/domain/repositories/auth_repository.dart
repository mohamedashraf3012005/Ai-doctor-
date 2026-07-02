import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

/// Auth repository contract for the domain layer.
abstract class AuthRepository {
  /// Logs in with username/password and role. Returns token + user.
  Future<Either<Failure, ({String token, UserEntity user})>> login({
    required String userName,
    required String password,
    required String role,
  });

  /// Registers a new patient account.
  Future<Either<Failure, ({String token, UserEntity user})>> registerPatient({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    int? age,
    String? gender,
  });

  /// Registers a new doctor account.
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
  });

  /// Fetches the current user's profile.
  Future<Either<Failure, UserEntity>> getProfile();

  /// Updates the current user's profile.
  Future<Either<Failure, UserEntity>> updateProfile({
    String? fullName,
    String? phone,
    int? age,
    String? gender,
    String? password,
  });

  /// Sends a forgot password request.
  Future<Either<Failure, String>> forgotPassword(String email);

  /// Verifies OTP code.
  Future<Either<Failure, bool>> verifyOtp({
    required String email,
    required String otp,
  });

  /// Resets password with OTP token.
  Future<Either<Failure, bool>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  /// Checks if user is logged in (has valid token).
  Future<bool> isLoggedIn();

  /// Logs out and clears session.
  Future<void> logout();
}
