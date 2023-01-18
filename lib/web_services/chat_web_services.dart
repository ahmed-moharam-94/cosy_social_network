import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatWebServices {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ChatWebServices(this.firestore, this.firebaseAuth);

  Future<void> createChat(
      {required Map<String, dynamic> chatData,
      required String chatId,
      required String senderId,
      required String receiverId}) async {
    try {
      await firestore.collection('chats').doc(chatId).set(chatData);
      // add chat to both of users documents
      await addChatToUsers(
          senderId: senderId, receiverId: receiverId, chatId: chatId);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addChatToUsers(
      {required String senderId,
      required String receiverId,
      required String chatId}) async {
    try {
      await firestore.collection('users').doc(senderId).update({
        'chats': FieldValue.arrayUnion([chatId]),
      });
      await firestore.collection('users').doc(receiverId).update({
        'chats': FieldValue.arrayUnion([chatId]),
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<List<QuerySnapshot<Map<String, dynamic>>>?> getChats() async {
    List<QuerySnapshot<Map<String, dynamic>>>? _fetchedChatsSnapshots = [];
    try {
      final currentUserId = firebaseAuth.currentUser!.uid;
      final userDocument =
          await firestore.collection('users').doc(currentUserId).get();
      List<String> chatsIds = userDocument.data()!['chats'].cast<String>();

      List<List<String>> subLists = batchList(chatsIds);

      for (List<String> ids in subLists) {
        QuerySnapshot<Map<String, dynamic>>? _fetchedChatsSnapshot;
        // get posts raw data
        if (chatsIds.isNotEmpty) {
          _fetchedChatsSnapshot = await firestore
              .collection('chats')
              .where('chatId',
                  whereIn:
                      ids) // use where to filter user post from showing in home screen
              .get();
        }
        _fetchedChatsSnapshots.add(_fetchedChatsSnapshot!);
      }
      return _fetchedChatsSnapshots;
    } catch (error) {
      rethrow;
    }
  }

  List<List<String>> batchList(List<String> items) {
    // batch list to lists with length <= 10
    // required for firebase query using where in
    List<List<String>> subLists = [];
    int step = 10;
    for (int i = 0; i < items.length; i += step) {
      List<String> subList = [];
      int end = i + step > items.length ? i + (items.length - i) : i + step;
      subList = items.sublist(i, end);
      subLists.add(subList);
    }
    return subLists;
  }

  Future<bool> isCurrentUserFirstUser(String chatId) async {
    bool isFirstUser = false;
    try {
      var chatDocument = await firestore.collection('chats').doc(chatId).get();
      final currentUserId = firebaseAuth.currentUser!.uid;
      final String firstUserId = chatDocument.data()!['chatFirstUserId'];
      isFirstUser = currentUserId == firstUserId;
      return isFirstUser;
    } catch (error) {
      rethrow;
    }
  }
}
