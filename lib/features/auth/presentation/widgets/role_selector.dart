import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Role selector matching the custom radio buttons styled as cards in login/register.
class RoleSelector extends StatelessWidget {
  final String selectedRole;
  final ValueChanged<String> onRoleChanged;
  final bool showAdmin;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
    this.showAdmin = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final roles = [
      (key: 'patient', label: 'Patient', icon: Icons.person_outline),
      (key: 'doctor', label: 'Doctor', icon: Icons.person_pin_outlined),
      if (showAdmin) (key: 'admin', label: 'Admin', icon: Icons.shield_outlined),
    ];

    return Row(
      children: roles.map((role) {
        final isSelected = selectedRole == role.key;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: InkWell(
              onTap: () => onRoleChanged(role.key),
              borderRadius: AppRadius.button,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : (isDark ? const Color(0xFF093D2C) : Colors.white),
                  borderRadius: AppRadius.button,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? const Color(0xFF114C39) : AppColors.border),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      role.icon,
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? Colors.white60 : AppColors.textSecondary),
                      size: 22,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      role.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
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
      }).toList(),
    );
  }
}
