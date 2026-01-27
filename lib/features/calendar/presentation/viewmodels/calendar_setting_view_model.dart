import 'package:dutytable/features/calendar/domain/entities/calendar_entity.dart';
import 'package:dutytable/features/calendar/domain/usecases/delete_calendar_use_case.dart';
import 'package:dutytable/features/calendar/domain/usecases/exile_member_use_case.dart';
import 'package:dutytable/features/calendar/domain/usecases/read_personal_calendar_use_case.dart';
import 'package:dutytable/features/calendar/domain/usecases/read_shared_calendar_from_id_use_case.dart';
import 'package:dutytable/main.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/out_calendar_use_case.dart';

@injectable
class CalendarSettingViewModel extends ChangeNotifier {
  //UseCases
  final ReadPersonalCalendarUseCase _readPersonalCalendarUseCase;
  final ReadSharedCalendarFromIdUseCase _readSharedCalendarFromIdUseCase;
  final ExileMemberUseCase _exileMemberUseCase;
  final OutCalendarUseCase _outCalendarUseCase;
  final DeleteCalendarUseCase _deleteCalendarUseCase;

  /// 캘린더 데이터(private)
  late CalendarEntity _calendar;

  /// 캘린더 데이터(public)
  CalendarEntity get calendar => _calendar;

  final currentUser = supabase.auth.currentUser;

  /// 캘린더 세팅 뷰모델
  CalendarSettingViewModel(
    this._readPersonalCalendarUseCase,
    this._readSharedCalendarFromIdUseCase,
    this._exileMemberUseCase,
    this._outCalendarUseCase,
    this._deleteCalendarUseCase,
    @factoryParam CalendarEntity? calendar,
  ) {
    if (calendar != null) {
      _calendar = calendar;
    }
  }

  /// 단일 캘린더 불러오기
  Future<void> fetchCalendar() async {
    if (_calendar.type == 'personal') {
      _calendar = await _readPersonalCalendarUseCase();
    } else {
      _calendar = await _readSharedCalendarFromIdUseCase(_calendar.id);
    }
    notifyListeners();
  }

  /// 멤버 추방
  Future<void> exileMember(String userId) async {
    await _exileMemberUseCase(_calendar.id, userId);
  }

  /// 캘린더 나가기(멤버만)
  Future<void> outCalendar() async {
    await _outCalendarUseCase(_calendar.id);
  }

  /// 캘린더 삭제(방장만)
  Future<void> deleteCalendar() async {
    await _deleteCalendarUseCase(_calendar.id);
  }
}
