import 'package:cozy_social_media_app/web_services/auth_web_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthController with ChangeNotifier {
  final AuthWebServices authWebServices;

  AuthController(this.authWebServices);

  int _sentOtp = 0000;
  int get sentOtp {
    return _sentOtp;
  }

  Future<void> sendOtp(String email) async {
    try {
      await authWebServices.sendOtp(email);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> getOtp() async {
    try {
      int otp = await authWebServices.getOtpCode();
      _sentOtp = otp;
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> verifyEmail() async {
    try {
      await authWebServices.verifyEmail();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  // validate email
  String? validateEmailText(String? value) {
    const _emailRegPattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z]+";
    RegExp regex = RegExp(_emailRegPattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'Enter a valid email address';
    } else {
      return null;
    }
  }

  // validate password
  String? validatePasswordText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 8) {
      return 'Please enter at least 8 characters';
    } else {
      return null;
    }
  }


  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await authWebServices.signInWithEmailAndPassword(email, password);
      notifyListeners();
    } on FirebaseAuthException catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<bool> signInWithFacebook() async {
    try {
      await authWebServices.signInWithFacebook();
      return true;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      await authWebServices.registerWithEmailAndPassword(email, password);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await authWebServices.signOut();
    }  catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }



}
