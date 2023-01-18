import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/dims.dart';
import '../../../constants/strings.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/user_controller.dart';

const resendTimer = 40;

class ResendOtpWidget extends StatefulWidget {
  const ResendOtpWidget({Key? key}) : super(key: key);

  @override
  State<ResendOtpWidget> createState() => _ResendOtpWidgetState();
}

class _ResendOtpWidgetState extends State<ResendOtpWidget> {
  int seconds = resendTimer;
  late Timer timer;

  Future<void> getSentOtp() async {
    await Provider.of<AuthController>(context, listen: false).getOtp();
  }

  Future<void> resendOtp() async {
    resetTimer();
    final _email =
        Provider.of<UserController>(context, listen: false).currentUser.email;
    await Provider.of<AuthController>(context, listen: false).sendOtp(_email);
    await getSentOtp();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
        timer.tick;
      }
    });
  }

  void resetTimer() {
    setState(() {
      seconds = resendTimer;
    });
    timer.cancel();
    startTimer();
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(seconds.toString(), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: smallPadding),
         Text(didNotReceiveCode, style: Theme.of(context).textTheme.titleMedium),
        TextButton(
          onPressed: seconds == 0 ? () => resendOtp() : null,
          child:  Text('Resend Email', style: Theme.of(context).textTheme.titleMedium?.copyWith(color:
          seconds == 0 ?
          Theme.of(context).colorScheme.primary : Colors.grey)),
        ),
      ],
    );
  }
}
