import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import '../constants/strings.dart';
import '../helpers/dynamic_link_service.dart';

class AuthWebServices {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthWebServices(this.firestore, this.firebaseAuth);

  int generateOtp() {
    var rnd = math.Random();
    var next = rnd.nextDouble();
    while (next < 1000) {
      next *= 10;
    }
    return next.toInt();
  }

  Future<void> sendOtp(String emailAddress) async {
    try {
      // generate otp code
      int otp = generateOtp();

      final currentUserId = firebaseAuth.currentUser!.uid;
      // send otp to user collection
      await firestore.collection('users').doc(currentUserId).update({
        'otp': otp,
        'isVerified': false,
      });


      // create dynamic link
      final dynamicLink = await DynamicLinkService.createDynamicLink();
      final smtpServer =
          gmail(applicationEmail, gmailApplicationPassword);
      final message = Message()
        ..from = const Address(
            'cozy.social.network@gmail.com', 'Cozy Social Network')
        ..recipients.add(emailAddress)
        ..subject = 'Verification Code'
        ..html = """
                <h2>Your verification code is \n $otp</h2>
                <h3>Open the app: \n $dynamicLink</h3>
              """;


      await send(message, smtpServer);
    } catch (error) {
      rethrow;
    }
  }

  Future<int> getOtpCode() async {
    int otp = 0000;
    final currentUserId = firebaseAuth.currentUser!.uid;
    try {
      var userSnapshot =
          await firestore.collection('users').doc(currentUserId).get();
      if (userSnapshot.data() != null && userSnapshot.data()!['otp'] != null) {
        otp = userSnapshot.data()!['otp'];
      }
      return otp;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> verifyEmail() async {
    try {
      final currentUserId = firebaseAuth.currentUser!.uid;
      await firestore.collection('users').doc(currentUserId).update({
        'otp': FieldValue.delete(),
        'isVerified': true,
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // safe the device taken (the device that user is signed in from)
      await saveDeviceTokenToUser();
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> signInWithFacebook() async {
    try {
      final _facebookLoginResult = await FacebookAuth.i.login();
      final _userData = await FacebookAuth.i.getUserData();

      // get token from facebook and put it in firestore
      final _userCredential = FacebookAuthProvider.credential(
          _facebookLoginResult.accessToken!.token);
      await firebaseAuth.signInWithCredential(_userCredential);
      final _userId = firebaseAuth.currentUser!.uid;
      await firestore.collection('users').doc(_userId).set({
        'email': _userData['email'],
        'userId': _userId,
        // if user signed in with facebook then the email is verified and no need to send otp
        'isVerified': true,
      });
      // safe the device taken (the device that user is signed in from)
      await saveDeviceTokenToUser();
      return true;
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final _userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // add user data to firestore
      final _user = _userCredential.user;
      await firestore.collection('users').doc(_user?.uid).set({
        'id': _user?.uid,
        'email': _user?.email,
      });
      // safe the device taken (the device that user is signed in from)
      await saveDeviceTokenToUser();
    } on FirebaseAuthException catch (error) {
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      final deviceToken = await requestDeviceToken();
      await resetDeviceTokenWhenUserSignOut(deviceToken);
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (error) {
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  Future<String?> requestDeviceToken() async {
    try {
      String? deviceToken = '';
      deviceToken = await FirebaseMessaging.instance.getToken();
      FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
        saveDeviceTokenToUser();
      });
      return deviceToken;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> saveDeviceTokenToUser() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final deviceToken = await requestDeviceToken();
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'devicesToken': FieldValue.arrayUnion([deviceToken])
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> resetDeviceTokenWhenUserSignOut(String? deviceToken) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'devicesToken': FieldValue.arrayRemove([deviceToken])
      });
    } catch (error) {
      rethrow;
    }
  }
}
