import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../data_sources/booking_remote_data_source.dart';

/// Implementation of [BookingRepository].
class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource _remoteDataSource;

  BookingRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, AppointmentEntity>> bookAppointment({
    required String doctorId,
    required String patientName,
    required String patientPhone,
    required String appointmentDate,
    required String timeSlot,
    String? medicalNotes,
  }) async {
    try {
      final model = await _remoteDataSource.bookAppointment(
        doctorId: doctorId,
        patientName: patientName,
        patientPhone: patientPhone,
        appointmentDate: appointmentDate,
        timeSlot: timeSlot,
        medicalNotes: medicalNotes,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getMyAppointments() async {
    try {
      final models = await _remoteDataSource.getMyAppointments();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelAppointment(String appointmentId) async {
    try {
      final result = await _remoteDataSource.cancelAppointment(appointmentId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
