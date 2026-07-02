import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/shared/widgets/empty_state_widget.dart';
import '../../../../core/shared/widgets/error_widget.dart';
import '../../../../core/shared/widgets/loading_widget.dart';
import '../../../../core/shared/widgets/page_header.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../cubit/doctors_cubit.dart';
import '../cubit/doctors_state.dart';
import '../widgets/doctor_card.dart';
import '../widgets/doctor_search_bar.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  final _searchController = TextEditingController();
  String _selectedSpecialty = 'all';

  @override
  void initState() {
    super.initState();
    // Fetch initial doctors list
    context.read<DoctorsCubit>().fetchDoctors();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _triggerSearch() {
    context.read<DoctorsCubit>().fetchDoctors(
          searchQuery: _searchController.text.trim(),
          specialty: _selectedSpecialty,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.screenWidth > 900;
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF02140F) : AppColors.surface,
      body: Column(
        children: [
          PageHeader(
            badge: context.translate('doctors'),
            title: context.translate('findYourDoctor'),
            subtitle: context.translate('doctorsSubtitle'),
          ),
          // Search/Filter Bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding,
              vertical: 16,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppDimensions.maxWidth),
                child: DoctorSearchBar(
                  controller: _searchController,
                  selectedSpecialty: _selectedSpecialty,
                  onSpecialtyChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedSpecialty = val;
                      });
                      _triggerSearch();
                    }
                  },
                  onSearchPressed: _triggerSearch,
                ),
              ),
            ),
          ),
          // Doctor List Grid
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.horizontalPadding,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: AppDimensions.maxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<DoctorsCubit, DoctorsState>(
                        builder: (context, state) {
                          if (state is DoctorsLoaded) {
                            final text = context.isArabic
                                ? 'تم العثور على ${state.doctors.length} طبيب'
                                : '${state.doctors.length} specialists found';
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Text(
                                text,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      BlocBuilder<DoctorsCubit, DoctorsState>(
                        builder: (context, state) {
                          if (state is DoctorsLoading) {
                            return const AppLoadingWidget(itemCount: 4);
                          } else if (state is DoctorsError) {
                            return AppErrorWidget(
                              message: state.message,
                              onRetry: _triggerSearch,
                            );
                          } else if (state is DoctorsLoaded) {
                            if (state.doctors.isEmpty) {
                              return EmptyStateWidget(
                                icon: Icons.person_search_outlined,
                                title: context.isArabic ? 'لم يتم العثور على أطباء' : 'No Doctors Found',
                                subtitle: context.isArabic
                                    ? 'حاول تعديل معايير البحث أو مرشح التخصص.'
                                    : 'Try adjusting your search criteria or specialty filters.',
                              );
                            }
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.doctors.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isDesktop ? 3 : (context.screenWidth > 600 ? 2 : 1),
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 20,
                                childAspectRatio: 0.78,
                              ),
                              itemBuilder: (context, index) {
                                final doc = state.doctors[index];
                                return DoctorCard(doctor: doc);
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      const SizedBox(height: 32),
                    ],
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
