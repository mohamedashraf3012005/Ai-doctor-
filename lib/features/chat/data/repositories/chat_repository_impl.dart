import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/chat_contact_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../data_sources/chat_remote_data_source.dart';

/// Implementation of [ChatRepository].
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;
  final SecureStorageService _storage;

  ChatRepositoryImpl(this._remoteDataSource, this._storage);

  @override
  Future<Either<Failure, List<ChatContactEntity>>> getContacts() async {
    try {
      final models = await _remoteDataSource.getContacts();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> getChatHistory(String contactId) async {
    try {
      final myId = await _storage.getUserId() ?? '';
      final models = await _remoteDataSource.getChatHistory(contactId);
      final entities = models.map((model) => model.toEntity(myId)).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String receiverId,
    required String content,
  }) async {
    try {
      final myId = await _storage.getUserId() ?? '';
      final model = await _remoteDataSource.sendMessage(
        receiverId: receiverId,
        content: content,
      );
      return Right(model.toEntity(myId));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> sendAiMessage({
    required String message,
    required List<Map<String, String>> history,
    required String userRole,
    required String lang,
  }) async {
    try {
      final reply = await _remoteDataSource.sendAiMessage(
        message: message,
        history: history,
        userRole: userRole,
        lang: lang,
      );
      return Right(reply);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> summarizeChat(String conversation) async {
    try {
      final summary = await _remoteDataSource.summarizeChat(conversation);
      return Right(summary);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
