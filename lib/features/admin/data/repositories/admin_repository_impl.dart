import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/admin_repository.dart';
import '../data_sources/admin_remote_data_source.dart';
import '../models/admin_models.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource _remoteDataSource;

  AdminRepositoryImpl(this._remoteDataSource);

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
  Future<Either<Failure, AdminStatsModel>> getStats() {
    return _execute(() => _remoteDataSource.getStats());
  }

  @override
  Future<Either<Failure, DashboardStatsModel>> getDashboardStats() {
    return _execute(() => _remoteDataSource.getDashboardStats());
  }

  @override
  Future<Either<Failure, ChartDataModel>> getChartData() {
    return _execute(() => _remoteDataSource.getChartData());
  }

  @override
  Future<Either<Failure, List<AdminPatientModel>>> getPatients() {
    return _execute(() => _remoteDataSource.getPatients());
  }

  @override
  Future<Either<Failure, List<AdminDoctorModel>>> getDoctors() {
    return _execute(() => _remoteDataSource.getDoctors());
  }

  @override
  Future<Either<Failure, List<AdminActivityModel>>> getRecentActivity() {
    return _execute(() => _remoteDataSource.getRecentActivity());
  }

  @override
  Future<Either<Failure, List<AdminAppointmentModel>>> getAppointments({String? status, String? range}) {
    return _execute(() => _remoteDataSource.getAppointments(status: status, range: range));
  }

  @override
  Future<Either<Failure, void>> deletePatient(String id) {
    return _execute(() => _remoteDataSource.deletePatient(id));
  }

  @override
  Future<Either<Failure, void>> deleteDoctor(String id) {
    return _execute(() => _remoteDataSource.deleteDoctor(id));
  }

  @override
  Future<Either<Failure, void>> approveDoctor(String id) {
    return _execute(() => _remoteDataSource.approveDoctor(id));
  }

  @override
  Future<Either<Failure, void>> rejectDoctor(String id, String reason) {
    return _execute(() => _remoteDataSource.rejectDoctor(id, reason));
  }

  @override
  Future<Either<Failure, void>> updateAppointmentStatus(String id, String status) {
    return _execute(() => _remoteDataSource.updateAppointmentStatus(id, status));
  }

  @override
  Future<Either<Failure, void>> registerDoctor(Map<String, dynamic> payload) {
    return _execute(() => _remoteDataSource.registerDoctor(payload));
  }

  @override
  Future<Either<Failure, void>> registerPatient(Map<String, dynamic> payload) {
    return _execute(() => _remoteDataSource.registerPatient(payload));
  }

  @override
  Future<Either<Failure, void>> addSpecialty(Map<String, dynamic> payload) {
    return _execute(() => _remoteDataSource.addSpecialty(payload));
  }
}
