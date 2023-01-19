import 'package:cozy_social_media_app/models/request.dart';
import 'package:cozy_social_media_app/web_services/request_web_services.dart';
import 'package:flutter/foundation.dart';

class RequestController with ChangeNotifier {
  final RequestWebServices requestWebServices;

  RequestController(this.requestWebServices);

  List<Request> _receivedRequests = [];

  List<Request> get receivedRequests {
    return [..._receivedRequests];
  }

  Future<void> sendRequest({required Request request}) async {
    try {
      await requestWebServices.sendRequest(
          request: request, requestId: request.requestId);
      await requestWebServices.addSentRequestsToUser(
          senderId: request.senderId, requestId: request.requestId);
      await requestWebServices.addRequestToReceiverUser(
          receiverId: request.receiverId, requestId: request.requestId);
    } catch (error) {
      if (kDebugMode) {
        print('$error sendRequest');
      }
    }
  }

  Future<void> getReceivedRequests() async {
    _receivedRequests = [];
    List<Request> _requests = [];
    try {
      final receivedRequests = await requestWebServices.getReceivedRequests();
      if (receivedRequests != null && receivedRequests.docs.isNotEmpty) {
        receivedRequests.docs.map((request) async {
          final receivedRequest =
              Request.fromFireStore(requestSnapshot: request.data());
          _requests.add(receivedRequest);
        }).toList();

        _receivedRequests = _requests;
        notifyListeners();
      }
    } catch (error) {
      if (kDebugMode) {
        print('$error getReceivedRequests');
      }
    }
  }

  Future<bool> wasRequestSentToThisUserBefore(
      {required String senderId, required String receiverId}) async {
    bool wasSent = false;
    try {
      wasSent = await requestWebServices.wasRequestSentToThisUserBefore(
          currentUser: senderId, otherUser: receiverId);
    } catch (error) {
      if (kDebugMode) {
        print('$error wasRequestSentToThisUserBefore');
      }
    }
    return wasSent;
  }

  Future<bool> areFriends(
      {required String profileUserId}) async {
    bool areFriends = false;
    try {
      areFriends = await requestWebServices.areFriends(
          profileUserId: profileUserId);
    } catch (error) {
      if (kDebugMode) {
        print('$error areFriends');
      }
    }
    return areFriends;
  }

  Future<void> acceptOrRejectRequest(
      {required String requestId, required bool isAccepted, required String senderId, required receiverId}) async {
    try {
      await requestWebServices.acceptOrRejectRequest(
          requestId: requestId, isAccepted: isAccepted, senderId: senderId, receiverId: receiverId);
      _receivedRequests
          .removeWhere((request) => request.requestId == requestId);
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('$error acceptOrRejectRequest');
      }
    }
  }
}
