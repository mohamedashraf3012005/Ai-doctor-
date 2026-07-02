import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/appointment_model.dart';

/// Remote data source for booking operations.
class BookingRemoteDataSource {
  final Dio _dio;

  BookingRemoteDataSource(this._dio);

  /// Books an appointment slot.
  Future<AppointmentModel> bookAppointment({
    required String doctorId,
    required String patientName,
    required String patientPhone,
    required String appointmentDate,
    required String timeSlot,
    String? medicalNotes,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.appointments,
        data: {
          'doctorId': doctorId,
          'patientName': patientName,
          'patientPhone': patientPhone,
          'appointmentDate': appointmentDate,
          'timeSlot': timeSlot,
          if (medicalNotes != null && medicalNotes.isNotEmpty) 'medicalNotes': medicalNotes,
        },
      );
      return AppointmentModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Fetches booked appointments list.
  Future<List<AppointmentModel>> getMyAppointments() async {
    try {
      final response = await _dio.get(ApiEndpoints.myAppointments);
      final List<dynamic> list = response.data;
      return list.map((item) => AppointmentModel.fromJson(item)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Cancels an appointment.
  Future<bool> cancelAppointment(String id) async {
    try {
      await _dio.put(ApiEndpoints.cancelAppointment(id));
      return true;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ServerException _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    String message = 'Appointment operation failed';

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
