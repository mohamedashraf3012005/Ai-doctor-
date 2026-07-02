import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login.
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<Failure, ({String token, UserEntity user})>> call({
    required String userName,
    required String password,
    required String role,
  }) {
    return _repository.login(
      userName: userName,
      password: password,
      role: role,
    );
  }
}
