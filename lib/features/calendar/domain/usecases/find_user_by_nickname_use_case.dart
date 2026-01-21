import 'package:dutytable/features/calendar/domain/entities/user_entity.dart';
import 'package:dutytable/features/calendar/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FindUserByNicknameUseCase {
  final UserRepository _repository;

  FindUserByNicknameUseCase(this._repository);

  Future<UserEntity?> call(String nickname) {
    return _repository.findUserByNickname(nickname);
  }
}
