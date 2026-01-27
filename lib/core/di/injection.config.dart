// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:ui' as _i264;

import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/calendar/data/datasources/calendar_data_source.dart'
    as _i751;
import '../../features/calendar/data/datasources/chat_data_source.dart'
    as _i632;
import '../../features/calendar/data/datasources/user_data_source.dart'
    as _i943;
import '../../features/calendar/data/repositories/calendar_repository_impl.dart'
    as _i712;
import '../../features/calendar/data/repositories/chat_repository_impl.dart'
    as _i219;
import '../../features/calendar/data/repositories/storage_repository_impl.dart'
    as _i458;
import '../../features/calendar/data/repositories/user_repository_impl.dart'
    as _i167;
import '../../features/calendar/domain/entities/calendar_entity.dart' as _i125;
import '../../features/calendar/domain/repositories/calendar_repository.dart'
    as _i241;
import '../../features/calendar/domain/repositories/chat_repository.dart'
    as _i413;
import '../../features/calendar/domain/repositories/storage_repository.dart'
    as _i1041;
import '../../features/calendar/domain/repositories/user_repository.dart'
    as _i489;
import '../../features/calendar/domain/usecases/chat_insert_use_case.dart'
    as _i408;
import '../../features/calendar/domain/usecases/create_shared_calendar_use_case.dart'
    as _i954;
import '../../features/calendar/domain/usecases/delete_calendar_use_case.dart'
    as _i605;
import '../../features/calendar/domain/usecases/exile_member_use_case.dart'
    as _i706;
import '../../features/calendar/domain/usecases/fetch_chat_messages_use_case.dart'
    as _i711;
import '../../features/calendar/domain/usecases/fetch_user_info_use_case.dart'
    as _i903;
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
import '../../features/calendar/domain/usecases/subscribe_messages_use_case.dart'
    as _i208;
import '../../features/calendar/domain/usecases/transfer_admin_role_use_case.dart'
    as _i743;
import '../../features/calendar/domain/usecases/update_calendar_info_use_case.dart'
    as _i796;
import '../../features/calendar/domain/usecases/update_last_read_at_use_case.dart'
    as _i655;
import '../../features/home_widget/data/datasources/widget_local_data_source.dart'
    as _i763;
import '../../features/home_widget/data/repositories/widget_repository_impl.dart'
    as _i326;
import '../../features/home_widget/domain/repositories/widget_repository.dart'
    as _i131;
import '../../features/home_widget/domain/usecases/sync_all_calendars_to_widget_use_case.dart'
    as _i605;
import '../../features/onboarding/data/datasource/onboarding_local_data_source.dart'
    as _i849;
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart'
    as _i452;
import '../../features/onboarding/domain/repositories/onboarding_repository.dart'
    as _i430;
import '../../features/onboarding/domain/usecases/finish_onboarding_use_case.dart'
    as _i862;
import '../../features/onboarding/domain/usecases/get_onboarding_pages_usecase.dart'
    as _i590;
import '../../features/onboarding/presentation/viewmodels/onboarding_viewmodel.dart'
    as _i758;
import '../../features/profile/data/datasources/profile_data_source.dart'
    as _i406;
import '../../features/profile/data/repositories/profile_repository_impl.dart'
    as _i334;
import '../../features/profile/domain/repositories/profile_repository.dart'
    as _i894;
import '../../features/profile/domain/usecases/delete_user_use_case.dart'
    as _i41;
import '../../features/profile/domain/usecases/fetch_user_use_case.dart'
    as _i353;
import '../../features/profile/domain/usecases/nickname_overlapping_use_case.dart'
    as _i309;
import '../../features/profile/domain/usecases/set_google_account_use_case.dart'
    as _i1020;
import '../../features/profile/domain/usecases/sync_google_calendar_to_schedule_use_case.dart'
    as _i807;
import '../../features/profile/domain/usecases/update_google_sync_use_case.dart'
    as _i618;
import '../../features/profile/domain/usecases/update_image_use_case.dart'
    as _i825;
import '../../features/profile/domain/usecases/update_nickname_use_case.dart'
    as _i837;
import '../../features/profile/domain/usecases/update_notification_use_case.dart'
    as _i73;
import '../../features/schedule/data/datasources/google_calendar_data_source.dart'
    as _i595;
import '../../features/schedule/data/datasources/google_calendar_data_source_impl.dart'
    as _i1011;
import '../../features/schedule/data/datasources/location_data_source.dart'
    as _i985;
