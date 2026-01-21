import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/calendar/data/models/calendar_member_model.dart';
import '../../features/calendar/data/models/calendar_model.dart';
import '../../features/calendar/domain/entities/calendar_entity.dart';

class SupabaseManager {
  static final SupabaseManager _shared = SupabaseManager();
  static SupabaseManager get shared => _shared;

  // Get a reference your Supabase client
  final supabase = Supabase.instance.client;

  SupabaseManager() {
    debugPrint("SupabaseManager init");
  }

  /// 현재 사용자가 속한 모든 캘린더를 가져오기
  Future<List<CalendarEntity>> getCalendars() async {
    // 1. Supabase로부터 데이터 fetch
    final response = await supabase
        .from('calendars')
        .select(
          '*, calendars_user_id_fkey:users(*), calendar_members(*, users(*))',
        );

    // 2. 파싱 로직
    final List<dynamic> data = response as List;

    return data.map((json) {
      final memberJsonList = json['calendar_members'] as List<dynamic>? ?? [];
      final members = memberJsonList
          .map((m) => CalendarMemberModel.fromJson(m as Map<String, dynamic>))
          .toList();

      return CalendarModel.fromJson(
        json as Map<String, dynamic>,
        members: members,
      );
    }).toList();
  }
}
