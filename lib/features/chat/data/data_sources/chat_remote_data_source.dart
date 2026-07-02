import 'package:dio/dio.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/chat_contact_model.dart';
import '../models/chat_message_model.dart';

/// Remote data source for peer messaging and AI assistant chats.
class ChatRemoteDataSource {
  final Dio _dio;

  ChatRemoteDataSource(this._dio);

  /// Fetch list of contacts from C# backend.
  Future<List<ChatContactModel>> getContacts() async {
    try {
      final response = await _dio.get(ApiEndpoints.chatContacts);
      final List<dynamic> list = response.data;
      return list.map((item) => ChatContactModel.fromJson(item)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Fetch chat history with a user.
  Future<List<ChatMessageModel>> getChatHistory(String contactId) async {
    try {
      final response = await _dio.get(ApiEndpoints.chatHistory(contactId));
      final List<dynamic> list = response.data;
      return list.map((item) => ChatMessageModel.fromJson(item)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Sends a message.
  Future<ChatMessageModel> sendMessage({
    required String receiverId,
    required String content,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.chatSend,
        data: {
          'receiverId': receiverId,
          'content': content,
        },
      );
      return ChatMessageModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Calls the AI assistant server.
  Future<String> sendAiMessage({
    required String message,
    required List<Map<String, String>> history,
    required String userRole,
    required String lang,
  }) async {
    try {
      final tempDio = Dio();
      final response = await tempDio.post(
        '${AppConfig.aiBaseUrl}/chat',
        data: {
          'message': message,
          'user_role': userRole,
          'history': history,
          'platform_data': '',
          'lang': lang,
        },
      );

      final data = response.data;
      if (data['success'] == true) {
        return data['reply']?.toString() ?? '';
      }
      return data['reply']?.toString() ?? 'Sorry, an error occurred.';
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Calls the AI assistant server for conversation summaries.
  Future<String> summarizeChat(String conversation) async {
    try {
      final tempDio = Dio();
      final response = await tempDio.post(
        '${AppConfig.aiBaseUrl}/summarize',
        data: {'conversation': conversation},
      );
      return response.data['reply']?.toString() ?? 'Failed to generate summary.';
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ServerException _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    String message = 'Chat operation failed';

    if (e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        message = data['message'] ?? data['title'] ?? message;
      } else if (data is String && data.isNotEmpty) {
        message = data;
      }
    }

    return ServerException(message, statusCode: statusCode);
  }
}
