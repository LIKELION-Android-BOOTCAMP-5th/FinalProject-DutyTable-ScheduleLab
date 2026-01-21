import 'package:injectable/injectable.dart';

import '../repositories/widget_repository.dart';

@lazySingleton
class SyncAllCalendarsToWidgetUseCase {
  final WidgetRepository _repository;

  SyncAllCalendarsToWidgetUseCase(this._repository);

  Future<void> call() async {
    return _repository.syncAllCalendarsToWidget();
  }
}
