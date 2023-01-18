import 'package:cozy_social_media_app/views/widgets/auth_widgets/register_form_widget.dart';
import 'package:flutter/material.dart';
import '../../../constants/dims.dart';

class RegisterWidget extends StatelessWidget {
  // register call back function to pass bool isLogin = false to authentication widget
  final void Function(bool isLogin) registerCallback;

  const RegisterWidget({Key? key, required this.registerCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('Register'),
      padding: const EdgeInsets.symmetric(horizontal: largePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const RegisterFormWidget(),
          const SizedBox(height: mediumPadding),
          alreadyHaveAccountWidgetBuilder(),
        ],
      ),
    );
  }

  Widget alreadyHaveAccountWidgetBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account',
          style:
          TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        TextButton(
          // pass false to authentication widget
            onPressed: () => registerCallback(false),
            child: const Text('Login'))
      ],
    );
  }
}
