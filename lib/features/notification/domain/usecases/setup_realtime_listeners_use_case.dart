import 'package:injectable/injectable.dart';

import '../repositories/notification_repository.dart';

@injectable
class SetupRealtimeListenersUseCase {
  final NotificationRepository repository;
  SetupRealtimeListenersUseCase(this.repository);

  void call() {
    repository.setupRealtimeListeners();
  }
}
