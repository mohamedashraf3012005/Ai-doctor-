import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../data/models/doctor_dashboard_models.dart';
import '../cubit/doctor_dashboard_cubit.dart';
import '../cubit/doctor_dashboard_state.dart';

class DocPatientsTab extends StatefulWidget {
  final DoctorDashboardStatsModel stats;

  const DocPatientsTab({super.key, required this.stats});

  @override
  State<DocPatientsTab> createState() => _DocPatientsTabState();
}

class _DocPatientsTabState extends State<DocPatientsTab> {
  String _searchQuery = '';

  List<_PatientEntry> _getPatients() {
    final uniqueIds = <String>{};
    final patients = <_PatientEntry>[];

    for (final a in widget.stats.todayAppointments) {
      final pid = a.patientId;
      if (pid != null && pid.isNotEmpty && uniqueIds.add(pid)) {
        patients.add(_PatientEntry(id: pid, name: a.patientName));
      }
    }
    for (final a in widget.stats.pastAppointments) {
      final pid = a.patientId;
      if (pid != null && pid.isNotEmpty && uniqueIds.add(pid)) {
        patients.add(_PatientEntry(id: pid, name: a.patientName));
      }
    }
    return patients;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final allPatients = _getPatients();
    final filtered = _searchQuery.isEmpty
        ? allPatients
        : allPatients.where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: context.translate('searchPatients'),
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
              filled: true,
              fillColor: isDark ? const Color(0xFF071F17) : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: isDark ? const Color(0xFF093D2C) : const Color(0xFFE2E8F0),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: isDark ? const Color(0xFF093D2C) : const Color(0xFFE2E8F0),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
          ),
        ),
        const SizedBox(height: 16),
        // Patients Table
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.people_outline_rounded, size: 56,
                          color: isDark ? Colors.white24 : AppColors.textSecondary.withAlpha(80)),
                      const SizedBox(height: 12),
                      Text(
                        context.translate('noResults'),
                        style: TextStyle(color: isDark ? Colors.white38 : AppColors.textSecondary),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final patient = filtered[index];
                    return _buildPatientTile(context, isDark, patient);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildPatientTile(BuildContext context, bool isDark, _PatientEntry patient) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF071F17) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF093D2C) : const Color(0xFFE2E8F0),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withAlpha(25),
          child: Text(
            patient.name.isNotEmpty ? patient.name[0].toUpperCase() : 'P',
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          patient.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          context.isArabic ? 'نشط' : 'Active',
          style: TextStyle(fontSize: 12, color: AppColors.success),
        ),
        trailing: OutlinedButton.icon(
          onPressed: () => _showPatientDetails(context, patient.id),
          icon: const Icon(Icons.person_search_rounded, size: 16),
          label: Text(context.translate('viewDetails'), style: const TextStyle(fontSize: 12)),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ),
    );
  }

  void _showPatientDetails(BuildContext context, String patientId) {
    context.read<DoctorDashboardCubit>().fetchPatientDetails(patientId);

    showDialog(
      context: context,
      builder: (dlgContext) {
        return BlocBuilder<DoctorDashboardCubit, DoctorDashboardState>(
          builder: (context, state) {
            final isDark = context.isDark;

            if (state is DoctorDashboardLoaded && state.patientDetails != null) {
              final p = state.patientDetails!;
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                backgroundColor: isDark ? const Color(0xFF071F17) : Colors.white,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: AppColors.primary.withAlpha(25),
                              child: Text(
                                p.fullName.isNotEmpty ? p.fullName[0].toUpperCase() : 'P',
                                style: const TextStyle(
                                    color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.fullName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(p.email,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: isDark ? Colors.white54 : AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                context.read<DoctorDashboardCubit>().clearPatientDetails();
                                Navigator.pop(dlgContext);
                              },
                              icon: Icon(Icons.close, color: isDark ? Colors.white54 : AppColors.textSecondary),
                            ),
                          ],
                        ),
                        const Divider(height: 30),
                        // Info Fields
                        _infoRow(Icons.male_rounded, 'Gender',
                            context.isArabic ? (p.gender == 'Male' ? 'ذكر' : 'أنثى') : p.gender, isDark),
                        if (p.age != null)
                          _infoRow(Icons.cake_rounded, 'Age',
                              '${p.age} ${context.isArabic ? 'سنة' : 'Years'}', isDark),
                        _infoRow(Icons.history_rounded, context.translate('medicalHistory'),
                            p.medicalHistory ?? (context.isArabic ? 'لا يوجد' : 'None'), isDark),
                        const SizedBox(height: 16),
                        // Scans Section
                        Text(
                          context.translate('scansAndAnalyses'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (p.scans.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                context.isArabic ? 'لا توجد فحوصات' : 'No scans recorded',
                                style: TextStyle(color: isDark ? Colors.white38 : AppColors.textSecondary),
                              ),
                            ),
                          )
                        else
                          ...p.scans.map((scan) => _buildScanTile(context, isDark, scan)),
                      ],
                    ),
                  ),
                ),
              );
            }

            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: isDark ? const Color(0xFF071F17) : Colors.white,
              child: const Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16),
                    Text('Loading patient details...'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: isDark ? Colors.white70 : AppColors.textSecondary)),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 13, color: isDark ? Colors.white : AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }

  Widget _buildScanTile(BuildContext context, bool isDark, DoctorDashboardReportModel scan) {
    Color badgeColor = const Color(0xFFF59E0B);
    final lower = scan.aiResult.toLowerCase();
    if (lower.contains('critical') || lower.contains('fracture')) {
      badgeColor = const Color(0xFFEF4444);
    } else if (lower.contains('normal')) {
      badgeColor = const Color(0xFF10B981);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A2D22) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(scan.scanType, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              scan.aiResult.length > 30 ? '${scan.aiResult.substring(0, 30)}...' : scan.aiResult,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: badgeColor),
            ),
          ),
          const SizedBox(width: 8),
          Text(scan.date, style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _PatientEntry {
  final String id;
  final String name;
  const _PatientEntry({required this.id, required this.name});
}
