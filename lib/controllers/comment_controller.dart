
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cozy_social_media_app/web_services/comments_web_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/comment.dart';

class CommentController with ChangeNotifier {
  final CommentsWebServices commentsWebServices;
  CommentController(this.commentsWebServices);

  List<Comment> _allComments = [];
  List<Comment> get allComments {
    return [..._allComments];
  }

  List<Comment> _userComments = [];
  List<Comment> get userComments {
    return [..._userComments];
  }

  Future<void> sendComment(Comment comment) async {
    final String commentId = FirebaseFirestore.instance.collection('comments').doc().id;

    try {
      await commentsWebServices.sendComment(comment, commentId);
      await commentsWebServices.addCommentToPost(comment.postId, commentId);
      await commentsWebServices.addCommentIdToUser(commentId);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> getPostCommentsExceptUsersComment(String postId) async {
    _allComments = [];
    try {
      var commentsSnapshot = await commentsWebServices.getPostCommentsExceptUsersComment(postId);
      commentsSnapshot.docs.map((commentSnapshot) {
        final Comment comment = Comment.fromMap(commentSnapshot.data());
        _allComments.add(comment);
      }).toList();
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> getUserComments(String postId) async {
    _userComments = [];

    try {
      var commentsSnapshot = await commentsWebServices.getUserComments(postId);
      commentsSnapshot.docs.map((commentSnapshot) {
        final Comment comment = Comment.fromMap(commentSnapshot.data());
        _userComments.add(comment);
      }).toList();
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  bool isMyComment(String userId) {
    return userId == FirebaseAuth.instance.currentUser!.uid;
  }

  Future<int> getUserNumberOfCommentsInPost(String postId) async {
    try {
      return commentsWebServices.getUserNumberOfCommentsInPost(postId);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return 0;
    }
  }

  Future<int> getNumberOfComments(String postId) async {
    try {
      return await commentsWebServices.getNumberOfComments(postId);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return 0;
    }
  }
}

