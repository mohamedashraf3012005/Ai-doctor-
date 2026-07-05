import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = context.isMobile;
    final isArabic = context.isArabic;
    final heroText = Column(
      crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          context.translate('heroTitle'),
          style: theme.textTheme.displayLarge?.copyWith(
            color: Colors.white,
            fontSize: isMobile ? 28 : 42,
            height: 1.2,
            fontWeight: FontWeight.w900,
          ),
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 16),
        Text(
          context.translate('heroDescription'),
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.95),
            fontSize: isMobile ? 15 : 17,
            height: 1.5,
          ),
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _pillButton(
              context,
              context.translate('startDiagnosis'),
              true,
              onTap: () => context.go('/diagnosis'),
            ),
            _pillButton(
              context,
              context.translate('findDoctor'),
              false,
              onTap: () => context.go('/doctors'),
            ),
          ],
        ),
      ],
    );

    final heroIllustration = Container(
      height: isMobile ? 180 : 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: AppRadius.card,
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: const Center(
        child: Icon(Icons.monitor_heart, color: Colors.white, size: 80),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF0D9488)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.card,
        boxShadow: const [AppShadows.card],
      ),
      child: isMobile
          ? Column(
              children: [
                heroText,
                const SizedBox(height: 24),
                heroIllustration,
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 3, child: heroText),
                const SizedBox(width: 24),
                Expanded(flex: 2, child: heroIllustration),
              ],
            ),
    );
  }

  Widget _pillButton(BuildContext context, String label, bool primary, {bool dark = false, required VoidCallback onTap}) {

    final background = primary ? (dark ? AppColors.primary : AppColors.primary.withValues(alpha: 0.1)) : Colors.transparent;
    final border = primary ? Colors.transparent : (dark ? Colors.transparent : AppColors.border);
    final textColor = primary ? (dark ? Colors.white : AppColors.primary) : (dark ? Colors.white : AppColors.primary);
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.pill,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: background,
          borderRadius: AppRadius.pill,
          border: Border.all(color: border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
