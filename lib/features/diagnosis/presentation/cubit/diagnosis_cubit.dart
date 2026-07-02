import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/analyze_scan_use_case.dart';
import '../../domain/use_cases/get_my_diagnoses_use_case.dart';
import 'diagnosis_state.dart';

/// Cubit managing AI analysis upload progress and results.
class DiagnosisCubit extends Cubit<DiagnosisState> {
  final AnalyzeScanUseCase _analyzeScanUseCase;

  DiagnosisCubit({
    required AnalyzeScanUseCase analyzeScanUseCase,
  })  : _analyzeScanUseCase = analyzeScanUseCase,
        super(const DiagnosisInitial());

  /// Triggers AI analysis on file with progress simulation feedback.
  Future<void> analyzeScan({
    required String scanType,
    required String filePath,
    required String lang,
  }) async {
    emit(const DiagnosisLoading(progress: 0.1));

    // Simulate progress while calling endpoint
    for (double p = 0.2; p <= 0.8; p += 0.25) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (state is DiagnosisLoading) {
        emit(DiagnosisLoading(progress: p));
      }
    }

    final result = await _analyzeScanUseCase(
      scanType: scanType,
      filePath: filePath,
      lang: lang,
    );

    result.fold(
      (failure) => emit(DiagnosisError(failure.message)),
      (diagnosis) {
        emit(const DiagnosisLoading(progress: 1.0));
        emit(DiagnosisSuccess(diagnosis));
      },
    );
  }

  /// Resets back to initial upload stage.
  void reset() => emit(const DiagnosisInitial());
}

/// Cubit managing loading of a patient's historical diagnoses.
class MyDiagnosesCubit extends Cubit<MyDiagnosesState> {
  final GetMyDiagnosesUseCase _getMyDiagnosesUseCase;

  MyDiagnosesCubit({
    required GetMyDiagnosesUseCase getMyDiagnosesUseCase,
  })  : _getMyDiagnosesUseCase = getMyDiagnosesUseCase,
        super(MyDiagnosesInitial());

  /// Fetch history records list.
  Future<void> fetchHistory() async {
    emit(MyDiagnosesLoading());
    final result = await _getMyDiagnosesUseCase();
    result.fold(
      (failure) => emit(MyDiagnosesError(failure.message)),
      (diagnoses) => emit(MyDiagnosesLoaded(diagnoses)),
    );
  }
}
