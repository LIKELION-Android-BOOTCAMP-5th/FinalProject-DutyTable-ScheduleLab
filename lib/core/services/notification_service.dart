import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // 싱글톤 패턴 설정
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localPlugin =
      FlutterLocalNotificationsPlugin();

  // 전역에서 사용할 채널 ID 정의
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'fcm_head_up_channel_id',
    'Head-up 알림 채널',
    description: '팝업 알림을 위한 가장 높은 중요도의 채널입니다.',
    importance: Importance.max,
    playSound: true,
  );

  Future<void> initialize() async {
    // 권한 요청
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Android 채널 생성
    await _localPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
    >()
        ?.createNotificationChannel(_channel);

    // Local Notifications 초기화
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _localPlugin.initialize(initializationSettings);

    // 포그라운드 알림 옵션 (iOS)
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 리스너 연결
    _setupMessageListeners();
  }

  // 포그라운드 리스너
  void _setupMessageListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _localPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              channelDescription: _channel.description,
              importance: Importance.max,
              priority: Priority.high,
              icon: android.smallIcon,
            ),
          ),
        );
      }
    });
  }
}
