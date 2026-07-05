import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';
import '../storage/secure_storage_service.dart';

// Auth Imports
import '../../features/auth/data/data_sources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/use_cases/login_use_case.dart';
import '../../features/auth/domain/use_cases/register_use_case.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

// Doctors Imports
import '../../features/doctors/data/data_sources/doctors_remote_data_source.dart';
import '../../features/doctors/data/repositories/doctors_repository_impl.dart';
import '../../features/doctors/domain/repositories/doctors_repository.dart';
import '../../features/doctors/domain/use_cases/get_doctor_availability_use_case.dart';
import '../../features/doctors/domain/use_cases/get_doctors_use_case.dart';
import '../../features/doctors/presentation/cubit/doctors_cubit.dart';

// Diagnosis Imports
import '../../features/diagnosis/data/data_sources/diagnosis_remote_data_source.dart';
import '../../features/diagnosis/data/repositories/diagnosis_repository_impl.dart';
import '../../features/diagnosis/domain/repositories/diagnosis_repository.dart';
import '../../features/diagnosis/domain/use_cases/analyze_scan_use_case.dart';
import '../../features/diagnosis/domain/use_cases/get_my_diagnoses_use_case.dart';
import '../../features/diagnosis/presentation/cubit/diagnosis_cubit.dart';

// Booking Imports
import '../../features/booking/data/data_sources/booking_remote_data_source.dart';
import '../../features/booking/data/repositories/booking_repository_impl.dart';
import '../../features/booking/domain/repositories/booking_repository.dart';
import '../../features/booking/domain/use_cases/book_appointment_use_case.dart';
import '../../features/booking/domain/use_cases/get_my_appointments_use_case.dart';
import '../../features/booking/presentation/cubit/booking_cubit.dart';

// Chat Imports
import '../../features/chat/data/data_sources/chat_remote_data_source.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/domain/use_cases/get_chat_history_use_case.dart';
import '../../features/chat/domain/use_cases/get_contacts_use_case.dart';
import '../../features/chat/presentation/cubit/chat_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ─── Core & External ──────────────────────────────────────
  const secureStorage = FlutterSecureStorage();
  sl.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);

  final storageService = SecureStorageService(storage: secureStorage);
  sl.registerLazySingleton<SecureStorageService>(() => storageService);

  final dio = DioClient.init(storageService);
  sl.registerLazySingleton<Dio>(() => dio);

  // ─── Auth Feature ─────────────────────────────────────────
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(sl()));
  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl()));
  // Use cases
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<RegisterPatientUseCase>(() => RegisterPatientUseCase(sl()));
  sl.registerLazySingleton<RegisterDoctorUseCase>(() => RegisterDoctorUseCase(sl()));
  // Cubit
  sl.registerFactory<AuthCubit>(() => AuthCubit(
        loginUseCase: sl(),
        registerPatientUseCase: sl(),
        registerDoctorUseCase: sl(),
        authRepository: sl(),
        storage: sl(),
      ));

  // ─── Doctors Feature ──────────────────────────────────────
  // Data sources
  sl.registerLazySingleton<DoctorsRemoteDataSource>(() => DoctorsRemoteDataSource(sl()));
  // Repository
  sl.registerLazySingleton<DoctorsRepository>(() => DoctorsRepositoryImpl(sl()));
  // Use cases
  sl.registerLazySingleton<GetDoctorsUseCase>(() => GetDoctorsUseCase(sl()));
  sl.registerLazySingleton<GetDoctorAvailabilityUseCase>(() => GetDoctorAvailabilityUseCase(sl()));
  // Cubits
  sl.registerFactory<DoctorsCubit>(() => DoctorsCubit(getDoctorsUseCase: sl()));
  sl.registerFactory<DoctorAvailabilityCubit>(() => DoctorAvailabilityCubit(getDoctorAvailabilityUseCase: sl()));

  // ─── Diagnosis Feature ────────────────────────────────────
  // Data sources
  sl.registerLazySingleton<DiagnosisRemoteDataSource>(() => DiagnosisRemoteDataSource(sl()));
  // Repository
  sl.registerLazySingleton<DiagnosisRepository>(() => DiagnosisRepositoryImpl(sl()));
  // Use cases
  sl.registerLazySingleton<AnalyzeScanUseCase>(() => AnalyzeScanUseCase(sl()));
  sl.registerLazySingleton<GetMyDiagnosesUseCase>(() => GetMyDiagnosesUseCase(sl()));
  // Cubits
  sl.registerFactory<DiagnosisCubit>(() => DiagnosisCubit(analyzeScanUseCase: sl()));
  sl.registerFactory<MyDiagnosesCubit>(() => MyDiagnosesCubit(getMyDiagnosesUseCase: sl()));

  // ─── Booking Feature ──────────────────────────────────────
  // Data sources
  sl.registerLazySingleton<BookingRemoteDataSource>(() => BookingRemoteDataSource(sl()));
  // Repository
  sl.registerLazySingleton<BookingRepository>(() => BookingRepositoryImpl(sl()));
  // Use cases
  sl.registerLazySingleton<BookAppointmentUseCase>(() => BookAppointmentUseCase(sl()));
  sl.registerLazySingleton<GetMyAppointmentsUseCase>(() => GetMyAppointmentsUseCase(sl()));
  sl.registerLazySingleton<CancelAppointmentUseCase>(() => CancelAppointmentUseCase(sl()));
  // Cubits
  sl.registerFactory<BookingCubit>(() => BookingCubit(bookAppointmentUseCase: sl()));
  sl.registerFactory<MyAppointmentsCubit>(() => MyAppointmentsCubit(
        getMyAppointmentsUseCase: sl(),
        cancelAppointmentUseCase: sl(),
      ));

  // ─── Chat Feature ─────────────────────────────────────────
  // Data sources
  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSource(sl()));
  // Repository
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(sl(), sl()));
  // Use cases
  sl.registerLazySingleton<GetContactsUseCase>(() => GetContactsUseCase(sl()));
  sl.registerLazySingleton<GetChatHistoryUseCase>(() => GetChatHistoryUseCase(sl()));
  sl.registerLazySingleton<SendMessageUseCase>(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton<SendAiMessageUseCase>(() => SendAiMessageUseCase(sl()));
  sl.registerLazySingleton<SummarizeChatUseCase>(() => SummarizeChatUseCase(sl()));
  // Cubit
  sl.registerFactory<ChatCubit>(() => ChatCubit(
        getContactsUseCase: sl(),
        getChatHistoryUseCase: sl(),
        sendMessageUseCase: sl(),
        sendAiMessageUseCase: sl(),
        summarizeChatUseCase: sl(),
        storage: sl(),
      ));
}
