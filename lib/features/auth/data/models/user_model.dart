import '../../domain/entities/user_entity.dart';

/// User model for serialization/deserialization.
class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final int? age;
  final String? gender;
  final String? specialization;
  final int? experienceYears;
  final String? clinicAddress;
  final String? profileImageUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.age,
    this.gender,
    this.specialization,
    this.experienceYears,
    this.clinicAddress,
    this.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? json['userId'] ?? json['_id'] ?? '').toString(),
      name: json['fullName'] ?? json['name'] ?? json['userName'] ?? '',
      email: json['email'] ?? '',
      role: (json['role'] ?? 'patient').toString().toLowerCase(),
      phone: json['phone'] ?? json['phoneNumber'],
      age: json['age'] is int ? json['age'] : int.tryParse('${json['age'] ?? ''}'),
      gender: json['gender'],
      specialization: json['specialization'] ?? json['specialty'],
      experienceYears: json['experienceYears'] is int
          ? json['experienceYears']
          : int.tryParse('${json['experienceYears'] ?? ''}'),
      clinicAddress: json['clinicAddress'] ?? json['address'],
      profileImageUrl: json['profileImageUrl'] ?? json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': name,
        'email': email,
        'role': role,
        'phone': phone,
        'age': age,
        'gender': gender,
        'specialization': specialization,
        'experienceYears': experienceYears,
        'clinicAddress': clinicAddress,
        'profileImageUrl': profileImageUrl,
      };

  UserEntity toEntity() => UserEntity(
        id: id,
        name: name,
        email: email,
        role: role,
        phone: phone,
        age: age,
        gender: gender,
        specialization: specialization,
        experienceYears: experienceYears,
        clinicAddress: clinicAddress,
        profileImageUrl: profileImageUrl,
      );
}
