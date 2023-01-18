import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../constants/strings.dart';

class NotificationService {
  Future<void> initNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      onDidReceiveNotificationResponse) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: initializationSettingsDarwin);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    listenToFirebaseMessages(flutterLocalNotificationsPlugin);
  }

  Future<void> listenToFirebaseMessages(flutterLocalNotificationsPlugin) async {
    // listen to firebase messaging and then fire local notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      showNotification(message, flutterLocalNotificationsPlugin);
    });
  }

  Future<void> showNotification(RemoteMessage message,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    BigTextStyleInformation bigTextStyleInformation = const BigTextStyleInformation(
     ' message.notification!.body!',
      htmlFormatBigText: true,
      contentTitle: 'message.notification!.title',
      htmlFormatContentTitle: true,
    );

    // setup Android local notification details
    String channelId = notificationChannelId;
    String channelName = notificationChannelName;

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.high,
      styleInformation: bigTextStyleInformation,
      priority: Priority.high,
      playSound: true,
    );

    // assign Android and IOS notifications details to
    final notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: const DarwinNotificationDetails(),
    );

    if (message.notification != null) {
      await flutterLocalNotificationsPlugin.show(
        0,
        'message.notification?.title',
       ' message.notification?.body',
        notificationDetails,
        payload: message.data['body'],
      );
    }
  }

  Future<void> requestFCMPermissions() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    NotificationSettings notificationSettings =
        await firebaseMessaging.requestPermission(
            alert: true,
            badge: true,
            sound: true,
            announcement: false,
            carPlay: false,
            criticalAlert: false,
            provisional: false);
    if (kDebugMode) {
      if (notificationSettings.authorizationStatus ==
          AuthorizationStatus.authorized) {
        print('user granted auth');
      } else if (notificationSettings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('user grant provisional permission');
      } else {
        print('user did not grant permission');
      }
    }
  }
}
