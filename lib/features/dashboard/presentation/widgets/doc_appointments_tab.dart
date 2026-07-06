import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../data/models/doctor_dashboard_models.dart';
import '../cubit/doctor_dashboard_cubit.dart';

class DocAppointmentsTab extends StatefulWidget {
  final DoctorDashboardStatsModel stats;

  const DocAppointmentsTab({super.key, required this.stats});

  @override
  State<DocAppointmentsTab> createState() => _DocAppointmentsTabState();
}

class _DocAppointmentsTabState extends State<DocAppointmentsTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      children: [
        // Tab Bar
        Container(
          margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF071F17) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF093D2C) : const Color(0xFFE2E8F0),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: isDark ? Colors.white54 : AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
              Tab(text: context.translate('upcomingSchedule')),
              Tab(text: context.translate('bookingHistory')),
            ],
          ),
        ),
        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildUpcomingList(context, isDark),
              _buildPastList(context, isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingList(BuildContext context, bool isDark) {
    final upcoming = widget.stats.todayAppointments;

    if (upcoming.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_busy_rounded, size: 56,
                color: isDark ? Colors.white24 : AppColors.textSecondary.withAlpha(80)),
            const SizedBox(height: 12),
            Text(
              context.translate('noUpcomingAppointments'),
              style: TextStyle(color: isDark ? Colors.white38 : AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: upcoming.length,
      itemBuilder: (context, index) {
        final appt = upcoming[index];
        return _buildAppointmentCard(context, isDark, appt, isUpcoming: true);
      },
    );
  }

  Widget _buildPastList(BuildContext context, bool isDark) {
    final past = widget.stats.pastAppointments;

    if (past.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history_rounded, size: 56,
                color: isDark ? Colors.white24 : AppColors.textSecondary.withAlpha(80)),
            const SizedBox(height: 12),
            Text(
              context.translate('noPastBookings'),
              style: TextStyle(color: isDark ? Colors.white38 : AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: past.length,
      itemBuilder: (context, index) {
        final appt = past[index];
        return _buildAppointmentCard(context, isDark, appt, isUpcoming: false);
      },
    );
  }

  Widget _buildAppointmentCard(BuildContext context, bool isDark,
      DoctorDashboardAppointmentModel appt,
      {required bool isUpcoming}) {
    final statusColor = _statusColor(appt.status);

    String displayDate = '';
    if (appt.appointmentDate.isNotEmpty) {
      try {
        final dt = DateTime.parse(appt.appointmentDate);
        displayDate = '${dt.day}/${dt.month}/${dt.year}';
      } catch (_) {
        displayDate = appt.appointmentDate.split('T').first;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF071F17) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF093D2C) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withAlpha(25),
                child: Text(
                  appt.patientName.isNotEmpty ? appt.patientName[0].toUpperCase() : 'P',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            appt.patientName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isDark ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (appt.queueNumber != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.danger.withAlpha(20),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '#${appt.queueNumber}',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.danger),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      appt.reason,
                      style: TextStyle(fontSize: 13, color: isDark ? Colors.white54 : AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 14, color: isDark ? Colors.white38 : AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(displayDate, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? Colors.white54 : AppColors.textSecondary)),
              const SizedBox(width: 16),
              Icon(Icons.access_time_rounded, size: 14, color: isDark ? Colors.white38 : AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(appt.time, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? Colors.white54 : AppColors.textSecondary)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  appt.status,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),
          if (isUpcoming && (appt.status == 'Scheduled' || appt.status == 'Confirmed')) ...[
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (appt.status == 'Scheduled')
                  _actionButton(
                    context,
                    label: context.translate('confirm'),
                    icon: Icons.check_circle_outline,
                    color: const Color(0xFF10B981),
                    onTap: () => context.read<DoctorDashboardCubit>().updateAppointmentStatus(appt.id, 'Confirmed'),
                  ),
                if (appt.status == 'Confirmed')
                  _actionButton(
                    context,
                    label: context.translate('complete'),
                    icon: Icons.done_all_rounded,
                    color: const Color(0xFF06B6D4),
                    onTap: () => context.read<DoctorDashboardCubit>().updateAppointmentStatus(appt.id, 'Completed'),
                  ),
                const SizedBox(width: 8),
                _actionButton(
                  context,
                  label: context.translate('cancel'),
                  icon: Icons.cancel_outlined,
                  color: const Color(0xFFEF4444),
                  onTap: () => _confirmCancel(context, appt),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: color.withAlpha(15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withAlpha(50)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmCancel(BuildContext context, DoctorDashboardAppointmentModel appt) {
    showDialog(
      context: context,
      builder: (dlg) => AlertDialog(
        title: Text(context.translate('cancelAppointment')),
        content: Text('${context.translate('confirmCancelMsg')} ${appt.patientName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlg),
            child: Text(context.translate('no')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () {
              Navigator.pop(dlg);
              context.read<DoctorDashboardCubit>().updateAppointmentStatus(appt.id, 'Cancelled');
            },
            child: Text(context.translate('yes'), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Scheduled':
        return const Color(0xFF3B82F6);
      case 'Confirmed':
        return const Color(0xFF10B981);
      case 'Completed':
        return const Color(0xFF06B6D4);
      case 'Cancelled':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }
}
