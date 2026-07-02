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
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      fullName: json['fullName'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? json['phoneNumber'] ?? '',
      gender: json['gender'] ?? 'Male',
      specialization: json['specialization'] ?? json['specialty'] ?? '',
      experienceYears: json['experienceYears'] is int
          ? json['experienceYears']
          : int.tryParse('${json['experienceYears'] ?? ''}') ?? 0,
      clinicAddress: json['clinicAddress'] ?? json['address'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? json['imageUrl'],
      isApproved: json['isApproved'] ?? json['approved'] ?? true,
      rating: (json['rating'] ?? 4.8) is int
          ? (json['rating'] as int).toDouble()
          : (json['rating'] as double? ?? 4.8),
      reviewsCount: json['reviewsCount'] ?? json['reviewCount'] ?? 12,
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
