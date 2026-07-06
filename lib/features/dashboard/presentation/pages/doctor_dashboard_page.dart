import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/doctor_dashboard_cubit.dart';
import '../cubit/doctor_dashboard_state.dart';
import '../widgets/doc_overview_tab.dart';
import '../widgets/doc_appointments_tab.dart';
import '../widgets/doc_patients_tab.dart';
import '../widgets/doc_reports_tab.dart';
import '../widgets/doc_settings_tab.dart';
import '../widgets/doc_profile_tab.dart';
import '../widgets/floating_doctor_bot.dart';

class DoctorDashboardPage extends StatefulWidget {
  const DoctorDashboardPage({super.key});

  @override
  State<DoctorDashboardPage> createState() => _DoctorDashboardPageState();
}

class _DoctorDashboardPageState extends State<DoctorDashboardPage> {
  int _currentTab = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const List<_SidebarItem> _tabs = [
    _SidebarItem(Icons.dashboard_rounded, 'overview', 'Overview'),
    _SidebarItem(Icons.calendar_month_rounded, 'appointments', 'Appointments'),
    _SidebarItem(Icons.people_rounded, 'patients', 'Patients'),
    _SidebarItem(Icons.science_rounded, 'reports', 'Reports'),
    _SidebarItem(Icons.schedule_rounded, 'settings', 'Settings'),
    _SidebarItem(Icons.person_rounded, 'edit_profile_title', 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    context.read<DoctorDashboardCubit>().fetchDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = context.screenWidth < 900;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) {
          return Scaffold(
            backgroundColor: isDark ? const Color(0xFF02140F) : AppColors.surface,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text(context.translate('signInRequired'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.push('/login'),
                    child: Text(context.translate('signIn')),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: isDark ? const Color(0xFF02140F) : AppColors.surface,
          drawer: isMobile ? _buildSidebar(context, isDark) : null,
          floatingActionButton: const FloatingDoctorBot(),
          body: Row(
            children: [
              if (!isMobile) _buildSidebar(context, isDark),
              Expanded(
                child: Column(
                  children: [
                    _buildTopBar(context, isDark, isMobile, authState),
                    Expanded(
                      child: BlocBuilder<DoctorDashboardCubit, DoctorDashboardState>(
                        builder: (context, state) {
                          if (state is DoctorDashboardLoading) {
                            return const Center(
                              child: CircularProgressIndicator(color: AppColors.primary),
                            );
                          }
                          if (state is DoctorDashboardError) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.error_outline, size: 48,
                                      color: isDark ? Colors.redAccent : AppColors.danger),
                                  const SizedBox(height: 12),
                                  Text(state.message,
                                      style: TextStyle(
                                          color: isDark ? Colors.white70 : AppColors.textSecondary)),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        context.read<DoctorDashboardCubit>().fetchDashboard(),
                                    icon: const Icon(Icons.refresh),
                                    label: Text(context.translate('retry')),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (state is DoctorDashboardLoaded) {
                            return _buildTabContent(context, state);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar(BuildContext context, bool isDark) {
    final bgColor = isDark ? const Color(0xFF05281D) : const Color(0xFFF1F5F9);
    final borderColor = isDark ? const Color(0xFF093D2C) : const Color(0xFFE2E8F0);

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(right: BorderSide(color: borderColor)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Brand Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF059669), Color(0xFF0D9488)],
                      ),
                    ),
                    child: const Icon(Icons.local_hospital_rounded, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.translate('appTitle'),
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          context.translate('doctorPortal'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark ? const Color(0xFFA7F3D0) : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Doctor Info Card
            BlocBuilder<DoctorDashboardCubit, DoctorDashboardState>(
              builder: (context, state) {
                String name = '';
                String specialty = '';
                double rating = 0;
                if (state is DoctorDashboardLoaded) {
                  name = state.stats.doctorName;
                  specialty = state.stats.doctorSpecialty;
                  rating = state.profile.rating ?? 0;
                }
                final initials = name.isNotEmpty
                    ? name.split(' ').where((w) => w.isNotEmpty).take(2).map((w) => w[0]).join()
                    : 'DR';

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF093D2C) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.primary,
                        child: Text(initials.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name.isNotEmpty ? 'Dr. $name' : 'Doctor',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                            if (specialty.isNotEmpty)
                              Text(
                                specialty,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? const Color(0xFFA7F3D0) : AppColors.textSecondary,
                                ),
                              ),
                            if (rating > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star_rounded,
                                        size: 14, color: Color(0xFFF59E0B)),
                                    const SizedBox(width: 3),
                                    Text(
                                      rating.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white70 : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Navigation Items
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _tabs.length,
                itemBuilder: (context, index) {
                  final item = _tabs[index];
                  final isSelected = _currentTab == index;
                  return _buildNavItem(context, isDark, item, index, isSelected);
                },
              ),
            ),
            // Logout Button
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
              child: InkWell(
                onTap: () {
                  context.read<AuthCubit>().logout();
                  context.go('/login');
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: isDark
                        ? Colors.red.withAlpha(30)
                        : Colors.red.withAlpha(15),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.logout_rounded, size: 20,
                          color: isDark ? Colors.redAccent : AppColors.danger),
                      const SizedBox(width: 12),
                      Text(
                        context.translate('logout'),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.redAccent : AppColors.danger,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, bool isDark, _SidebarItem item, int index, bool isSelected) {
    String label;
    try {
      label = context.translate(item.translationKey);
    } catch (_) {
      label = item.fallback;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () {
            setState(() => _currentTab = index);
            if (context.screenWidth < 900) {
              Navigator.of(context).pop(); // close drawer
            }
          },
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: isSelected
                  ? (isDark ? AppColors.primary.withAlpha(40) : AppColors.primary.withAlpha(25))
                  : Colors.transparent,
              border: isSelected
                  ? Border.all(color: AppColors.primary.withAlpha(60))
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 20,
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? Colors.white54 : AppColors.textSecondary),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? Colors.white70 : AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(
      BuildContext context, bool isDark, bool isMobile, AuthAuthenticated authState) {
    final bgColor = isDark ? const Color(0xFF071F17) : Colors.white;
    final borderColor = isDark ? const Color(0xFF093D2C) : const Color(0xFFE2E8F0);
    final item = _tabs[_currentTab];
    String title;
    try {
      title = context.translate(item.translationKey);
    } catch (_) {
      title = item.fallback;
    }

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          if (isMobile)
            IconButton(
              icon: Icon(Icons.menu_rounded,
                  color: isDark ? Colors.white70 : AppColors.textPrimary),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
          if (isMobile) const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          // Language Toggle
          _buildTopBarPill(
            context,
            isDark,
            icon: Icons.language_rounded,
            label: context.isArabic ? 'AR' : 'EN',
            onTap: () {
              final cubit = context.read<LocaleCubit>();
              cubit.toggleLocale();
            },
          ),
          const SizedBox(width: 8),
          // Theme Toggle
          _buildTopBarPill(
            context,
            isDark,
            icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            label: isDark ? 'Light' : 'Dark',
            onTap: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
          const SizedBox(width: 8),
          // Refresh
          _buildTopBarPill(
            context,
            isDark,
            icon: Icons.refresh_rounded,
            label: '',
            onTap: () {
              context.read<DoctorDashboardCubit>().fetchDashboard();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopBarPill(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: label.isEmpty ? 10 : 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withAlpha(12) : Colors.grey.withAlpha(20),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white.withAlpha(10) : Colors.grey.withAlpha(40),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16,
                  color: isDark ? Colors.white70 : AppColors.textSecondary),
              if (label.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, DoctorDashboardLoaded state) {
    switch (_currentTab) {
      case 0:
        return DocOverviewTab(stats: state.stats, profile: state.profile);
      case 1:
        return DocAppointmentsTab(stats: state.stats);
      case 2:
        return DocPatientsTab(stats: state.stats);
      case 3:
        return DocReportsTab(stats: state.stats);
      case 4:
        return DocSettingsTab(profile: state.profile);
      case 5:
        return DocProfileTab(profile: state.profile);
      default:
        return DocOverviewTab(stats: state.stats, profile: state.profile);
    }
  }
}

class _SidebarItem {
  final IconData icon;
  final String translationKey;
  final String fallback;

  const _SidebarItem(this.icon, this.translationKey, this.fallback);
}
