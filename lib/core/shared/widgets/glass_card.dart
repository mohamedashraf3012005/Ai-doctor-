import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Glassmorphism card matching the website's glass-card style.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? borderColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF05281D).withValues(alpha: 0.8)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: borderRadius ?? AppRadius.card,
        border: Border.all(
          color: borderColor ??
              (isDark
                  ? const Color(0xFF093D2C)
                  : AppColors.border.withValues(alpha: 0.5)),
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : const Color(0xFF05281D))
                .withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
