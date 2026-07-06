import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../data/models/doctor_dashboard_models.dart';
import '../cubit/doctor_dashboard_cubit.dart';

class DocSettingsTab extends StatefulWidget {
  final DoctorProfileModel profile;

  const DocSettingsTab({super.key, required this.profile});

  @override
  State<DocSettingsTab> createState() => _DocSettingsTabState();
}

class _DocSettingsTabState extends State<DocSettingsTab> {
  late List<_DayEntry> _days;

  @override
  void initState() {
    super.initState();
    _initDays();
  }

  @override
  void didUpdateWidget(covariant DocSettingsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) {
      _initDays();
    }
  }

  void _initDays() {
    final avails = widget.profile.availabilities;
    _days = List.generate(7, (i) {
      final existing = avails.where((a) => a.dayOfWeek == i).firstOrNull;
      return _DayEntry(
        dayOfWeek: i,
        isOpen: existing != null,
        startTime: existing?.startTime.substring(0, 5) ?? '09:00',
        endTime: existing?.endTime.substring(0, 5) ?? '17:00',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final dayNames = context.isArabic
        ? ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت']
        : ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(24),
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
            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 24, color: AppColors.primary),
                const SizedBox(width: 10),
                Text(
                  context.translate('manageHours'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              context.isArabic
                  ? 'قم بضبط ساعات العمل الخاصة بك لكل يوم من أيام الأسبوع.'
                  : 'Configure your working hours for each day of the week.',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white54 : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            // Day Rows
            ...List.generate(7, (i) => _buildDayRow(context, isDark, dayNames[i], i)),
            const SizedBox(height: 24),
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveAvailability,
                icon: const Icon(Icons.save_rounded, color: Colors.white),
                label: Text(
                  context.translate('saveChanges'),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayRow(BuildContext context, bool isDark, String dayName, int index) {
    final day = _days[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? (day.isOpen ? const Color(0xFF093D2C) : Colors.white.withAlpha(5))
            : (day.isOpen ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC)),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: day.isOpen
              ? AppColors.primary.withAlpha(40)
              : (isDark ? const Color(0xFF093D2C) : const Color(0xFFE2E8F0)),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              dayName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
          // Toggle
          Switch(
            value: day.isOpen,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primary,
            onChanged: (val) {
              setState(() => _days[index] = day.copyWith(isOpen: val));
            },
          ),
          const SizedBox(width: 16),
          // Start Time
          Expanded(
            child: _buildTimePicker(
              context,
              isDark,
              label: context.isArabic ? 'البدء' : 'Start',
              value: day.startTime,
              enabled: day.isOpen,
              onChanged: (val) {
                setState(() => _days[index] = day.copyWith(startTime: val));
              },
            ),
          ),
          const SizedBox(width: 12),
          // End Time
          Expanded(
            child: _buildTimePicker(
              context,
              isDark,
              label: context.isArabic ? 'الانتهاء' : 'End',
              value: day.endTime,
              enabled: day.isOpen,
              onChanged: (val) {
                setState(() => _days[index] = day.copyWith(endTime: val));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker(
    BuildContext context,
    bool isDark, {
    required String label,
    required String value,
    required bool enabled,
    required ValueChanged<String> onChanged,
  }) {
    return InkWell(
      onTap: enabled
          ? () async {
              final parts = value.split(':');
              final hour = int.tryParse(parts[0]) ?? 9;
              final minute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;

              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: hour, minute: minute),
              );
              if (picked != null) {
                final h = picked.hour.toString().padLeft(2, '0');
                final m = picked.minute.toString().padLeft(2, '0');
                onChanged('$h:$m');
              }
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF071F17) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? const Color(0xFF093D2C) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, size: 16,
                color: enabled
                    ? AppColors.primary
                    : (isDark ? Colors.white24 : AppColors.textSecondary.withAlpha(80))),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 10, color: isDark ? Colors.white38 : AppColors.textSecondary)),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: enabled
                        ? (isDark ? Colors.white : AppColors.textPrimary)
                        : (isDark ? Colors.white24 : AppColors.textSecondary.withAlpha(80)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveAvailability() {
    final payload = _days
        .where((d) => d.isOpen)
        .map((d) => DoctorAvailabilityModel(
              dayOfWeek: d.dayOfWeek,
              startTime: '${d.startTime}:00',
              endTime: '${d.endTime}:00',
            ))
        .toList();

    context.read<DoctorDashboardCubit>().updateAvailability(payload);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.translate('scheduleUpdated')),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _DayEntry {
  final int dayOfWeek;
  final bool isOpen;
  final String startTime;
  final String endTime;

  const _DayEntry({
    required this.dayOfWeek,
    required this.isOpen,
    required this.startTime,
    required this.endTime,
  });

  _DayEntry copyWith({
    bool? isOpen,
    String? startTime,
    String? endTime,
  }) {
    return _DayEntry(
      dayOfWeek: dayOfWeek,
      isOpen: isOpen ?? this.isOpen,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
