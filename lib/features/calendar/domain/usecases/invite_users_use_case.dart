import 'package:dutytable/features/calendar/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class InviteUsersUseCase {
  final UserRepository _repository;

  InviteUsersUseCase(this._repository);

  Future<void> call(int calendarId, List<String> invitedUserIds) {
    return _repository.inviteUsers(calendarId, invitedUserIds);
  }
}
