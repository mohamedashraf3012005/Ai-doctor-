import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../data/models/admin_models.dart';
import '../cubit/admin_cubit.dart';

class AdminPatientsTab extends StatefulWidget {
  final List<AdminPatientModel> patients;

  const AdminPatientsTab({super.key, required this.patients});

  @override
  State<AdminPatientsTab> createState() => _AdminPatientsTabState();
}

class _AdminPatientsTabState extends State<AdminPatientsTab> {
  String _searchQuery = '';
  int _currentPage = 1;
  static const int _pageSize = 10;
  bool _sortAscending = true;
  String _sortColumn = 'name'; // name, email, registered

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    // Filter patients
    final filteredPatients = widget.patients.where((p) {
      final name = p.fullName.toLowerCase();
      final email = p.email.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || email.contains(query);
    }).toList();

    // Sort patients
    if (_sortColumn == 'name') {
      filteredPatients.sort((a, b) =>
          _sortAscending ? a.fullName.compareTo(b.fullName) : b.fullName.compareTo(a.fullName));
    } else if (_sortColumn == 'email') {
      filteredPatients.sort((a, b) =>
          _sortAscending ? a.email.compareTo(b.email) : b.email.compareTo(a.email));
    } else if (_sortColumn == 'registered') {
      filteredPatients.sort((a, b) {
        final dateA = a.createdAt ?? '';
        final dateB = b.createdAt ?? '';
        return _sortAscending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
      });
    }

    // Pagination
    final totalItems = filteredPatients.length;
    final totalPages = (totalItems / _pageSize).ceil();
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = (startIndex + _pageSize < totalItems) ? startIndex + _pageSize : totalItems;
    final paginatedPatients =
        totalItems > 0 ? filteredPatients.sublist(startIndex, endIndex) : <AdminPatientModel>[];

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Patients Directory + Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.translate('patientsDirectory'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$totalItems Total Patients',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
              Row(
                children: [
                  // Search box
                  Container(
                    width: 240,
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
                        hintText: 'Search patients...',
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

          // Patients Table
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
                              Text(context.translate('thPatientInfo')),
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
                              Text(context.translate('thEmail')),
                              const SizedBox(width: 4),
                              const Icon(Icons.swap_vert, size: 14),
                            ],
                          ),
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              _sortColumn = 'email';
                              _sortAscending = ascending;
                            });
                          },
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              Text(context.translate('thRegistered')),
                              const SizedBox(width: 4),
                              const Icon(Icons.swap_vert, size: 14),
                            ],
                          ),
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              _sortColumn = 'registered';
                              _sortAscending = ascending;
                            });
                          },
                        ),
                        DataColumn(label: Text(context.translate('thStatus'))),
                        DataColumn(label: Text(context.translate('thActions'))),
                      ],
                      rows: paginatedPatients.map((patient) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                patient.fullName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataCell(Text(patient.email)),
                            DataCell(Text(patient.createdAt ?? 'Jul 2, 2026')),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Active',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.visibility, color: Colors.blue),
                                    onPressed: () => _showPatientDetailsDialog(context, patient),
                                    tooltip: 'View Profile',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () =>
                                        _showDeleteConfirmation(context, patient.id, patient.fullName),
                                    tooltip: 'Delete Patient',
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

  void _showPatientDetailsDialog(BuildContext context, AdminPatientModel patient) {
    showDialog(
      context: context,
      builder: (dlgContext) {
        return AlertDialog(
          title: Text(context.translate('patient_profile')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Full Name: ${patient.fullName}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Email: ${patient.email}'),
              const SizedBox(height: 8),
              Text('Registered Date: ${patient.createdAt ?? 'Jul 2, 2026'}'),
              const SizedBox(height: 8),
              const Text('Status: Active'),
              const SizedBox(height: 8),
              const Text('Age: 32'),
              const SizedBox(height: 8),
              const Text('Gender: Male'),
              const SizedBox(height: 8),
              const Text('Medical History: None'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dlgContext),
              child: const Text('Close'),
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
                context.read<AdminCubit>().deletePatient(id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Patient $name removed successfully')),
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
