import 'package:cozy_social_media_app/views/widgets/auth_widgets/text_field_decoration_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../constants/dims.dart';
import 'package:provider/provider.dart';
import '../../../controllers/auth_controller.dart';

class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({Key? key}) : super(key: key);

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();
  String _email = '';
  String _password = '';
  String _passwordConfirm = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
    super.dispose();
  }

  // validate email
  String? _validateEmail(String? value) {
    return Provider.of<AuthController>(context, listen: false)
        .validateEmailText(value);
  }

  // validate password
  String? _validatePassword(String? value) {
    return Provider.of<AuthController>(context, listen: false)
        .validatePasswordText(value);
  }

  Future<void> register() async {
    // get current validation state from the Form
    final _isValid = _formKey.currentState!.validate();
    if (twoPasswordsIsEqual) {
      if (_isValid) {
        // if the form is valid try to create account
        await createAccount();
      }
    } else if (_passwordConfirm != '') {
      // if the two passwords are not equal exist the function
      displayErrorSnackBar('Confirm password does\'t equal your password.');
      return;
    }
  }


  // check if the the two passwords is equal
  bool get twoPasswordsIsEqual {
    return _passwordTextController.text == _confirmPasswordTextController.text;
  }

  // Send user authentication data to firebase
  Future<void> createAccount() async {
    try {
      toggleIsLoading(isLoading: true);
      await sendAuthDataToFirebase();
    } on FirebaseAuthException catch (error) {
      displayErrorSnackBar(error);
    } on FirebaseException catch (error) {
      displayErrorSnackBar(error);
    } catch (error) {
      displayErrorSnackBar(error);
    }
    toggleIsLoading(isLoading: false);
  }

  void toggleIsLoading({required bool isLoading}) {
    if (mounted) {
      setState(() {
        _isLoading = isLoading;
      });
    }
  }

  Future<void> sendAuthDataToFirebase() async {
    await Provider.of<AuthController>(context, listen: false)
        .registerWithEmailAndPassword(_email, _password);
  }

  void displayErrorSnackBar(error) {
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
          child: Column(
        children: [
          emailTextFieldBuilder(),
          const SizedBox(height: smallPadding),
          passwordTextFieldBuilder(),
          const SizedBox(height: smallPadding),
          confirmPasswordTextFieldBuilder(),
          const SizedBox(height: largePadding),
          createAccountButtonBuilder(),
        ],
      )),
    );
  }

  Widget emailTextFieldBuilder() {
    return TextFieldDecorationWidget(
        textFieldWidget: TextFormField(
      controller: _emailTextController,
      autocorrect: false,
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
    ));
  }

  Widget passwordTextFieldBuilder() {
    return TextFieldDecorationWidget(
        textFieldWidget: TextFormField(
      focusNode: _passwordFocusNode,
      controller: _passwordTextController,
      obscureText: true,
      autocorrect: false,
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
      textInputAction: TextInputAction.next,
      validator: (value) {
        return _validatePassword(value);
      },
      onChanged: (value) {
        _password = value.trim();
      },
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
      },
    ));
  }

  Widget confirmPasswordTextFieldBuilder() {
    return TextFieldDecorationWidget(
      textFieldWidget: TextFormField(
        focusNode: _confirmPasswordFocusNode,
        controller: _confirmPasswordTextController,
        autocorrect: false,
        obscureText: true,
        enableSuggestions: false,
        decoration: InputDecoration(
          hintText: 'Confirm your Password',
          icon: Icon(
            Icons.lock,
            color: Theme.of(context).colorScheme.primary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please, confirm your password';
          } else {
            return null;
          }
        },
        onChanged: (value) {
          _passwordConfirm = value.trim();
        },
      ),
    );
  }

  Widget createAccountButtonBuilder() {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ElevatedButton(
                onPressed: register,
                child: const Text('Create Account')));
  }
}
