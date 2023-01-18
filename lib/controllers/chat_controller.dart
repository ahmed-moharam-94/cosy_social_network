import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cozy_social_media_app/models/chat.dart';
import 'package:cozy_social_media_app/web_services/chat_web_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ChatController with ChangeNotifier {
  final ChatWebServices chatWebServices;

  ChatController(this.chatWebServices);


  List<Chat> _chats = [];

  List<Chat> get chats {
    return [..._chats];
  }

  Future<void> createChat(
      {required Chat chat}) async {
    try {
      final chatData = chat.chatToMap(chat);
      await chatWebServices.createChat(
          chatData: chatData,
          chatId: chat.chatId,
          senderId: chat.firstUserId,
          receiverId: chat.secondUserId);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> getChats() async {
    List<Chat> fetchedChats = [];
    try {
      var chatsSnapshots =
          await chatWebServices.getChats();
      if (chatsSnapshots != null) {
        for (var querySnapshot in chatsSnapshots) {
          querySnapshot.docs.map((chatSnapshot) {
            final Chat chat = Chat.fromMap(chatSnapshot.data());
            fetchedChats.add(chat);
          }).toList();
          _chats = fetchedChats;
        }
      }
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<bool> isFirstUserId(String chatId) async {
    bool isFirstUser = false;
    try {
      isFirstUser = await chatWebServices.isCurrentUserFirstUser(chatId);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return isFirstUser;
  }
}
