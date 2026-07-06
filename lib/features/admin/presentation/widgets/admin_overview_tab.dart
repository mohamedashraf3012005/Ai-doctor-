import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../data/models/admin_models.dart';
import '../cubit/admin_cubit.dart';
import 'admin_stat_card.dart';

class AdminOverviewTab extends StatelessWidget {
  final AdminStatsModel stats;
  final DashboardStatsModel dashboardStats;
  final ChartDataModel chartData;
  final List<AdminPatientModel> patients;
  final List<AdminDoctorModel> doctors;
  final List<AdminAppointmentModel> appointments;
  final List<AdminActivityModel> activities;
  final ValueChanged<int> onTabChanged;

  const AdminOverviewTab({
    super.key,
    required this.stats,
    required this.dashboardStats,
    required this.chartData,
    required this.patients,
    required this.doctors,
    required this.appointments,
    required this.activities,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.screenWidth < 900;
    final pendingVerifications = doctors.where((d) => !d.isApproved).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth < 600 ? 1 : (constraints.maxWidth < 1100 ? 2 : 3);
              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2.2,
                children: [
                  AdminStatCard(
                    value: '${stats.totalPatients}',
                    label: context.translate('totalPatients'),
                    icon: Icons.people,
                    color: AppColors.primary,
                  ),
                  AdminStatCard(
                    value: '${stats.totalDoctors}',
                    label: context.translate('registeredDoctors'),
                    icon: Icons.person_pin,
                    color: AppColors.secondary,
                  ),
                  AdminStatCard(
                    value: '${stats.totalScans}',
                    label: context.translate('aiScans'),
                    icon: Icons.biotech,
                    color: AppColors.secondary,
                  ),
                  AdminStatCard(
                    value: '${stats.todayAppointments}',
                    label: context.translate('todayAppointments'),
                    icon: Icons.calendar_today,
                    color: Colors.orange,
                  ),
                  AdminStatCard(
                    value: '$pendingVerifications',
                    label: context.translate('pendingVerification'),
                    icon: Icons.warning_amber_rounded,
                    color: Colors.red,
                  ),
                  AdminStatCard(
                    value: '${stats.monthAppointments}',
                    label: context.translate('apptsThisMonth'),
                    icon: Icons.calendar_month,
                    color: AppColors.primary,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Quick Actions Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildQuickActionBtn(
                  context,
                  label: context.translate('todayAppointments'),
                  icon: Icons.calendar_month,
                  color: AppColors.primary,
                  onPressed: () => onTabChanged(3),
                  filled: true,
                ),
                const SizedBox(width: 12),
                _buildQuickActionBtn(
                  context,
                  label: context.translate('registerNewDoctor'),
                  icon: Icons.person_add_alt_1,
                  color: AppColors.primary,
                  onPressed: () => _showAddDoctorDialog(context),
                ),
                const SizedBox(width: 12),
                _buildQuickActionBtn(
                  context,
                  label: context.translate('addSpecialty'),
                  icon: Icons.local_offer,
                  color: AppColors.primary,
                  onPressed: () => _showAddSpecialtyDialog(context),
                ),
                const SizedBox(width: 12),
                _buildQuickActionBtn(
                  context,
                  label: context.translate('registerNewPatient'),
                  icon: Icons.person_add,
                  color: AppColors.primary,
                  onPressed: () => _showAddPatientDialog(context),
                ),
                const SizedBox(width: 12),
                _buildQuickActionBtn(
                  context,
                  label: context.translate('quickReport'),
                  icon: Icons.analytics,
                  color: AppColors.primary,
                  onPressed: () => _showQuickReportDialog(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Charts / Today's Activity Layout
          isMobile
              ? Column(
                  children: [
                    _buildGrowthChartCard(context),
                    const SizedBox(height: 24),
                    _buildTodayActivityCard(context),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildGrowthChartCard(context)),
                    const SizedBox(width: 24),
                    Expanded(flex: 1, child: _buildTodayActivityCard(context)),
                  ],
                ),
          const SizedBox(height: 24),

          // Doughnut Charts Row
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 900;
              return isNarrow
                  ? Column(
                      children: [
                        _buildDoughnutCard(
                          context,
                          title: context.translate('doctorsBySpecialty'),
                          labels: chartData.specLabels,
                          values: chartData.specValues,
                          colors: [Colors.purple, Colors.orange, Colors.red, Colors.cyan, Colors.teal],
                        ),
                        const SizedBox(height: 24),
                        _buildDoughnutCard(
                          context,
                          title: context.translate('patientGender'),
                          labels: chartData.genderLabels.map((g) => context.translate(g.toLowerCase())).toList(),
                          values: chartData.genderValues,
                          colors: [Colors.blue, Colors.pink],
                        ),
                        const SizedBox(height: 24),
                        _buildDoughnutCard(
                          context,
                          title: context.translate('appointmentStatus'),
                          labels: chartData.statusLabels.map((s) => context.translate(s.toLowerCase())).toList(),
                          values: chartData.statusValues,
                          colors: [Colors.green, Colors.orange, Colors.red, Colors.blue],
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: _buildDoughnutCard(
                            context,
                            title: context.translate('doctorsBySpecialty'),
                            labels: chartData.specLabels,
                            values: chartData.specValues,
                            colors: [Colors.purple, Colors.orange, Colors.red, Colors.cyan, Colors.teal],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDoughnutCard(
                            context,
                            title: context.translate('patientGender'),
                            labels: chartData.genderLabels.map((g) => context.translate(g.toLowerCase())).toList(),
                            values: chartData.genderValues,
                            colors: [Colors.blue, Colors.pink],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDoughnutCard(
                            context,
                            title: context.translate('appointmentStatus'),
                            labels: chartData.statusLabels.map((s) => context.translate(s.toLowerCase())).toList(),
                            values: chartData.statusValues,
                            colors: [Colors.green, Colors.orange, Colors.red, Colors.blue],
                          ),
                        ),
                      ],
                    );
            },
          ),
          const SizedBox(height: 24),

          // Weekly appointments bar chart
          _buildWeeklyBarChart(context),
        ],
      ),
    );
  }

  Widget _buildQuickActionBtn(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    bool filled = false,
  }) {

    if (filled) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 16),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );
    }
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: AppColors.primary, size: 16),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _buildGrowthChartCard(BuildContext context) {
    final isDark = context.isDark;
    final labels = dashboardStats.growthLabels;
    final patientData = dashboardStats.patientGrowth;
    final doctorData = dashboardStats.doctorGrowth;

    return Container(
      height: 380,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF05281D) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF093D2C) : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.translate('platformGrowth'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  _buildLegendDot(Colors.blue, context.translate('patients')),
                  const SizedBox(width: 16),
                  _buildLegendDot(AppColors.primary, context.translate('doctors')),
                ],
              )
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark ? Colors.white10 : Colors.black12,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              labels[index],
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      patientData.length,
                      (i) => FlSpot(i.toDouble(), patientData[i]),
                    ),
                    isCurved: true,
                    barWidth: 3,
                    color: Colors.blue,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withValues(alpha: 0.1),
                    ),
                  ),
                  LineChartBarData(
                    spots: List.generate(
                      doctorData.length,
                      (i) => FlSpot(i.toDouble(), doctorData[i]),
                    ),
                    isCurved: true,
                    barWidth: 3,
                    color: AppColors.primary,
                    dashArray: [5, 5],
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildTodayActivityCard(BuildContext context) {
    final isDark = context.isDark;
    final uniquePatients = appointments.map((a) => a.patientName).toSet().length;
    final uniqueDoctors = appointments.map((a) => a.doctorName).toSet().length;

    return Container(
      height: 380,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF05281D) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF093D2C) : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.translate('recentSystemActivity'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          _buildActivityItem(
            context,
            value: '$uniquePatients',
            label: context.translate('activePatients'),
            icon: Icons.people,
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildActivityItem(
            context,
            value: '$uniqueDoctors',
            label: context.translate('activeDoctors'),
            icon: Icons.person_pin,
            color: Colors.green,
          ),
          const SizedBox(height: 16),
          _buildActivityItem(
            context,
            value: '${appointments.length}',
            label: context.translate('todayAppointments'),
            icon: Icons.calendar_today,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context, {
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    final isDark = context.isDark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF02140F) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF093D2C) : const Color(0xFFF1F5F9),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDoughnutCard(
    BuildContext context, {
    required String title,
    required List<String> labels,
    required List<double> values,
    required List<Color> colors,
  }) {
    final isDark = context.isDark;
    final total = values.fold(0.0, (sum, item) => sum + item);

    return Container(
      height: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF05281D) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF093D2C) : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 50,
                sections: List.generate(
                  values.length,
                  (i) {
                    final value = values[i];
                    final color = colors[i % colors.length];
                    final percentage = total > 0 ? (value / total * 100).toStringAsFixed(0) : '0';
                    return PieChartSectionData(
                      color: color,
                      value: value,
                      title: '$percentage%',
                      radius: 30,
                      titleStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Legend list
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: List.generate(
              labels.length,
              (i) => _buildLegendDot(colors[i % colors.length], labels[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyBarChart(BuildContext context) {
    final isDark = context.isDark;
    final labels = chartData.weekLabels;
    final values = chartData.weekValues;

    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF05281D) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF093D2C) : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.translate('weeklyAppointments'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BarChart(
              BarChartData(
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              labels[index],
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(
                  values.length,
                  (i) => BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: values[i],
                        color: values[i] > 0 ? AppColors.primary : Colors.grey.withValues(alpha: 0.2),
                        width: 24,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Methods for Dialogs
  void _showAddDoctorDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String fullName = '';
    String email = '';
    String password = '';
    String specialization = 'Neurology';
    int experienceYears = 5;
    String clinicAddress = '';

    showDialog(
      context: context,
      builder: (dlgContext) {
        return AlertDialog(
          title: Text(context.translate('registerNewDoctor')),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    onSaved: (v) => fullName = v!,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email Address'),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    onSaved: (v) => email = v!,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    onSaved: (v) => password = v!,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: specialization,
                    decoration: const InputDecoration(labelText: 'Specialization'),
                    items: ['Neurology', 'Pulmonology', 'Orthopedics', 'Cardiology']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) => specialization = v!,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Experience Years'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    onSaved: (v) => experienceYears = int.parse(v!),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Clinic Address'),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    onSaved: (v) => clinicAddress = v!,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dlgContext),
              child: Text(context.translate('cancel')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  Navigator.pop(dlgContext);
                  final success = await context.read<AdminCubit>().registerDoctor({
                    'FullName': fullName,
                    'Email': email,
                    'Password': password,
                    'Specialization': specialization,
                    'ExperienceYears': experienceYears,
                    'ClinicAddress': clinicAddress,
                    'Role': 'doctor',
                    'Phone': '1234567890',
                  });
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Doctor registered successfully')),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAddSpecialtyDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String nameEn = '';
    String nameAr = '';

    showDialog(
      context: context,
      builder: (dlgContext) {
        return AlertDialog(
          title: Text(context.translate('addNewSpecialty')),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Specialty Name (English)'),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  onSaved: (v) => nameEn = v!,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Specialty Name (Arabic)'),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  onSaved: (v) => nameAr = v!,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dlgContext),
              child: Text(context.translate('cancel')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  Navigator.pop(dlgContext);
                  final success = await context.read<AdminCubit>().addSpecialty({
                    'nameEn': nameEn,
                    'nameAr': nameAr,
                  });
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Specialty added successfully')),
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddPatientDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String fullName = '';
    String email = '';
    String password = '';
    int age = 30;
    String gender = 'Male';
    String phone = '';

    showDialog(
      context: context,
      builder: (dlgContext) {
        return AlertDialog(
          title: Text(context.translate('registerNewPatient')),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    onSaved: (v) => fullName = v!,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email Address'),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    onSaved: (v) => email = v!,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    onSaved: (v) => password = v!,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    onSaved: (v) => age = int.parse(v!),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: gender,
                    decoration: const InputDecoration(labelText: 'Gender'),
                    items: ['Male', 'Female']
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                    onChanged: (v) => gender = v!,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    onSaved: (v) => phone = v!,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dlgContext),
              child: Text(context.translate('cancel')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  Navigator.pop(dlgContext);
                  final success = await context.read<AdminCubit>().registerPatient({
                    'FullName': fullName,
                    'Email': email,
                    'Password': password,
                    'Age': age,
                    'Gender': gender.toLowerCase(),
                    'Phone': phone,
                    'Role': 'patient',
                  });
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Patient registered successfully')),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showQuickReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dlgContext) {
        return AlertDialog(
          title: Text(context.translate('quickReport')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Patients: ${stats.totalPatients}'),
              const SizedBox(height: 8),
              Text('Registered Doctors: ${stats.totalDoctors}'),
              const SizedBox(height: 8),
              Text('Total AI Scans Analysis: ${stats.totalScans}'),
              const SizedBox(height: 8),
              Text("Today's Appointments: ${stats.todayAppointments}"),
              const SizedBox(height: 8),
              Text('Month Appointments: ${stats.monthAppointments}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dlgContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
