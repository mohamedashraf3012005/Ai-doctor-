import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_doctor_availability_use_case.dart';
import '../../domain/use_cases/get_doctors_use_case.dart';
import 'doctors_state.dart';

/// Cubit managing doctors data fetching.
class DoctorsCubit extends Cubit<DoctorsState> {
  final GetDoctorsUseCase _getDoctorsUseCase;

  DoctorsCubit({
    required GetDoctorsUseCase getDoctorsUseCase,
  })  : _getDoctorsUseCase = getDoctorsUseCase,
        super(const DoctorsInitial());

  /// Load the doctor list with search parameters.
  Future<void> fetchDoctors({String? searchQuery, String? specialty}) async {
    emit(const DoctorsLoading());
    final result = await _getDoctorsUseCase(
      searchQuery: searchQuery,
      specialty: specialty,
    );
    result.fold(
      (failure) => emit(DoctorsError(failure.message)),
      (doctors) => emit(DoctorsLoaded(doctors)),
    );
  }
}

/// Cubit managing a single doctor's availability dates and slots.
class DoctorAvailabilityCubit extends Cubit<DoctorAvailabilityState> {
  final GetDoctorAvailabilityUseCase _getDoctorAvailabilityUseCase;

  DoctorAvailabilityCubit({
    required GetDoctorAvailabilityUseCase getDoctorAvailabilityUseCase,
  })  : _getDoctorAvailabilityUseCase = getDoctorAvailabilityUseCase,
        super(DoctorAvailabilityInitial());

  /// Load availability slots.
  Future<void> fetchAvailability({required String doctorId, String? date}) async {
    emit(DoctorAvailabilityLoading());
    final result = await _getDoctorAvailabilityUseCase(
      doctorId: doctorId,
      date: date,
    );
    result.fold(
      (failure) => emit(DoctorAvailabilityError(failure.message)),
      (availability) => emit(DoctorAvailabilityLoaded(availability)),
    );
  }
}
