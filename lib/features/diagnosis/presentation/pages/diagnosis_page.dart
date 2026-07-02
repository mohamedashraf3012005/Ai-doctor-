import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/shared/widgets/app_button.dart';
import '../../../../core/shared/widgets/page_header.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/diagnosis_cubit.dart';
import '../cubit/diagnosis_state.dart';
import '../widgets/confidence_gauge.dart';
import '../widgets/result_card.dart';
import '../widgets/scan_type_card.dart';
import '../widgets/upload_dropzone.dart';

class DiagnosisPage extends StatefulWidget {
  const DiagnosisPage({super.key});

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  String? _selectedScanType;
  String? _filePath;
  String? _fileName;

  void _onScanTypeSelected(String type) {
    setState(() {
      _selectedScanType = type;
    });
  }

  void _onFileSelected(String path, String name) {
    setState(() {
      _filePath = path;
      _fileName = name;
    });

    // Auto-trigger analysis if a scan type is selected
    if (_selectedScanType != null) {
      _triggerAnalysis();
    }
  }

  void _clearFile() {
    setState(() {
      _filePath = null;
      _fileName = null;
    });
    context.read<DiagnosisCubit>().reset();
  }

  void _triggerAnalysis() {
    // Auth Check
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in to run an AI diagnosis'),
          backgroundColor: AppColors.primary,
        ),
      );
      context.push('/login');
      return;
    }

    if (_selectedScanType == null || _filePath == null) return;

    context.read<DiagnosisCubit>().analyzeScan(
          scanType: _selectedScanType!,
          filePath: _filePath!,
          lang: 'en',
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.screenWidth > 900;
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF02140F) : AppColors.surface,
      body: BlocConsumer<DiagnosisCubit, DiagnosisState>(
        listener: (context, state) {
          if (state is DiagnosisError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.danger,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                PageHeader(
                  badge: context.translate('diagnosis'),
                  title: context.translate('aiMedicalDiagnosis'),
                  subtitle: context.translate('diagnosisSubtitle'),
                ),
                const SizedBox(height: 24),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: AppDimensions.maxWidth),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.horizontalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state is DiagnosisInitial || state is DiagnosisError) ...[
                            // Step 1: Selection
                            Text(
                              context.isArabic ? 'اختر نوع الفحص' : 'Select Examination Type',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              context.isArabic
                                  ? 'نماذج الذكاء الاصطناعي لدينا مدربة خصيصاً لهذه الأنواع من البيانات الطبية.'
                                  : 'Our AI models are specifically trained for these types of medical data.',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                ScanTypeCard(
                                  title: context.translate('boneFracture'),
                                  icon: Icons.healing,
                                  iconColor: AppColors.primary,
                                  isSelected: _selectedScanType == 'xray_bone',
                                  onTap: () => _onScanTypeSelected('xray_bone'),
                                ),
                                const SizedBox(width: 12),
                                ScanTypeCard(
                                  title: context.translate('chestXRay'),
                                  icon: Icons.air,
                                  iconColor: AppColors.secondary,
                                  isSelected: _selectedScanType == 'ecg_heart',
                                  onTap: () => _onScanTypeSelected('ecg_heart'),
                                ),
                                const SizedBox(width: 12),
                                ScanTypeCard(
                                  title: context.translate('brainMRI'),
                                  icon: Icons.psychology,
                                  iconColor: Colors.purple,
                                  isSelected: _selectedScanType == 'brain_neurology',
                                  onTap: () => _onScanTypeSelected('brain_neurology'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // Step 2: Upload Zone
                            Text(
                              context.translate('uploadScan'),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            UploadDropzone(
                              selectedFilePath: _filePath,
                              selectedFileName: _fileName,
                              onFileSelected: (file) {
                                _onFileSelected(file.path!, file.name);
                              },
                              onClearFile: _clearFile,
                            ),
                            const SizedBox(height: 32),

                            // Submit Button
                            if (_filePath != null && state is! DiagnosisLoading)
                              Center(
                                child: AppButton(
                                  label: context.isArabic ? 'تحليل بواسطة الذكاء الاصطناعي' : 'Analyze with AI',
                                  icon: Icons.biotech,
                                  onPressed: _triggerAnalysis,
                                ),
                              ),
                          ],

                          // Scanning Loading State
                          if (state is DiagnosisLoading) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF05281D) : Colors.white,
                                borderRadius: AppRadius.card,
                                border: Border.all(
                                  color: isDark ? const Color(0xFF093D2C) : AppColors.border,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 24),
                                  const SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 4,
                                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  Text(
                                    context.translate('analyzing'),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    context.isArabic
                                        ? 'جاري الكشف عن الحالات الشاذة والأنماط باستخدام شبكاتنا العصبية.'
                                        : 'Detecting anomalies and patterns using our neural networks.',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: state.progress,
                                      minHeight: 8,
                                      backgroundColor: isDark ? const Color(0xFF093D2C) : AppColors.border,
                                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ],

                          // Result Area
                          if (state is DiagnosisSuccess) ...[
                            Center(
                              child: Text(
                                context.isArabic ? 'نتائج التحليل' : 'Analysis Results',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            if (isDesktop)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: ConfidenceGauge(
                                      confidence: state.diagnosis.report.confidence,
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    flex: 3,
                                    child: ResultCard(diagnosis: state.diagnosis),
                                  ),
                                ],
                              )
                            else ...[
                              ConfidenceGauge(
                                confidence: state.diagnosis.report.confidence,
                              ),
                              const SizedBox(height: 20),
                              ResultCard(diagnosis: state.diagnosis),
                            ],
                            const SizedBox(height: 32),

                            // Disclaimer Banner
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(alpha: 0.1),
                                borderRadius: AppRadius.button,
                                border: Border.all(
                                  color: AppColors.warning.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      context.isArabic
                                          ? 'تنبيه: هذا التشخيص تم إنشاؤه بواسطة نموذج ذكاء اصطناعي كفحص أولي. لا ينبغي اعتباره تشخيصاً طبياً نهائياً. استشر دائماً طبيباً مؤهلاً.'
                                          : 'Notice: This diagnosis is generated by an AI model as a preliminary check. It should NOT be considered a final medical diagnosis. Always consult a qualified physician.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark ? Colors.white70 : AppColors.textPrimary,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Actions
                            Center(
                              child: Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  AppButton(
                                    label: context.translate('newScan'),
                                    isOutlined: true,
                                    icon: Icons.refresh,
                                    onPressed: _clearFile,
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
