import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  late String requestId;
  late Timestamp requestDate;
  late String senderId;
  late String receiverId;
  late bool isAccepted;
  late bool replied;

  Request({
    required this.requestId,
    required this.requestDate,
    required this.senderId,
    required this.receiverId,
    required this.isAccepted,
    required this.replied,
  });

  Map<String, dynamic> requestToMap({required final Request request}) {
    return {
      'requestId': request.requestId,
      'requestDate': request.requestDate,
      'senderId': request.senderId,
      'receiverId': request.receiverId,
      'isAccepted': request.isAccepted,
      'replied': request.replied,
    };
  }

  factory Request.fromFireStore(
      {
        required Map<String, dynamic> requestSnapshot,
     }) {

    // sender name, receiver name, senderImageUrl and gender will be fetched from post collection
    // so when the user update the name or the image it will appear in the request
    return Request(
      requestId: requestSnapshot['requestId'] ?? 'Error',
      requestDate: requestSnapshot['requestDate'] ?? 'Error',
      senderId: requestSnapshot['senderId'] ?? 'Error',
      receiverId: requestSnapshot['receiverId'] ?? 'Error',
      isAccepted: requestSnapshot['isAccepted'] ?? false,
      replied: requestSnapshot['replied'] ?? false,
    );
  }
}
