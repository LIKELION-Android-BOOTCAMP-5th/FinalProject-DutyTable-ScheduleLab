// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/calendar/data/datasources/calendar_data_source.dart'
    as _i751;
import '../../features/calendar/data/datasources/user_data_source.dart'
    as _i943;
import '../../features/calendar/data/repositories/calendar_repository_impl.dart'
    as _i712;
import '../../features/calendar/data/repositories/storage_repository_impl.dart'
    as _i458;
import '../../features/calendar/data/repositories/user_repository_impl.dart'
    as _i167;
import '../../features/calendar/domain/repositories/calendar_repository.dart'
    as _i241;
import '../../features/calendar/domain/repositories/chat_repository.dart'
    as _i413;
import '../../features/calendar/domain/repositories/storage_repository.dart'
    as _i1041;
import '../../features/calendar/domain/repositories/user_repository.dart'
    as _i489;
import '../../features/calendar/domain/usecases/create_shared_calendar_use_case.dart'
    as _i954;
import '../../features/calendar/domain/usecases/delete_calendar_use_case.dart'
    as _i605;
import '../../features/calendar/domain/usecases/exile_member_use_case.dart'
    as _i706;
import '../../features/calendar/domain/usecases/find_user_by_nickname_use_case.dart'
    as _i583;
import '../../features/calendar/domain/usecases/invite_users_use_case.dart'
    as _i1002;
import '../../features/calendar/domain/usecases/out_calendar_use_case.dart'
    as _i852;
import '../../features/calendar/domain/usecases/out_calendars_use_case.dart'
    as _i384;
import '../../features/calendar/domain/usecases/read_calendar_final_list_use_case.dart'
    as _i634;
import '../../features/calendar/domain/usecases/read_calendar_title_by_id_use_case.dart'
    as _i834;
import '../../features/calendar/domain/usecases/read_google_calendar_connection_use_case.dart'
    as _i597;
import '../../features/calendar/domain/usecases/read_next_schedule_use_case.dart'
    as _i581;
import '../../features/calendar/domain/usecases/read_personal_calendar_use_case.dart'
    as _i654;
import '../../features/calendar/domain/usecases/read_shared_calendar_from_id_use_case.dart'
    as _i920;
import '../../features/calendar/domain/usecases/read_unread_chat_count_use_case.dart'
    as _i684;
import '../../features/calendar/domain/usecases/transfer_admin_role_use_case.dart'
    as _i743;
import '../../features/calendar/domain/usecases/update_calendar_info_use_case.dart'
    as _i796;
import '../../features/home_widget/data/datasources/widget_local_data_source.dart'
    as _i763;
import '../../features/home_widget/data/repositories/widget_repository_impl.dart'
    as _i326;
import '../../features/home_widget/domain/repositories/widget_repository.dart'
    as _i131;
import '../../features/home_widget/domain/usecases/sync_all_calendars_to_widget_use_case.dart'
    as _i605;
import '../../features/schedule/domain/repositories/schedule_repository.dart'
    as _i736;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i751.CalendarDataSource>(
      () => _i751.CalendarDataSource(),
    );
    gh.lazySingleton<_i943.UserDataSource>(() => _i943.UserDataSource());
    gh.lazySingleton<_i1041.StorageRepository>(
      () => _i458.StorageRepositoryImpl(),
    );
    gh.lazySingleton<_i489.UserRepository>(
      () => _i167.UserRepositoryImpl(gh<_i943.UserDataSource>()),
    );
    gh.lazySingleton<_i684.ReadUnreadChatCountUseCase>(
      () => _i684.ReadUnreadChatCountUseCase(gh<_i413.ChatRepository>()),
    );
    gh.lazySingleton<_i241.CalendarRepository>(
      () => _i712.CalendarRepositoryImpl(gh<_i751.CalendarDataSource>()),
    );
    gh.lazySingleton<_i131.WidgetRepository>(
      () => _i326.WidgetRepositoryImpl(
        gh<_i763.WidgetLocalDataSource>(),
        gh<_i736.ScheduleRepository>(),
        gh<_i241.CalendarRepository>(),
      ),
    );
    gh.lazySingleton<_i743.TransferAdminRoleUseCase>(
      () => _i743.TransferAdminRoleUseCase(gh<_i489.UserRepository>()),
    );
    gh.lazySingleton<_i706.ExileMemberUseCase>(
      () => _i706.ExileMemberUseCase(gh<_i489.UserRepository>()),
    );
    gh.lazySingleton<_i583.FindUserByNicknameUseCase>(
      () => _i583.FindUserByNicknameUseCase(gh<_i489.UserRepository>()),
    );
    gh.lazySingleton<_i1002.InviteUsersUseCase>(
      () => _i1002.InviteUsersUseCase(gh<_i489.UserRepository>()),
    );
    gh.lazySingleton<_i852.OutCalendarUseCase>(
      () => _i852.OutCalendarUseCase(gh<_i489.UserRepository>()),
    );
    gh.lazySingleton<_i384.OutCalendarsUseCase>(
      () => _i384.OutCalendarsUseCase(gh<_i489.UserRepository>()),
    );
    gh.lazySingleton<_i597.ReadGoogleCalendarConnectionUseCase>(
      () =>
          _i597.ReadGoogleCalendarConnectionUseCase(gh<_i489.UserRepository>()),
    );
    gh.lazySingleton<_i954.CreateSharedCalendarUseCase>(
      () => _i954.CreateSharedCalendarUseCase(
        gh<_i241.CalendarRepository>(),
        gh<_i1041.StorageRepository>(),
      ),
    );
    gh.lazySingleton<_i605.SyncAllCalendarsToWidgetUseCase>(
      () => _i605.SyncAllCalendarsToWidgetUseCase(gh<_i131.WidgetRepository>()),
    );
    gh.lazySingleton<_i605.DeleteCalendarUseCase>(
      () => _i605.DeleteCalendarUseCase(gh<_i241.CalendarRepository>()),
    );
    gh.lazySingleton<_i634.ReadCalendarFinalListUseCase>(
      () => _i634.ReadCalendarFinalListUseCase(gh<_i241.CalendarRepository>()),
    );
    gh.lazySingleton<_i834.ReadCalendarTitleByIdUseCase>(
      () => _i834.ReadCalendarTitleByIdUseCase(gh<_i241.CalendarRepository>()),
    );
    gh.lazySingleton<_i581.ReadNextScheduleUseCase>(
      () => _i581.ReadNextScheduleUseCase(gh<_i241.CalendarRepository>()),
    );
    gh.lazySingleton<_i654.ReadPersonalCalendarUseCase>(
      () => _i654.ReadPersonalCalendarUseCase(gh<_i241.CalendarRepository>()),
    );
    gh.lazySingleton<_i920.ReadSharedCalendarFromIdUseCase>(
      () =>
          _i920.ReadSharedCalendarFromIdUseCase(gh<_i241.CalendarRepository>()),
    );
    gh.lazySingleton<_i796.UpdateCalendarInfoUseCase>(
      () => _i796.UpdateCalendarInfoUseCase(gh<_i241.CalendarRepository>()),
    );
    return this;
  }
}
