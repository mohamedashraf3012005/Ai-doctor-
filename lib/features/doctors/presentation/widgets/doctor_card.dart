import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/doctor_entity.dart';

/// Doctor representation card matching the website's doctor-card template.
class DoctorCard extends StatelessWidget {
  final DoctorEntity doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF05281D) : AppColors.surfaceAlt,
        borderRadius: AppRadius.card,
        border: Border.all(
          color: isDark ? const Color(0xFF093D2C) : AppColors.border,
        ),
        boxShadow: const [AppShadows.soft],
      ),
      child: ClipRRect(
        borderRadius: AppRadius.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar area with rating badge overlay
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.3,
                  child: doctor.profileImageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: doctor.profileImageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => _buildAvatarPlaceholder(isDark),
                        )
                      : _buildAvatarPlaceholder(isDark),
                ),
                // Specialty Badge overlay
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppRadius.pill,
                    ),
                    child: Text(
                      doctor.specialization,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Rating overlay
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: AppRadius.pill,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          doctor.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Info content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (context.isArabic ? 'د. ' : 'Dr. ') + doctor.fullName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.isArabic
                        ? 'خبرة ${doctor.experienceYears} سنة'
                        : '${doctor.experienceYears} Years Experience',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Clinic location
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          doctor.clinicAddress,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // CTA button
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      color: AppColors.primary,
                      borderRadius: AppRadius.button,
                      child: InkWell(
                        onTap: () {
                          // Navigate to booking wizard page
                          context.push('/booking', extra: doctor);
                        },
                        borderRadius: AppRadius.button,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            context.translate('bookNow'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(bool isDark) {
    return Container(
      color: isDark ? const Color(0xFF093D2C) : const Color(0xFFEBFDF5),
      child: const Center(
        child: Icon(
          Icons.person_pin,
          size: 64,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
