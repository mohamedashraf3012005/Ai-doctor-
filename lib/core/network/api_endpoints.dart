/// Centralized API endpoint constants matching the backend Swagger spec.
class ApiEndpoints {
  ApiEndpoints._();

  // ─── Auth ─────────────────────────────────────────────────
  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static const String profile = 'auth/profile';
  static const String forgotPassword = 'auth/forgot-password';
  static const String verifyOtp = 'auth/verify-otp';
  static const String resetPassword = 'auth/reset-password';

  // ─── Doctors ──────────────────────────────────────────────
  static const String doctors = 'doctors';
  static String doctorById(String id) => 'doctors/$id';
  static String doctorAvailability(String id) => 'doctors/$id/availability';
  static const String doctorProfile = 'doctors/profile';
  static const String doctorDashboard = 'doctors/dashboard';
  static const String doctorAvailabilityPost = 'doctors/availability';

  // ─── Appointments ─────────────────────────────────────────
  static const String appointments = 'appointments';
  static const String myAppointments = 'appointments/my';
  static const String todayAppointments = 'appointments/today';
  static String cancelAppointment(String id) => 'appointments/$id/cancel';
  static String appointmentStatus(String id) => 'appointments/$id/status';

  // ─── Diagnosis ────────────────────────────────────────────
  static const String diagnosisAnalyze = 'diagnosis/analyze';
  static const String myDiagnoses = 'diagnosis/my';
  static String diagnosisById(String id) => 'diagnosis/$id';

  // ─── Chat ─────────────────────────────────────────────────
  static const String chatContacts = 'chat/contacts';
  static String chatHistory(String contactId) => 'chat/history/$contactId';
  static const String chatSend = 'chat/send';

  // ─── Patient ──────────────────────────────────────────────
  static const String patientDashboard = 'patient/dashboard';

  // ─── Reviews ──────────────────────────────────────────────
  static const String reviews = 'reviews';
  static String doctorReviews(String doctorId) => 'reviews/doctor/$doctorId';

  // ─── Notifications ────────────────────────────────────────
  static const String notifications = 'notifications';
  static String markNotificationRead(String id) => 'notifications/$id/read';

  // ─── Admin ───────────────────────────────────────────────
  static const String publicStats = 'public/stats';
  static const String adminPatients = 'admin/patients';
  static const String adminDoctors = 'admin/doctors';
  static const String adminDashboardStats = 'admin/dashboardStats';
  static const String adminCharts = 'admin/charts';
  static const String adminAppointments = 'admin/appointments';
  static const String adminSpecialties = 'admin/specialties';
  static String adminDeletePatient(String id) => 'admin/patients/$id';
  static String adminDeleteDoctor(String id) => 'admin/doctors/$id';
  static String adminApproveDoctor(String id) => 'admin/doctors/$id/approve';
  static String adminRejectDoctor(String id) => 'admin/doctors/$id/reject';
  static String adminAppointmentStatus(String id) => 'admin/appointments/$id/status';
  static const String adminRegisterDoctor = 'admin/doctors/register';
  static const String adminRegisterPatient = 'admin/patients/register';
  static const String adminActivity = 'admin/activity';
}
