import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/admin_repository.dart';
import 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminRepository _repository;

  AdminCubit({required AdminRepository repository})
      : _repository = repository,
        super(const AdminInitial());

  Future<void> fetchDashboardData({bool silent = false}) async {
    if (!silent) {
      emit(const AdminLoading());
    }

    final statsRes = await _repository.getStats();
    final dashStatsRes = await _repository.getDashboardStats();
    final chartsRes = await _repository.getChartData();
    final patientsRes = await _repository.getPatients();
    final doctorsRes = await _repository.getDoctors();
    final apptsRes = await _repository.getAppointments();
    final activitiesRes = await _repository.getRecentActivity();

    String? errorMessage;
    statsRes.fold((l) => errorMessage = l.message, (r) => null);
    dashStatsRes.fold((l) => errorMessage = l.message, (r) => null);
    chartsRes.fold((l) => errorMessage = l.message, (r) => null);
    patientsRes.fold((l) => errorMessage = l.message, (r) => null);
    doctorsRes.fold((l) => errorMessage = l.message, (r) => null);
    apptsRes.fold((l) => errorMessage = l.message, (r) => null);
    activitiesRes.fold((l) => errorMessage = l.message, (r) => null);

    if (errorMessage != null) {
      emit(AdminError(errorMessage!));
      return;
    }

    final stats = statsRes.getOrElse(() => throw StateError('Stats unavailable'));
    final dashStats = dashStatsRes.getOrElse(() => throw StateError('Dashboard stats unavailable'));
    final chartData = chartsRes.getOrElse(() => throw StateError('Charts unavailable'));
    final patients = patientsRes.getOrElse(() => []);
    final doctors = doctorsRes.getOrElse(() => []);
    final appointments = apptsRes.getOrElse(() => []);
    final activities = activitiesRes.getOrElse(() => []);

    emit(AdminLoaded(
      stats: stats,
      dashboardStats: dashStats,
      chartData: chartData,
      patients: patients,
      doctors: doctors,
      appointments: appointments,
      activities: activities,
    ));
  }

  Future<void> deletePatient(String id) async {
    final result = await _repository.deletePatient(id);
    result.fold(
      (l) => emit(AdminError(l.message)),
      (r) => fetchDashboardData(silent: true),
    );
  }

  Future<void> deleteDoctor(String id) async {
    final result = await _repository.deleteDoctor(id);
    result.fold(
      (l) => emit(AdminError(l.message)),
      (r) => fetchDashboardData(silent: true),
    );
  }

  Future<void> approveDoctor(String id) async {
    final result = await _repository.approveDoctor(id);
    result.fold(
      (l) => emit(AdminError(l.message)),
      (r) => fetchDashboardData(silent: true),
    );
  }

  Future<void> rejectDoctor(String id, String reason) async {
    final result = await _repository.rejectDoctor(id, reason);
    result.fold(
      (l) => emit(AdminError(l.message)),
      (r) => fetchDashboardData(silent: true),
    );
  }

  Future<void> updateAppointmentStatus(String id, String status) async {
    final result = await _repository.updateAppointmentStatus(id, status);
    result.fold(
      (l) => emit(AdminError(l.message)),
      (r) => fetchDashboardData(silent: true),
    );
  }

  Future<bool> registerDoctor(Map<String, dynamic> payload) async {
    final result = await _repository.registerDoctor(payload);
    return result.fold(
      (l) {
        emit(AdminError(l.message));
        return false;
      },
      (r) {
        fetchDashboardData(silent: true);
        return true;
      },
    );
  }

  Future<bool> registerPatient(Map<String, dynamic> payload) async {
    final result = await _repository.registerPatient(payload);
    return result.fold(
      (l) {
        emit(AdminError(l.message));
        return false;
      },
      (r) {
        fetchDashboardData(silent: true);
        return true;
      },
    );
  }

  Future<bool> addSpecialty(Map<String, dynamic> payload) async {
    final result = await _repository.addSpecialty(payload);
    return result.fold(
      (l) {
        emit(AdminError(l.message));
        return false;
      },
      (r) {
        fetchDashboardData(silent: true);
        return true;
      },
    );
  }
}
