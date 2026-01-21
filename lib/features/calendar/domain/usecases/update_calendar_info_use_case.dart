import 'package:dutytable/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UpdateCalendarInfoUseCase {
  final CalendarRepository _repository;

  UpdateCalendarInfoUseCase(this._repository);

  Future<bool> call({
    String? title,
    String? description,
    String? imageURL,
    required int calendarId,
  }) {
    return _repository.updateCalendarInfo(
      title: title,
      description: description,
      imageUrl: imageURL,
      calendarId: calendarId,
    );
  }
}
