import 'package:flutter/material.dart';
import '../widgets/auth_widgets/authentication_widget.dart';

class AuthenticationScreen extends StatelessWidget {
  static const routeName = 'AuthScreen';

  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AuthenticationWidget(),
    );
  }
}
