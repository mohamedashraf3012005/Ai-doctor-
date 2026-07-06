import 'package:equatable/equatable.dart';
import '../../data/models/admin_models.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {
  const AdminInitial();
}

class AdminLoading extends AdminState {
  const AdminLoading();
}

class AdminLoaded extends AdminState {
  final AdminStatsModel stats;
  final DashboardStatsModel dashboardStats;
  final ChartDataModel chartData;
  final List<AdminPatientModel> patients;
  final List<AdminDoctorModel> doctors;
  final List<AdminAppointmentModel> appointments;
  final List<AdminActivityModel> activities;

  const AdminLoaded({
    required this.stats,
    required this.dashboardStats,
    required this.chartData,
    required this.patients,
    required this.doctors,
    required this.appointments,
    required this.activities,
  });

  AdminLoaded copyWith({
    AdminStatsModel? stats,
    DashboardStatsModel? dashboardStats,
    ChartDataModel? chartData,
    List<AdminPatientModel>? patients,
    List<AdminDoctorModel>? doctors,
    List<AdminAppointmentModel>? appointments,
    List<AdminActivityModel>? activities,
  }) {
    return AdminLoaded(
      stats: stats ?? this.stats,
      dashboardStats: dashboardStats ?? this.dashboardStats,
      chartData: chartData ?? this.chartData,
      patients: patients ?? this.patients,
      doctors: doctors ?? this.doctors,
      appointments: appointments ?? this.appointments,
      activities: activities ?? this.activities,
    );
  }

  @override
  List<Object?> get props => [
        stats,
        dashboardStats,
        chartData,
        patients,
        doctors,
        appointments,
        activities,
      ];
}

class AdminError extends AdminState {
  final String message;

  const AdminError(this.message);

  @override
  List<Object?> get props => [message];
}
