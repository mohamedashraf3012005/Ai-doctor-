import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class GetChatHistoryUseCase {
  final ChatRepository _repository;

  GetChatHistoryUseCase(this._repository);

  Future<Either<Failure, List<ChatMessageEntity>>> call(String contactId) {
    return _repository.getChatHistory(contactId);
  }
}

class SendMessageUseCase {
  final ChatRepository _repository;

  SendMessageUseCase(this._repository);

  Future<Either<Failure, ChatMessageEntity>> call({
    required String receiverId,
    required String content,
  }) {
    return _repository.sendMessage(
      receiverId: receiverId,
      content: content,
    );
  }
}

class SendAiMessageUseCase {
  final ChatRepository _repository;

  SendAiMessageUseCase(this._repository);

  Future<Either<Failure, String>> call({
    required String message,
    required List<Map<String, String>> history,
    required String userRole,
    required String lang,
  }) {
    return _repository.sendAiMessage(
      message: message,
      history: history,
      userRole: userRole,
      lang: lang,
    );
  }
}

class SummarizeChatUseCase {
  final ChatRepository _repository;

  SummarizeChatUseCase(this._repository);

  Future<Either<Failure, String>> call(String conversation) {
    return _repository.summarizeChat(conversation);
  }
}
