import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/booking/presentation/pages/booking_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/diagnosis/presentation/pages/diagnosis_page.dart';
import '../../features/doctors/domain/entities/doctor_entity.dart';
import '../../features/doctors/presentation/pages/doctors_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import 'app_shell.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    navigatorKey: _rootNavigatorKey,
    routes: [
      // Shell Route for persistent bottom navigation tabs
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: '/doctors',
            name: 'doctors',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DoctorsPage(),
            ),
          ),
          GoRoute(
            path: '/diagnosis',
            name: 'diagnosis',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DiagnosisPage(),
            ),
          ),
          GoRoute(
            path: '/chat',
            name: 'chat',
            pageBuilder: (context, state) {
              final docId = state.uri.queryParameters['doc'];
              return NoTransitionPage(
                child: ChatPage(initialDoctorId: docId),
              );
            },
          ),
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardPage(),
            ),
          ),
        ],
      ),

      // Auth pages (no persistent shell)
      GoRoute(
        path: '/login',
        name: 'login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      // Booking flow (no shell tab)
      GoRoute(
        path: '/booking',
        name: 'booking',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final doctor = state.extra as DoctorEntity?;
          return BookingPage(initialDoctor: doctor);
        },
      ),

      // Fallbacks
      GoRoute(
        path: '/',
        redirect: (_, __) => '/home',
      ),
    ],
  );
}
