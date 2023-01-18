import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  late String commentId;
  late String postId;
  late String userId;
  late String userName;
  late String userImage;
  late String userGender;
  late String text;
  late Timestamp createDate;


  Comment({
    required this.commentId,
    required this.postId,
    required this.userId,
    required this.text,
    required this.createDate,
    required this.userName,
    required this.userImage,
    required this.userGender,
  });

  factory Comment.fromMap(Map<String, dynamic> commentData) {
    return Comment(
      commentId: commentData['commentId'] ?? '',
      postId: commentData['postId'] ?? '',
      userId: commentData['userId'] ?? '',
      text: commentData['text'] ?? '',
      userName: commentData['userName']?? '',
      userImage: commentData['userImage']?? '',
      userGender: commentData['userGender']?? '',
      createDate: commentData['createDate'] ?? '',
    );
  }

  Map<String, dynamic> toMap(Comment comment, String commentId, String userId) {
    return {
      'commentId': commentId,
      'postId': comment.postId,
      'userId': userId,
      'text': comment.text,
      'userName': comment.userName,
      'userImage': comment.userImage,
      'userGender': comment.userGender,
      'createDate': comment.createDate,
    };
  }
}
