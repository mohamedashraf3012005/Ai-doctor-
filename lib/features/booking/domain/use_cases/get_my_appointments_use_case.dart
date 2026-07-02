import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/appointment_entity.dart';
import '../repositories/booking_repository.dart';

class GetMyAppointmentsUseCase {
  final BookingRepository _repository;

  GetMyAppointmentsUseCase(this._repository);

  Future<Either<Failure, List<AppointmentEntity>>> call() {
    return _repository.getMyAppointments();
  }
}

class CancelAppointmentUseCase {
  final BookingRepository _repository;

  CancelAppointmentUseCase(this._repository);

  Future<Either<Failure, bool>> call(String appointmentId) {
    return _repository.cancelAppointment(appointmentId);
  }
}
