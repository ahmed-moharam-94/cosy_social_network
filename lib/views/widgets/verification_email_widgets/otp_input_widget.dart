import 'package:cozy_social_media_app/views/widgets/verification_email_widgets/resend_otp_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../../constants/dims.dart';
import '../../../constants/strings.dart';
import '../../../controllers/auth_controller.dart';
import '../../screens/main_screen.dart';

class OtpInputWidget extends StatefulWidget {
  const OtpInputWidget({Key? key}) : super(key: key);

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  bool isLoading = false;
  int sentOtp = 0000;

  void setLoadingValue(bool value) {
    if (mounted) {
      setState(() {
        isLoading = value;
      });
    }
  }

  Future<void> getSentOtp() async {
    setLoadingValue(true);
    await Provider.of<AuthController>(context, listen: false).getOtp();
    sentOtp = Provider.of<AuthController>(context, listen: false).sentOtp;
    setLoadingValue(false);
  }

  @override
  void initState() {
    getSentOtp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pinController = TextEditingController();
    final focusNode = FocusNode();
    final formKey = GlobalKey<FormState>();

    final focusedBorderColor = Theme.of(context).colorScheme.primary;
    final borderColor = Theme.of(context).colorScheme.primary.withOpacity(0.2);

    const fillColor = Colors.transparent;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(generalRadius),
        border: Border.all(color: borderColor),
      ),
    );

    void navigateToMainScreen() {
      Navigator.of(context)
          .pushNamed(MainScreen.routeName, arguments: {'screenIndex': 0});
    }

    Future<void> verifyEmail() async {
      try {
        setLoadingValue(true);
        await Provider.of<AuthController>(context, listen: false).verifyEmail();
        navigateToMainScreen();
        setLoadingValue(false);
      } catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    }

    String? submitCode(String? value) {
      sentOtp = Provider.of<AuthController>(context, listen: false).sentOtp;
      return value == sentOtp.toString() ? null : 'Code is incorrect';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: mediumPadding),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Verification',
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      ?.copyWith(color: Theme.of(context).colorScheme.primary)),
              const SizedBox(height: hugePadding),
              Text(enterVerificationCode,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.grey)),
              const SizedBox(height: hugePadding),
              Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Pinput(
                        controller: pinController,
                        focusNode: focusNode,
                        androidSmsAutofillMethod:
                            AndroidSmsAutofillMethod.smsUserConsentApi,
                        listenForMultipleSmsOnAndroid: true,
                        defaultPinTheme: defaultPinTheme,
                        validator: (value) {
                          var validator = submitCode(value);
                          if (validator == null) {
                            verifyEmail();
                          }
                          return validator;
                        },
                        hapticFeedbackType: HapticFeedbackType.lightImpact,
                        onCompleted: (pin) {
                          debugPrint('onCompleted: $pin');
                        },
                        onChanged: (value) {
                          debugPrint('onChanged: $value');
                        },
                        cursor: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 9),
                              width: 22,
                              height: 1,
                              color: focusedBorderColor,
                            ),
                          ],
                        ),
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: focusedBorderColor),
                          ),
                        ),
                        submittedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            color: fillColor,
                            borderRadius: BorderRadius.circular(19),
                            border: Border.all(color: focusedBorderColor),
                          ),
                        ),
                        errorPinTheme: defaultPinTheme.copyBorderWith(
                          border: Border.all(color: Colors.redAccent),
                        ),
                      ),
                    ),
                    const SizedBox(height: hugePadding),
                    const ResendOtpWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
