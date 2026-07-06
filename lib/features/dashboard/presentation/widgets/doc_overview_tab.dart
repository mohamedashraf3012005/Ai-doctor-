import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../data/models/doctor_dashboard_models.dart';

class DocOverviewTab extends StatelessWidget {
  final DoctorDashboardStatsModel stats;
  final DoctorProfileModel profile;

  const DocOverviewTab({super.key, required this.stats, required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = context.screenWidth < 900;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Banner
          _buildWelcomeBanner(context, isDark),
          const SizedBox(height: 24),
          // Stats Grid
          _buildStatsGrid(context, isDark, isMobile),
          const SizedBox(height: 24),
          // Charts Row
          if (isMobile) ...[
            _buildWeeklyChart(context, isDark),
            const SizedBox(height: 20),
            _buildApptStatusChart(context, isDark),
            const SizedBox(height: 20),
            _buildScanOverview(context, isDark),
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _buildWeeklyChart(context, isDark)),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildApptStatusChart(context, isDark),
                      const SizedBox(height: 20),
                      _buildScanOverview(context, isDark),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 24),
          // Upcoming Schedule Section
          _buildUpcomingSchedule(context, isDark),
          const SizedBox(height: 24),
          // Availability Display
          _buildAvailabilityGrid(context, isDark),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner(BuildContext context, bool isDark) {
    final name = stats.doctorName.isNotEmpty
        ? stats.doctorName.split(' ').first
        : 'Doctor';
    final now = DateTime.now();
    final dateStr = '${_dayName(now.weekday, context.isArabic)}, ${now.day} ${_monthName(now.month, context.isArabic)} ${now.year}';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF0D9488)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(60),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${context.translate('welcomeBack')}, Dr. $name 👋',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${context.translate('youHave')} ${stats.upcomingAppointmentsCount} ${context.translate('upcomingAppointments')}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  dateStr,
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.medical_services_rounded, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, bool isDark, bool isMobile) {
    final items = [
      _StatItem(
        Icons.calendar_today_rounded,
        context.translate('todayAppointments'),
        stats.todayAppointmentsCount.toString(),
        const Color(0xFF3B82F6),
      ),
      _StatItem(
        Icons.people_rounded,
        context.translate('totalPatients'),
        stats.totalPatientsCount.toString(),
        const Color(0xFF059669),
      ),
      _StatItem(
        Icons.event_available_rounded,
        context.translate('totalSessions'),
        stats.totalSessionsCount.toString(),
        const Color(0xFF8B5CF6),
      ),
      _StatItem(
        Icons.assignment_rounded,
        context.translate('pendingReports'),
        stats.newReportsCount.toString(),
        const Color(0xFFF59E0B),
      ),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: items.map((item) {
        final w = isMobile
            ? (context.screenWidth - 48 - 16) / 2
            : (context.screenWidth - 260 - 48 - 48) / 4;
        return SizedBox(
          width: w.clamp(140.0, 300.0),
          child: _buildStatCard(context, isDark, item),
        );
      }).toList(),
    );
  }

