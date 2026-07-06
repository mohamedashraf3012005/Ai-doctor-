import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../data/models/admin_models.dart';
import '../cubit/admin_cubit.dart';

class AdminDoctorsTab extends StatefulWidget {
  final List<AdminDoctorModel> doctors;

  const AdminDoctorsTab({super.key, required this.doctors});

  @override
  State<AdminDoctorsTab> createState() => _AdminDoctorsTabState();
}

class _AdminDoctorsTabState extends State<AdminDoctorsTab> {
  String _searchQuery = '';
  String _specialtyFilter = '';
  int _currentPage = 1;
  static const int _pageSize = 10;
  bool _sortAscending = true;
  String _sortColumn = 'name'; // name, specialty, address, experience

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    // Get unique specialties for dropdown
    final specialties = widget.doctors
        .map((d) => d.specialty)
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList();

    // Filter doctors
    final filteredDoctors = widget.doctors.where((d) {
      final name = d.fullName.toLowerCase();
      final email = d.email.toLowerCase();
      final query = _searchQuery.toLowerCase();
      final matchesQuery = name.contains(query) || email.contains(query);

      final matchesSpecialty = _specialtyFilter.isEmpty || d.specialty == _specialtyFilter;

      return matchesQuery && matchesSpecialty;
    }).toList();

    // Sort doctors
    if (_sortColumn == 'name') {
      filteredDoctors.sort((a, b) =>
          _sortAscending ? a.fullName.compareTo(b.fullName) : b.fullName.compareTo(a.fullName));
    } else if (_sortColumn == 'specialty') {
      filteredDoctors.sort((a, b) =>
          _sortAscending ? a.specialty.compareTo(b.specialty) : b.specialty.compareTo(a.specialty));
    } else if (_sortColumn == 'address') {
      filteredDoctors.sort((a, b) => _sortAscending
          ? a.clinicAddress.compareTo(b.clinicAddress)
          : b.clinicAddress.compareTo(a.clinicAddress));
    } else if (_sortColumn == 'experience') {
      filteredDoctors.sort((a, b) => _sortAscending
          ? a.experienceYears.compareTo(b.experienceYears)
          : b.experienceYears.compareTo(a.experienceYears));
    }

