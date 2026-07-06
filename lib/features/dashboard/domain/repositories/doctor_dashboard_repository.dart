import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/doctor_dashboard_models.dart';

abstract class DoctorDashboardRepository {
  Future<Either<Failure, DoctorDashboardStatsModel>> getDashboard();
  Future<Either<Failure, DoctorProfileModel>> getDoctorById(String id);
  Future<Either<Failure, void>> updateAvailability(List<DoctorAvailabilityModel> payload);
  Future<Either<Failure, DoctorProfileModel>> getMyProfile();
  Future<Either<Failure, DoctorProfileModel>> updateProfile(Map<String, dynamic> payload);
  Future<Either<Failure, DoctorPatientDetailsModel>> getPatientDetails(String id);
  Future<Either<Failure, void>> updateAppointmentStatus(String id, String status);
}