import '../../features/schedule/data/datasources/location_data_source_impl.dart'
    as _i360;
import '../../features/schedule/data/datasources/schedule_remote_data_source.dart'
    as _i738;
import '../../features/schedule/data/datasources/schedule_remote_data_source_impl.dart'
    as _i455;
import '../../features/schedule/data/repositories/google_calnedar_repository_impl.dart'
    as _i424;
import '../../features/schedule/data/repositories/location_repository_impl.dart'
    as _i683;
import '../../features/schedule/data/repositories/schedule_repository_impl.dart'
    as _i688;
import '../../features/schedule/domain/entities/schedule_entity.dart' as _i798;
import '../../features/schedule/domain/repositories/google_calendar_repository.dart'
    as _i511;
import '../../features/schedule/domain/repositories/location_repository.dart'
    as _i527;
import '../../features/schedule/domain/repositories/schedule_repository.dart'
    as _i736;
import '../../features/schedule/domain/usecases/add_schedule_use_case.dart'
    as _i585;
import '../../features/schedule/domain/usecases/delete_all_schedules_use_case.dart'
    as _i762;
import '../../features/schedule/domain/usecases/delete_schedules_by_group_id_use_case.dart'
    as _i871;
import '../../features/schedule/domain/usecases/delete_schedules_use_case.dart'
    as _i315;
import '../../features/schedule/domain/usecases/fetch_all_shared_schedules_use_case.dart'
    as _i1028;
import '../../features/schedule/domain/usecases/fetch_holidays_use_case.dart'
    as _i352;
import '../../features/schedule/domain/usecases/fetch_my_schedules_use_case.dart'
    as _i994;
import '../../features/schedule/domain/usecases/fetch_schedule_by_id_use_case.dart'
    as _i29;
import '../../features/schedule/domain/usecases/fetch_schedules_by_range_use_case.dart'
    as _i435;
import '../../features/schedule/domain/usecases/fetch_schedules_use_case.dart'
    as _i1061;
import '../../features/schedule/domain/usecases/geocode_address_use_case.dart'
    as _i570;
import '../../features/schedule/domain/usecases/search_address_use_case.dart'
    as _i65;
import '../../features/schedule/domain/usecases/sync_google_calendar_to_schedule_use_case.dart'
    as _i34;
import '../../features/schedule/domain/usecases/update_schedule_use_case.dart'
    as _i595;
import '../../features/schedule/domain/usecases/update_schedules_by_group_id_use_case.dart'
    as _i830;
import '../../features/schedule/presentation/viewmodels/schedule_add_view_model.dart'
    as _i227;
import '../../features/schedule/presentation/viewmodels/schedule_detail_view_model.dart'
    as _i986;
import '../../features/schedule/presentation/viewmodels/schedule_edit_view_model.dart'
    as _i103;
import '../../features/schedule/presentation/viewmodels/schedule_view_model.dart'
    as _i60;
