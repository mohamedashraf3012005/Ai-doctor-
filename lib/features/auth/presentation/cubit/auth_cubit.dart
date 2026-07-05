import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/register_use_case.dart';
import 'auth_state.dart';

/// Cubit managing all authentication state transitions.
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterPatientUseCase _registerPatientUseCase;
  final RegisterDoctorUseCase _registerDoctorUseCase;
  final AuthRepository _authRepository;
  final SecureStorageService _storage;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterPatientUseCase registerPatientUseCase,
    required RegisterDoctorUseCase registerDoctorUseCase,
    required AuthRepository authRepository,
    required SecureStorageService storage,
  })  : _loginUseCase = loginUseCase,
        _registerPatientUseCase = registerPatientUseCase,
        _registerDoctorUseCase = registerDoctorUseCase,
        _authRepository = authRepository,
        _storage = storage,
        super(const AuthInitial());

  /// Check if user is already logged in.
  /// Restores the role from secure storage so it always matches what the user chose.
  Future<void> checkAuthStatus() async {
    final loggedIn = await _authRepository.isLoggedIn();
    if (loggedIn) {
      // Read the persisted role BEFORE fetching the profile.
      final storedRole = await _storage.getRole();
      final result = await _authRepository.getProfile();
      result.fold(
        (failure) => emit(const AuthUnauthenticated()),
        (user) {
          // Override role with the one we stored at login/register time.
          final corrected = UserEntity(
            id: user.id,
            name: user.name,
            email: user.email,
            role: storedRole?.toLowerCase() ?? user.role,
            phone: user.phone,
            age: user.age,
            gender: user.gender,
            specialization: user.specialization,
            experienceYears: user.experienceYears,
            clinicAddress: user.clinicAddress,
            profileImageUrl: user.profileImageUrl,
          );
          emit(AuthAuthenticated(user: corrected, token: ''));
        },
      );
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  /// Login with credentials.
  Future<void> login({
    required String userName,
    required String password,
    required String role,
  }) async {
    emit(const AuthLoading());
    final result = await _loginUseCase(
      userName: userName,
      password: password,
      role: role,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (data) {
        // Ensure role matches the selected role to avoid misclassification
        final correctedUser = UserEntity(
          id: data.user.id,
          name: data.user.name,
          email: data.user.email,
          role: role,
          phone: data.user.phone,
          age: data.user.age,
          gender: data.user.gender,
          specialization: data.user.specialization,
          experienceYears: data.user.experienceYears,
          clinicAddress: data.user.clinicAddress,
          profileImageUrl: data.user.profileImageUrl,
        );
        emit(AuthAuthenticated(user: correctedUser, token: data.token));
      },
    );
  }

  /// Register as patient.
  Future<void> registerPatient({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    int? age,
    String? gender,
  }) async {
    emit(const AuthLoading());
    final result = await _registerPatientUseCase(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      age: age,
      gender: gender,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (data) {
        // Always force role to 'patient' regardless of what backend returns.
        final corrected = UserEntity(
          id: data.user.id,
          name: data.user.name,
          email: data.user.email,
          role: 'patient',
          phone: data.user.phone,
          age: data.user.age,
          gender: data.user.gender,
          specialization: data.user.specialization,
          experienceYears: data.user.experienceYears,
          clinicAddress: data.user.clinicAddress,
          profileImageUrl: data.user.profileImageUrl,
        );
        emit(AuthAuthenticated(user: corrected, token: data.token));
      },
    );
  }

  /// Register as doctor.
  Future<void> registerDoctor({
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
    emit(const AuthLoading());
    final result = await _registerDoctorUseCase(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      specialization: specialization,
      experienceYears: experienceYears,
      gender: gender,
      clinicAddress: clinicAddress,
      idCardPath: idCardPath,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (data) {
        // Always force role to 'doctor' regardless of what backend returns.
        final corrected = UserEntity(
          id: data.user.id,
          name: data.user.name,
          email: data.user.email,
          role: 'doctor',
          phone: data.user.phone,
          age: data.user.age,
          gender: data.user.gender,
          specialization: data.user.specialization,
          experienceYears: data.user.experienceYears,
          clinicAddress: data.user.clinicAddress,
          profileImageUrl: data.user.profileImageUrl,
        );
        emit(AuthAuthenticated(user: corrected, token: data.token));
      },
    );
  }

  /// Forgot password — request OTP.
  Future<void> forgotPassword(String email) async {
    emit(const AuthLoading());
    final result = await _authRepository.forgotPassword(email);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (otp) => emit(ForgotPasswordOtpSent(email: email, otp: otp)),
    );
  }

  /// Verify OTP.
  Future<void> verifyOtp({required String email, required String otp}) async {
    emit(const AuthLoading());
    final result = await _authRepository.verifyOtp(email: email, otp: otp);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(OtpVerified(email: email, otp: otp)),
    );
  }

  /// Reset password.
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    emit(const AuthLoading());
    final result = await _authRepository.resetPassword(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const PasswordResetSuccess()),
    );
  }

  /// Update profile.
  Future<void> updateProfile({
    String? fullName,
    String? phone,
    int? age,
    String? gender,
    String? password,
  }) async {
    emit(const AuthLoading());
    final result = await _authRepository.updateProfile(
      fullName: fullName,
      phone: phone,
      age: age,
      gender: gender,
      password: password,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(ProfileUpdateSuccess(user)),
    );
  }

  /// Logout.
  Future<void> logout() async {
    await _authRepository.logout();
    emit(const AuthUnauthenticated());
  }
}
