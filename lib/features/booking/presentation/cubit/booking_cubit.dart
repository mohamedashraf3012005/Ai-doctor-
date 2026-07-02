import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/book_appointment_use_case.dart';
import '../../domain/use_cases/get_my_appointments_use_case.dart';
import 'booking_state.dart';

/// Cubit managing consultation appointment booking transactions.
class BookingCubit extends Cubit<BookingState> {
  final BookAppointmentUseCase _bookAppointmentUseCase;

  BookingCubit({
    required BookAppointmentUseCase bookAppointmentUseCase,
  })  : _bookAppointmentUseCase = bookAppointmentUseCase,
        super(const BookingInitial());

  /// Books an appointment.
  Future<void> bookAppointment({
    required String doctorId,
    required String patientName,
    required String patientPhone,
    required String appointmentDate,
    required String timeSlot,
    String? medicalNotes,
  }) async {
    emit(const BookingLoading());
    final result = await _bookAppointmentUseCase(
      doctorId: doctorId,
      patientName: patientName,
      patientPhone: patientPhone,
      appointmentDate: appointmentDate,
      timeSlot: timeSlot,
      medicalNotes: medicalNotes,
    );
    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (appointment) => emit(BookingSuccess(appointment)),
    );
  }

  void reset() => emit(const BookingInitial());
}

/// Cubit managing a patient's historical or upcoming scheduled consultations list.
class MyAppointmentsCubit extends Cubit<MyAppointmentsState> {
  final GetMyAppointmentsUseCase _getMyAppointmentsUseCase;
  final CancelAppointmentUseCase _cancelAppointmentUseCase;

  MyAppointmentsCubit({
    required GetMyAppointmentsUseCase getMyAppointmentsUseCase,
    required CancelAppointmentUseCase cancelAppointmentUseCase,
  })  : _getMyAppointmentsUseCase = getMyAppointmentsUseCase,
        _cancelAppointmentUseCase = cancelAppointmentUseCase,
        super(MyAppointmentsInitial());

  /// Fetches lists.
  Future<void> fetchAppointments() async {
    emit(MyAppointmentsLoading());
    final result = await _getMyAppointmentsUseCase();
    result.fold(
      (failure) => emit(MyAppointmentsError(failure.message)),
      (appointments) => emit(MyAppointmentsLoaded(appointments)),
    );
  }

  /// Cancels an appointment.
  Future<void> cancelAppointment(String id) async {
    final result = await _cancelAppointmentUseCase(id);
    result.fold(
      (failure) => emit(MyAppointmentsError(failure.message)),
      (_) => fetchAppointments(),
    );
  }
}
