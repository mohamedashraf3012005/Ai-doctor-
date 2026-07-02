import 'package:equatable/equatable.dart';
import '../../domain/entities/diagnosis_entity.dart';

/// States for AI Scan Upload & Results.
abstract class DiagnosisState extends Equatable {
  const DiagnosisState();

  @override
  List<Object?> get props => [];
}

class DiagnosisInitial extends DiagnosisState {
  const DiagnosisInitial();
}

class DiagnosisLoading extends DiagnosisState {
  final double progress;

  const DiagnosisLoading({this.progress = 0.0});

  @override
  List<Object?> get props => [progress];
}

class DiagnosisSuccess extends DiagnosisState {
  final DiagnosisEntity diagnosis;

  const DiagnosisSuccess(this.diagnosis);

  @override
  List<Object?> get props => [diagnosis];
}

class DiagnosisError extends DiagnosisState {
  final String message;

  const DiagnosisError(this.message);

  @override
  List<Object?> get props => [message];
}

/// States for fetching patient's previous diagnosis list.
abstract class MyDiagnosesState extends Equatable {
  const MyDiagnosesState();

  @override
  List<Object?> get props => [];
}

class MyDiagnosesInitial extends MyDiagnosesState {}

class MyDiagnosesLoading extends MyDiagnosesState {}

class MyDiagnosesLoaded extends MyDiagnosesState {
  final List<DiagnosisEntity> diagnoses;

  const MyDiagnosesLoaded(this.diagnoses);

  @override
  List<Object?> get props => [diagnoses];
}

class MyDiagnosesError extends MyDiagnosesState {
  final String message;

  const MyDiagnosesError(this.message);

  @override
  List<Object?> get props => [message];
}
