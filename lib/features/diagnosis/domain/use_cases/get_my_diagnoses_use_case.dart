import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/diagnosis_entity.dart';
import '../repositories/diagnosis_repository.dart';

class GetMyDiagnosesUseCase {
  final DiagnosisRepository _repository;

  GetMyDiagnosesUseCase(this._repository);

  Future<Either<Failure, List<DiagnosisEntity>>> call() {
    return _repository.getMyDiagnoses();
  }
}
