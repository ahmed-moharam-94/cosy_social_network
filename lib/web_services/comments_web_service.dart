import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/comment.dart';

class CommentsWebServices {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  CommentsWebServices(this.firestore, this.firebaseAuth);

  Future<void> sendComment(Comment comment, String commentId) async {
    final String userId = firebaseAuth.currentUser!.uid;
    try {
      await firestore
          .collection('comments')
          .doc(commentId)
          .set(comment.toMap(comment, commentId, userId));
    } catch (error) {

      rethrow;
    }
  }

  Future<void> addCommentToPost(String postId, String commentId) async {
    try {
      await firestore.collection('posts').doc(postId).update({
        'comments': FieldValue.arrayUnion([commentId])
      });

    } catch (error) {
      rethrow;
    }
  }

  Future<void> addCommentIdToUser(String commentId) async {
    final userId = firebaseAuth.currentUser!.uid;
    try {
      await firestore.collection('users').doc(userId).update({
        'comments': FieldValue.arrayUnion([commentId])
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPostCommentsExceptUsersComment(
      String postId) async {
    final userId = firebaseAuth.currentUser!.uid;
    try {
      var commentsQuerySnapshot = await firestore
          .collection('comments')
          .where('userId', isNotEqualTo: userId)
          .where('postId', isEqualTo: postId)
          .get();

      return commentsQuerySnapshot;
    } catch (error) {
      rethrow;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserComments(
      String postId) async {
    final userId = firebaseAuth.currentUser!.uid;
    try {
      var commentsQuerySnapshot = await firestore
          .collection('comments')
          .where('userId', isEqualTo: userId)
          .where('postId', isEqualTo: postId)
          .get();

      return commentsQuerySnapshot;
    } catch (error) {
      rethrow;
    }
  }

  Future<int> getUserNumberOfCommentsInPost(String postId) async {
    final userId = firebaseAuth.currentUser!.uid;
    try {
      var userComments = await firestore
          .collection('comments')
          .where('postId', isEqualTo: postId)
          .where('userId', isEqualTo: userId)
          .get();
      return userComments.docs.length;
    } catch (error) {
      rethrow;
    }
  }

  Future<int> getNumberOfComments(String postId) async {
    int numberOfComments = 0;
    try {
      var post =  await firestore.collection('posts').doc(postId).get();
      if (post.data() != null) {
        List comments = post.data()!['comments'];
        numberOfComments = comments.length;
      }
    } catch (error) {
      rethrow;
    }
    return numberOfComments;
  }
}
