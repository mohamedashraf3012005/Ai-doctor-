import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/diagnosis_entity.dart';
import '../../domain/repositories/diagnosis_repository.dart';
import '../data_sources/diagnosis_remote_data_source.dart';

/// Implementation of [DiagnosisRepository].
class DiagnosisRepositoryImpl implements DiagnosisRepository {
  final DiagnosisRemoteDataSource _remoteDataSource;

  DiagnosisRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, DiagnosisEntity>> analyzeScan({
    required String scanType,
    required String filePath,
    required String lang,
  }) async {
    try {
      final model = await _remoteDataSource.analyzeScan(
        scanType: scanType,
        filePath: filePath,
        lang: lang,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DiagnosisEntity>>> getMyDiagnoses() async {
    try {
      final models = await _remoteDataSource.getMyDiagnoses();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteDiagnosis(String id) async {
    try {
      final result = await _remoteDataSource.deleteDiagnosis(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
