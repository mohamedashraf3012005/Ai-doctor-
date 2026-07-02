import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat_contact_entity.dart';
import '../entities/chat_message_entity.dart';

/// Repository interface managing messaging operations.
abstract class ChatRepository {
  /// Fetches chat contacts list.
  Future<Either<Failure, List<ChatContactEntity>>> getContacts();

  /// Fetches history exchanges with a specific contact.
  Future<Either<Failure, List<ChatMessageEntity>>> getChatHistory(String contactId);

  /// Sends a peer-to-peer message to a doctor/patient.
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String receiverId,
    required String content,
  });

  /// Sends an query to the AI assistant server.
  Future<Either<Failure, String>> sendAiMessage({
    required String message,
    required List<Map<String, String>> history,
    required String userRole,
    required String lang,
  });

  /// Generates a summary for doctor-patient consultations.
  Future<Either<Failure, String>> summarizeChat(String conversation);
}
