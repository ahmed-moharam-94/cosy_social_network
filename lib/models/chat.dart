import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  late String chatId;
  late String firstUserId; //  first user is the one who sent the request
  late String secondUserId; //  first user is the one who approved the request
  late String approvedRequestId;
  late Timestamp chatCreatedDate;

  Chat(
      {required this.chatId,
      required this.firstUserId,
      required this.secondUserId,
      required this.approvedRequestId,
      required this.chatCreatedDate});

  factory Chat.fromMap(Map<String, dynamic> chatSnapshot) {
    // get users names and images from user
    return Chat(
        chatId: chatSnapshot['chatId'],
        firstUserId: chatSnapshot['chatFirstUserId'] ?? 'Error',
        secondUserId: chatSnapshot['chatSecondUserId'] ?? 'Error',
        approvedRequestId: chatSnapshot['approvedRequestId'] ?? 'Error',
        chatCreatedDate: chatSnapshot['chatCreatedDate']);
  }

  Map<String, dynamic> chatToMap(Chat chat) {
    return {
      'chatId': chat.chatId,
      'chatFirstUserId': chat.firstUserId,
      'chatSecondUserId': chat.secondUserId,
      'approvedRequestId': chat.approvedRequestId,
      'chatCreatedDate': chat.chatCreatedDate,
    };
  }
}
