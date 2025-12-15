import 'package:dutytable/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FcmTestScreen extends StatefulWidget {
  const FcmTestScreen({super.key});

  @override
  State<FcmTestScreen> createState() => _FcmTestScreenState();
}

class _FcmTestScreenState extends State<FcmTestScreen> {
  @override
  void initState() {
    super.initState();
    supabase.auth.onAuthStateChange.listen((event) async {
      if (event.event == AuthChangeEvent.signedIn) {
        await FirebaseMessaging.instance.requestPermission();

        await FirebaseMessaging.instance.getAPNSToken();

        final fcmToken = FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          await supabase.from('users').upsert({'fcm_token': fcmToken});
        }
      }
    });
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      await supabase.from('users').upsert({'fcm_token': fcmToken});
    });
  }

  Future<void> _setFcmToken(String fcmToken) async {
    await supabase.from('users').upsert({'fcm_token': fcmToken});
  }

  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
