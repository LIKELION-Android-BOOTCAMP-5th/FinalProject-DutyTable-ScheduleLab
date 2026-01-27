import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../../schedule/domain/repositories/google_calendar_repository.dart';

@injectable
class SetGoogleAccountUseCase {
  final GoogleCalendarRepository repository;
  SetGoogleAccountUseCase(this.repository);

  void call(GoogleSignInAccount? account) {
    repository.setGoogleAccount(account);
  }
}
