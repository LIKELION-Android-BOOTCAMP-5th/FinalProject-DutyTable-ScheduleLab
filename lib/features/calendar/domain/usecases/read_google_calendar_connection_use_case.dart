import 'package:dutytable/features/calendar/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ReadGoogleCalendarConnectionUseCase {
  final UserRepository _repository;

  ReadGoogleCalendarConnectionUseCase(this._repository);

  Future<bool> call() async {
    return await _repository.readIsGoogleCalendarConnection();
  }
}
