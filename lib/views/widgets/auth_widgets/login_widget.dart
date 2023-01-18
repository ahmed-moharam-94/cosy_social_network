import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../constants/dims.dart';
import '../../../controllers/auth_controller.dart';
import '../../screens/main_screen.dart';
import 'login_form_widget.dart';

class LoginWidget extends StatefulWidget {
  // login call back function to pass bool isLogin = false to authentication widget
  final void Function(bool isLogin) loginCallBack;

  const LoginWidget({Key? key, required this.loginCallBack}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool _isLoading = false;

  Future<void> loginWithFacebook() async {
    toggleLoading(true);
    try {
      await tryToLoginWithFacebook();
    } on FirebaseException catch (error) {
      displayErrorSnackBar(error);
    } catch (error) {
      displayErrorSnackBar(error);
    }
    toggleLoading(false);
  }

  Future<void> tryToLoginWithFacebook() async {
    bool _isSignedIn = await Provider.of<AuthController>(context, listen: false)
        .signInWithFacebook();
    if (_isSignedIn) {
      // push if signed in
      navigateToBaseScreen();
    }
  }

  void toggleLoading(bool isLoading) {
    if (mounted) {
      setState(() {
        _isLoading = isLoading;
      });
    }
  }

  void displayErrorSnackBar(error) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(error.toString())));
  }

  void navigateToBaseScreen() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('Login'),
      padding: const EdgeInsets.symmetric(horizontal: largePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoginFormWidget(),
          const SizedBox(height: largePadding),
          const Text('Or Login by',
              style:
                  TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: mediumPadding),
          loginByFacebookButtonBuilder(),
          const SizedBox(height: mediumPadding),
          doNotHaveAccountWidgetBuilder(),
        ],
      ),
    );
  }

  Widget loginByFacebookButtonBuilder() {
    return SizedBox(
      width: double.infinity,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ElevatedButton.icon(
              onPressed: loginWithFacebook,
              icon: const Icon(Icons.facebook, color: Colors.white),
              style: ElevatedButton.styleFrom(backgroundColor: facebookColor),
              label: const Text('Facebook')),
    );
  }

  Widget doNotHaveAccountWidgetBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don\'t have an account?',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        TextButton(
            child: const Text('Create Account'),
            // pass false to authentication widget
            onPressed: () => widget.loginCallBack(true))
      ],
    );
  }
}
