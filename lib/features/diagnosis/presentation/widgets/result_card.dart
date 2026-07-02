import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/diagnosis_entity.dart';

/// Renders detail reports, medical recommendations, and Grad-CAM heatmap visualization.
class ResultCard extends StatelessWidget {
  final DiagnosisEntity diagnosis;

  const ResultCard({super.key, required this.diagnosis});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final rep = diagnosis.report;

    // Resolve severity
    final severity = rep.severity ?? 'Normal';
    final severityColor = severity.toLowerCase() == 'critical'
        ? AppColors.danger
        : (severity.toLowerCase() == 'warning' ? AppColors.warning : AppColors.success);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF05281D) : Colors.white,
            borderRadius: AppRadius.card,
            border: Border.all(
              color: isDark ? const Color(0xFF093D2C) : AppColors.border,
            ),
            boxShadow: const [AppShadows.soft],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: severityColor.withValues(alpha: 0.1),
                      borderRadius: AppRadius.pill,
                      border: Border.all(color: severityColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      severity.toUpperCase(),
                      style: TextStyle(
                        color: severityColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                rep.diagnosis,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              if (rep.boneName != null && rep.boneName!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Affected Area: ${rep.boneName}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              if (rep.medicalReport != null && rep.medicalReport!.isNotEmpty) ...[
                const Text(
                  'Technical Medical Findings',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  rep.medicalReport!,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: isDark ? Colors.white70 : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
              ],
              if (rep.treatmentPlan != null && rep.treatmentPlan!.isNotEmpty) ...[
                const Text(
                  'Suggested Treatment Plan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  rep.treatmentPlan!,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: isDark ? Colors.white70 : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
              ],
              const Text(
                'Recommended Specialist',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                rep.recommendations,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Material(
                  color: AppColors.primary,
                  borderRadius: AppRadius.button,
                  child: InkWell(
                    onTap: () {
                      context.push('/doctors', extra: diagnosis.scanType);
                    },
                    borderRadius: AppRadius.button,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      child: Text(
                        'Book Doctor Consultation',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (rep.heatmapUrl != null && rep.heatmapUrl!.isNotEmpty) ...[
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF05281D) : Colors.white,
              borderRadius: AppRadius.card,
              border: Border.all(
                color: isDark ? const Color(0xFF093D2C) : AppColors.border,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Injury Heatmap (Grad-CAM)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: AppRadius.button,
                  child: CachedNetworkImage(
                    imageUrl: rep.heatmapUrl!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Colors.grey.shade100,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
