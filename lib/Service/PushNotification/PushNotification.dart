import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/GlobalValue.dart';
import 'package:live_yoko/Navigation/Navigation.dart';

import '../../Utils/Utils.dart';
import '../APICaller.dart';

class PushNotifications {
  static final firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // request notification permission
  static Future init() async {
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    var token = await PushNotifications.firebaseMessaging.getToken();
    GlobalValue.getInstance().setFCMToken(token!);
  }

// initalize local notifications
  static Future localNotiInit() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();
    final didNotificationLaunchApp = await notificationAppLaunchDetails
            ?.didNotificationLaunchApp ??
        false; // khai báo biến check xem thông báo click vào khi app đã kết thúc hay chưa

    if (notificationAppLaunchDetails != null &&
            notificationAppLaunchDetails.didNotificationLaunchApp) {
      Map<String, dynamic> data = await jsonDecode(
          notificationAppLaunchDetails.notificationResponse!.payload!);

      await onNotificationTap(
          notificationAppLaunchDetails.notificationResponse!);
    }

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  // khi chạm vào thông báo cục bộ ở nền trước
  static onNotificationTap(NotificationResponse notificationResponse) {
    Map<String, dynamic> data = jsonDecode(notificationResponse.payload!);
    navigationInNotification(data);
  }

  static navigationInNotification(dynamic data) async {
    // switch (data['type'] == 1) {
    //   default:
    //     return Dashboard(); // uuid đoạn chat   data['id']
    // }
  }

  // show a simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('chat_app', 'chat_app channel',
            channelDescription: 'your channel description',
            channelShowBadge: true,
            icon: '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
            fullScreenIntent: true);
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }
}
