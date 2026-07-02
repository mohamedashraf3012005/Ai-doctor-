import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat_contact_entity.dart';
import '../repositories/chat_repository.dart';

class GetContactsUseCase {
  final ChatRepository _repository;

  GetContactsUseCase(this._repository);

  Future<Either<Failure, List<ChatContactEntity>>> call() {
    return _repository.getContacts();
  }
}
