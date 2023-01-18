import 'package:cozy_social_media_app/views/widgets/reusable_widgets/circular_loading_indicator_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/verification_email_widgets/otp_input_widget.dart';
import 'auth_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  static const String routeName = 'VerifyEmailScreen';

  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isLoading = false;

  void displayErrorSnackBar(error, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(error.toString())));
  }

  void navigateToAuthScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthenticationScreen()),
        (route) => false);
  }

  // sign out
  Future<void> _logout(BuildContext context) async {
    setLoadingValue(true);
    try {
      await Provider.of<AuthController>(context, listen: false).signOut();
      // navigate only when success
      navigateToAuthScreen(context);
    } on FirebaseAuthException catch (error) {
      displayErrorSnackBar(error, context);
    } catch (error) {
      displayErrorSnackBar(error, context);
    }
    setLoadingValue(false);
  }

  void setLoadingValue(bool value) {
    if (mounted) {
      setState(() {
        isLoading = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () => _logout(context),
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                  size: 32,
                ))
          ],
        ),
        body: isLoading
            ? const CircularLoadingIndicatorWidget()
            : const OtpInputWidget());
  }
}
