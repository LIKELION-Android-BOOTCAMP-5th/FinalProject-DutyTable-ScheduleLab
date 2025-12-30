import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../main.dart';

class SupabaseStorageService {
  static final SupabaseStorageService _instance =
      SupabaseStorageService._internal();
  factory SupabaseStorageService() => _instance;
  SupabaseStorageService._internal();

  /// 캘린더 이미지 저장(캘린더 추가, 캘린더 수정)
  Future<String?> uploadCalendarImage(File? imageFile, int calendarId) async {
    if (imageFile == null) return null;

    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final file = imageFile;
    final extension = file.path.split('.').last;
    final filePath =
        'calendar-images/$calendarId/${DateTime.now().millisecondsSinceEpoch}.$extension';

    await supabase.storage
        .from('calendar-images')
        .upload(
          filePath,
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );

    return supabase.storage.from('calendar-images').getPublicUrl(filePath);
  }

  /// 캘린더 이미지 삭제(캘린더 수정)
  Future<void> deleteCalendarImage(String imageUrl) async {
    try {
      final String bucketName = 'calendar-images';
      final String pattern = '$bucketName/';

      if (!imageUrl.contains(pattern)) return;

      final int startIndex = imageUrl.indexOf(pattern) + pattern.length;
      final String filePath = imageUrl.substring(startIndex);

      await supabase.storage.from(bucketName).remove([filePath]);

      print('이미지 삭제 성공');
    } catch (e) {
      print('이미지 삭제 중 오류 발생: $e');
    }
  }

  /// 프로필 이미지 저장(회원가입, 프로필 변경)
  Future<String?> uploadProfileImage(File imageFile) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('사용자 인증 필요');

    try {
      final fileExtension = imageFile.path.split('.').last;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${user.id}/profile_$timestamp.$fileExtension';

      await supabase.storage
          .from('profile-images')
          .upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      return supabase.storage.from('profile-images').getPublicUrl(filePath);
    } catch (e) {
      print('Storage Error: $e');
      return null;
    }
  }

  /// 프로필 이미지 삭제(프로필 변경)
  Future<void> deleteProfileImage(String path) async {
    List<String> paths = [];
    paths.add(path);
    await supabase.storage.from('profile-images').remove(paths);
  }
}
