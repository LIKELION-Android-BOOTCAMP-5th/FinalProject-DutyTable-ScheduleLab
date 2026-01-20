import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // 기본값
  preferRelativeImports: true,
  asExtension: true, // 확장 함수 형태로 사용할지 여부
)
void configureDependencies() => getIt.init();
