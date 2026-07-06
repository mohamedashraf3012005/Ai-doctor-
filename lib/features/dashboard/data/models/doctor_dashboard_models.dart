class DoctorDashboardStatsModel {
  final int todayAppointmentsCount;
  final int totalPatientsCount;
  final int totalSessionsCount;
  final int upcomingAppointmentsCount;
  final int newReportsCount;
  final String doctorName;
  final String doctorSpecialty;
  final List<DoctorDashboardAppointmentModel> todayAppointments;
  final List<DoctorDashboardAppointmentModel> pastAppointments;
  final List<DoctorDashboardReportModel> pendingReports;
  final DoctorDashboardScanStatsModel scanStats;
  final List<int> weeklyAppointments;

  const DoctorDashboardStatsModel({
    required this.todayAppointmentsCount,
    required this.totalPatientsCount,
    required this.totalSessionsCount,
    required this.upcomingAppointmentsCount,
    required this.newReportsCount,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.todayAppointments,
    required this.pastAppointments,
    required this.pendingReports,
    required this.scanStats,
    required this.weeklyAppointments,
  });

  factory DoctorDashboardStatsModel.fromJson(Map<String, dynamic> json) {
    final todayApptsList = json['todayAppointments'] ?? json['TodayAppointments'] as List? ?? [];
    final pastApptsList = json['pastAppointments'] ?? json['PastAppointments'] as List? ?? [];
    final pendingRepList = json['pendingReports'] ?? json['PendingReports'] as List? ?? [];
    
    final scanStatsMap = json['scanStats'] ?? json['ScanStats'] as Map<String, dynamic>? ?? {};
    final weeklyList = json['weeklyAppointments'] ?? json['WeeklyAppointments'] as List? ?? [];

    return DoctorDashboardStatsModel(
      todayAppointmentsCount: json['todayAppointmentsCount'] ?? json['TodayAppointmentsCount'] ?? 0,
      totalPatientsCount: json['totalPatientsCount'] ?? json['TotalPatientsCount'] ?? 0,
      totalSessionsCount: json['totalSessionsCount'] ?? json['TotalSessionsCount'] ?? 0,
      upcomingAppointmentsCount: json['upcomingAppointmentsCount'] ?? json['UpcomingAppointmentsCount'] ?? 0,
      newReportsCount: json['newReportsCount'] ?? json['NewReportsCount'] ?? 0,
      doctorName: json['doctorName'] ?? json['DoctorName'] ?? '',
      doctorSpecialty: json['doctorSpecialty'] ?? json['DoctorSpecialty'] ?? '',
      todayAppointments: (todayApptsList as List).map<DoctorDashboardAppointmentModel>((e) => DoctorDashboardAppointmentModel.fromJson(e)).toList(),
      pastAppointments: (pastApptsList as List).map<DoctorDashboardAppointmentModel>((e) => DoctorDashboardAppointmentModel.fromJson(e)).toList(),
      pendingReports: (pendingRepList as List).map<DoctorDashboardReportModel>((e) => DoctorDashboardReportModel.fromJson(e)).toList(),
      scanStats: DoctorDashboardScanStatsModel.fromJson(scanStatsMap),
      weeklyAppointments: List<int>.from(weeklyList.map((e) => (e as num).toInt())),
    );
  }
}

class DoctorDashboardAppointmentModel {
  final String id;
  final String? patientId;
  final String patientName;
  final String time;
  final String status;
  final String reason;
  final String appointmentDate;
  final int? queueNumber;

  const DoctorDashboardAppointmentModel({
    required this.id,
    this.patientId,
    required this.patientName,
    required this.time,
    required this.status,
    required this.reason,
    required this.appointmentDate,
    this.queueNumber,
  });

  factory DoctorDashboardAppointmentModel.fromJson(Map<String, dynamic> json) {
    return DoctorDashboardAppointmentModel(
      id: json['id']?.toString() ?? json['Id']?.toString() ?? '',
      patientId: json['patientId']?.toString() ?? json['PatientId']?.toString(),
      patientName: json['patientName'] ?? json['PatientName'] ?? 'Patient',
      time: json['time'] ?? json['Time'] ?? '',
      status: json['status'] ?? json['Status'] ?? 'Scheduled',
      reason: json['reason'] ?? json['Reason'] ?? 'General Consultation',
      appointmentDate: json['appointmentDate'] ?? json['AppointmentDate'] ?? '',
      queueNumber: json['queueNumber'] ?? json['QueueNumber'],
    );
  }
}

