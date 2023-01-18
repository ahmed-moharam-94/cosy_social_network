import 'dart:io';

import 'package:cozy_social_media_app/models/user.dart';
import 'package:cozy_social_media_app/web_services/user_web_services.dart';
import 'package:flutter/foundation.dart';

class UserController with ChangeNotifier {
  final UserWebServices userWebServices;

  UserController(this.userWebServices);

  AppUser _currentUser = AppUser(id: '', name: '', image: '');

  AppUser get currentUser {
    return _currentUser;
  }

  File? userImageFile;

  void setUserImageFile(File? file) {
    userImageFile = file;
  }

  void resetImageFileToNull() {
    userImageFile = null;
  }

  File? userCoverImageFile;

  void setUserCoverImageFile(File? file) {
    userCoverImageFile = file;
  }

  void resetCoverImageFileToNull() {
    userCoverImageFile = null;
  }

  Future<void> getCurrentUserData() async {
    try {
      final userData = await userWebServices.getCurrentUserData();
      AppUser user = AppUser.fromMap(userData);
      _currentUser = user;
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> sendUserData(AppUser user) async {
    // if user have existing image
    String imageUrl = user.image;
    String coverUrl = user.cover;
    try {
      if (userImageFile != null) {
        // if image file != null
        // then user have chose an image, so update image url
        imageUrl =
            await userWebServices.uploadUserImageAndReturnUrl(userImageFile);
      }
      // send cover photo if it's not null
      if (userCoverImageFile != null) {
        coverUrl = await userWebServices
            .uploadUserCoverImageAndReturnUrl(userCoverImageFile);
      }

      await userWebServices.sendUserData(user, imageUrl, coverUrl);
      resetImageFileToNull();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<AppUser> getUserById(String userId) async {
    try {
      AppUser user = AppUser();
      var userDataSnapshot = await userWebServices.getUserById(userId);
      if (userDataSnapshot.data() != null) {
        user = AppUser.fromMap(userDataSnapshot.data()!);
      }
      return user;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return currentUser;
  }
}
