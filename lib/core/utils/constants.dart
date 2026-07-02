/// Application-wide constants.
class AppConstants {
  AppConstants._();

  /// Animation durations.
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 350);
  static const Duration slowAnimation = Duration(milliseconds: 600);

  /// Pagination defaults.
  static const int defaultPageSize = 20;

  /// Specialties available in the system.
  static const List<String> specialties = [
    'Orthopedics',
    'Pneumonia',
    'Neurology',
  ];

  /// Scan types for diagnosis.
  static const Map<String, String> scanTypes = {
    'xray_bone': 'X-Ray (Bone Fracture)',
    'ecg_heart': 'X-Ray (Pneumonia)',
    'brain_neurology': 'Brain Tumors (MRI)',
  };

  /// User roles.
  static const String rolePatient = 'patient';
  static const String roleDoctor = 'doctor';
  static const String roleAdmin = 'admin';
}
