import 'package:equatable/equatable.dart';
import '../../data/models/doctor_dashboard_models.dart';

abstract class DoctorDashboardState extends Equatable {
  const DoctorDashboardState();

  @override
  List<Object?> get props => [];
}

class DoctorDashboardInitial extends DoctorDashboardState {
  const DoctorDashboardInitial();
}

class DoctorDashboardLoading extends DoctorDashboardState {
  const DoctorDashboardLoading();
}

class DoctorDashboardLoaded extends DoctorDashboardState {
  final DoctorDashboardStatsModel stats;
  final DoctorProfileModel profile;
  final DoctorPatientDetailsModel? patientDetails;

  const DoctorDashboardLoaded({
    required this.stats,
    required this.profile,
    this.patientDetails,
  });

  DoctorDashboardLoaded copyWith({
    DoctorDashboardStatsModel? stats,
    DoctorProfileModel? profile,
    DoctorPatientDetailsModel? patientDetails,
    bool clearPatientDetails = false,
  }) {
    return DoctorDashboardLoaded(
      stats: stats ?? this.stats,
      profile: profile ?? this.profile,
      patientDetails: clearPatientDetails ? null : (patientDetails ?? this.patientDetails),
    );
  }

  @override
  List<Object?> get props => [stats, profile, patientDetails];
}

class DoctorDashboardError extends DoctorDashboardState {
  final String message;

  const DoctorDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
