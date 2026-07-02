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
}
