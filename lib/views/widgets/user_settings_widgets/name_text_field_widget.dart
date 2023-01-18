import 'package:cozy_social_media_app/models/user.dart';
import 'package:flutter/material.dart';

class NameTextFieldWidget extends StatefulWidget {
  final AppUser user;
  const NameTextFieldWidget({Key? key, required this.user}) : super(key: key);

  @override
  State<NameTextFieldWidget> createState() => _NameTextFieldWidgetState();
}

class _NameTextFieldWidgetState extends State<NameTextFieldWidget> {
  // name text controller
  final _nameTextController = TextEditingController();

  void _submitUserName(AppUser user) {
    if (!(_nameTextController.value.text.length >= 6) ||
        !(_nameTextController.value.text.length <= 20)) {
      //if not in range exit function
      return;
    } else {
      user.name = _nameTextController.value.text;
    }
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    // if updating user name get the name from user
    _nameTextController.text = user.name;
    return TextField(
      maxLength: 20,
      controller: _nameTextController,
      decoration: const InputDecoration(
        labelText: 'Your Name',
        labelStyle: TextStyle(color: Colors.grey),
      ),
      onChanged: (value) => _submitUserName(user),
    );
  }
}
