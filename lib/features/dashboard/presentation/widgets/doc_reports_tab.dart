import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../data/models/doctor_dashboard_models.dart';

class DocReportsTab extends StatelessWidget {
  final DoctorDashboardStatsModel stats;

  const DocReportsTab({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final reports = stats.pendingReports;

    if (reports.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.assignment_turned_in_rounded, size: 64,
                color: isDark ? Colors.white24 : AppColors.textSecondary.withAlpha(80)),
            const SizedBox(height: 16),
            Text(
              context.isArabic ? 'لا توجد تقارير معلقة' : 'No pending reports for review',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white38 : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
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
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.science_rounded, size: 22, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text(
                    context.translate('pendingReports'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${reports.length} ${context.isArabic ? 'تقرير' : 'reports'}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: isDark ? const Color(0xFF0A2D22) : const Color(0xFFF8FAFC),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      context.translate('patient'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white54 : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      context.translate('aiResult'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white54 : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 80,
                    child: Text(
                      'Action',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Report Rows
            ...reports.map((report) => _buildReportRow(context, isDark, report)),
          ],
        ),
      ),
    );
  }

  Widget _buildReportRow(BuildContext context, bool isDark, DoctorDashboardReportModel report) {
    Color badgeColor = const Color(0xFFF59E0B);
    final lower = report.aiResult.toLowerCase();
    if (lower.contains('critical') || lower.contains('fracture') || lower.contains('كسر')) {
      badgeColor = const Color(0xFFEF4444);
    } else if (lower.contains('normal') || lower.contains('سليم') || lower.contains('طبيعي')) {
      badgeColor = const Color(0xFF10B981);
    }

    String displayResult = report.aiResult;
    try {
      // Try to parse JSON result
      if (displayResult.startsWith('{')) {
        final idx = displayResult.indexOf('Diagnosis');
        if (idx > 0) {
          displayResult = displayResult.substring(idx + 12).split('"').first;
        }
      }
    } catch (_) {}

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF093D2C) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              report.patientName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: badgeColor.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                displayResult.length > 40 ? '${displayResult.substring(0, 40)}...' : displayResult,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: badgeColor,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: () {
                  // In a full implementation, this would navigate to a diagnosis detail view
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.isArabic ? 'فتح تقرير الفحص...' : 'Opening scan report...'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: const Size(0, 0),
                ),
                child: Text(
                  context.translate('review'),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
