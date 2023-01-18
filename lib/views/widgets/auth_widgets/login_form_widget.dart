import 'package:cozy_social_media_app/controllers/user_controller.dart';
import 'package:cozy_social_media_app/views/widgets/auth_widgets/text_field_decoration_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/dims.dart';
import '../../../controllers/auth_controller.dart';
import '../../screens/main_screen.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({Key? key}) : super(key: key);

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  // create a form key to validate and submit form
  final _formKey = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();
  final _emailTextControl = TextEditingController();
  final _passwordTextControl = TextEditingController();
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  // validate email
  String? _validateEmail(String? value) {
    return Provider.of<AuthController>(context, listen: false).validateEmailText(value);
  }

  // validate password
  String? _validatePassword(String? value) {
   return Provider.of<AuthController>(context, listen: false).validatePasswordText(value);
  }

  Future<void> _login() async {
    // get validation state of the Form
    final _isValid = _formKey.currentState!.validate();
    // check if the Form is valid
    if (_isValid) {
        toggleLoading(isLoading: true);

      await tryToLogin();
    }
    toggleLoading(isLoading: false);
  }

  void toggleLoading({required isLoading}) {
    if (mounted) {
      setState(() {
        _isLoading = isLoading;
      });
    }
  }

  // Send user authentication data to firebase
  Future<void> tryToLogin() async {
    try {
      toggleLoading(isLoading: true);
      await sendAuthDataToFirebase();
      // navigate to base screen only if login success
      navigateToMainScreen();
    } on FirebaseAuthException catch (error) {
      displayErrorSnackBar(error);
    } on FirebaseException catch (error) {
      displayErrorSnackBar(error);
    } catch (error) {
      displayErrorSnackBar(error);
    }
    toggleLoading(isLoading: false);
  }

  Future<void> sendAuthDataToFirebase() async {
    await Provider.of<AuthController>(context, listen: false)
        .signInWithEmailAndPassword(_email, _password);
  }

  void displayErrorSnackBar(error) {
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  void navigateToMainScreen() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (route) => false);
  }


  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _emailTextControl.dispose();
    _passwordTextControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              emailTextFieldBuilder(),
              const SizedBox(height: mediumPadding),
              passwordTextFieldBuilder(),
              const SizedBox(height: largePadding),
              loginButtonBuilder(),
            ],
          )),
    );
  }

  Widget emailTextFieldBuilder() {
    return TextFieldDecorationWidget(
      textFieldWidget: TextFormField(
        controller: _emailTextControl,
        enableSuggestions: false,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Enter your Email',
          icon: Icon(
            Icons.email,
            color: Theme.of(context).colorScheme.primary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
        textInputAction: TextInputAction.next,
        validator: (value) {
          return _validateEmail(value);
        },
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
        onChanged: (value) {
          _email = value.trim();
        },
      ),
    );
  }

  Widget passwordTextFieldBuilder() {
    return TextFieldDecorationWidget(
      textFieldWidget: TextFormField(
        controller: _passwordTextControl,
        obscureText: true,
        enableSuggestions: false,
        decoration: InputDecoration(
          hintText: 'Enter your Password',
          icon: Icon(
            Icons.lock,
            color: Theme.of(context).colorScheme.primary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
        focusNode: _passwordFocusNode,
        validator: (value) {
          return _validatePassword(value);
        },
        onChanged: (value) {
          _password = value.trim();
        },
      ),
    );
  }

  Widget loginButtonBuilder() {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(onPressed: _login, child: const Text('Login')));
  }
}
