import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/diagnosis_entity.dart';
import '../repositories/diagnosis_repository.dart';

class AnalyzeScanUseCase {
  final DiagnosisRepository _repository;

  AnalyzeScanUseCase(this._repository);

  Future<Either<Failure, DiagnosisEntity>> call({
    required String scanType,
    required String filePath,
    required String lang,
  }) {
    return _repository.analyzeScan(
      scanType: scanType,
      filePath: filePath,
      lang: lang,
    );
  }
}
