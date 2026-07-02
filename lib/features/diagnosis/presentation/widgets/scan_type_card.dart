import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';

/// Card selector representing scan option templates.
class ScanTypeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  const ScanTypeCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.card,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? iconColor.withValues(alpha: 0.08)
                : (isDark ? const Color(0xFF05281D) : Colors.white),
            borderRadius: AppRadius.card,
            border: Border.all(
              color: isSelected
                  ? iconColor
                  : (isDark ? const Color(0xFF093D2C) : AppColors.border),
              width: 1.5,
            ),
            boxShadow: const [AppShadows.soft],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: iconColor),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
