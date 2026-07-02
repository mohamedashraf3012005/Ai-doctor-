import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/chat_contact_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/use_cases/get_chat_history_use_case.dart';
import '../../domain/use_cases/get_contacts_use_case.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetContactsUseCase _getContactsUseCase;
  final GetChatHistoryUseCase _getChatHistoryUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final SendAiMessageUseCase _sendAiMessageUseCase;
  final SummarizeChatUseCase _summarizeChatUseCase;
  final SecureStorageService _storage;

  List<ChatContactEntity> _cachedContacts = [];
  List<ChatMessageEntity> _cachedMessages = [];
  List<Map<String, String>> _aiHistory = [];

  ChatCubit({
    required GetContactsUseCase getContactsUseCase,
    required GetChatHistoryUseCase getChatHistoryUseCase,
    required SendMessageUseCase sendMessageUseCase,
    required SendAiMessageUseCase sendAiMessageUseCase,
    required SummarizeChatUseCase summarizeChatUseCase,
    required SecureStorageService storage,
  })  : _getContactsUseCase = getContactsUseCase,
        _getChatHistoryUseCase = getChatHistoryUseCase,
        _sendMessageUseCase = sendMessageUseCase,
        _sendAiMessageUseCase = sendAiMessageUseCase,
        _summarizeChatUseCase = summarizeChatUseCase,
        _storage = storage,
        super(const ChatInitial());

  List<ChatContactEntity> get contacts => _cachedContacts;
  List<ChatMessageEntity> get messages => _cachedMessages;

  /// Loads chat contacts list. Prepends the AI assistant for patients.
  Future<void> fetchContacts() async {
    emit(const ChatLoading());
    final role = await _storage.getRole() ?? 'patient';
    final result = await _getContactsUseCase();

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (list) {
        if (role.toLowerCase() == 'doctor') {
          // Doctors only see patient contacts, no AI bot
          _cachedContacts = list;
        } else {
          // Patients see AI bot + doctor contacts
          final bot = const ChatContactEntity(
            id: 'bot',
            name: 'Smart Care 360 Assistant',
            type: 'bot',
            online: true,
          );
          _cachedContacts = [bot, ...list];
        }
        emit(ContactsLoaded(_cachedContacts));
      },
    );
  }

  /// Loads chat logs with a contact.
  Future<void> fetchChatHistory(String contactId) async {
    if (contactId == 'bot') {
      _cachedMessages = [
        ChatMessageEntity(
          id: 'welcome',
          senderId: 'bot',
          content: 'Hello! I am your Smart Care 360 Assistant. How can I help you today?',
          timestamp: DateTime.now(),
          isSentByMe: false,
        ),
      ];
      emit(ChatHistoryLoaded(_cachedMessages));
      return;
    }

    emit(const ChatLoading());
    final result = await _getChatHistoryUseCase(contactId);
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (list) {
        _cachedMessages = list;
        emit(ChatHistoryLoaded(_cachedMessages));
      },
    );
  }

  /// Sends a message (peer or AI bot).
  Future<void> sendMessage({required String receiverId, required String content}) async {
    final myId = await _storage.getUserId() ?? 'user';
    final userMsg = ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: myId,
      content: content,
      timestamp: DateTime.now(),
      isSentByMe: true,
    );

    // Optimistically update message log in UI
    _cachedMessages = [..._cachedMessages, userMsg];
    emit(ChatHistoryLoaded(_cachedMessages));

    if (receiverId == 'bot') {
      _aiHistory.add({'role': 'user', 'text': content});
      if (_aiHistory.length > 8) _aiHistory = _aiHistory.sublist(_aiHistory.length - 8);

      emit(const AiMessageStreaming('')); // trigger bot thinking state

      final role = await _storage.getRole() ?? 'guest';
      final result = await _sendAiMessageUseCase(
        message: content,
        history: _aiHistory,
        userRole: role,
        lang: 'en',
      );

      result.fold(
        (failure) {
          final errBotMsg = ChatMessageEntity(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            senderId: 'bot',
            content: 'Failed to connect to AI server: ${failure.message}',
            timestamp: DateTime.now(),
            isSentByMe: false,
          );
          _cachedMessages = [..._cachedMessages, errBotMsg];
          emit(ChatHistoryLoaded(_cachedMessages));
        },
        (reply) async {
          _aiHistory.add({'role': 'model', 'text': reply});
          if (_aiHistory.length > 8) _aiHistory = _aiHistory.sublist(_aiHistory.length - 8);

          // Typing stream simulation
          String currentText = '';
          final words = reply.split(' ');
          for (final word in words) {
            await Future.delayed(const Duration(milliseconds: 60));
            currentText += (currentText.isEmpty ? '' : ' ') + word;
            emit(AiMessageStreaming(currentText));
          }

          // Complete streaming state
          final botMsg = ChatMessageEntity(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            senderId: 'bot',
            content: reply,
            timestamp: DateTime.now(),
            isSentByMe: false,
          );
          _cachedMessages = [..._cachedMessages, botMsg];
          emit(ChatHistoryLoaded(_cachedMessages));
        },
      );
    } else {
      // Peer to peer message
      final result = await _sendMessageUseCase(
        receiverId: receiverId,
        content: content,
      );
      result.fold(
        (failure) {
          emit(ChatError('Failed to send: ${failure.message}'));
        },
        (msg) {
          // Replace optimistic message if needed or keep it
        },
      );
    }
  }

  /// Summarize conversation log.
  Future<void> summarizeChat(String contactId) async {
    final conversationStr = _cachedMessages
        .map((m) => '${m.isSentByMe ? 'Patient' : 'Doctor'}: ${m.content}')
        .join('\n');

    emit(const ChatLoading());
    final result = await _summarizeChatUseCase(conversationStr);
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (summary) => emit(ChatSummarySuccess(summary)),
    );
  }
}
