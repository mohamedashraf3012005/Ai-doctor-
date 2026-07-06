class AdminStatsModel {
  final int totalPatients;
  final int totalDoctors;
  final int totalScans;
  final int todayAppointments;
  final int monthAppointments;

  const AdminStatsModel({
    required this.totalPatients,
    required this.totalDoctors,
    required this.totalScans,
    required this.todayAppointments,
    required this.monthAppointments,
  });

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminStatsModel(
      totalPatients: json['totalPatients'] ?? 0,
      totalDoctors: json['totalDoctors'] ?? 0,
      totalScans: json['totalScans'] ?? 0,
      todayAppointments: json['todayAppointments'] ?? 0,
      monthAppointments: json['monthAppointments'] ?? 0,
    );
  }
}

class DashboardStatsModel {
  final List<String> growthLabels;
  final List<double> patientGrowth;
  final List<double> doctorGrowth;

  const DashboardStatsModel({
    required this.growthLabels,
    required this.patientGrowth,
    required this.doctorGrowth,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    final labels = List<String>.from(json['growthLabels'] ?? json['GrowthLabels'] ?? []);
    final patients = List<num>.from(json['patientGrowth'] ?? json['PatientGrowth'] ?? [])
        .map((e) => e.toDouble())
        .toList();
    final doctors = List<num>.from(json['doctorGrowth'] ?? json['DoctorGrowth'] ?? [])
        .map((e) => e.toDouble())
        .toList();

    return DashboardStatsModel(
      growthLabels: labels.isEmpty ? ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'] : labels,
      patientGrowth: patients.isEmpty ? [0, 0, 0, 0, 0, 0, 0] : patients,
      doctorGrowth: doctors.isEmpty ? [0, 0, 0, 0, 0, 0, 0] : doctors,
    );
  }
}

class ChartDataModel {
  final List<String> specLabels;
  final List<double> specValues;
  final List<String> genderLabels;
  final List<double> genderValues;
  final List<String> statusLabels;
  final List<double> statusValues;
  final List<String> weekLabels;
  final List<double> weekValues;

  const ChartDataModel({
    required this.specLabels,
    required this.specValues,
    required this.genderLabels,
    required this.genderValues,
    required this.statusLabels,
    required this.statusValues,
    required this.weekLabels,
    required this.weekValues,
  });

  factory ChartDataModel.fromJson(Map<String, dynamic> json) {
    final specL = List<String>.from(json['specLabels'] ?? json['SpecLabels'] ?? []);
    final specV = List<num>.from(json['specValues'] ?? json['SpecValues'] ?? [])
        .map((e) => e.toDouble())
        .toList();

    final genL = List<String>.from(json['genderLabels'] ?? json['GenderLabels'] ?? []);
    final genV = List<num>.from(json['genderValues'] ?? json['GenderValues'] ?? [])
        .map((e) => e.toDouble())
        .toList();

    final statL = List<String>.from(json['statusLabels'] ?? json['StatusLabels'] ?? []);
    final statV = List<num>.from(json['statusValues'] ?? json['StatusValues'] ?? [])
        .map((e) => e.toDouble())
        .toList();

    final weekL = List<String>.from(json['weekLabels'] ?? json['WeekLabels'] ?? []);
    final weekV = List<num>.from(json['weekValues'] ?? json['WeekValues'] ?? [])
        .map((e) => e.toDouble())
        .toList();

    return ChartDataModel(
      specLabels: specL.isEmpty ? ['No Data'] : specL,
      specValues: specV.isEmpty ? [1.0] : specV,
      genderLabels: genL.isEmpty ? ['Male', 'Female'] : genL,
      genderValues: genV.isEmpty ? [0.0, 0.0] : genV,
      statusLabels: statL.isEmpty ? ['No Data'] : statL,
      statusValues: statV.isEmpty ? [1.0] : statV,
      weekLabels: weekL.isEmpty ? ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'] : weekL,
      weekValues: weekV.isEmpty ? [0, 0, 0, 0, 0, 0, 0] : weekV,
    );
  }
}

class AdminPatientModel {
  final String id;
  final String fullName;
  final String email;
  final String? createdAt;

  const AdminPatientModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.createdAt,
  });

  factory AdminPatientModel.fromJson(Map<String, dynamic> json) {
    return AdminPatientModel(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      createdAt: json['createdAt']?.toString(),
    );
  }
}

class AdminDoctorModel {
  final String id;
  final String fullName;
  final String email;
  final String specialty;
  final String clinicAddress;
  final int experienceYears;
  final bool isApproved;
  final String? idCardPath;

  const AdminDoctorModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.specialty,
    required this.clinicAddress,
    required this.experienceYears,
    required this.isApproved,
    this.idCardPath,
  });

  factory AdminDoctorModel.fromJson(Map<String, dynamic> json) {
    return AdminDoctorModel(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName'] ?? json['name'] ?? '',
      email: json['email']?.toString() ?? '',
      specialty: json['specialty']?.toString() ?? 'General',
      clinicAddress: json['clinicAddress']?.toString() ?? '',
      experienceYears: json['experienceYears'] ?? json['exp'] ?? 0,
      isApproved: json['isApproved'] ?? json['IsApproved'] ?? false,
      idCardPath: json['idCardPath'] ?? json['IdCardPath'],
    );
  }
}

class AdminAppointmentModel {
  final String id;
  final String? patientId;
  final String patientName;
  final String? doctorId;
  final String doctorName;
  final String specialty;
  final String appointmentDate;
  final String timeSlot;
  final String status;

  const AdminAppointmentModel({
    required this.id,
    this.patientId,
    required this.patientName,
    this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.appointmentDate,
    required this.timeSlot,
    required this.status,
  });

  factory AdminAppointmentModel.fromJson(Map<String, dynamic> json) {
    return AdminAppointmentModel(
      id: json['id']?.toString() ?? '',
      patientId: json['patientId']?.toString(),
      patientName: json['patientName'] ?? json['patient'] ?? '',
      doctorId: json['doctorId']?.toString(),
      doctorName: json['doctorName'] ?? json['doctor'] ?? '',
      specialty: json['specialty'] ?? json['specialization'] ?? 'General',
      appointmentDate: json['appointmentDate'] ?? json['date'] ?? '',
      timeSlot: json['timeSlot'] ?? json['time'] ?? '',
      status: json['status'] ?? 'Pending',
    );
  }
}

class AdminActivityModel {
  final String user;
  final String action;
  final String status;
  final String color;
  final String? time;

  const AdminActivityModel({
    required this.user,
    required this.action,
    required this.status,
    required this.color,
    this.time,
  });

  factory AdminActivityModel.fromJson(Map<String, dynamic> json) {
    return AdminActivityModel(
      user: json['user']?.toString() ?? '',
      action: json['action']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      color: json['color']?.toString() ?? 'primary',
      time: json['time']?.toString(),
    );
  }
}
