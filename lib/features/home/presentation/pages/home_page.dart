import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/utils/extensions.dart';
import '../widgets/hero_section.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF02140F) : AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.horizontalPadding,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppDimensions.maxWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(context),
                  const SizedBox(height: 32),
                  _buildHero(context),
                  const SizedBox(height: 36),
                  _buildFeatures(context),
                  const SizedBox(height: 36),
                  _buildProcess(context),
                  const SizedBox(height: 36),
                  _buildServices(context),
                  const SizedBox(height: 36),
                  _buildCTA(context),
                  const SizedBox(height: 40),
                  _buildFooter(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDark = context.isDark;
    final isArabic = context.isArabic;
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: Icon(
              Icons.medical_services_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                context.translate('appTitle'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
              ),
              const SizedBox(height: 2),
              Text(
                context.translate('smartAiMedicalPlatform'),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
              ),
            ],
          ),
        ),
        Row(
          children: [
            // Dark Mode Toggle
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                color: isDark ? const Color(0xFF34D399) : AppColors.primary,
              ),
              onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            ),
            const SizedBox(width: 8),
            // Language Selector
            InkWell(
              onTap: () => context.read<LocaleCubit>().toggleLocale(),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? const Color(0xFF114C39) : AppColors.border,
                  ),
                ),
                child: Text(
                  context.translate('language'),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFFECFDF5) : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return InkWell(
                    onTap: () => context.go('/dashboard'),
                    borderRadius: AppRadius.pill,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: AppRadius.pill,
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.dashboard_outlined, size: 16, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            context.translate('dashboard'),
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return InkWell(
                  onTap: () => context.push('/login'),
                  borderRadius: AppRadius.pill,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF093D2C) : AppColors.surfaceAlt,
                      borderRadius: AppRadius.pill,
                      border: Border.all(color: isDark ? const Color(0xFF114C39) : AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.login, size: 16),
                        const SizedBox(width: 6),
                        Text(context.translate('signIn'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHero(BuildContext context) => const HeroSection();

  Widget _buildFeatures(BuildContext context) {
    final isArabic = context.isArabic;
    return Column(
      crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          context.translate('everythingYouNeed'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 15,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.translate('everythingYouNeedDesc'),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 900
                ? 3
                : constraints.maxWidth > 600
                    ? 2
                    : 1;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              childAspectRatio: constraints.maxWidth > 900 ? 1.15 : 1.3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _featureCard(
                  context,
                  Icons.document_scanner_outlined,
                  context.translate('aiDiagnosis'),
                  context.translate('aiDiagnosisDesc'),
                  actionText: context.translate('tryNow'),
                  onTap: () => context.go('/diagnosis'),
                ),
                _featureCard(
                  context,
                  Icons.groups_outlined,
                  context.translate('expertDoctors'),
                  context.translate('expertDoctorsDesc'),
                  actionText: context.translate('browse'),
                  onTap: () => context.go('/doctors'),
                ),
                _featureCard(
                  context,
                  Icons.chat_bubble_outline,
                  context.translate('smartChat'),
                  context.translate('smartChatDesc'),
                  actionText: context.translate('chatNow'),
                  onTap: () => context.go('/chat'),
                ),
                _featureCard(
                  context,
                  Icons.calendar_month_outlined,
                  context.translate('easyBooking'),
                  context.translate('easyBookingDesc'),
                  actionText: context.translate('bookNow'),
                  onTap: () => context.go('/booking'),
                ),
                _featureCard(
                  context,
                  Icons.security_outlined,
                  context.translate('secureAndPrivate'),
                  context.translate('secureAndPrivateDesc'),
                  actionText: context.translate('learnMore'),
                  onTap: () {},
                ),
                _featureCard(
                  context,
                  Icons.bar_chart_outlined,
                  context.translate('healthTracking'),
                  context.translate('healthTrackingDesc'),
                  actionText: context.translate('myDashboard'),
                  onTap: () => context.go('/dashboard'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _featureCard(
    BuildContext context,
    IconData icon,
    String title,
    String description, {
    String? actionText,
    required VoidCallback onTap,
  }) {
    final isDark = context.isDark;
    final isArabic = context.isArabic;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.card,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF05281D) : AppColors.surfaceAlt,
          borderRadius: AppRadius.card,
          border: Border.all(color: isDark ? const Color(0xFF093D2C) : AppColors.border),
          boxShadow: const [AppShadows.soft],
        ),
        child: Column(
          crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                overflow: TextOverflow.fade,
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
              ),
            ),
            if (actionText != null) ...[
              const SizedBox(height: 12),
              Text(
                actionText,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProcess(BuildContext context) {
    final isMobile = context.isMobile;
    final isDark = context.isDark;
    final isArabic = context.isArabic;

    final steps = Column(
      crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          context.translate('howOurSystemWorks'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 15,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.translate('howOurSystemWorksDesc'),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 22),
        ...List.generate(3, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF05281D) : AppColors.surfaceAlt,
              borderRadius: AppRadius.card,
              border: Border.all(color: isDark ? const Color(0xFF093D2C) : AppColors.border),
            ),
            child: Row(
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        index == 0
                            ? context.translate('uploadYourScan')
                            : index == 1
                                ? context.translate('aiAnalysis')
                                : context.translate('getResultsBook'),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        index == 0
                            ? context.translate('uploadYourScanDesc')
                            : index == 1
                                ? context.translate('aiAnalysisDesc')
                                : context.translate('getResultsBookDesc'),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );

    final stats = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF05281D) : AppColors.surfaceAlt,
        borderRadius: AppRadius.card,
        border: Border.all(color: isDark ? const Color(0xFF093D2C) : AppColors.border),
        boxShadow: const [AppShadows.soft],
      ),
      child: Column(
        children: [
          _miniStatCard('96%', context.translate('confidence'), AppColors.primary),
          const SizedBox(height: 12),
          _miniStatCard('<3s', context.translate('analysisTime'), AppColors.secondary),
          const SizedBox(height: 12),
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF093D2C) : AppColors.surface,
              borderRadius: AppRadius.card,
            ),
            child: const Center(
              child: Icon(
                Icons.image_outlined,
                size: 50,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );

    if (isMobile) {
      return Column(
        children: [
          steps,
          const SizedBox(height: 24),
          stats,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: steps),
        const SizedBox(width: 24),
        Expanded(flex: 2, child: stats),
      ],
    );
  }

  Widget _miniStatCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.button,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadius.button,
            ),
            child: Center(
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServices(BuildContext context) {
    final isArabic = context.isArabic;
    return Column(
      crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          context.translate('comprehensiveMedicalServices'),
          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 26),
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _serviceChip(context, context.translate('boneFractureService'), Icons.healing),
            _serviceChip(context, context.translate('heartDiseaseService'), Icons.favorite_border),
            _serviceChip(context, context.translate('brainTumorService'), Icons.psychology_outlined),
            _serviceChip(context, context.translate('reportAnalysisService'), Icons.picture_as_pdf_outlined),
            _serviceChip(context, context.translate('lungConditionService'), Icons.air),
          ],
        ),
      ],
    );
  }

  Widget _serviceChip(BuildContext context, String label, IconData icon) {
    final isDark = context.isDark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF05281D) : AppColors.surfaceAlt,
        borderRadius: AppRadius.pill,
        border: Border.all(color: isDark ? const Color(0xFF093D2C) : AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white70 : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTA(BuildContext context) {
    final isMobile = context.isMobile;
    final isArabic = context.isArabic;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF05281D),
        borderRadius: AppRadius.card,
      ),
      child: Column(
        crossAxisAlignment: isMobile ? CrossAxisAlignment.center : (isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start),
        children: [
          Text(
            context.translate('readyToTakeControl'),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Colors.white,
              fontSize: isMobile ? 22 : 28,
            ),
            textAlign: isMobile ? TextAlign.center : (isArabic ? TextAlign.right : TextAlign.left),
          ),
          const SizedBox(height: 10),
          Text(
            context.translate('startFreeAnalysis'),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
            textAlign: isMobile ? TextAlign.center : (isArabic ? TextAlign.right : TextAlign.left),
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              _pillButton(
                context,
                context.translate('startFreeAnalysisBtn'),
                true,
                dark: true,
                onTap: () => context.go('/diagnosis'),
              ),
              _pillButton(
                context,
                context.translate('findSpecialist'),
                false,
                dark: true,
                onTap: () => context.go('/doctors'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final isDark = context.isDark;
    final isArabic = context.isArabic;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF05281D) : AppColors.surfaceAlt,
        borderRadius: AppRadius.card,
        border: Border.all(color: isDark ? const Color(0xFF093D2C) : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            context.translate('appTitle'),
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
          ),
          const SizedBox(height: 8),
          Text(
            context.translate('footerDesc'),
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _footerLink(context.translate('home'), () => context.go('/home')),
              _footerLink(context.translate('diagnosis'), () => context.go('/diagnosis')),
              _footerLink(context.translate('doctors'), () => context.go('/doctors')),
              _footerLink(context.translate('dashboard'), () => context.go('/dashboard')),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Text(
            context.translate('copyright'),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _footerLink(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _pillButton(
    BuildContext context,
    String label,
    bool filled, {
    bool dark = false,
    required VoidCallback onTap,
  }) {
    return Material(
      color: filled
          ? AppColors.primary
          : Colors.transparent,
      borderRadius: AppRadius.pill,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(999)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: filled
              ? null
              : BoxDecoration(
                  borderRadius: AppRadius.pill,
                  border: Border.all(color: dark ? Colors.white70 : AppColors.border),
                ),
          child: Text(
            label,
            style: TextStyle(
              color: filled
                  ? Colors.white
                  : (dark ? Colors.white : AppColors.textPrimary),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
