import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../data/models/admin_models.dart';
import '../cubit/admin_cubit.dart';

class AdminAppointmentsTab extends StatefulWidget {
  final List<AdminAppointmentModel> appointments;

  const AdminAppointmentsTab({super.key, required this.appointments});

  @override
  State<AdminAppointmentsTab> createState() => _AdminAppointmentsTabState();
}

class _AdminAppointmentsTabState extends State<AdminAppointmentsTab> {
  String _statusFilter = '';
  String _doctorFilter = '';
  int _currentPage = 1;
  static const int _pageSize = 10;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    // Get unique doctor names for dropdown
    final doctors = widget.appointments
        .map((a) => a.doctorName)
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();

    // Filter appointments
    final filteredAppointments = widget.appointments.where((a) {
      final matchesStatus = _statusFilter.isEmpty || a.status.toLowerCase() == _statusFilter.toLowerCase();
      final matchesDoctor = _doctorFilter.isEmpty || a.doctorName == _doctorFilter;
      return matchesStatus && matchesDoctor;
    }).toList();

    // Pagination
    final totalItems = filteredAppointments.length;
    final totalPages = (totalItems / _pageSize).ceil();
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = (startIndex + _pageSize < totalItems) ? startIndex + _pageSize : totalItems;
    final paginatedAppointments =
        totalItems > 0 ? filteredAppointments.sublist(startIndex, endIndex) : <AdminAppointmentModel>[];

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: All Appointments + Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.translate('allAppointments'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$totalItems Appointments Found',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
              Row(
                children: [
                  // Status Dropdown
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
                        value: _statusFilter.isEmpty ? null : _statusFilter,
                        hint: Text(context.translate('allStatus')),
                        items: [
                          DropdownMenuItem<String>(
                            value: null,
                            child: Text(context.translate('allStatus')),
                          ),
                          DropdownMenuItem(value: 'pending', child: Text(context.translate('pendingApproval'))),
                          DropdownMenuItem(value: 'confirmed', child: Text(context.translate('verified'))),
                          DropdownMenuItem(value: 'completed', child: Text(context.translate('tblStatus'))),
                          DropdownMenuItem(value: 'cancelled', child: Text(context.translate('cancel'))),
                        ],
                        onChanged: (v) {
                          setState(() {
                            _statusFilter = v ?? '';
                            _currentPage = 1;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Doctor Dropdown
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
                        value: _doctorFilter.isEmpty ? null : _doctorFilter,
                        hint: Text(context.translate('allDoctors')),
                        items: [
                          DropdownMenuItem<String>(
                            value: null,
                            child: Text(context.translate('allDoctors')),
                          ),
                          ...doctors.map(
                            (d) => DropdownMenuItem(value: d, child: Text(d)),
                          ),
                        ],
                        onChanged: (v) {
                          setState(() {
                            _doctorFilter = v ?? '';
                            _currentPage = 1;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Refresh button
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    color: AppColors.primary,
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                    onPressed: () {
                      context.read<AdminCubit>().fetchDashboardData();
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Appointments Table
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
                        DataColumn(label: Text(context.translate('thPatient'))),
                        DataColumn(label: Text(context.translate('thDoctor'))),
                        DataColumn(label: Text(context.translate('thSpecialty'))),
                        DataColumn(label: Text(context.translate('thDate'))),
                        DataColumn(label: Text(context.translate('thTime'))),
                        DataColumn(label: Text(context.translate('thStatus'))),
                        DataColumn(label: Text(context.translate('thActions'))),
                      ],
                      rows: paginatedAppointments.map((appt) {
                        final statusColor = appt.status.toLowerCase() == 'confirmed'
                            ? Colors.green
                            : (appt.status.toLowerCase() == 'cancelled'
                                ? Colors.red
                                : (appt.status.toLowerCase() == 'completed'
                                    ? Colors.teal
                                    : Colors.orange));

                        final showActions = appt.status.toLowerCase() == 'pending' ||
                            appt.status.toLowerCase() == 'confirmed' ||
                            appt.status.toLowerCase() == 'scheduled';

                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                appt.patientName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataCell(Text(appt.doctorName)),
                            DataCell(Text(appt.specialty)),
                            DataCell(Text(appt.appointmentDate)),
                            DataCell(Text(appt.timeSlot)),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  appt.status,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              showActions
                                  ? Row(
                                      children: [
                                        if (appt.status.toLowerCase() == 'pending' ||
                                            appt.status.toLowerCase() == 'scheduled')
                                          TextButton(
                                            onPressed: () {
                                              context
                                                  .read<AdminCubit>()
                                                  .updateAppointmentStatus(appt.id, 'Confirmed');
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Appointment confirmed')),
                                              );
                                            },
                                            child: const Text('Confirm', style: TextStyle(color: Colors.green)),
                                          ),
                                        if (appt.status.toLowerCase() == 'confirmed')
                                          TextButton(
                                            onPressed: () {
                                              context
                                                  .read<AdminCubit>()
                                                  .updateAppointmentStatus(appt.id, 'Completed');
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Appointment completed')),
                                              );
                                            },
                                            child: const Text('Complete', style: TextStyle(color: Colors.teal)),
                                          ),
                                        TextButton(
                                          onPressed: () {
                                            context
                                                .read<AdminCubit>()
                                                .updateAppointmentStatus(appt.id, 'Cancelled');
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Appointment cancelled')),
                                            );
                                          },
                                          child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    )
                                  : const Text('—'),
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
}
