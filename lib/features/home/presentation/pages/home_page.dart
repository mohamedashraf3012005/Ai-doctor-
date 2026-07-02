import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/utils/extensions.dart';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Smart Care 360',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 2),
              Text(
                'Smart AI Medical Platform',
                style: Theme.of(context).textTheme.bodyMedium,
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

  Widget _buildHero(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = context.isMobile;

    final heroText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: AppRadius.pill,
          ),
          child: const Text(
            'Smart Healthcare Platform',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Your Integrated Platform for Smart Medical Care',
          style: theme.textTheme.displayLarge?.copyWith(
            color: Colors.white,
            fontSize: isMobile ? 26 : 34,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Instant analysis of your medical scans, comprehensive health tracking, and direct connection with elite specialists to book your appointments.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _pillButton(
              context,
              'Start Diagnosis',
              true,
              onTap: () => context.go('/diagnosis'),
            ),
            _pillButton(
              context,
              'Find a Doctor',
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

  Widget _buildFeatures(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Platform Features',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 15,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Everything You Need, In One Place',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 26),
        ),
        const SizedBox(height: 8),
        Text(
          'From instant scan analysis to specialist booking — our platform covers your full healthcare journey.',
          style: Theme.of(context).textTheme.bodyLarge,
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
                  'Scan Analysis',
                  'Upload X-rays, ECGs or reports for instant preliminary analysis of various medical conditions.',
                  onTap: () => context.go('/diagnosis'),
                ),
                _featureCard(
                  context,
                  Icons.groups_outlined,
                  'Expert Doctors',
                  'Connect with verified specialists based on your scan analysis results and book appointments instantly.',
                  onTap: () => context.go('/doctors'),
                ),
                _featureCard(
                  context,
                  Icons.chat_bubble_outline,
                  'Smart Chat',
                  'Chat with your doctor or ask our medical assistant for guidance anytime, anywhere.',
                  onTap: () => context.go('/chat'),
                ),
                _featureCard(
                  context,
                  Icons.calendar_month_outlined,
                  'Easy Booking',
                  'Book, reschedule or cancel appointments with top specialists in just a few clicks.',
                  onTap: () => context.go('/dashboard'),
                ),
                _featureCard(
                  context,
                  Icons.security_outlined,
                  'Secure & Private',
                  'Your medical data is fully encrypted and protected.',
                  onTap: () {},
                ),
                _featureCard(
                  context,
                  Icons.bar_chart_outlined,
                  'Health Tracking',
                  'Monitor your diagnosis history, appointments, and health trends from your personal dashboard.',
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
    required VoidCallback onTap,
  }) {
    final isDark = context.isDark;
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcess(BuildContext context) {
    final isMobile = context.isMobile;
    final isDark = context.isDark;

    final steps = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Simple Process',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 15,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'How Our System Works',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 26),
        ),
        const SizedBox(height: 10),
        Text(
          'Three simple steps to get your preliminary medical analysis in seconds.',
          style: Theme.of(context).textTheme.bodyLarge,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        index == 0
                            ? 'Upload Your Scan'
                            : index == 1
                                ? 'Smart Analysis'
                                : 'Get Results & Book',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        index == 0
                            ? 'Upload your X-ray, ECG image, or PDF medical report to our secure platform.'
                            : index == 1
                                ? 'Our analysis models scan and detect anomalies or conditions within seconds.'
                                : 'Receive a detailed report with confidence scores and book the right specialist instantly.',
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
          _miniStatCard('96%', 'Confidence', AppColors.primary),
          const SizedBox(height: 12),
          _miniStatCard('<3s', 'Analysis Time', AppColors.secondary),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What We Detect',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 15,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Comprehensive Medical Services',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 26),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _serviceChip(context, 'Bone Fracture Detection', Icons.healing),
            _serviceChip(context, 'Heart Disease Analysis', Icons.favorite_border),
            _serviceChip(context, 'Brain Tumor Detection', Icons.psychology_outlined),
            _serviceChip(context, 'Report Analysis (PDF)', Icons.picture_as_pdf_outlined),
            _serviceChip(context, 'Lung Condition Screening', Icons.air),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF05281D),
        borderRadius: AppRadius.card,
      ),
      child: Column(
        crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(
            'Ready to take control of your health?',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Colors.white,
              fontSize: isMobile ? 22 : 28,
            ),
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
          ),
          const SizedBox(height: 10),
          Text(
            'Start your free analysis today. No registration required for the first scan.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              _pillButton(
                context,
                'Start Free Analysis',
                true,
                dark: true,
                onTap: () => context.go('/diagnosis'),
              ),
              _pillButton(
                context,
                'Find a Specialist',
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF05281D) : AppColors.surfaceAlt,
        borderRadius: AppRadius.card,
        border: Border.all(color: isDark ? const Color(0xFF093D2C) : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Smart Care 360', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Smart Care 360 is an advanced healthcare platform leveraging clinical technology to provide instant medical insights and connect patients with top specialists.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _footerLink('Home', () => context.go('/home')),
              _footerLink('Instant Diagnosis', () => context.go('/diagnosis')),
              _footerLink('Doctors', () => context.go('/doctors')),
              _footerLink('Dashboard', () => context.go('/dashboard')),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Text(
            '© 2026 Smart Care 360. All rights reserved.',
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
