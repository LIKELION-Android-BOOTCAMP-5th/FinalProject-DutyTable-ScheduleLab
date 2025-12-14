import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest_all.dart' as timezone;

import 'core/configs/app_theme.dart';
import 'core/router/app_router.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://eexkppotdipyrzzjakur.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVleGtwcG90ZGlweXJ6empha3VyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkzODcwNzksImV4cCI6MjA3NDk2MzA3OX0.HFGirj_JSIZB5bkgwm8CnQAqE9kBoRMOlcG8dl6-vyw',
  );

  await FlutterNaverMap().init(
    clientId: 'e98nekb2dd',
    onAuthFailed: (ex) {
      switch (ex) {
        case NQuotaExceededException(:final message):
          print("사용량 초과 (message: $message)");
          break;
        case NUnauthorizedClientException() ||
            NClientUnspecifiedException() ||
            NAnotherAuthFailedException():
          print("인증 실패: $ex");
          break;
      }
    },
  );

  timezone.initializeTimeZones();

  initializeDateFormatting().then(
    (_) => runApp(
      const MyApp(),
      // MultiProvider(
      //   providers: [
      //     ChangeNotifierProvider(create: (context) => CalendarTabViewModel()),
      //   ],
      //   child: const MyApp(),
      // ),
    ),
  );
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: const Locale("ko", "KR"),
      supportedLocales: const [Locale("ko", "KR")],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerConfig: createRouter(context),
      title: "DutyTable",
    );
  }
}
