import 'package:dutytable/features/calendar/presentation/viewmodels/personal_calendar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.white, // 상태 바 배경색 - 흰색
      statusBarIconBrightness: Brightness.dark, // 안드로이드 아이콘 색
      statusBarBrightness: Brightness.light, // iOS 아이콘 색
    ),
  );

  await Supabase.initialize(
    url: 'https://eexkppotdipyrzzjakur.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVleGtwcG90ZGlweXJ6empha3VyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkzODcwNzksImV4cCI6MjA3NDk2MzA3OX0.HFGirj_JSIZB5bkgwm8CnQAqE9kBoRMOlcG8dl6-vyw',
  );

  initializeDateFormatting().then(
    (_) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => PersonalCalendarViewModel(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: createRouter(context),
      title: "DutyTable",
    );
  }
}
