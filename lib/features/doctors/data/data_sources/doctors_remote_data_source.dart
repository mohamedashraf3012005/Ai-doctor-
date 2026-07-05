import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/doctor_model.dart';

/// Remote data source for fetching doctors list and checking schedule availability slots.
class DoctorsRemoteDataSource {
  final Dio _dio;

  DoctorsRemoteDataSource(this._dio);

  /// Fetch all doctors with search filters.
  Future<List<DoctorModel>> getDoctors({
    String? searchQuery,
    String? specialty,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['search'] = searchQuery;
      }
      if (specialty != null && specialty.isNotEmpty && specialty != 'all') {
        queryParams['specialty'] = specialty;
      }

      final response = await _dio.get(
        ApiEndpoints.doctors,
        queryParameters: queryParams,
      );

      // Handle both List responses and wrapped object responses
      final data = response.data;
      List<dynamic> list;
      if (data is List) {
        list = data;
      } else if (data is Map<String, dynamic>) {
        // Some APIs wrap results: { "data": [...] } or { "doctors": [...] }
        list = data['data'] ?? data['doctors'] ?? data['items'] ?? [];
      } else {
        list = [];
      }
      return list
          .whereType<Map<String, dynamic>>()
          .map((item) => DoctorModel.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get availability dates and slots.
  Future<Map<String, List<String>>> getDoctorAvailability({
    required String doctorId,
    String? date,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (date != null && date.isNotEmpty) {
        queryParams['date'] = date;
      }

      final response = await _dio.get(
        ApiEndpoints.doctorAvailability(doctorId),
        queryParameters: queryParams,
      );

      // Backend returns either a list of slots, or a map of dates -> list of slots.
      // E.g., {'2026-07-03': ['09:00', '10:00']}
      final data = response.data;
      final result = <String, List<String>>{};

      if (data is Map<String, dynamic>) {
        data.forEach((key, val) {
          if (val is List) {
            result[key] = val.map((e) => e.toString()).toList();
          }
        });
      } else if (data is List) {
        // If a single day is requested, it might return a list of times.
        final dateKey = date ?? DateTime.now().toString().split(' ')[0];
        result[dateKey] = data.map((e) => e.toString()).toList();
      }

      return result;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ServerException _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    String message = 'Failed to load doctors data';

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
