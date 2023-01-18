import 'package:flutter/material.dart';

import '../../../models/user.dart';

class UserBioTextFieldWidget extends StatefulWidget {
  final AppUser user;

  const UserBioTextFieldWidget({Key? key, required this.user})
      : super(key: key);

  @override
  State<UserBioTextFieldWidget> createState() => _UserBioTextFieldWidgetState();
}

class _UserBioTextFieldWidgetState extends State<UserBioTextFieldWidget> {
  // name text controller
  final _bioTextController = TextEditingController();

  void _submitUserBio(AppUser user) {
    user.bio = _bioTextController.value.text;
  }

  @override
  void dispose() {
    _bioTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    // if updating user bio get the current bio from user
    _bioTextController.text = user.bio;
    return TextField(
      maxLength: 40,
      minLines: 1,
      maxLines: 5,
      controller: _bioTextController,
      decoration: const InputDecoration(
        hintText: 'You can write a brief information about your self',
        hintStyle: TextStyle(color: Colors.grey),
        labelText: 'About You',
        labelStyle: TextStyle(color: Colors.grey),
      ),
      onChanged: (value) => _submitUserBio(user),
    );
  }
}
