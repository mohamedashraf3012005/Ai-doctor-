import 'package:file_picker/file_picker.dart';
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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  final _experienceController = TextEditingController();
  final _clinicController = TextEditingController();

  String _selectedRole = 'patient';
  String _selectedGender = 'Male';
  String _selectedSpecialty = 'Pneumonia';
  String? _idCardPath;
  String? _idCardName;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _experienceController.dispose();
    _clinicController.dispose();
    super.dispose();
  }

  Future<void> _pickIdCard() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _idCardPath = result.files.single.path;
        _idCardName = result.files.single.name;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedRole == 'patient') {
        context.read<AuthCubit>().registerPatient(
              fullName: _nameController.text.trim(),
              email: _emailController.text.trim(),
              phone: _phoneController.text.trim(),
              password: _passwordController.text,
              age: int.tryParse(_ageController.text),
              gender: _selectedGender,
            );
      } else {
        if (_idCardPath == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.translate('pleaseUploadId')),
              backgroundColor: AppColors.danger,
            ),
          );
          return;
        }
        context.read<AuthCubit>().registerDoctor(
              fullName: _nameController.text.trim(),
              email: _emailController.text.trim(),
              phone: _phoneController.text.trim(),
              password: _passwordController.text,
              specialization: _selectedSpecialty,
              experienceYears: int.tryParse(_experienceController.text),
              gender: _selectedGender,
              clinicAddress: _clinicController.text.trim(),
              idCardPath: _idCardPath,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.screenWidth > 900;
    final isDark = context.isDark;

    final features = [
      context.translate('secureEncryption'),
      context.translate('aiHealthAnalysis'),
      context.translate('verifiedSpecialists'),
    ]
        .map(
          (feat) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Text(
                  feat,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();

    final formContent = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.translate('signUp'),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.translate('registerSubtitle'),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
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
            showAdmin: false,
            onRoleChanged: (role) {
              setState(() {
                _selectedRole = role;
              });
            },
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _nameController,
            label: context.translate('fullName'),
            hint: 'John Doe',
            prefixIcon: Icons.person_outline,
            validator: Validators.requiredValidator(context, context.translate('fullName')),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _emailController,
            label: context.translate('email'),
            hint: 'name@example.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.emailValidator(context),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextField(
                  controller: _phoneController,
                  label: context.translate('phone'),
                  hint: '+12345678',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: Validators.phoneValidator(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  controller: _passwordController,
                  label: context.translate('password'),
                  hint: '••••••••',
                  obscureText: true,
                  prefixIcon: Icons.lock_outline,
                  validator: Validators.passwordValidator(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Patient fields
          if (_selectedRole == 'patient') ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _ageController,
                    label: context.translate('age'),
                    hint: '25',
                    keyboardType: TextInputType.number,
                    validator: Validators.requiredValidator(context, context.translate('age')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.translate('gender'),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedGender,
                        items: ['Male', 'Female']
                            .map((g) => DropdownMenuItem(
                                  value: g,
                                  child: Text(g == 'Male' ? context.translate('male') : context.translate('female')),
                                ))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _selectedGender = v);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDark ? const Color(0xFF093D2C) : Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: AppRadius.button,
                            borderSide: BorderSide(
                              color: isDark ? const Color(0xFF114C39) : AppColors.border,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],

          // Doctor fields
          if (_selectedRole == 'doctor') ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.translate('specialty'),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedSpecialty,
                        items: ['Pneumonia', 'Orthopedics', 'Neurology']
                            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _selectedSpecialty = v);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDark ? const Color(0xFF093D2C) : Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: AppRadius.button,
                            borderSide: BorderSide(
                              color: isDark ? const Color(0xFF114C39) : AppColors.border,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    controller: _experienceController,
                    label: context.translate('yearsExp'),
                    hint: '5',
                    keyboardType: TextInputType.number,
                    validator: Validators.requiredValidator(context, context.translate('yearsExp')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.translate('gender'),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedGender,
                        items: ['Male', 'Female']
                            .map((g) => DropdownMenuItem(
                                  value: g,
                                  child: Text(g == 'Male' ? context.translate('male') : context.translate('female')),
                                ))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _selectedGender = v);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDark ? const Color(0xFF093D2C) : Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: AppRadius.button,
                            borderSide: BorderSide(
                              color: isDark ? const Color(0xFF114C39) : AppColors.border,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    controller: _clinicController,
                    label: context.translate('clinicAddress'),
                    hint: 'City Street 12',
                    validator: Validators.requiredValidator(context, context.translate('clinicAddress')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.translate('nationalIdCard'),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickIdCard,
                  borderRadius: AppRadius.button,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF093D2C) : Colors.white,
                      borderRadius: AppRadius.button,
                      border: Border.all(
                        color: isDark ? const Color(0xFF114C39) : AppColors.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.cloud_upload_outlined, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _idCardName ?? context.translate('uploadNationalId'),
                            style: TextStyle(
                              color: _idCardName != null
                                  ? (isDark ? Colors.white : AppColors.textPrimary)
                                  : AppColors.textSecondary,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],

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
                label: context.translate('signUp'),
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
                  "${context.translate('alreadyHaveAccount')} ",
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                InkWell(
                  onTap: () => context.pop(),
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
                title: context.translate('registerVisualTitle'),
                subtitle: context.translate('registerVisualSubtitle'),
                features: features,
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
