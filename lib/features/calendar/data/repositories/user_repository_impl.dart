import 'package:dutytable/features/calendar/domain/entities/user_entity.dart';
import 'package:dutytable/features/calendar/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

import '../datasources/user_data_source.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserDataSource _dataSource;

  UserRepositoryImpl(this._dataSource);

  @override
  Future<UserEntity?> findUserByNickname(String nickname) async {
    try {
      final userModel = await _dataSource.findUserByNickname(nickname);

      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> transferAdminRole(int calendarId, String newAdminId) async {
    await _dataSource.transferAdminRole(calendarId, newAdminId);
  }

  @override
  Future<void> exileMember(int calendarId, String userId) async {
    await _dataSource.exileMember(calendarId, userId);
  }

  @override
  Future<void> outCalendar(int calendarId) async {
    await _dataSource.outCalendar(calendarId);
  }

  @override
  Future<void> inviteUsers(int calendarId, List<String> invitedUserIds) async {
    await _dataSource.inviteUsers(calendarId, invitedUserIds);
  }

  @override
  Future<void> outCalendars(List<int> calendarIds) async {
    await _dataSource.outCalendars(calendarIds);
  }

  @override
  Future<bool> readIsGoogleCalendarConnection() async {
    return await _dataSource.readIsGoogleCalendarConnection();
  }
}