class DoctorDashboardReportModel {
  final String id;
  final String? patientId;
  final String patientName;
  final String aiResult;
  final String scanType;
  final String date;

  const DoctorDashboardReportModel({
    required this.id,
    this.patientId,
    required this.patientName,
    required this.aiResult,
    required this.scanType,
    required this.date,
  });

  factory DoctorDashboardReportModel.fromJson(Map<String, dynamic> json) {
    return DoctorDashboardReportModel(
      id: json['id']?.toString() ?? json['Id']?.toString() ?? '',
      patientId: json['patientId']?.toString() ?? json['PatientId']?.toString(),
      patientName: json['patientName'] ?? json['PatientName'] ?? 'Patient',
      aiResult: json['aiResult'] ?? json['AIResult'] ?? 'Pending',
      scanType: json['scanType'] ?? json['ScanType'] ?? 'General',
      date: json['date'] ?? json['Date'] ?? '',
    );
  }
}

class DoctorDashboardScanStatsModel {
  final int total;
  final int normal;
  final int warning;
  final int critical;

  const DoctorDashboardScanStatsModel({
    required this.total,
    required this.normal,
    required this.warning,
    required this.critical,
  });

  factory DoctorDashboardScanStatsModel.fromJson(Map<String, dynamic> json) {
    return DoctorDashboardScanStatsModel(
      total: json['total'] ?? 0,
      normal: json['normal'] ?? 0,
      warning: json['warning'] ?? 0,
      critical: json['critical'] ?? 0,
    );
  }
}

class DoctorAvailabilityModel {
  final int dayOfWeek;
  final String startTime;
  final String endTime;

  const DoctorAvailabilityModel({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  factory DoctorAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return DoctorAvailabilityModel(
      dayOfWeek: json['dayOfWeek'] ?? json['DayOfWeek'] ?? 0,
      startTime: json['startTime'] ?? json['StartTime'] ?? '09:00',
      endTime: json['endTime'] ?? json['EndTime'] ?? '17:00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}

class DoctorPatientDetailsModel {
  final String id;
  final String fullName;
  final String email;
  final String gender;
  final int? age;
  final String? medicalHistory;
  final List<DoctorDashboardReportModel> scans;

  const DoctorPatientDetailsModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.gender,
    this.age,
    this.medicalHistory,
    required this.scans,
  });

  factory DoctorPatientDetailsModel.fromJson(Map<String, dynamic> json) {
    final scansList = json['scans'] ?? json['Scans'] as List? ?? [];
    return DoctorPatientDetailsModel(
      id: json['id']?.toString() ?? json['Id']?.toString() ?? '',
      fullName: json['fullName'] ?? json['FullName'] ?? 'Patient',
      email: json['email'] ?? json['Email'] ?? '',
      gender: json['gender'] ?? json['Gender'] ?? 'Male',
      age: json['age'] ?? json['Age'],
      medicalHistory: json['medicalHistory'] ?? json['MedicalHistory'],
      scans: (scansList as List).map<DoctorDashboardReportModel>((e) => DoctorDashboardReportModel.fromJson(e)).toList(),
    );
  }
}

class DoctorProfileModel {
  final String fullName;
  final String specialty;
  final String phoneNumber;
  final int? experienceYears;
  final String? bio;
  final String? clinicAddress;
  final double? rating;
  final List<DoctorAvailabilityModel> availabilities;

  const DoctorProfileModel({
    required this.fullName,
    required this.specialty,
    required this.phoneNumber,
    this.experienceYears,
    this.bio,
    this.clinicAddress,
    this.rating,
    required this.availabilities,
  });

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    final list = json['availabilities'] ?? json['Availabilities'] as List? ?? [];
    return DoctorProfileModel(
      fullName: json['fullName'] ?? json['FullName'] ?? '',
      specialty: json['specialty'] ?? json['Specialty'] ?? '',
      phoneNumber: json['phoneNumber'] ?? json['phoneNumber'] ?? json['Phone'] ?? '',
      experienceYears: json['experienceYears'] ?? json['exp'] ?? 0,
      bio: json['bio'] ?? json['Bio'] ?? '',
      clinicAddress: json['clinicAddress'] ?? json['ClinicAddress'] ?? '',
      rating: (json['rating'] ?? json['Rating'] as num?)?.toDouble() ?? 0.0,
      availabilities: (list as List).map<DoctorAvailabilityModel>((e) => DoctorAvailabilityModel.fromJson(e)).toList(),
    );
  }
}
