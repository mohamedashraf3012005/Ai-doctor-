import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/diagnosis_entity.dart';

/// Repository interface for AI diagnosis actions in the domain layer.
abstract class DiagnosisRepository {
  /// Uploads a file (X-ray, ECG, MRI) and returns AI analysis.
  Future<Either<Failure, DiagnosisEntity>> analyzeScan({
    required String scanType,
    required String filePath,
    required String lang,
  });

  /// Fetches a list of previous diagnoses for the patient.
  Future<Either<Failure, List<DiagnosisEntity>>> getMyDiagnoses();

  /// Deletes a specific diagnosis record.
  Future<Either<Failure, bool>> deleteDiagnosis(String id);
}
