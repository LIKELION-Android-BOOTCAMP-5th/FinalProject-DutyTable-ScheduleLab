import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/calendar/data/models/calendar_model.dart';

class SupabaseManager {
  static final SupabaseManager _shared = SupabaseManager();
  static SupabaseManager get shared => _shared;

  // Get a reference your Supabase client
  final supabase = Supabase.instance.client;

  SupabaseManager() {
    debugPrint("SupabaseManager init");
  }

  /// 현재 사용자가 속한 모든 캘린더를 가져오기
  Future<List<CalendarModel>> getCalendars() async {
    final response = await supabase
        .from('calendars')
        .select(
          '*, calendars_user_id_fkey:users(*), calendar_members(*, users(*))',
        );
    final calendars = (response as List)
        .map((json) => CalendarModel.fromJson(json))
        .toList();
    return calendars;
  }
}
