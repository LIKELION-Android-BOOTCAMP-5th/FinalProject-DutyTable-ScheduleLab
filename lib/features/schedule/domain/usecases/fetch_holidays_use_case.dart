import 'package:dutytable/features/schedule/domain/repositories/google_calendar_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchHolidaysUseCase {
  final GoogleCalendarRepository repository;

  FetchHolidaysUseCase(this.repository);

  Future<List<DateTime>> call(int targetYear) {
    return repository.fetchHolidays(targetYear);
  }
}
