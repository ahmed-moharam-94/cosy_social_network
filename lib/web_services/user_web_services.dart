import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cozy_social_media_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserWebServices {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  UserWebServices(this.firestore, this.firebaseAuth, this.firebaseStorage);

  Future<Map<String, dynamic>> getCurrentUserData() async {
    String userId = firebaseAuth.currentUser!.uid;
    Map<String, dynamic> userData = {};
    try {
      final userSnapshot =
          await firestore.collection('users').doc(userId).get();
      if (userSnapshot.data() != null) {
        userData = userSnapshot.data()!;
      }
      return userData;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> sendUserData(AppUser user, String imageUrl, String coverUrl) async {
    final userId = firebaseAuth.currentUser?.uid;
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .update(user.userToMap(user, imageUrl, coverUrl));
    } catch (error) {
      rethrow;
    }
  }

  Future<String> uploadUserImageAndReturnUrl(File? imageFile) async {
    final userId = firebaseAuth.currentUser!.uid;
    try {
      // upload image to firebase storage
      String imageUrl = '';
      // Create a storage reference from our app
      final storageRef = firebaseStorage.ref();
      // create a reference to the image avatar : posts_images/postId/postAvatar.jpg
      final imageBucketReference =
      storageRef.child('users_images/$userId/userAvatar.jpg');
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
    } catch (error) {
      rethrow;
    }
  }

  Future<String> uploadUserCoverImageAndReturnUrl(File? coverFile) async {
    final userId = firebaseAuth.currentUser!.uid;
    try {
      // upload image to firebase storage
      String coverUrl = '';
      // Create a storage reference from our app
      final storageRef = firebaseStorage.ref();
      // create a reference to the image avatar : posts_images/postId/postAvatar.jpg
      final imageBucketReference =
          storageRef.child('users_covers/$userId/userCover.jpg');
      // exit function if stored image == null
      if (coverFile != null) {
        // get image file path from storage
        try {
          await imageBucketReference.putFile(coverFile);
          // get the file url
          coverUrl = await imageBucketReference.getDownloadURL();


          
        } on FirebaseException catch (error) {
          throw Exception(error);
        } catch (error) {
          throw Exception(error);
          // catch any other errors
        }
      }
      // return image download url
      return coverUrl;
    } catch (error) {
      rethrow;
    }
  }


  Future<DocumentSnapshot<Map<String, dynamic>>> getUserById(String userId) async {
    try {
      return await firestore.collection('users').doc(userId).get();
    } catch (error) {
      rethrow;
    }
  }
}
