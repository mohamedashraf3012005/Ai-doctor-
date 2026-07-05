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
import '../widgets/role_selector.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'patient';
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
            userName: _emailController.text.trim(),
            password: _passwordController.text,
            role: _selectedRole,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.screenWidth > 900;
    final isDark = context.isDark;

    final formContent = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.translate('welcomeBack'),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.translate('loginSubtitle'),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            context.translate('registerAs'),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          RoleSelector(
            selectedRole: _selectedRole,
            onRoleChanged: (role) {
              setState(() {
                _selectedRole = role;
              });
            },
          ),
          const SizedBox(height: 24),
          AppTextField(
            controller: _emailController,
            label: context.translate('email'),
            hint: 'name@example.com',
            prefixIcon: _selectedRole == 'patient'
                ? Icons.email_outlined
                : _selectedRole == 'doctor'
                    ? Icons.email_outlined
                    : Icons.shield_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.emailValidator(context),
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.translate('password'),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/forgot-password'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      context.translate('forgotPassword'),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AppTextField(
                controller: _passwordController,
                hint: '********',
                obscureText: _obscurePassword,
                prefixIcon: Icons.lock_outline,
                suffix: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                validator: Validators.passwordValidator(context),
              ),
            ],
          ),
          const SizedBox(height: 32),
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${context.translate('welcomeUser')}, ${state.user.name}!'),
                    backgroundColor: AppColors.success,
                  ),
                );
                _emailController.clear();
                _passwordController.clear();
                // Navigate based on role
                if (state.user.role == 'doctor') {
                  context.go('/doctor-dashboard');
                } else if (state.user.role == 'admin') {
                  context.go('/admin-dashboard');
                } else {
                  context.go('/dashboard');
                }
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
                label: context.translate('signIn'),
                width: double.infinity,
                isLoading: state is AuthLoading,
                onPressed: _submit,
              );
            },
          ),
          const SizedBox(height: 24),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  "${context.translate('dontHaveAccount')} ",
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                InkWell(
                  onTap: () => context.push('/register'),
                  child: Text(
                    context.translate('signUp'),
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
              icon: const Icon(Icons.arrow_back, size: 16),
              label: Text(context.translate('backToHome')),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop)
            Expanded(
              child: AuthVisualPanel(
                title: context.translate('loginVisualTitle'),
                subtitle: context.translate('loginVisualSubtitle'),
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
                    child: isDesktop
                        ? GlassCard(child: formContent)
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: formContent,
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
