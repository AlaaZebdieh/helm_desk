import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../app/navigation/navigation_service.dart';
import '../../app/theme/app_colors.dart';

class NotificationsService {
  // final SetTokenNotificationUsecase? setTokenNotificationUsecase;
  // final MakeSeenUsecase? makeSeenUsecase;
  final NavigationService? navigationService;

  late final FirebaseMessaging _fcm;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late final AndroidNotificationChannel _channel;
  late final NotificationDetails _platformChannelSpecifics;
  late final InitializationSettings _initializationSettings;

  NotificationsService({
    // this.setTokenNotificationUsecase,
    // this.makeSeenUsecase,
    this.navigationService,
  });

  /// تهيئة الإشعارات بالكامل
  Future<void> init({bool isForeground = true}) async {
    _fcm = FirebaseMessaging.instance;
    await _createNotificationChannel();
    await _requestPermissions();
    _initializeLocalNotifications();
    _setupListeners();

    if (isForeground) {
      await _fcm.subscribeToTopic('all');
    }

    await _handleInitialMessage();
    _listenTokenRefresh();
  }

  /// إنشاء Notification Channel للأندرويد
  Future<void> _createNotificationChannel() async {
    _channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
  }

  /// طلب صلاحيات الإشعارات
  Future<void> _requestPermissions() async {
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// تهيئة Flutter Local Notifications
  void _initializeLocalNotifications() {
    _platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        color: AppColors.primary,
        importance: Importance.high,
      ),
    );

    _initializationSettings = InitializationSettings(
      android: const AndroidInitializationSettings('@mipmap/icon_notification'),
      iOS: const DarwinInitializationSettings(),
    );

    _flutterLocalNotificationsPlugin.initialize(
      _initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  /// الاستماع للرسائل أثناء تشغيل التطبيق
  void _setupListeners() {
    FirebaseMessaging.onMessage.listen((message) {
      _showNotification(message, isForeground: true);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // final notification = _parseNotification(message.data);
      // navigate(notification: notification);
    });
  }

  /// التعامل مع الرسالة عند فتح التطبيق من notification
  Future<void> _handleInitialMessage() async {
    // final initialMessage = await _fcm.getInitialMessage();
    // if (initialMessage != null) {
    //   final notification = _parseNotification(initialMessage.data);
    //   navigate(notification: notification);
    // }
  }

  /// عرض إشعار محلي
  Future<void> _showNotification(
    RemoteMessage message, {
    bool isForeground = false,
  }) async {
    final payload = jsonEncode(message.data);

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      _platformChannelSpecifics,
      payload: payload,
    );

    if (isForeground) {
      Future.delayed(
        const Duration(seconds: 5),
        () => _flutterLocalNotificationsPlugin.cancel(0),
      );
    }
  }

  /// عند الضغط على notification
  void _onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) {
    final payload = notificationResponse.payload;
    if (payload != null) {
      // final notification = _parseNotification(
      //   jsonDecode(payload) as Map<String, dynamic>,
      // );
      // navigate(notification: notification);
    }
  }

  /// تحويل الـ payload إلى notification
  // ItemNotification _parseNotification(Map<String, dynamic> data) {
  //   return ItemNotificationModel.fromJsonPayload(data);
  // }

  /// تحديث token
  void _listenTokenRefresh() {
    // _fcm.onTokenRefresh.listen((token) {
    //   if (Constants.token.isNotEmpty && setTokenNotificationUsecase != null) {
    //     setTokenNotificationUsecase!(
    //       SetTokenNotificationParams(fcmToken: token),
    //     );
    //   }
    // });
  }

  Future<String?> getToken() async {
    try {
      return await _fcm.getToken();
    } catch (_) {
      return null;
    }
  }

  /// التنقل عند الضغط على notification
  // Future<void> navigate({required ItemNotification notification}) async {
  //   if (makeSeenUsecase != null &&
  //       notification.id.isNotEmpty &&
  //       !notification.notificationIsSeen) {
  //     await makeSeenUsecase!(notification.id);
  //   }

  //   if (navigationService != null && notification.entityId.isNotEmpty) {
  //     switch (notification.type) {
  //       case NotificationTypeEnum.support_ticket_replied:
  //         navigationService!.pushNamed(
  //           Routes.ticketDetailsRoute,
  //           arguments: notification.entityId,
  //         );
  //         break;
  //       default:
  //         break;
  //     }
  //   }
  // }
}
