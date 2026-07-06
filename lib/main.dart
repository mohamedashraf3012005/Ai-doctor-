import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/di/service_locator.dart' as di;
import 'core/localization/app_localizations.dart';
import 'core/localization/locale_cubit.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';

// Cubits
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/booking/presentation/cubit/booking_cubit.dart';
import 'features/chat/presentation/cubit/chat_cubit.dart';
import 'features/diagnosis/presentation/cubit/diagnosis_cubit.dart';
import 'features/doctors/presentation/cubit/doctors_cubit.dart';
import 'features/admin/presentation/cubit/admin_cubit.dart';
import 'features/dashboard/presentation/cubit/doctor_dashboard_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize localization date symbol formatting
  await initializeDateFormatting();

  // Initialize service locator dependency injections
  await di.init();

  runApp(const Care360App());
}

class Care360App extends StatelessWidget {
  const Care360App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // ─── App-level cubits ────────────────────────────────
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<LocaleCubit>(create: (_) => LocaleCubit()),

        // ─── Feature cubits ─────────────────────────────────
        BlocProvider<AuthCubit>(
          create: (context) => di.sl<AuthCubit>()..checkAuthStatus(),
        ),
        BlocProvider<DoctorsCubit>(create: (context) => di.sl<DoctorsCubit>()),
        BlocProvider<DoctorAvailabilityCubit>(
          create: (context) => di.sl<DoctorAvailabilityCubit>(),
        ),
        BlocProvider<DiagnosisCubit>(
          create: (context) => di.sl<DiagnosisCubit>(),
        ),
        BlocProvider<MyDiagnosesCubit>(
          create: (context) => di.sl<MyDiagnosesCubit>(),
        ),
        BlocProvider<BookingCubit>(create: (context) => di.sl<BookingCubit>()),
        BlocProvider<MyAppointmentsCubit>(
          create: (context) => di.sl<MyAppointmentsCubit>(),
        ),
        BlocProvider<ChatCubit>(create: (context) => di.sl<ChatCubit>()),
        BlocProvider<AdminCubit>(create: (context) => di.sl<AdminCubit>()),
        BlocProvider<DoctorDashboardCubit>(create: (context) => di.sl<DoctorDashboardCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp.router(
                title: 'Smart Care 360',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                locale: locale,
                builder: (context, child) {
                  final direction = locale.languageCode == 'ar'
                      ? TextDirection.rtl
                      : TextDirection.ltr;
                  return Directionality(
                    textDirection: direction,
                    child: child!,
                  );
                },
                supportedLocales: const [Locale('en'), Locale('ar')],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                routerConfig: AppRouter.router,
              );
            },
          );
        },
      ),
    );
  }
}
