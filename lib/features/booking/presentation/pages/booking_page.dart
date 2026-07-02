import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/shared/widgets/app_button.dart';
import '../../../../core/shared/widgets/app_text_field.dart';
import '../../../../core/shared/widgets/glass_card.dart';
import '../../../../core/shared/widgets/page_header.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../doctors/domain/entities/doctor_entity.dart';
import '../../../doctors/presentation/cubit/doctors_cubit.dart';
import '../../../doctors/presentation/cubit/doctors_state.dart';
import '../../domain/entities/appointment_entity.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import '../widgets/booking_stepper.dart';
import '../widgets/time_slot_grid.dart';

class BookingPage extends StatefulWidget {
  final DoctorEntity? initialDoctor;

  const BookingPage({super.key, this.initialDoctor});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _patientFormKey = GlobalKey<FormState>();

  int _currentStep = 1;

  // Selected values
  String? _selectedSpecialty;
  DoctorEntity? _selectedDoctor;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedSlot;

  // Patient inputs
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  // Mock slots for fallback / demo evaluation
  final List<String> _demoSlots = [
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    // Load specialties and doctors
    context.read<DoctorsCubit>().fetchDoctors();

    // Set initial doctor if navigated with extra parameter
    if (widget.initialDoctor != null) {
      _selectedDoctor = widget.initialDoctor;
      _selectedSpecialty = widget.initialDoctor!.specialization;
    }

    // Prepopulate patient inputs from logged in user profile
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      _nameController.text = authState.user.name;
      _phoneController.text = authState.user.phone ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 1) {
      if (_selectedDoctor == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.translate('pleaseSelectDoctor'))),
        );
        return;
      }
      if (_selectedSlot == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.translate('pleaseSelectSlot'))),
        );
        return;
      }
      setState(() => _currentStep = 2);
    } else if (_currentStep == 2) {
      if (_patientFormKey.currentState!.validate()) {
        setState(() => _currentStep = 3);
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    }
  }

  void _submitBooking() {
    if (_selectedDoctor == null || _selectedSlot == null) return;

    final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

    context.read<BookingCubit>().bookAppointment(
          doctorId: _selectedDoctor!.id,
          patientName: _nameController.text.trim(),
          patientPhone: _phoneController.text.trim(),
          appointmentDate: formattedDate,
          timeSlot: _selectedSlot!,
          medicalNotes: _notesController.text.trim(),
        );
  }

  void _showSuccessDialog(AppointmentEntity appt) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 24),
                Text(
                  context.translate('appointmentConfirmed'),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  context.translate('appointmentConfirmedDesc'),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                AppButton(
                  label: context.translate('viewDashboard'),
                  width: double.infinity,
                  onPressed: () {
                    ctx.pop(); // close dialog
                    context.go('/dashboard');
                  },
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    ctx.pop();
                    context.go('/home');
                  },
                  child: Text(
                    context.translate('returnHome'),
                    style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _selectedSlot = null; // Reset slot
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF02140F) : AppColors.surface,
      body: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingSuccess) {
            context.read<BookingCubit>().reset();
            _showSuccessDialog(state.appointment);
          } else if (state is BookingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.danger),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                PageHeader(
                  badge: context.translate('appointmentBooking'),
                  title: context.translate('scheduleConsultation'),
                  subtitle: context.translate('bookingSubtitle'),
                ),
                const SizedBox(height: 24),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding),
                      child: Column(
                        children: [
                          BookingStepper(currentStep: _currentStep),
                          const SizedBox(height: 32),
                          GlassCard(
                            padding: const EdgeInsets.all(28),
                            child: _buildStepContent(state),
                          ),
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

  Widget _buildStepContent(BookingState state) {
    final isDark = context.isDark;
    if (_currentStep == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.translate('chooseSpecialist'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.translate('specialty'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    BlocBuilder<DoctorsCubit, DoctorsState>(
                      builder: (context, state) {
                        return DropdownButtonFormField<String>(
                          initialValue: _selectedSpecialty,
                          hint: Text(context.translate('allSpecialties')),
                          items: [
                            DropdownMenuItem(value: 'Pneumonia', child: Text(context.isArabic ? 'أمراض القلب' : 'Cardiologist')),
                            DropdownMenuItem(value: 'Orthopedics', child: Text(context.isArabic ? 'العظام' : 'Orthopedist')),
                            DropdownMenuItem(value: 'Neurology', child: Text(context.isArabic ? 'الأعصاب' : 'Neurologist')),
                          ],
                          onChanged: (val) {
                            setState(() {
                              _selectedSpecialty = val;
                              _selectedDoctor = null;
                              _selectedSlot = null;
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: isDark ? const Color(0xFF05281D) : Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: AppRadius.button,
                              borderSide: BorderSide(color: isDark ? const Color(0xFF163F2F) : AppColors.border),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.translate('selectDoctor'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              BlocBuilder<DoctorsCubit, DoctorsState>(
                builder: (context, state) {
                  List<DoctorEntity> list = [];
                  if (state is DoctorsLoaded) {
                    list = state.doctors;
                    if (_selectedSpecialty != null) {
                      list = list.where((d) => d.specialization == _selectedSpecialty).toList();
                    }
                  }

                  return DropdownButtonFormField<DoctorEntity>(
                    initialValue: _selectedDoctor,
                    hint: Text(context.translate('chooseSpecialistHint')),
                    items: list
                        .map((d) => DropdownMenuItem(value: d, child: Text('${context.isArabic ? "د." : "Dr."} ${d.fullName}')))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedDoctor = val;
                        _selectedSlot = null;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: isDark ? const Color(0xFF05281D) : Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.button,
                        borderSide: BorderSide(color: isDark ? const Color(0xFF163F2F) : AppColors.border),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          if (_selectedDoctor != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: AppRadius.button,
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.translate('clinicAddress'), style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(
                          _selectedDoctor!.clinicAddress,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white70 : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.translate('consultationDate'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('EEEE, MMM dd, yyyy', context.isArabic ? 'ar' : 'en').format(_selectedDate),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              AppButton(
                label: context.translate('changeDate'),
                isOutlined: true,
                onPressed: _selectDate,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            context.translate('availableSlots'),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          TimeSlotGrid(
            slots: _demoSlots,
            selectedSlot: _selectedSlot,
            onSlotSelected: (slot) {
              setState(() => _selectedSlot = slot);
            },
          ),
          const SizedBox(height: 32),
          Align(
            alignment: context.isArabic ? Alignment.centerLeft : Alignment.centerRight,
            child: AppButton(
              label: context.translate('continue_'),
              icon: context.isArabic ? Icons.arrow_back : Icons.arrow_forward,
              onPressed: _nextStep,
            ),
          ),
        ],
      );
    } else if (_currentStep == 2) {
      return Form(
        key: _patientFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.translate('personalInfo'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _nameController,
                    label: context.translate('patientFullName'),
                    hint: context.isArabic ? 'محمد أحمد' : 'John Doe',
                    validator: (v) => Validators.required(v, context.translate('patientName')),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _phoneController,
                    label: context.translate('contactPhone'),
                    hint: '+12345678',
                    validator: Validators.phone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _notesController,
              label: context.translate('reasonForVisit'),
              hint: context.translate('describeSymptoms'),
              maxLines: 4,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton(
                  label: context.translate('back'),
                  isOutlined: true,
                  icon: context.isArabic ? Icons.arrow_forward : Icons.arrow_back,
                  onPressed: _prevStep,
                ),
                AppButton(
                  label: context.translate('summary'),
                  icon: context.isArabic ? Icons.arrow_back : Icons.arrow_forward,
                  onPressed: _nextStep,
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      // Step 3 Summary
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.translate('confirmAppointment'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF093D2C) : const Color(0xFFF4FDF9),
              borderRadius: AppRadius.card,
              border: Border.all(color: isDark ? const Color(0xFF114C39) : AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.translate('specialist'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textSecondary)),
                          const SizedBox(height: 6),
                          Text('${context.isArabic ? "د." : "Dr."} ${_selectedDoctor!.fullName}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(_selectedDoctor!.specialization, style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  _selectedDoctor!.clinicAddress,
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.translate('schedule'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textSecondary)),
                          const SizedBox(height: 6),
                          Text(DateFormat('MMMM dd, yyyy', context.isArabic ? 'ar' : 'en').format(_selectedDate), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(_selectedSlot!, style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 16),
                Text(context.translate('patientDetailsLabel'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Text('${context.translate('name')}: ${_nameController.text}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${context.translate('phone')}: ${_phoneController.text}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppButton(
                label: context.translate('back'),
                isOutlined: true,
                icon: context.isArabic ? Icons.arrow_forward : Icons.arrow_back,
                onPressed: _prevStep,
              ),
              AppButton(
                label: context.translate('finalizeBooking'),
                icon: Icons.check,
                color: Colors.green,
                isLoading: state is BookingLoading,
                onPressed: _submitBooking,
              ),
            ],
          ),
        ],
      );
    }
  }
}
