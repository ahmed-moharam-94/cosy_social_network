import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cozy_social_media_app/web_services/messages_web_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../constants/strings.dart';
import '../models/message.dart';

class MessagesController with ChangeNotifier {
  final MessagesWebService messagesWebService;

  MessagesController(this.messagesWebService);

  Future<void> sendTextMessage(Message message) async {
    try {
      await messagesWebService.sendTextMessage(message);
      // add message to chat
      await messagesWebService.addMessagesToChat(message.chatId, message.id);
    } catch (error) {
      if (kDebugMode) {
        print('$error sendTextMessage');
      }
    }
  }

  Future<void> sendImageMessage(Message message, File imageFile) async {
    try {
      await messagesWebService.sendImageMessage(message, imageFile);
      // add message to chat
      await messagesWebService.addMessagesToChat(message.chatId, message.id);
    } catch (error) {
      if (kDebugMode) {
        print('$error sendImageMessage');
      }
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesStream()  {
    Stream<QuerySnapshot<Map<String, dynamic>>> messagesStream = const Stream.empty();
    try {
      messagesStream =  messagesWebService.getMessagesStream();
    } catch (error) {
      if (kDebugMode) {
        print('$error getMessagesStream');
      }
    }
    return messagesStream;
  }

  Future<Map<String, dynamic>> getLastMessageInfo(String chatId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    Map<String, dynamic> lastMessageInfo = {};
    String sender = '';
    try {
      lastMessageInfo = await messagesWebService.getLastMessageInfo(chatId);
      String senderId = lastMessageInfo['senderId'];
      String message = lastMessageInfo['message'];
      if (senderId == userId) {
        sender = 'You';
      }
      // if the last message is image
      if (message.contains(imageMessageBucket)) {
        message = 'Sent an Attachment';
      }
      lastMessageInfo = {
        'message': message,
        'sender': sender,
      };
      return lastMessageInfo;
    } catch (error) {
      if (kDebugMode) {
        print('$error getLastMessageInfo');
      }
      return {};
    }
  }
}
