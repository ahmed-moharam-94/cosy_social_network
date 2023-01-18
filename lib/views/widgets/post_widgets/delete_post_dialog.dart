import 'package:cozy_social_media_app/models/post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/dims.dart';
import '../../../constants/strings.dart';
import '../../../controllers/post_controller.dart';

class DeletePostDialog extends StatefulWidget {
  final Post post;
  const DeletePostDialog({Key? key, required this.post}) : super(key: key);

  @override
  State<DeletePostDialog> createState() => _DeletePostDialogState();
}

class _DeletePostDialogState extends State<DeletePostDialog> {

  Future<void> _deletePost(BuildContext context) async {
    await Provider.of<PostController>(context, listen: false).deletePost(widget.post.postId);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Post'),
      content: const Text(deletePost),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(dialogRadius)),
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('     No     ')),
        TextButton(
            onPressed: () {
              _deletePost(context);
              Navigator.of(context).pop(true);
            },
            child: const Text('     yes     ')),
      ],
    );
  }
}
