import 'package:equatable/equatable.dart';

/// Represents an appointment record.
class AppointmentEntity extends Equatable {
  final String id;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialization;
  final String doctorClinicAddress;
  final String patientName;
  final String patientPhone;
  final String appointmentDate;
  final String timeSlot;
  final String? medicalNotes;
  final String status; // Pending, Confirmed, Cancelled, Completed

  const AppointmentEntity({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.doctorClinicAddress,
    required this.patientName,
    required this.patientPhone,
    required this.appointmentDate,
    required this.timeSlot,
    this.medicalNotes,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        doctorId,
        doctorName,
        doctorSpecialization,
        doctorClinicAddress,
        patientName,
        patientPhone,
        appointmentDate,
        timeSlot,
        medicalNotes,
        status,
      ];
}
