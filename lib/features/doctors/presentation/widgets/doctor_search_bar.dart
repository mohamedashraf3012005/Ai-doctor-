import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';

/// Customized search and filter row for finding specialists.
class DoctorSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String selectedSpecialty;
  final ValueChanged<String?> onSpecialtyChanged;
  final VoidCallback onSearchPressed;

  const DoctorSearchBar({
    super.key,
    required this.controller,
    required this.selectedSpecialty,
    required this.onSpecialtyChanged,
    required this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF05281D).withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isDark ? const Color(0xFF114C39) : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Icon(Icons.search, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: context.translate('searchDoctors'),
                hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onSubmitted: (_) => onSearchPressed(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 32,
            width: 1,
            color: isDark ? const Color(0xFF114C39) : AppColors.border,
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: selectedSpecialty,
            underline: const SizedBox(),
            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
            items: [
              DropdownMenuItem(value: 'all', child: Text(context.translate('allSpecialties'))),
              DropdownMenuItem(
                value: 'Pneumonia',
                child: Text(context.isArabic ? 'الالتهاب الرئوي' : 'Pneumonia'),
              ),
              DropdownMenuItem(
                value: 'Orthopedics',
                child: Text(context.isArabic ? 'العظام' : 'Orthopedics'),
              ),
              DropdownMenuItem(
                value: 'Neurology',
                child: Text(context.isArabic ? 'المخ والأعصاب' : 'Neurology'),
              ),
            ],
            onChanged: onSpecialtyChanged,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
