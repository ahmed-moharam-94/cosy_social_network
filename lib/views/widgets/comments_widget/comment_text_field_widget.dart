import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cozy_social_media_app/constants/dims.dart';
import 'package:cozy_social_media_app/controllers/comment_controller.dart';
import 'package:cozy_social_media_app/models/post.dart';
import 'package:cozy_social_media_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/comment.dart';

class CommentTextFieldWidget extends StatefulWidget {
  final Post post;
  final AppUser user;
  final double screenHeight;
  final Function(bool) writeCommentCallback;

  const CommentTextFieldWidget(
      {Key? key, required this.screenHeight, required this.post, required this.user, required this.writeCommentCallback})
      : super(key: key);

  @override
  State<CommentTextFieldWidget> createState() => _CommentTextFieldWidgetState();
}

class _CommentTextFieldWidgetState extends State<CommentTextFieldWidget> {
  late double screenHeight;
  String text = '';
  late Comment comment;
  final commentController = TextEditingController();

  Future<void> _submitComment() async {
    text == commentController.text;
    if (text == '') {
      return;
    } else {
      comment.text = text;
      await sendComment();
    }

    // clear textField
    cleatTextField();
    unFocusKeyboard();
  }

  Future<void> sendComment() async {
    Provider.of<CommentController>(context, listen: false).sendComment(comment);
  }

  void cleatTextField() {
    commentController.clear();
    text = '';
  }

  void unFocusKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void didChangeDependencies() {
    screenHeight = widget.screenHeight;
    comment = Comment(
        commentId: '',
        postId: widget.post.postId,
        userId: '',
        text: text,
        userName: widget.user.name,
        userImage: widget.user.image,
        userGender: widget.user.gender,
        createDate: Timestamp.now());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight * 0.093,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: commentController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: mediumPadding),
                hintText: 'Write your comment',
              ),
              onChanged: (value) {
                setState(() {
                  text = value;
                });
              },
            ),
          ),
          IconButton(
              onPressed: () {
                _submitComment();
                widget.writeCommentCallback(true);
              },
              icon: Icon(Icons.send,
                  color: text.isEmpty ? Colors.grey : Theme
                      .of(context)
                      .colorScheme
                      .primary)),
        ],
      ),
    );
  }
}
