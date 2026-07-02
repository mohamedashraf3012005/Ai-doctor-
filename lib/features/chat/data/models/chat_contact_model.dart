import '../../domain/entities/chat_contact_entity.dart';

/// Contact model serialization.
class ChatContactModel {
  final String id;
  final String name;
  final String type;
  final bool online;
  final String? specialization;

  const ChatContactModel({
    required this.id,
    required this.name,
    required this.type,
    required this.online,
    this.specialization,
  });

  factory ChatContactModel.fromJson(Map<String, dynamic> json) {
    final isDoc = (json['role'] ?? '').toString().toLowerCase() == 'doctor';
    return ChatContactModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: json['fullName'] ?? json['name'] ?? '',
      type: isDoc ? 'doctor' : 'patient',
      online: json['online'] ?? false,
      specialization: json['specialization'] ?? json['specialty'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': name,
        'role': type,
        'online': online,
        'specialization': specialization,
      };

  ChatContactEntity toEntity() => ChatContactEntity(
        id: id,
        name: name,
        type: type,
        online: online,
        specialization: specialization,
      );
}
