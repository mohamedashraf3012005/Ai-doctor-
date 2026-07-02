import 'package:equatable/equatable.dart';

/// Represents a chat participant (AI assistant, Doctor, or Patient).
class ChatContactEntity extends Equatable {
  final String id;
  final String name;
  final String type; // 'bot', 'doctor', 'patient'
  final bool online;
  final String? specialization;

  const ChatContactEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.online,
    this.specialization,
  });

  @override
  List<Object?> get props => [id, name, type, online, specialization];
}
