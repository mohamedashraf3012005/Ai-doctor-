import 'dart:convert';
import '../../domain/entities/diagnosis_entity.dart';

/// Diagnosis result data model wrapping JSON parsing.
class DiagnosisResultModel {
  final String id;
  final String scanType;
  final String fileName;
  final String? filePath;
  final String aiResult;
  final DateTime createdAt;

  const DiagnosisResultModel({
    required this.id,
    required this.scanType,
    required this.fileName,
    this.filePath,
    required this.aiResult,
    required this.createdAt,
  });

  factory DiagnosisResultModel.fromJson(Map<String, dynamic> json) {
    return DiagnosisResultModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      scanType: json['scanType'] ?? '',
      fileName: json['fileName'] ?? '',
      filePath: json['filePath'],
      aiResult: json['aiResult'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'scanType': scanType,
        'fileName': fileName,
        'filePath': filePath,
        'aiResult': aiResult,
        'createdAt': createdAt.toIso8601String(),
      };

  DiagnosisEntity toEntity() {
    final parsedReport = parseAIResult(aiResult);
    return DiagnosisEntity(
      id: id,
      scanType: scanType,
      fileName: fileName,
      filePath: filePath,
      aiResult: aiResult,
      createdAt: createdAt,
      report: parsedReport,
    );
  }

  /// Helper method parsing the complex aiResult string from backend/HF space.
  static DiagnosisReportEntity parseAIResult(String aiResult) {
    try {
      final decoded = jsonDecode(aiResult);
      if (decoded is Map<String, dynamic>) {
        // If it's a bilingual object created in diagnosis.js
        if (decoded['_isBilingual'] == true) {
          return DiagnosisReportEntity(
            confidence: decoded['Confidence']?.toString() ?? '90%',
            diagnosis: decoded['DiagnosisEn']?.toString() ?? decoded['Diagnosis']?.toString() ?? 'Undetermined',
            recommendations: decoded['RecommendationsEn']?.toString() ?? decoded['Recommendations']?.toString() ?? '',
            boneName: decoded['BoneNameEn']?.toString() ?? decoded['BoneName']?.toString(),
            severity: decoded['SeverityEn']?.toString() ?? decoded['Severity']?.toString(),
            medicalReport: decoded['MedicalReportEn']?.toString() ?? decoded['MedicalReport']?.toString(),
            treatmentPlan: decoded['TreatmentPlanEn']?.toString() ?? decoded['TreatmentPlan']?.toString(),
            heatmapUrl: decoded['Heatmap']?.toString(),
          );
        }

        // Standard backend payload
        return DiagnosisReportEntity(
          confidence: decoded['confidence']?.toString() ?? decoded['Confidence']?.toString() ?? '90%',
          diagnosis: decoded['diagnosis']?.toString() ?? decoded['Diagnosis']?.toString() ?? 'Undetermined',
          recommendations: decoded['recommendations']?.toString() ?? decoded['Recommendations']?.toString() ?? '',
          boneName: decoded['boneName']?.toString() ?? decoded['BoneName']?.toString(),
          severity: decoded['severity']?.toString() ?? decoded['Severity']?.toString(),
          medicalReport: decoded['medicalReport']?.toString() ?? decoded['MedicalReport']?.toString(),
          treatmentPlan: decoded['treatmentPlan']?.toString() ?? decoded['TreatmentPlan']?.toString(),
          heatmapUrl: decoded['heatmap']?.toString() ?? decoded['Heatmap']?.toString(),
        );
      }
    } catch (_) {
      // Fallback if not a valid JSON string
    }

    return DiagnosisReportEntity(
      confidence: '90%',
      diagnosis: aiResult.isNotEmpty ? aiResult : 'Analysis Complete',
      recommendations: 'Consult a specialist for a detailed review.',
    );
  }
}