import 'network_module.dart' as _i567;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio());
    gh.lazySingleton<_i751.CalendarDataSource>(
      () => _i751.CalendarDataSource(),
    );
    gh.lazySingleton<_i632.ChatDataSource>(() => _i632.ChatDataSource());
    gh.lazySingleton<_i943.UserDataSource>(() => _i943.UserDataSource());
    gh.lazySingleton<_i849.OnboardingLocalDataSource>(
      () => _i849.OnboardingLocalDataSource(),
    );
    gh.lazySingleton<_i406.ProfileDataSource>(() => _i406.ProfileDataSource());
    gh.lazySingleton<_i413.ChatRepository>(
      () => _i219.ChatRepositoryImpl(gh<_i632.ChatDataSource>()),
    );
    gh.lazySingleton<_i985.LocationDataSource>(
      () => _i360.LocationDataSourceImpl(),
    );
    gh.lazySingleton<_i894.ProfileRepository>(
      () => _i334.ProfileRepositoryImpl(gh<_i406.ProfileDataSource>()),
    );
    gh.lazySingleton<_i595.GoogleCalendarDataSource>(
      () => _i1011.GoogleCalendarDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i763.WidgetLocalDataSource>(
      () => _i763.WidgetLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i1041.StorageRepository>(
      () => _i458.StorageRepositoryImpl(),
    );
    gh.lazySingleton<_i489.UserRepository>(
      () => _i167.UserRepositoryImpl(gh<_i943.UserDataSource>()),
    );
    gh.lazySingleton<_i738.ScheduleRemoteDataSource>(
      () => _i455.ScheduleRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i684.ReadUnreadChatCountUseCase>(
      () => _i684.ReadUnreadChatCountUseCase(gh<_i413.ChatRepository>()),
    );
    gh.lazySingleton<_i241.CalendarRepository>(
      () => _i712.CalendarRepositoryImpl(gh<_i751.CalendarDataSource>()),
    );
    gh.factory<_i408.ChatInsertUseCase>(
      () => _i408.ChatInsertUseCase(gh<_i413.ChatRepository>()),
    );
    gh.factory<_i711.FetchChatMessagesUseCase>(
      () => _i711.FetchChatMessagesUseCase(gh<_i413.ChatRepository>()),
    );
    gh.factory<_i903.FetchUserInfoUseCase>(
      () => _i903.FetchUserInfoUseCase(gh<_i413.ChatRepository>()),
    );
    gh.factory<_i208.SubscribeMessagesUseCase>(
      () => _i208.SubscribeMessagesUseCase(gh<_i413.ChatRepository>()),
    );
    gh.factory<_i655.UpdateLastReadAtUseCase>(
      () => _i655.UpdateLastReadAtUseCase(gh<_i413.ChatRepository>()),
    );
    gh.lazySingleton<_i736.ScheduleRepository>(
      () => _i688.ScheduleRepositoryImpl(gh<_i738.ScheduleRemoteDataSource>()),
    );
    gh.lazySingleton<_i131.WidgetRepository>(
      () => _i326.WidgetRepositoryImpl(
        gh<_i763.WidgetLocalDataSource>(),
        gh<_i736.ScheduleRepository>(),
        gh<_i241.CalendarRepository>(),
      ),
    );
    gh.factory<_i41.DeleteUserUseCase>(
      () => _i41.DeleteUserUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i353.FetchUserUseCase>(
      () => _i353.FetchUserUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i309.NicknameOverlappingUseCase>(
      () => _i309.NicknameOverlappingUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i618.UpdateGoogleSyncUseCase>(
      () => _i618.UpdateGoogleSyncUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i825.UpdateimageUseCase>(
      () => _i825.UpdateimageUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i837.UpdateNicknameUseCase>(
      () => _i837.UpdateNicknameUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i73.UpdateNotificationUseCase>(
      () => _i73.UpdateNotificationUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.lazySingleton<_i743.TransferAdminRoleUseCase>(
      () => _i743.TransferAdminRoleUseCase(gh<_i489.UserRepository>()),
    );
    gh.lazySingleton<_i430.OnboardingRepository>(
      () =>
          _i452.OnboardingRepositoryImpl(gh<_i849.OnboardingLocalDataSource>()),
    );
    gh.factory<_i585.AddScheduleUseCase>(
      () => _i585.AddScheduleUseCase(gh<_i736.ScheduleRepository>()),
    );
    gh.factory<_i762.DeleteAllSchedulesUseCase>(
      () => _i762.DeleteAllSchedulesUseCase(gh<_i736.ScheduleRepository>()),
    );
    gh.factory<_i871.DeleteSchedulesByGroupIdUseCase>(
      () =>
          _i871.DeleteSchedulesByGroupIdUseCase(gh<_i736.ScheduleRepository>()),
    );
    gh.factory<_i315.DeleteSchedulesUseCase>(
      () => _i315.DeleteSchedulesUseCase(gh<_i736.ScheduleRepository>()),
    );
    gh.factory<_i1028.FetchAllSharedSchedulesUseCase>(
      () =>
          _i1028.FetchAllSharedSchedulesUseCase(gh<_i736.ScheduleRepository>()),
    );
    gh.factory<_i994.FetchMySchedulesUseCase>(
      () => _i994.FetchMySchedulesUseCase(gh<_i736.ScheduleRepository>()),
    );
    gh.factory<_i29.FetchScheduleByIdUseCase>(
      () => _i29.FetchScheduleByIdUseCase(gh<_i736.ScheduleRepository>()),
    );
    gh.factory<_i435.FetchSchedulesByRangeUseCase>(
      () => _i435.FetchSchedulesByRangeUseCase(gh<_i736.ScheduleRepository>()),
    );
    gh.factory<_i1061.FetchSchedulesUseCase>(
      () => _i1061.FetchSchedulesUseCase(gh<_i736.ScheduleRepository>()),
    );
    gh.factory<_i595.UpdateScheduleUseCase>(
      () => _i595.UpdateScheduleUseCase(gh<_i736.ScheduleRepository>()),
    );
    gh.factory<_i830.UpdateSchedulesByGroupIdUseCase>(
      () =>
          _i830.UpdateSchedulesByGroupIdUseCase(gh<_i736.ScheduleRepository>()),
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
    gh.lazySingleton<_i527.LocationRepository>(
      () => _i683.LocationRepositoryImpl(gh<_i985.LocationDataSource>()),
    );
    gh.lazySingleton<_i511.GoogleCalendarRepository>(
      () => _i424.GoogleCalendarRepositoryImpl(
        gh<_i595.GoogleCalendarDataSource>(),
      ),
    );
    gh.lazySingleton<_i605.SyncAllCalendarsToWidgetUseCase>(
      () => _i605.SyncAllCalendarsToWidgetUseCase(gh<_i131.WidgetRepository>()),
    );
    gh.factoryParam<_i986.ScheduleDetailViewModel, int, bool>(
      (scheduleId, isAdmin) => _i986.ScheduleDetailViewModel(
        gh<_i29.FetchScheduleByIdUseCase>(),
        gh<_i315.DeleteSchedulesUseCase>(),
        gh<_i871.DeleteSchedulesByGroupIdUseCase>(),
        scheduleId,
        isAdmin,
      ),
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
    gh.factory<_i862.FinishOnboardingUseCase>(
      () => _i862.FinishOnboardingUseCase(gh<_i430.OnboardingRepository>()),
    );
    gh.factory<_i590.GetOnboardingPagesUseCase>(
      () => _i590.GetOnboardingPagesUseCase(gh<_i430.OnboardingRepository>()),
    );
    gh.factory<_i1020.SetGoogleAccountUseCase>(
      () =>
          _i1020.SetGoogleAccountUseCase(gh<_i511.GoogleCalendarRepository>()),
    );
    gh.factory<_i807.SyncGoogleCalendarToScheduleUseCase>(
      () => _i807.SyncGoogleCalendarToScheduleUseCase(
        gh<_i511.GoogleCalendarRepository>(),
      ),
    );
    gh.factory<_i352.FetchHolidaysUseCase>(
      () => _i352.FetchHolidaysUseCase(gh<_i511.GoogleCalendarRepository>()),
    );
    gh.factory<_i34.SyncGoogleCalendarToScheduleUseCase>(
      () => _i34.SyncGoogleCalendarToScheduleUseCase(
        gh<_i511.GoogleCalendarRepository>(),
      ),
    );
    gh.factory<_i570.GeocodeAddressUseCase>(
      () => _i570.GeocodeAddressUseCase(gh<_i527.LocationRepository>()),
    );
    gh.factory<_i65.SearchAddressUseCase>(
      () => _i65.SearchAddressUseCase(gh<_i527.LocationRepository>()),
    );
    gh.factoryParam<_i758.OnboardingViewModel, _i264.VoidCallback, dynamic>(
      (onFinished, _) => _i758.OnboardingViewModel(
        gh<_i590.GetOnboardingPagesUseCase>(),
        gh<_i862.FinishOnboardingUseCase>(),
        onFinished,
      ),
    );
    gh.factoryParam<_i60.ScheduleViewModel, _i125.CalendarEntity, dynamic>(
      (calendar, _) => _i60.ScheduleViewModel(
        gh<_i1061.FetchSchedulesUseCase>(),
        gh<_i994.FetchMySchedulesUseCase>(),
        gh<_i1028.FetchAllSharedSchedulesUseCase>(),
        gh<_i762.DeleteAllSchedulesUseCase>(),
        gh<_i34.SyncGoogleCalendarToScheduleUseCase>(),
        calendar,
      ),
    );
    gh.factoryParam<_i103.ScheduleEditViewModel, _i798.ScheduleEntity, dynamic>(
      (schedule, _) => _i103.ScheduleEditViewModel(
        gh<_i585.AddScheduleUseCase>(),
        gh<_i352.FetchHolidaysUseCase>(),
        gh<_i595.UpdateScheduleUseCase>(),
        gh<_i871.DeleteSchedulesByGroupIdUseCase>(),
        gh<_i570.GeocodeAddressUseCase>(),
        schedule,
      ),
    );
    gh.factoryParam<_i227.ScheduleAddViewModel, DateTime?, dynamic>(
      (date, _) => _i227.ScheduleAddViewModel(
        gh<_i585.AddScheduleUseCase>(),
        gh<_i352.FetchHolidaysUseCase>(),
        gh<_i570.GeocodeAddressUseCase>(),
        date,
      ),
    );
    return this;
  }
}

class _$NetworkModule extends _i567.NetworkModule {}
