import 'package:equatable/equatable.dart';

/// Doctor details for listing and booking screens.
class DoctorEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String gender;
  final String specialization;
  final int experienceYears;
  final String clinicAddress;
  final String? profileImageUrl;
  final bool isApproved;
  final double rating;
  final int reviewsCount;

  const DoctorEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.specialization,
    required this.experienceYears,
    required this.clinicAddress,
    this.profileImageUrl,
    required this.isApproved,
    this.rating = 4.8,
    this.reviewsCount = 12,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phone,
        gender,
        specialization,
        experienceYears,
        clinicAddress,
        profileImageUrl,
        isApproved,
        rating,
        reviewsCount,
      ];
}
