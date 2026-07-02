import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_contact_entity.dart';
import '../../domain/entities/chat_message_entity.dart';

/// States for Chat interface.
abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ContactsLoaded extends ChatState {
  final List<ChatContactEntity> contacts;

  const ContactsLoaded(this.contacts);

  @override
  List<Object?> get props => [contacts];
}

class ChatHistoryLoaded extends ChatState {
  final List<ChatMessageEntity> messages;

  const ChatHistoryLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}

/// AI Bot specific chat states.
class AiMessageStreaming extends ChatState {
  final String partialReply;

  const AiMessageStreaming(this.partialReply);

  @override
  List<Object?> get props => [partialReply];
}

class ChatSummarySuccess extends ChatState {
  final String summary;

  const ChatSummarySuccess(this.summary);

  @override
  List<Object?> get props => [summary];
}
