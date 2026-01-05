import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dutytable/features/notification/data/models/invite_notification_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../features/notification/data/datasources/notification_data_source.dart';

class NotificationService {
  // 싱글톤 패턴 설정
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localPlugin =
      FlutterLocalNotificationsPlugin();

  final _invitationController =
  StreamController<InviteNotificationModel>.broadcast();
  Stream<InviteNotificationModel> get invitationStream =>
      _invitationController.stream;

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
        AndroidFlutterLocalNotificationsPlugin>()
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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // 초대 알림 데이터 페이로드에 calendar_id가 포함되어 있는지 확인
      if (message.data.containsKey('calendar_id')) {
        try {
          // 푸시 알림 데이터에 포함된 id를 사용하여 DB에서 전체 알림 정보 조회
          final notificationId = int.parse(message.data['id'].toString());
          final notification = await NotificationDataSource.shared
              .getInviteNotificationById(notificationId);
          _invitationController.add(notification as InviteNotificationModel);
        } catch (e) {
          print('전체 초대알림 정보를 가져오는데 실패했습니다: $e');
        }
      } else {
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
      }
    });
  }

  void dispose() {
    _invitationController.close();
  }
}
