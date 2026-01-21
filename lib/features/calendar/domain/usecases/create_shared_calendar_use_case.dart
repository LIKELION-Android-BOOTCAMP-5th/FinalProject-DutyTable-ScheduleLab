import 'dart:io';

import 'package:dutytable/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:injectable/injectable.dart';

import '../repositories/storage_repository.dart';

@lazySingleton
class CreateSharedCalendarUseCase {
  final CalendarRepository _calendarRepo;
  final StorageRepository _storageRepo;

  CreateSharedCalendarUseCase(this._calendarRepo, this._storageRepo);

  Future<void> call({
    required String title,
    String? description,
    required List<String> invitedUserIds,
    File? imageFile,
  }) async {
    final calendarId = await _calendarRepo.createSharedCalendar(
      title: title,
      description: description,
      invitedUserIds: invitedUserIds,
    );

    if (imageFile != null) {
      final String uploadedUrl = await _storageRepo.uploadCalendarImage(
        imageFile,
        calendarId,
      );

      await _calendarRepo.updateCalendarInfo(
        calendarId: calendarId,
        imageUrl: uploadedUrl,
      );
    }
  }
}
