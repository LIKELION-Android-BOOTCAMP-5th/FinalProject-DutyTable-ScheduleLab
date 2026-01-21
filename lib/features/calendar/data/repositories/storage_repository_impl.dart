import 'dart:io';

import 'package:dutytable/features/calendar/domain/repositories/storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../main.dart';

@LazySingleton(as: StorageRepository)
class StorageRepositoryImpl implements StorageRepository {
  @override
  Future<String> uploadCalendarImage(File imageFile, int calendarId) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final extension = imageFile.path.split('.').last;
    // 경로 규칙: calendar-images/ID/파일명.확장자
    final filePath =
        '$calendarId/${DateTime.now().millisecondsSinceEpoch}.$extension';

    await supabase.storage
        .from('calendar-images')
        .upload(
          filePath,
          imageFile,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );

    // 저장된 파일의 http URL 반환
    return supabase.storage.from('calendar-images').getPublicUrl(filePath);
  }

  @override
  Future<void> deleteCalendarImage(String? imageUrl) async {
    if (imageUrl == null || imageUrl.isEmpty) return;

    try {
      final String bucketName = 'calendar-images';
      final String pattern = '$bucketName/';

      if (!imageUrl.contains(pattern)) return;

      final int startIndex = imageUrl.indexOf(pattern) + pattern.length;
      final String filePath = imageUrl.substring(startIndex);

      await supabase.storage.from(bucketName).remove([filePath]);
    } catch (e) {
      // 에러 로깅은 도메인에 영향을 주지 않도록 내부에서 처리하거나 Rethrow
      debugPrint('이미지 삭제 실패: $e');
    }
  }
}
