import 'package:flutter_bloc/flutter_bloc.dart';
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

  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterPatientUseCase registerPatientUseCase,
    required RegisterDoctorUseCase registerDoctorUseCase,
    required AuthRepository authRepository,
  })  : _loginUseCase = loginUseCase,
        _registerPatientUseCase = registerPatientUseCase,
        _registerDoctorUseCase = registerDoctorUseCase,
        _authRepository = authRepository,
        super(const AuthInitial());

  /// Check if user is already logged in.
  Future<void> checkAuthStatus() async {
    final loggedIn = await _authRepository.isLoggedIn();
    if (loggedIn) {
      final result = await _authRepository.getProfile();
      result.fold(
        (failure) => emit(const AuthUnauthenticated()),
        (user) => emit(AuthAuthenticated(user: user, token: '')),
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
      (data) => emit(AuthAuthenticated(user: data.user, token: data.token)),
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
      (data) => emit(AuthAuthenticated(user: data.user, token: data.token)),
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
      (data) => emit(AuthAuthenticated(user: data.user, token: data.token)),
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
