import 'package:equatable/equatable.dart';

/// Base failure class for domain-layer error handling.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Failure originating from a remote server response.
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// Failure due to network connectivity issues.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// Failure originating from local cache/storage operations.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error']);
}

/// Failure related to authentication (expired token, unauthorized).
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}
