import 'package:dutytable/features/calendar/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ExileMemberUseCase {
  final UserRepository _repository;

  ExileMemberUseCase(this._repository);

  Future<void> call(int calendarId, String userId) async {
    return await _repository.exileMember(calendarId, userId);
  }
}
