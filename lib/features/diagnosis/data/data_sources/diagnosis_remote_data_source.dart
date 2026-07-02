import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/diagnosis_result_model.dart';

/// Remote data source for AI scan analysis.
/// Communicates with Hugging Face Spaces directly for X-Ray/Pneumonia/Brain models,
/// then fires-and-forgets to C# backend for record keeping.
class DiagnosisRemoteDataSource {
  final Dio _dio;

  DiagnosisRemoteDataSource(this._dio);

  /// Main entry point for AI analysis.
  Future<DiagnosisResultModel> analyzeScan({
    required String scanType,
    required String filePath,
    required String lang,
  }) async {
    try {
      final fileName = filePath.split('/').last.split('\\').last;

      if (scanType == 'xray_bone') {
        final hfResult = await _predictBoneFracture(filePath, fileName, lang);
        _saveToBackend(filePath, fileName, scanType, lang);
        return DiagnosisResultModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          scanType: scanType,
          fileName: fileName,
          aiResult: jsonEncode(hfResult),
          createdAt: DateTime.now(),
        );
      } else if (scanType == 'ecg_heart') {
        final hfResult = await _predictPneumonia(filePath, fileName, lang);
        _saveToBackend(filePath, fileName, scanType, lang);
        return DiagnosisResultModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          scanType: scanType,
          fileName: fileName,
          aiResult: jsonEncode(hfResult),
          createdAt: DateTime.now(),
        );
      } else if (scanType == 'brain_neurology') {
        final hfResult = await _predictBrainTumor(filePath, fileName, lang);
        _saveToBackend(filePath, fileName, scanType, lang);
        return DiagnosisResultModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          scanType: scanType,
          fileName: fileName,
          aiResult: jsonEncode(hfResult),
          createdAt: DateTime.now(),
        );
      }

      // Fallback: skin / PDF — use C# backend as proxy
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
        'scanType': scanType,
        'Lang': lang,
      });
      final response = await _dio.post(
        ApiEndpoints.diagnosisAnalyze,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      return DiagnosisResultModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Fetches previous diagnoses from C# database.
  Future<List<DiagnosisResultModel>> getMyDiagnoses() async {
    try {
      final response = await _dio.get(ApiEndpoints.myDiagnoses);
      final List<dynamic> list = response.data;
      return list.map((item) => DiagnosisResultModel.fromJson(item)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Deletes a diagnosis record.
  Future<bool> deleteDiagnosis(String id) async {
    try {
      await _dio.delete(ApiEndpoints.diagnosisById(id));
      return true;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ─── HF Space Helpers ─────────────────────────────────────

  Future<Map<String, dynamic>> _callHfPredict(
    Dio dio, String url, String filePath, String fileName, String lang,
  ) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
      'lang': lang,
    });
    final res = await dio.post(url, data: form);
    return res.data is Map<String, dynamic> ? res.data : {};
  }

  Future<Map<String, dynamic>> _predictBoneFracture(
    String filePath, String fileName, String lang,
  ) async {
    final tempDio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 60), receiveTimeout: const Duration(seconds: 60)));
    final responses = await Future.wait([
      _callHfPredict(tempDio, 'https://hazemfarag-bone-fraction.hf.space/predict', filePath, fileName, 'ar'),
      _callHfPredict(tempDio, 'https://hazemfarag-bone-fraction.hf.space/predict', filePath, fileName, 'en'),
    ]);
    final dataAr = responses[0]; final dataEn = responses[1];
    if (dataAr['success'] == false || dataEn['success'] == false) {
      throw ServerException('Unable to analyze image. Please upload a clear bone X-ray.');
    }
    final predAr = (dataAr['prediction'] ?? '').toString();
    final predEn = (dataEn['prediction'] ?? '').toString();
    final confidence = dataEn['confidence'] ?? dataAr['confidence'] ?? 90.0;
    final repAr = dataAr['report_data'] is Map ? dataAr['report_data'] as Map : {};
    final repEn = dataEn['report_data'] is Map ? dataEn['report_data'] as Map : {};
    final isFracturedEn = predEn.toLowerCase().contains('fracture') || predEn.toLowerCase().contains('fractured');
    return {
      '_isBilingual': true,
      'Confidence': '$confidence%',
      'DiagnosisEn': predEn, 'DiagnosisAr': predAr,
      'RecommendationsEn': isFracturedEn ? 'Please consult an orthopedic specialist immediately.' : 'No clear signs of fracture. Rest and follow up if pain persists.',
      'BoneNameEn': repEn['bone_name'] ?? '', 'SeverityEn': repEn['severity'] ?? '',
      'MedicalReportEn': repEn['report'] ?? '', 'TreatmentPlanEn': repEn['treatment_plan'] ?? '',
      'BoneNameAr': repAr['bone_name'] ?? '', 'SeverityAr': repAr['severity'] ?? '',
      'MedicalReportAr': repAr['report'] ?? '', 'TreatmentPlanAr': repAr['treatment_plan'] ?? '',
      'Diagnosis': lang == 'ar' ? predAr : predEn,
      'Recommendations': lang == 'ar' ? (isFracturedEn ? 'يرجى مراجعة طبيب عظام فوراً.' : 'لا توجد علامات واضحة لكسر.') : (isFracturedEn ? 'Please consult an orthopedic specialist immediately.' : 'No clear signs of fracture.'),
      'Heatmap': (dataEn['heatmap'] ?? dataAr['heatmap'] ?? '').toString(),
    };
  }

  Future<Map<String, dynamic>> _predictPneumonia(
    String filePath, String fileName, String lang,
  ) async {
    final tempDio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 60), receiveTimeout: const Duration(seconds: 60)));
    final responses = await Future.wait([
      _callHfPredict(tempDio, 'https://hazemfarag-pneumonia-diagnosis-ai.hf.space/predict/chest-xray', filePath, fileName, 'ar'),
      _callHfPredict(tempDio, 'https://hazemfarag-pneumonia-diagnosis-ai.hf.space/predict/chest-xray', filePath, fileName, 'en'),
    ]);
    final dataAr = responses[0]; final dataEn = responses[1];
    if (dataAr['success'] == false || dataEn['success'] == false) {
      throw ServerException('Unable to analyze image. Please upload a clear chest X-ray.');
    }
    final predAr = (dataAr['prediction'] ?? '').toString();
    final predEn = (dataEn['prediction'] ?? '').toString();
    final confidence = dataEn['confidence'] ?? dataAr['confidence'] ?? 90.0;
    final repAr = dataAr['report_data'] is Map ? dataAr['report_data'] as Map : {};
    final repEn = dataEn['report_data'] is Map ? dataEn['report_data'] as Map : {};
    final isAbnormalEn = predEn.toLowerCase().contains('pneumonia') || predEn.toLowerCase().contains('abnormal');
    return {
      '_isBilingual': true,
      'Confidence': '$confidence%',
      'DiagnosisEn': predEn, 'DiagnosisAr': predAr,
      'RecommendationsEn': isAbnormalEn ? 'Please consult a pulmonologist immediately.' : 'Lungs appear clear and healthy.',
      'BoneNameEn': repEn['disease_name'] ?? '', 'SeverityEn': repEn['severity'] ?? '',
      'MedicalReportEn': repEn['report'] ?? '', 'TreatmentPlanEn': repEn['treatment_plan'] ?? '',
      'BoneNameAr': repAr['disease_name'] ?? '', 'SeverityAr': repAr['severity'] ?? '',
      'MedicalReportAr': repAr['report'] ?? '', 'TreatmentPlanAr': repAr['treatment_plan'] ?? '',
      'Diagnosis': lang == 'ar' ? predAr : predEn,
      'Recommendations': lang == 'ar' ? (isAbnormalEn ? 'يرجى مراجعة طبيب أمراض صدرية.' : 'الرئة سليمة.') : (isAbnormalEn ? 'Please consult a pulmonologist.' : 'Lungs appear clear.'),
      'Heatmap': (dataEn['heatmap'] ?? dataAr['heatmap'] ?? '').toString(),
    };
  }

  Future<Map<String, dynamic>> _predictBrainTumor(
    String filePath, String fileName, String lang,
  ) async {
    final tempDio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 60), receiveTimeout: const Duration(seconds: 60)));
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
      'model_type': 'ensemble',
    });
    final res = await tempDio.post('https://khaledai123-brain-tumor-mri-model.hf.space/predict', data: form);
    final hfData = res.data is Map<String, dynamic> ? res.data as Map<String, dynamic> : <String, dynamic>{};

    if (hfData['is_valid_mri'] == false) {
      throw ServerException(lang == 'ar'
          ? (hfData['warning_ar']?.toString() ?? 'الصورة ليست أشعة رنين مغناطيسي. يرجى رفع صورة صحيحة.')
          : (hfData['warning_en']?.toString() ?? 'Not a valid Brain MRI scan. Please upload a valid scan.'));
    }

    final confidence = hfData['confidence'] ?? 90.0;
    final tumorFound = hfData['tumor_present'] ?? false;
    final medReport = hfData['medical_report'] is Map ? hfData['medical_report'] as Map : {};

    return {
      '_isBilingual': true,
      'Confidence': '$confidence%',
      'DiagnosisEn': hfData['label']?.toString() ?? (tumorFound ? 'Brain Tumor Detected' : 'No Tumor - Healthy Brain'),
      'DiagnosisAr': hfData['arabic_label']?.toString() ?? (tumorFound ? 'تم اكتشاف ورم' : 'لا يوجد ورم - سليم'),
      'RecommendationsEn': tumorFound ? 'Please consult a neurosurgeon immediately.' : 'MRI results appear normal.',
      'RecommendationsAr': tumorFound ? 'يرجى مراجعة طبيب المخ والأعصاب فوراً.' : 'نتائج الأشعة سليمة.',
      'BoneNameEn': medReport['tumor_type_en'] ?? (tumorFound ? 'Brain Tumor' : 'Healthy Brain'),
      'SeverityEn': medReport['severity_level_en'] ?? (tumorFound ? 'Critical' : 'Normal'),
      'MedicalReportEn': medReport['medical_description_en'] ?? '',
      'TreatmentPlanEn': medReport['treatment_plan_en'] ?? '',
      'BoneNameAr': medReport['tumor_type_ar'] ?? (tumorFound ? 'ورم دماغي' : 'سليم'),
      'SeverityAr': medReport['severity_level_ar'] ?? (tumorFound ? 'حرج' : 'طبيعي'),
      'MedicalReportAr': medReport['medical_description_ar'] ?? '',
      'TreatmentPlanAr': medReport['treatment_plan_ar'] ?? '',
      'Diagnosis': lang == 'ar' ? (hfData['arabic_label']?.toString() ?? '') : (hfData['label']?.toString() ?? ''),
      'Recommendations': tumorFound ? 'Please consult a neurosurgeon immediately.' : 'MRI results appear normal.',
      'Heatmap': (hfData['gradcam_image'] ?? '').toString(),
    };
  }

  /// Fire-and-forget call to log scan record to C# DB.
  void _saveToBackend(String filePath, String fileName, String scanType, String lang) async {
    try {
      final saveFormData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
        'scanType': scanType,
        'Lang': lang,
      });
      await _dio.post(ApiEndpoints.diagnosisAnalyze, data: saveFormData);
    } catch (_) {}
  }

  ServerException _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    String message = 'AI scan analysis failed';
    if (e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        message = data['message'] ?? data['title'] ?? message;
      } else if (data is String && data.isNotEmpty) {
        message = data;
      }
    }
    return ServerException(message, statusCode: statusCode);
  }
}
