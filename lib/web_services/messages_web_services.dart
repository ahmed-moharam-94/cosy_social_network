import 'dart:io';

import 'package:cozy_social_media_app/models/message.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MessagesWebService {
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;

  MessagesWebService(this.firestore, this.firebaseStorage);

  Future<void> sendTextMessage(Message message) async {
    Map<String, dynamic> messageData = message.toMap(message: message);
    try {
      await firestore.collection('messages').add(messageData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addMessagesToChat(String chatId, String messageId) async {
    try {
      await firestore.collection('chats').doc(chatId).update({
        'messages': FieldValue.arrayUnion([messageId])
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<String> uploadImageToFirebaseStorage(File imageFile) async {
    try {
      String fileBaseName = basename(imageFile.path);

      final bucketReference = firebaseStorage
          .ref()
          .child('chatImages')
          .child(fileBaseName);

      await bucketReference.putFile(imageFile);
      // return image url
      return await bucketReference.getDownloadURL();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> sendImageMessage(Message message, File imageFile) async {
    try {
      // get image url
      final String imageMessageUrl =
          await uploadImageToFirebaseStorage(imageFile);
      Map<String, dynamic> messageData =
          message.toMap(message: message, imageUrl: imageMessageUrl);
      // send message to fireStore
      await firestore.collection('messages').add(messageData);
    } catch (error) {
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesStream() {
    try {
      return firestore
          .collection('messages')
          .orderBy('createDate', descending: true)
          .snapshots();
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getLastMessageInfo(String chatId) async {
    Map<String, dynamic> lastMessageInfo = {};

    try {
      final chatSnapshot = await firestore
          .collection('messages')
          .where('chatId', isEqualTo: chatId)
          .orderBy('createDate', descending: true)
          .get();
      String lastMessage = chatSnapshot.docs.first.get('text');
      String senderId = chatSnapshot.docs.first.get('senderId');

      lastMessageInfo = {
        'message': lastMessage,
        'senderId': senderId,
      };
      return lastMessageInfo;
    } catch (error) {
      rethrow;
    }
  }
}
