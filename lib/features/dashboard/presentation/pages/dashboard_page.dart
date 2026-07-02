import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/shared/widgets/app_button.dart';
import '../../../../core/shared/widgets/empty_state_widget.dart';
import '../../../../core/shared/widgets/error_widget.dart';
import '../../../../core/shared/widgets/loading_widget.dart';
import '../../../../core/shared/widgets/page_header.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../booking/presentation/cubit/booking_cubit.dart';
import '../../../booking/presentation/cubit/booking_state.dart';
import '../../../diagnosis/presentation/cubit/diagnosis_cubit.dart';
import '../../../diagnosis/presentation/cubit/diagnosis_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<MyAppointmentsCubit>().fetchAppointments();
    context.read<MyDiagnosesCubit>().fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF02140F) : AppColors.surface,
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          if (authState is! AuthAuthenticated) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text(context.translate('signInRequired'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  AppButton(label: context.translate('signIn'), onPressed: () => context.push('/login')),
                ],
              ),
            );
          }

          final user = authState.user;
          return SingleChildScrollView(
            child: Column(
              children: [
                PageHeader(
                  badge: context.translate('controlCenter'),
                  title: context.translate('patientDashboard'),
                  subtitle: context.translate('dashboardSubtitle'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: AppDimensions.maxWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          // Welcome Card
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF059669), Color(0xFF0D9488)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: AppRadius.card,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${context.translate('welcomeBackUser')}, ${user.name}!',
                                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${user.email} • ${user.role[0].toUpperCase()}${user.role.substring(1)}',
                                        style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14),
                                      ),
                                      const SizedBox(height: 20),
                                      Wrap(
                                        spacing: 12,
                                        runSpacing: 12,
                                        children: [
                                          _quickAction(context, context.translate('newScanAction'), Icons.biotech, () => context.go('/diagnosis')),
                                          _quickAction(context, context.translate('findDoctorAction'), Icons.people, () => context.go('/doctors')),
                                          _quickAction(context, context.translate('aiChatAction'), Icons.chat_bubble_outline, () => context.go('/chat')),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(child: Icon(Icons.person, color: Colors.white, size: 36)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Quick Stats Row
                          BlocBuilder<MyAppointmentsCubit, MyAppointmentsState>(
                            builder: (context, apptState) {
                              return BlocBuilder<MyDiagnosesCubit, MyDiagnosesState>(
                                builder: (context, diagState) {
                                  int totalScans = 0, totalAppts = 0, pendingAppts = 0;
                                  if (diagState is MyDiagnosesLoaded) totalScans = diagState.diagnoses.length;
                                  if (apptState is MyAppointmentsLoaded) {
                                    totalAppts = apptState.appointments.length;
                                    pendingAppts = apptState.appointments.where((a) => a.status.toLowerCase() == 'pending' || a.status.toLowerCase() == 'confirmed').length;
                                  }
                                  return Row(
                                    children: [
                                      _statCard(context, '$totalScans', context.translate('aiScans'), Icons.biotech, AppColors.primary),
                                      const SizedBox(width: 12),
                                      _statCard(context, '$totalAppts', context.translate('appointments'), Icons.calendar_month, AppColors.secondary),
                                      const SizedBox(width: 12),
                                      _statCard(context, '$pendingAppts', context.translate('upcoming'), Icons.schedule, Colors.orange),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 32),

                          // Upcoming Appointments Section
                          _sectionTitle(context.translate('upcomingAppointments')),
                          const SizedBox(height: 16),
                          BlocBuilder<MyAppointmentsCubit, MyAppointmentsState>(
                            builder: (context, state) {
                              if (state is MyAppointmentsLoading) return const AppLoadingWidget(itemCount: 2);
                              if (state is MyAppointmentsError) return AppErrorWidget(message: state.message, onRetry: () => context.read<MyAppointmentsCubit>().fetchAppointments());
                              if (state is MyAppointmentsLoaded) {
                                if (state.appointments.isEmpty) {
                                  return EmptyStateWidget(
                                    icon: Icons.calendar_today_outlined,
                                    title: context.translate('noAppointments'),
                                    subtitle: context.translate('noAppointmentsDesc'),
                                  );
                                }
                                return Column(
                                  children: state.appointments.take(5).map((appt) {
                                    final statusColor = appt.status.toLowerCase() == 'confirmed'
                                        ? AppColors.success
                                        : (appt.status.toLowerCase() == 'cancelled' ? AppColors.danger : AppColors.warning);
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF05281D) : Colors.white,
                                        borderRadius: AppRadius.card,
                                        border: Border.all(color: isDark ? const Color(0xFF093D2C) : AppColors.border),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50, height: 50,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withValues(alpha: 0.1),
                                              borderRadius: AppRadius.button,
                                            ),
                                            child: const Icon(Icons.person_pin, color: AppColors.primary),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('${context.isArabic ? "د." : "Dr."} ${appt.doctorName}', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimary)),
                                                const SizedBox(height: 4),
                                                Text('${appt.appointmentDate} at ${appt.timeSlot}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: statusColor.withValues(alpha: 0.1),
                                              borderRadius: AppRadius.pill,
                                            ),
                                            child: Text(appt.status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                          const SizedBox(height: 32),

                          // Scan History Section
                          _sectionTitle(context.translate('recentScans')),
                          const SizedBox(height: 16),
                          BlocBuilder<MyDiagnosesCubit, MyDiagnosesState>(
                            builder: (context, state) {
                              if (state is MyDiagnosesLoading) return const AppLoadingWidget(itemCount: 2);
                              if (state is MyDiagnosesError) return AppErrorWidget(message: state.message, onRetry: () => context.read<MyDiagnosesCubit>().fetchHistory());
                              if (state is MyDiagnosesLoaded) {
                                if (state.diagnoses.isEmpty) {
                                  return EmptyStateWidget(
                                    icon: Icons.document_scanner_outlined,
                                    title: context.translate('noScans'),
                                    subtitle: context.translate('noScansDesc'),
                                  );
                                }
                                return Column(
                                  children: state.diagnoses.take(5).map((diag) {
                                    String typeLabel = diag.scanType;
                                    if (diag.scanType == 'xray_bone') typeLabel = context.isArabic ? 'أشعة سينية (عظام)' : 'X-Ray (Bone)';
                                    if (diag.scanType == 'ecg_heart') typeLabel = context.isArabic ? 'أشعة الصدر' : 'Chest X-Ray';
                                    if (diag.scanType == 'brain_neurology') typeLabel = context.isArabic ? 'أشعة الدماغ' : 'Brain MRI';
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF05281D) : Colors.white,
                                        borderRadius: AppRadius.card,
                                        border: Border.all(color: isDark ? const Color(0xFF093D2C) : AppColors.border),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50, height: 50,
                                            decoration: BoxDecoration(
                                              color: AppColors.secondary.withValues(alpha: 0.1),
                                              borderRadius: AppRadius.button,
                                            ),
                                            child: const Icon(Icons.biotech, color: AppColors.secondary),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(typeLabel, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimary)),
                                                const SizedBox(height: 4),
                                                Text(diag.report.diagnosis, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                                              ],
                                            ),
                                          ),
                                          Text(diag.report.confidence, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                          const SizedBox(height: 32),

                          // Logout
                          Center(
                            child: AppButton(
                              label: context.translate('signOut'),
                              isOutlined: true,
                              icon: Icons.logout,
                              color: AppColors.danger,
                              onPressed: () {
                                context.read<AuthCubit>().logout();
                                context.go('/home');
                              },
                            ),
                          ),
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _quickAction(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white.withValues(alpha: 0.15),
      borderRadius: AppRadius.pill,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(999)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(BuildContext context, String value, String label, IconData icon, Color color) {
    final isDark = context.isDark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF05281D) : Colors.white,
          borderRadius: AppRadius.card,
          border: Border.all(color: isDark ? const Color(0xFF093D2C) : AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 10),
            Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: isDark ? Colors.white : AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
    );
  }
}
