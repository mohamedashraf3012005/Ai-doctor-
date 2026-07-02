import 'package:equatable/equatable.dart';

/// Represents a message exchange records.
class ChatMessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final bool isSentByMe;

  const ChatMessageEntity({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.isSentByMe,
  });

  @override
  List<Object?> get props => [id, senderId, content, timestamp, isSentByMe];
}
