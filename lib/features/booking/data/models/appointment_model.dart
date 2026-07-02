import '../../domain/entities/appointment_entity.dart';

/// Appointment details representation with serialization/deserialization.
class AppointmentModel {
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
  final String status;

  const AppointmentModel({
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

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    // Resolve doctor nested attributes if present, otherwise handle flat format
    final doc = json['doctor'] ?? {};
    final docId = (json['doctorId'] ?? doc['id'] ?? '').toString();
    final docName = json['doctorName'] ?? doc['fullName'] ?? doc['name'] ?? '';
    final docSpec = json['doctorSpecialization'] ?? doc['specialization'] ?? doc['specialty'] ?? '';
    final docAddress = json['doctorClinicAddress'] ?? doc['clinicAddress'] ?? doc['address'] ?? '';

    return AppointmentModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      doctorId: docId,
      doctorName: docName,
      doctorSpecialization: docSpec,
      doctorClinicAddress: docAddress,
      patientName: json['patientName'] ?? json['name'] ?? '',
      patientPhone: json['patientPhone'] ?? json['phone'] ?? '',
      appointmentDate: json['appointmentDate'] ?? json['date'] ?? '',
      timeSlot: json['timeSlot'] ?? json['time'] ?? '',
      medicalNotes: json['medicalNotes'] ?? json['notes'],
      status: json['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'doctorId': doctorId,
        'doctorName': doctorName,
        'doctorSpecialization': doctorSpecialization,
        'doctorClinicAddress': doctorClinicAddress,
        'patientName': patientName,
        'patientPhone': patientPhone,
        'appointmentDate': appointmentDate,
        'timeSlot': timeSlot,
        'medicalNotes': medicalNotes,
        'status': status,
      };

  AppointmentEntity toEntity() => AppointmentEntity(
        id: id,
        doctorId: doctorId,
        doctorName: doctorName,
        doctorSpecialization: doctorSpecialization,
        doctorClinicAddress: doctorClinicAddress,
        patientName: patientName,
        patientPhone: patientPhone,
        appointmentDate: appointmentDate,
        timeSlot: timeSlot,
        medicalNotes: medicalNotes,
        status: status,
      );
}
