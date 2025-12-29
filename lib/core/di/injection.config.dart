// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dutytable/core/di/app_module.dart' as _i69;
import 'package:dutytable/features/onboarding/data/datasources/onboarding_local_data_source.dart'
    as _i591;
import 'package:dutytable/features/onboarding/presentation/args/onboarding_args.dart'
    as _i925;
import 'package:dutytable/features/onboarding/presentation/viewmodels/onboarding_viewmodel.dart'
    as _i125;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i591.OnboardingLocalDataSource>(
      () => _i591.OnboardingLocalDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.factoryParam<_i125.OnboardingViewModel, _i925.OnboardingArgs, dynamic>(
      (args, _) => _i125.OnboardingViewModel(
        gh<_i591.OnboardingLocalDataSource>(),
        args,
      ),
    );
    return this;
  }
}

class _$AppModule extends _i69.AppModule {}
