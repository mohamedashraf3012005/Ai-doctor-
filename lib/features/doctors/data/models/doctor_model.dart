import '../../domain/entities/doctor_entity.dart';

/// Doctor representation with serialization/deserialization.
class DoctorModel {
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

  const DoctorModel({
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

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: (json['id'] ?? json['_id'] ?? json['doctorId'] ?? '').toString(),
      fullName: json['fullName'] ?? json['name'] ?? json['doctorName'] ?? '',
      email: json['email'] ?? json['emailAddress'] ?? '',
      phone: json['phone'] ?? json['phoneNumber'] ?? json['mobile'] ?? '',
      gender: json['gender'] ?? 'Male',
      specialization:
          json['specialization'] ??
          json['specialty'] ??
          json['department'] ??
          '',
      experienceYears: json['experienceYears'] is int
          ? json['experienceYears']
          : int.tryParse(
                  '${json['experienceYears'] ?? json['yearsOfExperience'] ?? ''}',
                ) ??
                0,
      clinicAddress:
          json['clinicAddress'] ?? json['address'] ?? json['clinic'] ?? '',
      profileImageUrl:
          json['profileImageUrl'] ?? json['imageUrl'] ?? json['avatarUrl'],
      isApproved:
          json['isApproved'] ?? json['approved'] ?? json['isVerified'] ?? true,
      rating: (json['rating'] ?? json['averageRating'] ?? 4.8) is int
          ? (json['rating'] ?? json['averageRating'] as int).toDouble()
          : ((json['rating'] ?? json['averageRating']) as num?)?.toDouble() ??
                4.8,
      reviewsCount:
          json['reviewsCount'] ??
          json['reviewCount'] ??
          json['totalReviews'] ??
          12,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'gender': gender,
    'specialization': specialization,
    'experienceYears': experienceYears,
    'clinicAddress': clinicAddress,
    'profileImageUrl': profileImageUrl,
    'isApproved': isApproved,
    'rating': rating,
    'reviewsCount': reviewsCount,
  };

  DoctorEntity toEntity() => DoctorEntity(
    id: id,
    fullName: fullName,
    email: email,
    phone: phone,
    gender: gender,
    specialization: specialization,
    experienceYears: experienceYears,
    clinicAddress: clinicAddress,
    profileImageUrl: profileImageUrl,
    isApproved: isApproved,
    rating: rating,
    reviewsCount: reviewsCount,
  );
}
