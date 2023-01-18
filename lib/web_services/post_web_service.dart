import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cozy_social_media_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/post.dart';

class PostWebServices {
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;

  PostWebServices(this.firestore, this.firebaseStorage);

  Future<QuerySnapshot<Map<String, dynamic>>> getAllPosts() async {
    QuerySnapshot<Map<String, dynamic>> _fetchedPosts;
    try {
        _fetchedPosts =
            await firestore.collection('posts').orderBy('postDate', descending: true).get();
    } on FirebaseException catch (error) {
      throw Exception(error);
    } catch (error) {
      throw Exception(error);
    }
    return _fetchedPosts;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSpecificUserPosts(String userId) async {
    QuerySnapshot<Map<String, dynamic>> _fetchedPosts;
    try {
        // if user id is available then get specific user posts
        _fetchedPosts = await firestore
            .collection('posts')
            .orderBy('postDate', descending: true)
            .where('userId', isEqualTo: userId)
            .get();
    } on FirebaseException catch (error) {
      throw Exception(error);
    } catch (error) {
      throw Exception(error);
    }
    return _fetchedPosts;
  }

  Future<void> addPostIdToUserDocument(String postId, String userId) async {
    try {
      await firestore.collection('users').doc(userId).update({
        'posts': FieldValue.arrayUnion([postId]),
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> createOrUpdatePost(
      {required Post post,
      required String imageUrl,
      required AppUser user}) async {
    // postId from post object because it's already exist when updating
    String postId = post.postId;
    if (postId == '') {
      // if it's a new post
      postId = firestore.collection('posts').doc().id;
    }
    Map<String, dynamic> postData = post.postToMap(
        post: post, postId: postId, postImageUrl: imageUrl, user: user);
    try {
      // update post document
      await firestore.collection('posts').doc(postId).set(postData);
      // update user posts with the new image
      await addPostIdToUserDocument(postId, user.id);
    } on FirebaseException catch (error) {
      throw Exception(error);
    } catch (error) {
      throw Exception(error);
    }
  }

  // upload image to firebase storage
  Future<String> uploadPostImageAndReturnUrl(
      String postId, File? imageFile) async {
    String imageUrl = '';
    // Create a storage reference from our app
    final storageRef = firebaseStorage.ref();
    // create a reference to the image avatar : posts_images/postId/postAvatar.jpg
    final imageBucketReference =
        storageRef.child('posts_images/$postId/postAvatar.jpg');
    // exit function if stored image == null
    if (imageFile != null) {
      // get image file path from storage
      try {
        await imageBucketReference.putFile(imageFile);
        // get the file url
        imageUrl = await imageBucketReference.getDownloadURL();
      } on FirebaseException catch (error) {
        throw Exception(error);
      } catch (error) {
        throw Exception(error);
        // catch any other errors
      }
    }
    // return image download url
    return imageUrl;
  }

  Future<void> deletePost(String postId) async {
    final _currentUserId = FirebaseAuth.instance.currentUser!.uid;

    try {
      // delete post from post collection
      await firestore.collection('posts').doc(postId).delete();
      // delete post from user post ids list
      await firestore.collection('users').doc(_currentUserId).update({
        'posts': FieldValue.arrayRemove([postId]),
      });
    } on FirebaseException {
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  Future<int> getUserPostsNumber(String userId) async {
    int numberOfPosts = 0;
    try {
      var user = await firestore.collection('users').doc(userId).get();
      if (user.exists && user.data()!['posts'] != null) {
        List userPosts = user.data()!['posts'];
        numberOfPosts = userPosts.length;
      }
    } on FirebaseException {
      rethrow;
    } catch (error) {
      rethrow;
    }
    return numberOfPosts;
  }
}
