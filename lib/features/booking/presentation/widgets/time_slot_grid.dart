import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';

/// Grid of time slot chips supporting selection.
class TimeSlotGrid extends StatelessWidget {
  final List<String> slots;
  final String? selectedSlot;
  final ValueChanged<String> onSlotSelected;

  const TimeSlotGrid({
    super.key,
    required this.slots,
    required this.selectedSlot,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    if (slots.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        alignment: Alignment.center,
        child: const Text(
          'No available time slots found for the selected date.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: slots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.5,
      ),
      itemBuilder: (context, index) {
        final slot = slots[index];
        final isSelected = selectedSlot == slot;

        return InkWell(
          onTap: () => onSlotSelected(slot),
          borderRadius: AppRadius.button,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? const Color(0xFF093D2C) : const Color(0xFFF4FDF9)),
              borderRadius: AppRadius.button,
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? const Color(0xFF114C39) : AppColors.border),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              slot,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : AppColors.textPrimary),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        );
      },
    );
  }
}