  Widget _buildStatCard(BuildContext context, bool isDark, _StatItem item) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF071F17) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF093D2C) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: item.color.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: item.color.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.color, size: 22),
          ),
          const SizedBox(height: 14),
          Text(
            item.value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white54 : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(BuildContext context, bool isDark) {
    final dayLabels = context.isArabic
        ? ['أح', 'ن', 'ث', 'ر', 'خ', 'ج', 'س']
        : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final data = stats.weeklyAppointments.length == 7
        ? stats.weeklyAppointments
        : List.filled(7, 0);
    final maxVal = data.reduce((a, b) => a > b ? a : b).toDouble();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF071F17) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF093D2C) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.translate('weeklyPatientActivity'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark ? Colors.white.withAlpha(10) : Colors.grey.withAlpha(30),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white38 : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= dayLabels.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            dayLabels[idx],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white38 : AppColors.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: maxVal > 0 ? maxVal + 1 : 5,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(7, (i) => FlSpot(i.toDouble(), data[i].toDouble())),
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                        radius: 4,
                        color: AppColors.primary,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary.withAlpha(80),
                          AppColors.primary.withAlpha(0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApptStatusChart(BuildContext context, bool isDark) {
    final scheduled = stats.todayAppointments.where((a) => a.status == 'Scheduled').length;
    final confirmed = stats.todayAppointments.where((a) => a.status == 'Confirmed').length;
    final completed = stats.todayAppointments.where((a) => a.status == 'Completed').length;
    final cancelled = stats.todayAppointments.where((a) => a.status == 'Cancelled').length;
    final total = scheduled + confirmed + completed + cancelled;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF071F17) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF093D2C) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.translate('appointmentStatus'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          if (total == 0)
            SizedBox(
              height: 140,
              child: Center(
                child: Text(
                  context.translate('noAppointments'),
                  style: TextStyle(color: isDark ? Colors.white38 : AppColors.textSecondary),
                ),
              ),
            )
          else
            SizedBox(
              height: 140,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 30,
                  sections: [
                    PieChartSectionData(value: scheduled.toDouble(), color: const Color(0xFF3B82F6), radius: 22, title: '', showTitle: false),
                    PieChartSectionData(value: confirmed.toDouble(), color: const Color(0xFF10B981), radius: 22, title: '', showTitle: false),
                    PieChartSectionData(value: completed.toDouble(), color: const Color(0xFF06B6D4), radius: 22, title: '', showTitle: false),
                    PieChartSectionData(value: cancelled.toDouble(), color: const Color(0xFFEF4444), radius: 22, title: '', showTitle: false),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              _legendDot('Scheduled', const Color(0xFF3B82F6), scheduled, isDark),
              _legendDot('Confirmed', const Color(0xFF10B981), confirmed, isDark),
              _legendDot('Completed', const Color(0xFF06B6D4), completed, isDark),
              _legendDot('Cancelled', const Color(0xFFEF4444), cancelled, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(String label, Color color, int count, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text('$label ($count)',
            style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildScanOverview(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF071F17) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF093D2C) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.translate('scanOverview'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _scanRow(Icons.check_circle_rounded, context.translate('normal'), stats.scanStats.normal, const Color(0xFF10B981), isDark),
          const SizedBox(height: 10),
          _scanRow(Icons.warning_rounded, context.translate('warning'), stats.scanStats.warning, const Color(0xFFF59E0B), isDark),
          const SizedBox(height: 10),
          _scanRow(Icons.dangerous_rounded, context.translate('critical'), stats.scanStats.critical, const Color(0xFFEF4444), isDark),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.translate('totalScans'),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white54 : AppColors.textSecondary)),
              Text(stats.scanStats.total.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? Colors.white : AppColors.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _scanRow(IconData icon, String label, int count, Color color, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label, style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : AppColors.textSecondary)),
        ),
        Text(count.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildUpcomingSchedule(BuildContext context, bool isDark) {
    final upcoming = stats.todayAppointments
        .where((a) => a.status == 'Scheduled' || a.status == 'Confirmed')
        .take(5)
        .toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF071F17) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF093D2C) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule_rounded, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                context.translate('upcomingSchedule'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (upcoming.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  context.translate('noUpcomingAppointments'),
                  style: TextStyle(color: isDark ? Colors.white38 : AppColors.textSecondary),
                ),
              ),
            )
          else
            ...upcoming.map((appt) => _buildScheduleCard(context, isDark, appt)),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(BuildContext context, bool isDark, DoctorDashboardAppointmentModel appt) {
    final statusColor = _statusColor(appt.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A2D22) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: statusColor, width: 3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary.withAlpha(25),
            child: Text(
              appt.patientName.isNotEmpty ? appt.patientName[0].toUpperCase() : 'P',
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appt.patientName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                Text(
                  appt.reason,
                  style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(appt.time, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: statusColor)),
              ),
              const SizedBox(height: 4),
              Text(
                appt.status,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: statusColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityGrid(BuildContext context, bool isDark) {
    final days = context.isArabic
        ? ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت']
        : ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    final avails = profile.availabilities;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF071F17) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF093D2C) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                context.translate('manageHours'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(7, (i) {
              final avail = avails.where((a) => a.dayOfWeek == i).firstOrNull;
              final timeStr = avail != null ? '${avail.startTime} - ${avail.endTime}' : (context.isArabic ? 'مغلق' : 'Closed');
              final isOpen = avail != null;

              return Container(
                width: 150,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark
                      ? (isOpen ? const Color(0xFF093D2C) : Colors.white.withAlpha(5))
                      : (isOpen ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC)),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isOpen
                        ? AppColors.primary.withAlpha(40)
                        : (isDark ? const Color(0xFF093D2C) : const Color(0xFFE2E8F0)),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      days[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white54 : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      timeStr,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isOpen ? AppColors.primary : (isDark ? Colors.white30 : AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              );
            }),
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

  String _dayName(int weekday, bool isArabic) {
    const en = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const ar = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    return isArabic ? ar[weekday - 1] : en[weekday - 1];
  }

  String _monthName(int month, bool isArabic) {
    const en = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const ar = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    return isArabic ? ar[month - 1] : en[month - 1];
  }
}

class _StatItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem(this.icon, this.label, this.value, this.color);
}
