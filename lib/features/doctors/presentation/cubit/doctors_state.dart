import 'package:equatable/equatable.dart';
import '../../domain/entities/doctor_entity.dart';

/// States for doctors search and listing.
abstract class DoctorsState extends Equatable {
  const DoctorsState();

  @override
  List<Object?> get props => [];
}

class DoctorsInitial extends DoctorsState {
  const DoctorsInitial();
}

class DoctorsLoading extends DoctorsState {
  const DoctorsLoading();
}

class DoctorsLoaded extends DoctorsState {
  final List<DoctorEntity> doctors;

  const DoctorsLoaded(this.doctors);

  @override
  List<Object?> get props => [doctors];
}

class DoctorsError extends DoctorsState {
  final String message;

  const DoctorsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State for doctor schedule checking.
abstract class DoctorAvailabilityState extends Equatable {
  const DoctorAvailabilityState();

  @override
  List<Object?> get props => [];
}

class DoctorAvailabilityInitial extends DoctorAvailabilityState {}

class DoctorAvailabilityLoading extends DoctorAvailabilityState {}

class DoctorAvailabilityLoaded extends DoctorAvailabilityState {
  final Map<String, List<String>> availability;

  const DoctorAvailabilityLoaded(this.availability);

  @override
  List<Object?> get props => [availability];
}

class DoctorAvailabilityError extends DoctorAvailabilityState {
  final String message;

  const DoctorAvailabilityError(this.message);

  @override
  List<Object?> get props => [message];
}
