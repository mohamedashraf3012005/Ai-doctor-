import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/doctor_entity.dart';
import '../../domain/repositories/doctors_repository.dart';
import '../data_sources/doctors_remote_data_source.dart';

/// Implementation of [DoctorsRepository].
class DoctorsRepositoryImpl implements DoctorsRepository {
  final DoctorsRemoteDataSource _remoteDataSource;

  DoctorsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<DoctorEntity>>> getDoctors({
    String? searchQuery,
    String? specialty,
  }) async {
    try {
      final models = await _remoteDataSource.getDoctors(
        searchQuery: searchQuery,
        specialty: specialty,
      );
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, List<String>>>> getDoctorAvailability({
    required String doctorId,
    String? date,
  }) async {
    try {
      final availability = await _remoteDataSource.getDoctorAvailability(
        doctorId: doctorId,
        date: date,
      );
      return Right(availability);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
