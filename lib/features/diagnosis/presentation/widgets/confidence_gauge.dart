import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';

/// Circular progress chart showing the AI confidence score.
class ConfidenceGauge extends StatelessWidget {
  final String confidence;

  const ConfidenceGauge({super.key, required this.confidence});

  double _getPercent() {
    final cleanString = confidence.replaceAll('%', '').trim();
    final value = double.tryParse(cleanString) ?? 90.0;
    return (value / 100.0).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final percent = _getPercent();
    final color = percent > 0.8
        ? AppColors.success
        : (percent > 0.5 ? AppColors.warning : AppColors.danger);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF05281D) : AppColors.surfaceAlt,
        borderRadius: AppRadius.card,
        border: Border.all(
          color: isDark ? const Color(0xFF093D2C) : AppColors.border,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularPercentIndicator(
            radius: 80.0,
            lineWidth: 10.0,
            percent: percent,
            center: Text(
              confidence,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: isDark ? const Color(0xFF093D2C) : AppColors.border.withValues(alpha: 0.5),
            progressColor: color,
            animation: true,
            animationDuration: 1000,
          ),
          const SizedBox(height: 16),
          Text(
            'Confidence Score'.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
