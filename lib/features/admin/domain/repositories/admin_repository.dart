import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/admin_models.dart';

abstract class AdminRepository {
  Future<Either<Failure, AdminStatsModel>> getStats();
  Future<Either<Failure, DashboardStatsModel>> getDashboardStats();
  Future<Either<Failure, ChartDataModel>> getChartData();
  Future<Either<Failure, List<AdminPatientModel>>> getPatients();
  Future<Either<Failure, List<AdminDoctorModel>>> getDoctors();
  Future<Either<Failure, List<AdminActivityModel>>> getRecentActivity();
  Future<Either<Failure, List<AdminAppointmentModel>>> getAppointments({String? status, String? range});
  Future<Either<Failure, void>> deletePatient(String id);
  Future<Either<Failure, void>> deleteDoctor(String id);
  Future<Either<Failure, void>> approveDoctor(String id);
  Future<Either<Failure, void>> rejectDoctor(String id, String reason);
  Future<Either<Failure, void>> updateAppointmentStatus(String id, String status);
  Future<Either<Failure, void>> registerDoctor(Map<String, dynamic> payload);
  Future<Either<Failure, void>> registerPatient(Map<String, dynamic> payload);
  Future<Either<Failure, void>> addSpecialty(Map<String, dynamic> payload);
}
