import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/admin_cubit.dart';
import '../cubit/admin_state.dart';
import '../widgets/admin_sidebar.dart';
import '../widgets/admin_overview_tab.dart';
import '../widgets/admin_patients_tab.dart';
import '../widgets/admin_doctors_tab.dart';
import '../widgets/admin_appointments_tab.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _currentTab = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().fetchDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = context.screenWidth < 1000;
    final scaffoldBg = isDark ? const Color(0xFF02140F) : AppColors.surface;

    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        if (state is AdminLoading || state is AdminInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is AdminError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppColors.danger),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<AdminCubit>().fetchDashboardData(),
                    child: Text(context.translate('retry')),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is AdminLoaded) {
          final sidebar = AdminSidebar(
            currentIndex: _currentTab,
            onTabChanged: (index) {
              setState(() {
                _currentTab = index;
              });
              if (isMobile) {
                _scaffoldKey.currentState?.closeDrawer();
              }
            },
            onLogout: () {
              context.read<AuthCubit>().logout();
              context.go('/home');
            },
          );

          final body = _buildActiveTab(state);

          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: scaffoldBg,
            drawer: isMobile ? Drawer(child: sidebar) : null,
            body: Row(
              children: [
                if (!isMobile) sidebar,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header / Topbar
                      _buildHeader(context, isMobile),
                      // Tab Content
                      Expanded(child: body),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildActiveTab(AdminLoaded state) {
    switch (_currentTab) {
      case 0:
        return AdminOverviewTab(
          stats: state.stats,
          dashboardStats: state.dashboardStats,
          chartData: state.chartData,
          patients: state.patients,
          doctors: state.doctors,
          appointments: state.appointments,
          activities: state.activities,
          onTabChanged: (index) {
            setState(() {
              _currentTab = index;
            });
          },
        );
      case 1:
        return AdminPatientsTab(patients: state.patients);
      case 2:
        return AdminDoctorsTab(doctors: state.doctors);
      case 3:
        return AdminAppointmentsTab(appointments: state.appointments);
      default:
        return const SizedBox();
    }
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    final isDark = context.isDark;
    final localeCubit = context.read<LocaleCubit>();
    final themeCubit = context.read<ThemeCubit>();
    final isArabic = localeCubit.isArabic;

    // Format current date
    final dateStr = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    String titleKey = 'systemOverview';
    if (_currentTab == 1) titleKey = 'patientsDirectory';
    if (_currentTab == 2) titleKey = 'doctorsVerification';
    if (_currentTab == 3) titleKey = 'allAppointments';

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF05281D) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF093D2C) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Menu button + Title
          Row(
            children: [
              if (isMobile)
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
              Text(
                context.translate(titleKey),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          // Right side: Date, Lang, Dark Mode, Profile
          Row(
            children: [
              // Date
              if (context.screenWidth > 700) ...[
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      dateStr,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
              ],
              // Language Switcher
              InkWell(
                onTap: () => localeCubit.toggleLocale(),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isArabic ? 'EN' : 'AR',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Theme Switcher
              IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  color: isDark ? Colors.yellow : Colors.grey.shade700,
                ),
                onPressed: () => themeCubit.toggleTheme(),
              ),
              const SizedBox(width: 12),
              // Profile Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield_outlined, color: Colors.green, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      context.translate('admin'),
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
