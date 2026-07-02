import '../../domain/entities/chat_message_entity.dart';

/// Message model serialization.
class ChatMessageModel {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;

  const ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      senderId: (json['senderId'] ?? json['fromUserId'] ?? '').toString(),
      content: json['content'] ?? json['message'] ?? json['text'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
      };

  ChatMessageEntity toEntity(String currentUserId) {
    return ChatMessageEntity(
      id: id,
      senderId: senderId,
      content: content,
      timestamp: timestamp,
      isSentByMe: senderId.toLowerCase() == currentUserId.toLowerCase(),
    );
  }
}
