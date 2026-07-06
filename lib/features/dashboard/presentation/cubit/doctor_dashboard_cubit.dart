import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/doctor_dashboard_repository.dart';
import '../../data/models/doctor_dashboard_models.dart';
import 'doctor_dashboard_state.dart';

class DoctorDashboardCubit extends Cubit<DoctorDashboardState> {
  final DoctorDashboardRepository _repository;

  DoctorDashboardCubit({required DoctorDashboardRepository repository})
      : _repository = repository,
        super(const DoctorDashboardInitial());

  Future<void> fetchDashboard({bool silent = false}) async {
    if (!silent) {
      emit(const DoctorDashboardLoading());
    }

    final statsRes = await _repository.getDashboard();
    final profileRes = await _repository.getMyProfile();

    String? errorMessage;
    statsRes.fold((l) => errorMessage = l.message, (r) => null);
    profileRes.fold((l) => errorMessage = l.message, (r) => null);

    if (errorMessage != null) {
      emit(DoctorDashboardError(errorMessage!));
      return;
    }

    final stats = statsRes.getOrElse(() => throw StateError('Stats unavailable'));
    final profile = profileRes.getOrElse(() => throw StateError('Profile unavailable'));

    emit(DoctorDashboardLoaded(
      stats: stats,
      profile: profile,
      patientDetails: state is DoctorDashboardLoaded ? (state as DoctorDashboardLoaded).patientDetails : null,
    ));
  }

  Future<void> updateAvailability(List<DoctorAvailabilityModel> payload) async {
    final result = await _repository.updateAvailability(payload);
    result.fold(
      (l) => emit(DoctorDashboardError(l.message)),
      (r) => fetchDashboard(silent: true),
    );
  }

  Future<bool> updateProfile(Map<String, dynamic> payload) async {
    final result = await _repository.updateProfile(payload);
    return result.fold(
      (l) {
        emit(DoctorDashboardError(l.message));
        return false;
      },
      (r) {
        fetchDashboard(silent: true);
        return true;
      },
    );
  }

  Future<void> fetchPatientDetails(String patientId) async {
    final currentState = state;
    if (currentState is DoctorDashboardLoaded) {
      final result = await _repository.getPatientDetails(patientId);
      result.fold(
        (l) => emit(DoctorDashboardError(l.message)),
        (r) => emit(currentState.copyWith(patientDetails: r)),
      );
    }
  }

  Future<void> updateAppointmentStatus(String id, String status) async {
    final result = await _repository.updateAppointmentStatus(id, status);
    result.fold(
      (l) => emit(DoctorDashboardError(l.message)),
      (r) => fetchDashboard(silent: true),
    );
  }

  void clearPatientDetails() {
    final currentState = state;
    if (currentState is DoctorDashboardLoaded) {
      emit(currentState.copyWith(clearPatientDetails: true));
    }
  }
}
