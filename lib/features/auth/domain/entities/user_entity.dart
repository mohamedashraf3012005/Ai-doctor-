/// User entity for domain layer.
class UserEntity {
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

  const UserEntity({
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
}
