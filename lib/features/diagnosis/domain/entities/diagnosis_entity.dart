import 'package:equatable/equatable.dart';

/// Represents a parsed AI diagnosis result details.
class DiagnosisReportEntity extends Equatable {
  final String confidence;
  final String diagnosis;
  final String recommendations;
  final String? boneName;
  final String? severity;
  final String? medicalReport;
  final String? treatmentPlan;
  final String? heatmapUrl;

  const DiagnosisReportEntity({
    required this.confidence,
    required this.diagnosis,
    required this.recommendations,
    this.boneName,
    this.severity,
    this.medicalReport,
    this.treatmentPlan,
    this.heatmapUrl,
  });

  @override
  List<Object?> get props => [
        confidence,
        diagnosis,
        recommendations,
        boneName,
        severity,
        medicalReport,
        treatmentPlan,
        heatmapUrl,
      ];
}

/// Main diagnosis entity representing a scan check record.
class DiagnosisEntity extends Equatable {
  final String id;
  final String scanType;
  final String fileName;
  final String? filePath;
  final String aiResult;
  final DateTime createdAt;
  final DiagnosisReportEntity report;

  const DiagnosisEntity({
    required this.id,
    required this.scanType,
    required this.fileName,
    this.filePath,
    required this.aiResult,
    required this.createdAt,
    required this.report,
  });

  @override
  List<Object?> get props => [
        id,
        scanType,
        fileName,
        filePath,
        aiResult,
        createdAt,
        report,
      ];
}
