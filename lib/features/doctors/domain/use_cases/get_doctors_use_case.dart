import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_entity.dart';
import '../repositories/doctors_repository.dart';

/// Use case for listing and searching doctors.
class GetDoctorsUseCase {
  final DoctorsRepository _repository;

  GetDoctorsUseCase(this._repository);

  Future<Either<Failure, List<DoctorEntity>>> call({
    String? searchQuery,
    String? specialty,
  }) {
    return _repository.getDoctors(
      searchQuery: searchQuery,
      specialty: specialty,
    );
  }
}
