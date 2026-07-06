import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/doctor_dashboard_models.dart';

class DoctorDashboardRemoteDataSource {
  final Dio _dio;

  DoctorDashboardRemoteDataSource(this._dio);

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

  Future<DoctorDashboardStatsModel> getDashboard() async {
    try {
      final response = await _dio.get(ApiEndpoints.doctorDashboard);
      return DoctorDashboardStatsModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<DoctorProfileModel> getDoctorById(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.doctorById(id));
      return DoctorProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> updateAvailability(List<DoctorAvailabilityModel> payload) async {
    try {
      final data = payload.map((e) => e.toJson()).toList();
      await _dio.post(
        ApiEndpoints.doctorAvailabilityPost,
        data: data,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<DoctorProfileModel> getMyProfile() async {
    try {
      final response = await _dio.get(ApiEndpoints.doctorProfile);
      return DoctorProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<DoctorProfileModel> updateProfile(Map<String, dynamic> payload) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.doctorProfile,
        data: payload,
      );
      return DoctorProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<DoctorPatientDetailsModel> getPatientDetails(String id) async {
    try {
      final response = await _dio.get('${ApiEndpoints.doctors}/patients/$id');
      return DoctorPatientDetailsModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> updateAppointmentStatus(String id, String status) async {
    try {
      await _dio.put(
        ApiEndpoints.appointmentStatus(id),
        data: '"$status"', // sends raw string JSON representation like "Confirmed"
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
}