    // Pagination
    final totalItems = filteredDoctors.length;
    final totalPages = (totalItems / _pageSize).ceil();
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = (startIndex + _pageSize < totalItems) ? startIndex + _pageSize : totalItems;
    final paginatedDoctors =
        totalItems > 0 ? filteredDoctors.sublist(startIndex, endIndex) : <AdminDoctorModel>[];

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Doctors Verification + Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.translate('doctorsVerification'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$totalItems Registered Doctors',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
              Row(
                children: [
                  // Specialty Dropdown
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF02140F) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? const Color(0xFF093D2C) : AppColors.border,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _specialtyFilter.isEmpty ? null : _specialtyFilter,
                        hint: Text(context.translate('allSpecialties')),
                        items: [
                          DropdownMenuItem<String>(
                            value: null,
                            child: Text(context.translate('allSpecialties')),
                          ),
                          ...specialties.map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          ),
                        ],
                        onChanged: (v) {
                          setState(() {
                            _specialtyFilter = v ?? '';
                            _currentPage = 1;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Search box
                  Container(
                    width: 200,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF02140F) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? const Color(0xFF093D2C) : AppColors.border,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        icon: Icon(Icons.search, size: 18, color: Colors.grey),
                        contentPadding: EdgeInsets.only(bottom: 12),
                      ),
                      onChanged: (v) {
                        setState(() {
                          _searchQuery = v;
                          _currentPage = 1;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Register new doctor button
                  ElevatedButton.icon(
                    onPressed: () => _showAddDoctorDialog(context),
                    icon: const Icon(Icons.add, size: 16, color: Colors.white),
                    label: Text(context.translate('registerNewDoctor'), style: const TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // CSV button
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Data exported successfully')),
                      );
                    },
                    icon: const Icon(Icons.download, size: 16),
                    label: Text(context.translate('csvExport')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Doctors Table
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF05281D) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? const Color(0xFF093D2C) : AppColors.border,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        isDark ? const Color(0xFF02140F) : const Color(0xFFF8FAFC),
                      ),
                      columns: [
                        DataColumn(
                          label: Row(
                            children: [
                              Text(context.translate('thDoctorName')),
                              const SizedBox(width: 4),
                              const Icon(Icons.swap_vert, size: 14),
                            ],
                          ),
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              _sortColumn = 'name';
                              _sortAscending = ascending;
                            });
                          },
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              Text(context.translate('thSpecialty')),
                              const SizedBox(width: 4),
                              const Icon(Icons.swap_vert, size: 14),
                            ],
                          ),
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              _sortColumn = 'specialty';
                              _sortAscending = ascending;
                            });
                          },
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              Text(context.translate('thClinicAddress')),
                              const SizedBox(width: 4),
                              const Icon(Icons.swap_vert, size: 14),
                            ],
                          ),
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              _sortColumn = 'address';
                              _sortAscending = ascending;
                            });
                          },
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              Text(context.translate('thExperience')),
                              const SizedBox(width: 4),
                              const Icon(Icons.swap_vert, size: 14),
                            ],
                          ),
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              _sortColumn = 'experience';
                              _sortAscending = ascending;
                            });
                          },
                        ),
                        DataColumn(label: Text(context.translate('thVerification'))),
                        DataColumn(label: Text(context.translate('thActions'))),
                      ],
                      rows: paginatedDoctors.map((doctor) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    doctor.fullName,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    doctor.email,
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(Text(doctor.specialty)),
                            DataCell(Text(doctor.clinicAddress)),
                            DataCell(Text('${doctor.experienceYears} Yrs Exp')),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: doctor.isApproved
                                      ? Colors.green.withValues(alpha: 0.1)
                                      : Colors.orange.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      doctor.isApproved ? Icons.check_circle : Icons.schedule,
                                      color: doctor.isApproved ? Colors.green : Colors.orange,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      doctor.isApproved
                                          ? context.translate('verified')
                                          : context.translate('pendingApproval'),
                                      style: TextStyle(
                                        color: doctor.isApproved ? Colors.green : Colors.orange,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.visibility, color: Colors.blue),
                                    onPressed: () => _showReviewDoctorDialog(context, doctor),
                                    tooltip: 'Review Doctor',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () =>
                                        _showDeleteConfirmation(context, doctor.id, doctor.fullName),
                                    tooltip: 'Delete Doctor',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Pagination Footer
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                totalItems > 0
                    ? 'Showing ${startIndex + 1} to $endIndex of $totalItems'
                    : 'Showing 0 to 0 of 0',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _currentPage > 1
                        ? () {
                            setState(() {
                              _currentPage--;
                            });
                          }
                        : null,
                  ),
                  ...List.generate(totalPages, (index) {
                    final page = index + 1;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _currentPage == page ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: _currentPage == page ? AppColors.primary : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          '$page',
                          style: TextStyle(
                            color: _currentPage == page ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _currentPage < totalPages
                        ? () {
                            setState(() {
                              _currentPage++;
                            });
                          }
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddDoctorDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String fullName = '';
    String email = '';
    String password = '';
    String specialization = 'Neurology';
    int experienceYears = 5;
    String clinicAddress = '';

    showDialog(
      context: context,
      builder: (dlgContext) {
        return AlertDialog(
          title: Text(context.translate('registerNewDoctor')),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    onSaved: (v) => fullName = v!,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email Address'),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    onSaved: (v) => email = v!,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    onSaved: (v) => password = v!,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: specialization,
                    decoration: const InputDecoration(labelText: 'Specialization'),
                    items: ['Neurology', 'Pulmonology', 'Orthopedics', 'Cardiology']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) => specialization = v!,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Experience Years'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    onSaved: (v) => experienceYears = int.parse(v!),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Clinic Address'),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    onSaved: (v) => clinicAddress = v!,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dlgContext),
              child: Text(context.translate('cancel')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  Navigator.pop(dlgContext);
                  final success = await context.read<AdminCubit>().registerDoctor({
                    'FullName': fullName,
                    'Email': email,
                    'Password': password,
                    'Specialization': specialization,
                    'ExperienceYears': experienceYears,
                    'ClinicAddress': clinicAddress,
                    'Role': 'doctor',
                    'Phone': '1234567890',
                  });
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Doctor registered successfully')),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showReviewDoctorDialog(BuildContext context, AdminDoctorModel doctor) {
    showDialog(
      context: context,
      builder: (dlgContext) {
        return AlertDialog(
          title: const Text('Review Doctor'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Doctor Name: ${doctor.fullName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Email: ${doctor.email}'),
                const SizedBox(height: 8),
                Text('Specialty: ${doctor.specialty}'),
                const SizedBox(height: 8),
                Text('Clinic Address: ${doctor.clinicAddress}'),
                const SizedBox(height: 8),
                Text('Experience: ${doctor.experienceYears} Years'),
                const SizedBox(height: 16),
                Text(
                  context.translate('idCard'),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 180,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: doctor.idCardPath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            doctor.idCardPath!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Center(
                              child: Icon(Icons.card_membership, size: 64, color: Colors.grey),
                            ),
                          ),
                        )
                      : const Center(
                          child: Text('No ID Card Uploaded'),
                        ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dlgContext),
              child: Text(context.translate('cancel')),
            ),
            if (!doctor.isApproved) ...[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                onPressed: () => _showRejectionReasonDialog(context, doctor.id),
                child: Text(context.translate('reject')),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                onPressed: () {
                  Navigator.pop(dlgContext);
                  context.read<AdminCubit>().approveDoctor(doctor.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Doctor ${doctor.fullName} approved successfully')),
                  );
                },
                child: Text(context.translate('approve')),
              ),
            ],
          ],
        );
      },
    );
  }

  void _showRejectionReasonDialog(BuildContext context, String doctorId) {
    final formKey = GlobalKey<FormState>();
    String reason = '';

    showDialog(
      context: context,
      builder: (dlgContext) {
        return AlertDialog(
          title: Text(context.translate('rejectionReason')),
          content: Form(
            key: formKey,
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'Reason for rejection'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              onSaved: (v) => reason = v!,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dlgContext),
              child: Text(context.translate('cancel')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  Navigator.pop(dlgContext);
                  // Dismiss first review dialog too
                  Navigator.pop(context);
                  context.read<AdminCubit>().rejectDoctor(doctorId, reason);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Doctor rejected successfully')),
                  );
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, String id, String name) {
    showDialog(
      context: context,
      builder: (dlgContext) {
        return AlertDialog(
          title: Text(context.translate('confirmDeletion')),
          content: Text('${context.translate('confirmDeletionMsg')}\n$name'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dlgContext),
              child: Text(context.translate('cancel')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
              onPressed: () {
                Navigator.pop(dlgContext);
                context.read<AdminCubit>().deleteDoctor(id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Doctor $name removed successfully')),
                );
              },
              child: Text(context.translate('delete')),
            ),
          ],
        );
      },
    );
  }
}
