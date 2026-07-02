import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';

/// Progress steps wizard indicator matching the website's booking-stepper design.
class BookingStepper extends StatelessWidget {
  final int currentStep;

  const BookingStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Connector bar
            Positioned(
              left: 40,
              right: 40,
              child: Container(
                height: 3,
                color: isDark ? const Color(0xFF093D2C) : AppColors.border,
              ),
            ),
            // Dynamic fill bar
            Positioned(
              left: 40,
              right: 40,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: currentStep == 1
                    ? 0.0
                    : (currentStep == 2 ? 0.5 : 1.0),
                child: Container(
                  height: 3,
                  color: AppColors.primary,
                ),
              ),
            ),
            // Step Nodes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStepNode(context, 1, context.translate('stepSelect'), currentStep >= 1),
                _buildStepNode(context, 2, context.translate('stepDetails'), currentStep >= 2),
                _buildStepNode(context, 3, context.translate('stepConfirm'), currentStep >= 3),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepNode(BuildContext context, int index, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : const Color(0xFFEBFDF5),
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? AppColors.primary : const Color(0xFFA7F3D0),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              '$index',
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFF64748B),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? AppColors.primary : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}
