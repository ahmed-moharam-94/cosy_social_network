import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  String chatId;
  Timestamp createDate;
  String senderId;
  String text;

  Message({
    required this.id,
    required this.chatId,
    required this.createDate,
    required this.senderId,
    required this.text,
  });

  factory Message.fromMap(Map<String, dynamic> messageData) {
    return Message(
      id: messageData['id'],
      chatId: messageData['chatId'],
      createDate: messageData['createDate'],
      senderId: messageData['senderId'],
      text: messageData['text'],
    );
  }

  Map<String, dynamic> toMap({required Message message, String imageUrl = ''}) {
    if (imageUrl == '') {
      // if the message is not image
      return {
        'id': message.id,
        'chatId': message.chatId,
        'createDate': message.createDate,
        'senderId': message.senderId,
        'text': message.text
      };
    } else {
      return {
        'id': message.id,
        'chatId': message.chatId,
        'createDate': message.createDate,
        'senderId': message.senderId,
        'text': imageUrl
      };
    }

  }
}
