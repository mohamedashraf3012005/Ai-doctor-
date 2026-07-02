import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/doctors_repository.dart';

/// Use case for fetching available appointment slots.
class GetDoctorAvailabilityUseCase {
  final DoctorsRepository _repository;

  GetDoctorAvailabilityUseCase(this._repository);

  Future<Either<Failure, Map<String, List<String>>>> call({
    required String doctorId,
    String? date,
  }) {
    return _repository.getDoctorAvailability(
      doctorId: doctorId,
      date: date,
    );
  }
}
