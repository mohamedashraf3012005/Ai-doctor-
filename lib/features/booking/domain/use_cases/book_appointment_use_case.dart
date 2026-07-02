import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/appointment_entity.dart';
import '../repositories/booking_repository.dart';

class BookAppointmentUseCase {
  final BookingRepository _repository;

  BookAppointmentUseCase(this._repository);

  Future<Either<Failure, AppointmentEntity>> call({
    required String doctorId,
    required String patientName,
    required String patientPhone,
    required String appointmentDate,
    required String timeSlot,
    String? medicalNotes,
  }) {
    return _repository.bookAppointment(
      doctorId: doctorId,
      patientName: patientName,
      patientPhone: patientPhone,
      appointmentDate: appointmentDate,
      timeSlot: timeSlot,
      medicalNotes: medicalNotes,
    );
  }
}
