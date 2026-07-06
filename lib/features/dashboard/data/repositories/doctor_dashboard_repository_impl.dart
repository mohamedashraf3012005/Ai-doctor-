import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/doctor_dashboard_repository.dart';
import '../data_sources/doctor_dashboard_remote_data_source.dart';
import '../models/doctor_dashboard_models.dart';

class DoctorDashboardRepositoryImpl implements DoctorDashboardRepository {
  final DoctorDashboardRemoteDataSource _remoteDataSource;

  DoctorDashboardRepositoryImpl(this._remoteDataSource);

  Future<Either<Failure, T>> _execute<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Right(result);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DoctorDashboardStatsModel>> getDashboard() {
    return _execute(() => _remoteDataSource.getDashboard());
  }

  @override
  Future<Either<Failure, DoctorProfileModel>> getDoctorById(String id) {
    return _execute(() => _remoteDataSource.getDoctorById(id));
  }

  @override
  Future<Either<Failure, void>> updateAvailability(List<DoctorAvailabilityModel> payload) {
    return _execute(() => _remoteDataSource.updateAvailability(payload));
  }

  @override
  Future<Either<Failure, DoctorProfileModel>> getMyProfile() {
    return _execute(() => _remoteDataSource.getMyProfile());
  }

  @override
  Future<Either<Failure, DoctorProfileModel>> updateProfile(Map<String, dynamic> payload) {
    return _execute(() => _remoteDataSource.updateProfile(payload));
  }

  @override
  Future<Either<Failure, DoctorPatientDetailsModel>> getPatientDetails(String id) {
    return _execute(() => _remoteDataSource.getPatientDetails(id));
  }

  @override
  Future<Either<Failure, void>> updateAppointmentStatus(String id, String status) {
    return _execute(() => _remoteDataSource.updateAppointmentStatus(id, status));
  }
}
