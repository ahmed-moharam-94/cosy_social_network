import 'package:flutter/material.dart';
import '../../../constants/strings.dart';
import '../../../models/post.dart';

class OpinionTextFieldWidget extends StatefulWidget {
  final Post post;

  const OpinionTextFieldWidget({Key? key, required this.post})
      : super(key: key);

  @override
  State<OpinionTextFieldWidget> createState() => _OpinionTextFieldWidgetState();
}

class _OpinionTextFieldWidgetState extends State<OpinionTextFieldWidget> {
  // bio text controller
  final _bioTextController = TextEditingController();

  // check if bio text field is between 60 and 300 characters then assign it's value to the post
  void _submitOpinionText(Post post) {
    post.opinion = _bioTextController.value.text;
  }

  @override
  void dispose() {
    _bioTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Post post = widget.post;
    // if updating my post get the post bio value
    _bioTextController.text = post.opinion;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Opinion',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        TextField(
          controller: _bioTextController,
          minLines: 1,
          maxLines: 20,
          maxLength: 500,
          decoration: const InputDecoration(hintText: bioHint, hintStyle: TextStyle(color: Colors.grey)),
          onChanged: (value) => _submitOpinionText(post),
        ),
      ],
    );
  }
}
