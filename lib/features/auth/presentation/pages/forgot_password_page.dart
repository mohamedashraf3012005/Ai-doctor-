import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/shared/widgets/app_button.dart';
import '../../../../core/shared/widgets/app_text_field.dart';
import '../../../../core/shared/widgets/glass_card.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_visual_panel.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final _resetFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  int _currentStep = 1; // 1: Email, 2: OTP, 3: New Password
  String _sentEmail = '';
  String _demoOtp = '';

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_emailFormKey.currentState!.validate()) {
      _sentEmail = _emailController.text.trim();
      context.read<AuthCubit>().forgotPassword(_sentEmail);
    }
  }

  void _verifyOtp() {
    if (_otpFormKey.currentState!.validate()) {
      context.read<AuthCubit>().verifyOtp(
            email: _sentEmail,
            otp: _otpController.text.trim(),
          );
    }
  }

  void _resetPassword() {
    if (_resetFormKey.currentState!.validate()) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.translate('passwordsNoMatch')),
            backgroundColor: AppColors.danger,
          ),
        );
        return;
      }
      context.read<AuthCubit>().resetPassword(
            email: _sentEmail,
            otp: _otpController.text.trim(),
            newPassword: _newPasswordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.screenWidth > 900;
    final isDark = context.isDark;

    Widget formContent = const SizedBox();

    if (_currentStep == 1) {
      formContent = Form(
        key: _emailFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.translate('resetPassword'),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.translate('resetPasswordDesc'),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            AppTextField(
              controller: _emailController,
              label: context.translate('email'),
              hint: 'name@example.com',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.emailValidator(context),
            ),
            const SizedBox(height: 32),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is ForgotPasswordOtpSent) {
                  setState(() {
                    _currentStep = 2;
                    _demoOtp = state.otp;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${context.translate('otpSentSuccess')} $_sentEmail'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.danger,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return AppButton(
                  label: context.translate('sendResetCode'),
                  width: double.infinity,
                  isLoading: state is AuthLoading,
                  onPressed: _sendOtp,
                );
              },
            ),
          ],
        ),
      );
    } else if (_currentStep == 2) {
      formContent = Form(
        key: _otpFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.translate('verifyOtp'),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.translate('verifyOtpDesc'),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: AppRadius.button,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: isDark ? Colors.white70 : AppColors.textPrimary,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(text: context.translate('demoResetCode')),
                          TextSpan(
                            text: _demoOtp,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppTextField(
              controller: _otpController,
              label: context.translate('verificationCode'),
              hint: '000000',
              prefixIcon: Icons.lock_clock_outlined,
              keyboardType: TextInputType.number,
              validator: Validators.requiredValidator(context, context.translate('verificationCode')),
            ),
            const SizedBox(height: 32),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is OtpVerified) {
                  setState(() {
                    _currentStep = 3;
                  });
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.danger,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return AppButton(
                  label: context.translate('verifyCode'),
                  width: double.infinity,
                  isLoading: state is AuthLoading,
                  onPressed: _verifyOtp,
                );
              },
            ),
          ],
        ),
      );
    } else if (_currentStep == 3) {
      formContent = Form(
        key: _resetFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.translate('newPassword'),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.translate('newPasswordDesc'),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            AppTextField(
              controller: _newPasswordController,
              label: context.translate('newPassword'),
              hint: '••••••••',
              obscureText: true,
              prefixIcon: Icons.lock_outline,
              validator: Validators.passwordValidator(context),
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _confirmPasswordController,
              label: context.translate('confirmPassword'),
              hint: '••••••••',
              obscureText: true,
              prefixIcon: Icons.lock_outline,
              validator: Validators.passwordValidator(context),
            ),
            const SizedBox(height: 32),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is PasswordResetSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.translate('passwordResetSuccess')),
                      backgroundColor: AppColors.success,
                    ),
                  );
                  context.go('/login');
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.danger,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return AppButton(
                  label: context.translate('resetPassword'),
                  width: double.infinity,
                  isLoading: state is AuthLoading,
                  onPressed: _resetPassword,
                );
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop)
            Expanded(
              child: AuthVisualPanel(
                title: context.translate('forgotVisualTitle'),
                subtitle: context.translate('forgotVisualSubtitle'),
              ),
            ),
          Expanded(
            child: Container(
              color: isDark ? const Color(0xFF02140F) : AppColors.surface,
              alignment: Alignment.center,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        isDesktop ? GlassCard(child: formContent) : formContent,
                        const SizedBox(height: 24),
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              Text(
                                context.translate('rememberedPassword'),
                                style: const TextStyle(color: AppColors.textSecondary),
                              ),
                              InkWell(
                                onTap: () {
                                  if (context.canPop()) {
                                    context.pop();
                                  } else {
                                    context.go('/login');
                                  }
                                },
                                child: Text(
                                  context.translate('signIn'),
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Divider(height: 1),
                        const SizedBox(height: 24),
                        Center(
                          child: TextButton.icon(
                            onPressed: () => context.go('/home'),
                            icon: Icon(context.isArabic ? Icons.arrow_forward : Icons.arrow_back, size: 16),
                            label: Text(context.translate('backToHome')),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.textSecondary,
                              textStyle: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
