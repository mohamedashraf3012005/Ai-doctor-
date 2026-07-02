import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_entity.dart';

/// Repository interface for doctor actions in the domain layer.
abstract class DoctorsRepository {
  /// Fetches a list of doctors with optional search and specialty filters.
  Future<Either<Failure, List<DoctorEntity>>> getDoctors({
    String? searchQuery,
    String? specialty,
  });

  /// Fetches available date/time slots for booking a doctor.
  Future<Either<Failure, Map<String, List<String>>>> getDoctorAvailability({
    required String doctorId,
    String? date,
  });
}
