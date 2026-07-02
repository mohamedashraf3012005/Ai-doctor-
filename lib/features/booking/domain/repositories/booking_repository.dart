import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/appointment_entity.dart';

/// Repository interface for booking consultations.
abstract class BookingRepository {
  /// Book a new consultation appointment slot.
  Future<Either<Failure, AppointmentEntity>> bookAppointment({
    required String doctorId,
    required String patientName,
    required String patientPhone,
    required String appointmentDate,
    required String timeSlot,
    String? medicalNotes,
  });

  /// Fetches a list of patient's booked appointments.
  Future<Either<Failure, List<AppointmentEntity>>> getMyAppointments();

  /// Cancels an active appointment consultation.
  Future<Either<Failure, bool>> cancelAppointment(String appointmentId);
}
