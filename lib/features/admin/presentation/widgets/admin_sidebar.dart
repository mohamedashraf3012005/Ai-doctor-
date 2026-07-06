import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';

class AdminSidebar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final VoidCallback onLogout;

  const AdminSidebar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final backgroundColor = isDark ? const Color(0xFF05281D) : const Color(0xFFF1F5F9);
    final borderColor = isDark ? const Color(0xFF093D2C) : const Color(0xFFE2E8F0);

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          right: BorderSide(color: borderColor),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo & Header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: const Center(
                  child: Icon(
                    Icons.admin_panel_settings,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.translate('appTitle'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      context.translate('adminPanel'),
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? const Color(0xFFA7F3D0) : AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Sidebar items
          Expanded(
            child: ListView(
              children: [
                _buildNavItem(
                  context,
                  index: 0,
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard,
                  title: context.translate('overview'),
                ),
                _buildNavItem(
                  context,
                  index: 1,
                  icon: Icons.people_outline,
                  activeIcon: Icons.people,
                  title: context.translate('patients'),
                ),
                _buildNavItem(
                  context,
                  index: 2,
                  icon: Icons.assignment_ind_outlined,
                  activeIcon: Icons.assignment_ind,
                  title: context.translate('doctors'),
                ),
                _buildNavItem(
                  context,
                  index: 3,
                  icon: Icons.calendar_month_outlined,
                  activeIcon: Icons.calendar_month,
                  title: context.translate('appointments'),
                ),
              ],
            ),
          ),
          // Logout Button
          InkWell(
            onTap: onLogout,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? const Color(0xFF093D2C) : const Color(0xFFCBD5E1),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.logout, color: AppColors.danger, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    context.translate('signOut'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.danger,
                      fontSize: 14,
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

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String title,
  }) {
    final isSelected = currentIndex == index;
    final isDark = context.isDark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () => onTabChanged(index),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : AppColors.textSecondary),
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white70 : AppColors.textSecondary),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
