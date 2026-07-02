import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

/// States for authentication.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  final String token;

  const AuthAuthenticated({required this.user, required this.token});

  @override
  List<Object?> get props => [user.id, token];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// States for forgot password flow.
class ForgotPasswordOtpSent extends AuthState {
  final String email;
  final String otp; // In real app, OTP comes via email; backend returns it for demo.

  const ForgotPasswordOtpSent({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

class OtpVerified extends AuthState {
  final String email;
  final String otp;

  const OtpVerified({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

class PasswordResetSuccess extends AuthState {
  const PasswordResetSuccess();
}

class ProfileUpdateSuccess extends AuthState {
  final UserEntity user;

  const ProfileUpdateSuccess(this.user);

  @override
  List<Object?> get props => [user.id];
}
