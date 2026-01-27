import 'package:injectable/injectable.dart';

import '../repositories/chat_repository.dart';

@injectable
class FetchUserInfoUseCase {
  final ChatRepository repository;

  FetchUserInfoUseCase(this.repository);

  Future<Map<String, dynamic>> call(String senderId) {
    return repository.fetchUserInfo(senderId);
  }
}
