import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../data/models/doctor_dashboard_models.dart';
import '../cubit/doctor_dashboard_cubit.dart';

class DocProfileTab extends StatefulWidget {
  final DoctorProfileModel profile;

  const DocProfileTab({super.key, required this.profile});

  @override
  State<DocProfileTab> createState() => _DocProfileTabState();
}

class _DocProfileTabState extends State<DocProfileTab> {
  final _formKey = GlobalKey<FormState>();
  late String _fullName;
  late String _specialty;
  late String _phone;
  late int _expYears;
  late String _bio;
  late String _address;

  @override
  void initState() {
    super.initState();
    _initFields();
  }

  @override
  void didUpdateWidget(covariant DocProfileTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) {
      _initFields();
    }
  }

  void _initFields() {
    _fullName = widget.profile.fullName;
    _specialty = widget.profile.specialty;
    _phone = widget.profile.phoneNumber;
    _expYears = widget.profile.experienceYears ?? 0;
    _bio = widget.profile.bio ?? '';
    _address = widget.profile.clinicAddress ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF071F17) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? const Color(0xFF093D2C) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.person_outline_rounded, size: 24, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text(
                    context.translate('editProfile'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Name
              TextFormField(
                initialValue: _fullName,
                decoration: InputDecoration(
                  labelText: context.translate('fullName'),
                  prefixIcon: const Icon(Icons.badge_outlined),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                onSaved: (v) => _fullName = v!.trim(),
              ),
              const SizedBox(height: 16),
              // Specialty
              TextFormField(
                initialValue: _specialty,
                decoration: InputDecoration(
                  labelText: context.translate('specialty'),
                  prefixIcon: const Icon(Icons.medical_services_outlined),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                onSaved: (v) => _specialty = v!.trim(),
              ),
              const SizedBox(height: 16),
              // Phone
              TextFormField(
                initialValue: _phone,
                decoration: InputDecoration(
                  labelText: context.translate('phoneNumber'),
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                onSaved: (v) => _phone = v!.trim(),
              ),
              const SizedBox(height: 16),
              // Exp Years
              TextFormField(
                initialValue: _expYears.toString(),
                decoration: InputDecoration(
                  labelText: context.translate('experienceYears'),
                  prefixIcon: const Icon(Icons.timeline_outlined),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                onSaved: (v) => _expYears = int.tryParse(v!) ?? 0,
              ),
              const SizedBox(height: 16),
              // Address
              TextFormField(
                initialValue: _address,
                decoration: InputDecoration(
                  labelText: context.translate('clinicAddress'),
                  prefixIcon: const Icon(Icons.location_on_outlined),
                ),
                onSaved: (v) => _address = v?.trim() ?? '',
              ),
              const SizedBox(height: 16),
              // Bio
              TextFormField(
                initialValue: _bio,
                decoration: InputDecoration(
                  labelText: context.translate('bio'),
                  prefixIcon: const Icon(Icons.description_outlined),
                ),
                maxLines: 4,
                onSaved: (v) => _bio = v?.trim() ?? '',
              ),
              const SizedBox(height: 24),
              // Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    context.translate('saveChanges'),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final payload = {
        'fullName': _fullName,
        'specialty': _specialty,
        'phoneNumber': _phone,
        'experienceYears': _expYears,
        'bio': _bio,
        'clinicAddress': _address,
      };

      final messenger = ScaffoldMessenger.of(context);
      final successMsg = context.translate('profileUpdated');

      final success = await context.read<DoctorDashboardCubit>().updateProfile(payload);
      if (success) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(successMsg),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }
}
