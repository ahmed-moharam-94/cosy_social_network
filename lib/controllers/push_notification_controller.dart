import 'package:flutter/foundation.dart';

import '../web_services/device_token_web_services.dart';

class PushNotificationController with ChangeNotifier {
  final PushNotificationWebServices pushNotificationWebServices;

  PushNotificationController(this.pushNotificationWebServices);

  List<String> _receiverDevicesTokens = [];

  List<String> get receiverDevicesTokens {
    return [..._receiverDevicesTokens];
  }

  Future<void> getReceiverDeviceToken({required String receiverUserId}) async {
    List<String> fetchedDevicesTokens = [];
    try {
      fetchedDevicesTokens = await pushNotificationWebServices
          .getReceiverDeviceToken(receiverUserId: receiverUserId);
      _receiverDevicesTokens = fetchedDevicesTokens;
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('$error getReceiverDeviceToken');
      }
    }
  }


  Future<void> sendPushNotification(
      {required String title,
        required String body,
        required String type,
        required List<String> devicesTokens}) async {
    try {

      // for ever device token send a notification
      for (String token in devicesTokens) {
        await pushNotificationWebServices.sendPushNotification(
            title, body, token, type);
      }
    } catch (error) {
      if (kDebugMode) {
        print('$error sendPushNotification');
      }
    }
  }
}
