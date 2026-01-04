import 'package:dutytable/core/providers/theme_provider.dart';
import 'package:dutytable/core/services/notification_service.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/shared_calendar_view_model.dart';
import 'package:dutytable/features/home_widget/data/datasources/widget_local_data_source.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest_all.dart' as timezone;

import 'core/network/firebase_options.dart';
import 'core/router/app_router.dart';
import 'features/notification/presentation/viewmodels/notification_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 환경 변수 및 날짜 로케일 초기화
  await dotenv.load(fileName: ".env");
  await initializeDateFormatting('ko_KR', null); // ko_KR 명시
  timezone.initializeTimeZones();

  // 외부 서비스 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().initialize();
  await Supabase.initialize(
    url: dotenv.get("SUPABASE_URL"),
    anonKey: dotenv.get("SUPABASE_ANON_KEY"),
  );

  // 네이버 맵 초기화
  await FlutterNaverMap().init(
    clientId: 'e98nekb2dd',
    onAuthFailed: (ex) {
      switch (ex) {
        case NQuotaExceededException(:final message):
          break;
        case NUnauthorizedClientException() ||
            NClientUnspecifiedException() ||
            NAnotherAuthFailedException():
          break;
      }
    },
  );

  // 위젯 데이터 초기 업데이트 로직 분리
  await _initialWidgetUpdate();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => NotificationState()),
        ChangeNotifierProvider(create: (context) => SharedCalendarViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

/// 앱 시작 시 실제 데이터를 기반으로 위젯을 업데이트하는 함수
Future<void> _initialWidgetUpdate() async {
  final widgetDataSource = WidgetDataSourceImpl();
  await widgetDataSource.syncAllCalendarsToWidget(); // 통합 싱크 호출
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      locale: const Locale("ko", "KR"),
      supportedLocales: const [Locale("ko", "KR")],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: themeProvider.themeMode,
      theme: ThemeData(brightness: Brightness.light, fontFamily: 'Pretendard'),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Pretendard',
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: createRouter(context),
      title: "DutyTable",

      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
