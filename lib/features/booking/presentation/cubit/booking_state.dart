import 'package:equatable/equatable.dart';
import '../../domain/entities/appointment_entity.dart';

/// States for Booking flow.
abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

class BookingLoading extends BookingState {
  const BookingLoading();
}

class BookingSuccess extends BookingState {
  final AppointmentEntity appointment;

  const BookingSuccess(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}

/// States for fetching my appointments list.
abstract class MyAppointmentsState extends Equatable {
  const MyAppointmentsState();

  @override
  List<Object?> get props => [];
}

class MyAppointmentsInitial extends MyAppointmentsState {}

class MyAppointmentsLoading extends MyAppointmentsState {}

class MyAppointmentsLoaded extends MyAppointmentsState {
  final List<AppointmentEntity> appointments;

  const MyAppointmentsLoaded(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

class MyAppointmentsError extends MyAppointmentsState {
  final String message;

  const MyAppointmentsError(this.message);

  @override
  List<Object?> get props => [message];
}
