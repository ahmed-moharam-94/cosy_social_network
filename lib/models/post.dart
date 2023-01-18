import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cozy_social_media_app/models/user.dart';

class Post {
  late String postId;
  late String userId;
  late String topic;
  late String postImage;
  late String experience;
  late String opinion;
  late String userGender;
  late Timestamp postDate;

  Post({
    required this.postId,
    required this.userId,
    required this.postDate,
    required this.topic,
    required this.postImage,
    required this.experience,
    required this.userGender,
    required this.opinion,
  });

  factory Post.fromMap(Map<String, dynamic> postSnapShot) {
    return Post(
      postId: postSnapShot['postId'] ?? '',
      userId: postSnapShot['userId'] ?? '',
      postDate: postSnapShot['postDate'] ?? '',
      topic: postSnapShot['topic'] ?? '',
      postImage: postSnapShot['postImage'] ?? '',
      experience: postSnapShot['experience'] ?? '',
      userGender: postSnapShot['userGender'] ?? '',
      opinion: postSnapShot['opinion'] ?? '',
    );
  }

  Map<String, dynamic> postToMap({
    required Post post,
    required String postId,
    required postImageUrl,
    required AppUser user,
  }) {
    return {
      'postId': postId,
      'userId': user.id,
      'postDate': Timestamp.now(),
      'topic': post.topic,
      'postImage': postImageUrl,
      'experience': post.experience,
      'userGender': post.userGender,
      'opinion': post.opinion,
    };
  }
}
