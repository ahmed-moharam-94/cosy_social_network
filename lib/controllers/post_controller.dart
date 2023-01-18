import 'dart:io';
import 'package:cozy_social_media_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/post.dart';
import '../web_services/post_web_service.dart';

class PostController with ChangeNotifier {
  final PostWebServices postWebService;

  PostController(this.postWebService);

  List<Post> _allPosts = [];

  List<Post> get allPosts {
    return [..._allPosts];
  }

  List<Post> _specificUserPosts = [];

  List<Post> get specificUserPosts {
    return [..._specificUserPosts];
  }


  File? imageFile;

  void setImageFile(File? file) {
    imageFile = file;
  }

  void resetImageFileToNull() {
    imageFile = null;
  }


  Future<void> getAllPosts() async {
    List<Post> allPosts = [];
    // get user posts raw data
    try {
      final posts = await postWebService.getAllPosts();
      // model the data
      posts.docs.map((postSnapshot) {
        final Post post = Post.fromMap(postSnapshot.data());
        allPosts.add(post);
      }).toList();
      _allPosts = allPosts;
      // shuffle posts to get random posts
      _allPosts.shuffle();
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> getSpecificUserPosts({String userId = ''}) async {
    List<Post> userPosts = [];
    // get user posts raw data
    try {
      final response = await postWebService.getSpecificUserPosts(userId);
      // model the data
      response.docs.map((postSnapshot) {
        final Post post = Post.fromMap(postSnapshot.data());
        userPosts.add(post);
      }).toList();
      _specificUserPosts = userPosts;
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }


  Future<void> createAndUpdateMyPost(Post post, AppUser user) async {
    // when updating get the post imageUrl
    String imageUrl = post.postImage;
    try {
      if (imageFile != null) {
        // user choose an image
        imageUrl = await postWebService.uploadPostImageAndReturnUrl(
            post.postId, imageFile);
      }
      await postWebService.createOrUpdatePost(post: post, user: user, imageUrl: imageUrl);
      // reset imageFile
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    resetImageFileToNull();
  }

  // delete post
  Future<void> deletePost(String postId) async {
    try {
      await postWebService.deletePost(postId);
      _allPosts.removeWhere((post) => post.postId == postId);
      _allPosts.removeWhere((post) => post.postId == postId);
      notifyListeners();
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        print(error);
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  bool isMyPost(Post post) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return post.userId == userId;
  }

  Future<int> getUserPostsNumber(String userId) async {
    try {
      return await postWebService.getUserPostsNumber(userId);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return 0;
    }
  }

}
