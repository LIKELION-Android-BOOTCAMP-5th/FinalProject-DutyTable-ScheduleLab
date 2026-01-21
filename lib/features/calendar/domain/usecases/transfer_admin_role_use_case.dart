import 'package:dutytable/features/calendar/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TransferAdminRoleUseCase {
  final UserRepository _response;

  TransferAdminRoleUseCase(this._response);

  Future<void> call(int calendarId, String newAdminId) async {
    return await _response.transferAdminRole(calendarId, newAdminId);
  }
}
