import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for patient registration.
class RegisterPatientUseCase {
  final AuthRepository _repository;

  RegisterPatientUseCase(this._repository);

  Future<Either<Failure, ({String token, UserEntity user})>> call({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    int? age,
    String? gender,
  }) {
    return _repository.registerPatient(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      age: age,
      gender: gender,
    );
  }
}

/// Use case for doctor registration.
class RegisterDoctorUseCase {
  final AuthRepository _repository;

  RegisterDoctorUseCase(this._repository);

  Future<Either<Failure, ({String token, UserEntity user})>> call({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String specialization,
    int? experienceYears,
    String? gender,
    String? clinicAddress,
    String? idCardPath,
  }) {
    return _repository.registerDoctor(
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
  }
}
