import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest_all.dart' as timezone;

import 'core/configs/app_theme.dart';
import 'core/router/app_router.dart';
import 'firebase_options.dart';

// 전역에서 사용할 채널 ID 정의
const AndroidNotificationChannel highImportanceChannel =
    AndroidNotificationChannel(
      'fcm_head_up_channel_id',
      'Head-up 알림 채널',
      description: '팝업 알림을 위한 가장 높은 중요도의 채널입니다.',
      importance: Importance.max,
      playSound: true,
    );

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(highImportanceChannel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // 알림 표시
    badge: true, // 뱃지 표시
    sound: true, // 소리 재생
  );
}

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeNotifications();
  await Supabase.initialize(
    url: dotenv.get("SUPABASE_URL"),
    anonKey: dotenv.get("SUPABASE_ANON_KEY"),
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
