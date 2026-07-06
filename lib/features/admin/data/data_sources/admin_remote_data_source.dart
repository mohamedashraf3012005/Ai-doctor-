import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/admin_models.dart';

class AdminRemoteDataSource {
  final Dio _dio;

  AdminRemoteDataSource(this._dio);

  Exception _handleDioError(DioException e) {
    if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
      return const UnauthorizedException();
    }
    String message = 'Server Error';
    if (e.response?.data != null) {
      if (e.response?.data is Map) {
        message = e.response?.data['message'] ?? e.response?.data['title'] ?? message;
      } else if (e.response?.data is String) {
        message = e.response?.data;
      }
    }
    return ServerException(message, statusCode: e.response?.statusCode);
  }

  Future<AdminStatsModel> getStats() async {
    try {
      final response = await _dio.get(ApiEndpoints.publicStats);
      return AdminStatsModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<DashboardStatsModel> getDashboardStats() async {
    try {
      final response = await _dio.get(ApiEndpoints.adminDashboardStats);
      return DashboardStatsModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ChartDataModel> getChartData() async {
    try {
      final response = await _dio.get(ApiEndpoints.adminCharts);
      return ChartDataModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<AdminPatientModel>> getPatients() async {
    try {
      final response = await _dio.get(ApiEndpoints.adminPatients);
      final List data = response.data is List ? response.data : (response.data['items'] ?? []);
      return data.map((json) => AdminPatientModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<AdminDoctorModel>> getDoctors() async {
    try {
      final response = await _dio.get(ApiEndpoints.adminDoctors);
      final List data = response.data is List ? response.data : (response.data['items'] ?? []);
      return data.map((json) => AdminDoctorModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<AdminActivityModel>> getRecentActivity() async {
    try {
      final response = await _dio.get(ApiEndpoints.adminActivity);
      final List data = response.data is List ? response.data : [];
      return data.map((json) => AdminActivityModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<AdminAppointmentModel>> getAppointments({String? status, String? range}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (status != null && status.isNotEmpty) {
        queryParameters['status'] = status;
      }
      if (range != null && range.isNotEmpty) {
        queryParameters['range'] = range;
      }
      final response = await _dio.get(
        ApiEndpoints.adminAppointments,
        queryParameters: queryParameters,
      );
      final List data = response.data is List ? response.data : (response.data['items'] ?? []);
      return data.map((json) => AdminAppointmentModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> deletePatient(String id) async {
    try {
      await _dio.delete(ApiEndpoints.adminDeletePatient(id));
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> deleteDoctor(String id) async {
    try {
      await _dio.delete(ApiEndpoints.adminDeleteDoctor(id));
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> approveDoctor(String id) async {
    try {
      await _dio.put(ApiEndpoints.adminApproveDoctor(id));
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> rejectDoctor(String id, String reason) async {
    try {
      await _dio.put(
        ApiEndpoints.adminRejectDoctor(id),
        data: {'reason': reason},
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> updateAppointmentStatus(String id, String status) async {
    try {
      await _dio.put(
        ApiEndpoints.adminAppointmentStatus(id),
        data: {'status': status},
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> registerDoctor(Map<String, dynamic> payload) async {
    try {
      await _dio.post(
        ApiEndpoints.adminRegisterDoctor,
        data: payload,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> registerPatient(Map<String, dynamic> payload) async {
    try {
      await _dio.post(
        ApiEndpoints.adminRegisterPatient,
        data: payload,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> addSpecialty(Map<String, dynamic> payload) async {
    try {
      await _dio.post(
        ApiEndpoints.adminSpecialties,
        data: payload,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
}
