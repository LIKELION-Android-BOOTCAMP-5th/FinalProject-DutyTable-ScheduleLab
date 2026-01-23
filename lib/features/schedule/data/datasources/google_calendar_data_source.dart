import 'package:google_sign_in/google_sign_in.dart';

abstract class GoogleCalendarDataSource {
  /// Google holiday
  Future<List<DateTime>> fetchHolidays(int targetYear);

  /// Google Sync
  void setGoogleAccount(GoogleSignInAccount? account);
  Future<List<Map<String, dynamic>>> syncGoogleCalendarToSchedule();
}
