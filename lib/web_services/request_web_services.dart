import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/request.dart';

class RequestWebServices {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  RequestWebServices(this.firestore, this.firebaseAuth);

  Future<void> sendRequest(
      {required Request request, required String requestId}) async {
    try {
      Map<String, dynamic> requestData = request.requestToMap(request: request);
      await firestore.collection('requests').doc(requestId).set(requestData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addSentRequestsToUser(
      {required String senderId, required String requestId}) async {
    try {
      await firestore.collection('users').doc(senderId).update({
        'sentRequests': FieldValue.arrayUnion([requestId])
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addRequestToReceiverUser(
      {required String receiverId, required String requestId}) async {
    try {
      await firestore.collection('users').doc(receiverId).update({
        'receivedRequests': FieldValue.arrayUnion([requestId])
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> wasRequestSentToThisUserBefore(
      {required String currentUser, required String otherUser}) async {
    bool wasSent = false;
    try {
      var senderRequestSnapshot = await firestore
          .collection('requests')
          .where('senderId', whereIn: [currentUser, otherUser]).get();

      for (var request in senderRequestSnapshot.docs) {
        final requestData = request.data();

        // either the request documents have the currentUser as the sender then the other user must be the receiver
        // or the current User is the receiver then the other user must be the sender
        if ((requestData['senderId'] == currentUser &&
                requestData['receiverId'] == otherUser) ||
            (requestData['receiverId'] == currentUser &&
                requestData['senderId'] == otherUser)) {
          wasSent = true;
        }
      }
    } catch (error) {
      rethrow;
    }
    return wasSent;
  }

  Future<bool> areFriends({required String profileUserId}) async {
    bool friendAccepted = false;
    final currentUserId = firebaseAuth.currentUser!.uid;
    try {
      var profileUser =
          await firestore.collection('users').doc(profileUserId).get();
      if (profileUser.data() != null &&
          profileUser.data()!['friends'] != null) {
        List<dynamic> userFriends = profileUser.data()!['friends'];
        List<String> profileUserFriends = userFriends.cast<String>();
        friendAccepted = profileUserFriends.contains(currentUserId);
      }
    } catch (error) {
      rethrow;
    }
    return friendAccepted;
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> getReceivedRequests() async {
    QuerySnapshot<Map<String, dynamic>>? requestsSnapshot;
    final userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      requestsSnapshot = await firestore
          .collection('requests')
          .where('receiverId', isEqualTo: userId)
          .where('replied', isEqualTo: false)
          .get();
      return requestsSnapshot;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getRequestUserData(String userId) async {
    Map<String, dynamic> userData = {};
    try {
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      String name = usersSnapshot.data()!['name'];
      String image = usersSnapshot.data()!['image'];
      String gender = usersSnapshot.data()!['gender'];
      userData = {
        'name': name,
        'image': image,
        'gender': gender,
      };
    } catch (error) {
      rethrow;
    }
    return userData;
  }

  Future<void> acceptOrRejectRequest(
      {required String requestId,
      required bool isAccepted,
      required String senderId,
      required String receiverId}) async {
    try {
      await firestore
          .collection('requests')
          .doc(requestId)
          .update({'isAccepted': isAccepted, 'replied': true});

      if (isAccepted) {
        // if the user accept the request then add the 2 users to friends list in users collection
        await firestore.collection('users').doc(senderId).update({
          'friends': FieldValue.arrayUnion([receiverId])
        });
        await firestore.collection('users').doc(receiverId).update({
          'friends': FieldValue.arrayUnion([senderId])
        });
      }
    } catch (error) {
      rethrow;
    }
  }
}
