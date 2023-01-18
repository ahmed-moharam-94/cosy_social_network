import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../constants/strings.dart';

class PushNotificationWebServices {
  final FirebaseFirestore firestore;

  PushNotificationWebServices(this.firestore);

  Future<List<String>> getReceiverDeviceToken(
      {required String receiverUserId}) async {
    List<String> receiverDeviceToken = [];
    try {
      var userDoc =
          await firestore.collection('users').doc(receiverUserId).get();
      if (userDoc.data() != null && userDoc.data()!['devicesToken'] != null) {
        List<dynamic> tokens = userDoc.data()!['devicesToken'];
        receiverDeviceToken = tokens.cast<String>();
      }
    } catch (error) {
      rethrow;
    }
    return receiverDeviceToken;
  }

  Future<void> sendPushNotification(
      String title, String body, String token, String type) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': fcmServer
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            // this is for clickable notification
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'type': type,
              'body': body,
              'title': title,
            },
            "notification": <String, dynamic>{
              "title": title,
              'type': type,
              "body": body,
              'android_channel_id': notificationChannelId
            },
            "to": token
          }));
    } catch (error) {
      rethrow;
    }
  }
}
