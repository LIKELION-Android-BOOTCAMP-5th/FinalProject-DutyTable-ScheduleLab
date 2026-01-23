import 'package:dutytable/features/schedule/data/datasources/google_calendar_data_source.dart';
import 'package:dutytable/features/schedule/domain/repositories/google_calendar_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: GoogleCalendarRepository)
class GoogleCalendarRepositoryImpl implements GoogleCalendarRepository {
  final GoogleCalendarDataSource dataSource;

  GoogleCalendarRepositoryImpl(this.dataSource);

  @override
  Future<List<DateTime>> fetchHolidays(int targetYear) {
    return dataSource.fetchHolidays(targetYear);
  }

  @override
  void setGoogleAccount(GoogleSignInAccount? account) {
    return dataSource.setGoogleAccount(account);
  }

  @override
  Future<List<Map<String, dynamic>>> syncGoogleCalendarToSchedule() {
    return dataSource.syncGoogleCalendarToSchedule();
  }
}
