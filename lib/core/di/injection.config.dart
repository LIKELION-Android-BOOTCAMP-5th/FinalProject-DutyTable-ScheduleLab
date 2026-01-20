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
import '../../features/calendar/data/repositories/calendar_repository_impl.dart'
    as _i712;
import '../../features/calendar/domain/repositories/calendar_repository.dart'
    as _i241;
import '../../features/calendar/domain/usecases/create_calendar_usecase.dart'
    as _i991;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i241.CalendarRepository>(
      () => _i712.CalendarRepositoryImpl(gh<_i751.CalendarDataSource>()),
    );
    gh.lazySingleton<_i991.CreateCalendarUseCase>(
      () => _i991.CreateCalendarUseCase(gh<_i241.CalendarRepository>()),
    );
    return this;
  }
}
