import 'package:cozy_social_media_app/constants/dims.dart';
import 'package:cozy_social_media_app/models/post.dart';
import 'package:flutter/material.dart';
import '../../../models/comment.dart';
import 'comment_user_image.dart';

class CommentItemWidget extends StatefulWidget {
  final Post post;
  final Comment comment;
  const CommentItemWidget({Key? key, required this.post, required this.comment}) : super(key: key);

  @override
  State<CommentItemWidget> createState() => _CommentItemWidgetState();
}

class _CommentItemWidgetState extends State<CommentItemWidget> {



  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: smallPadding, vertical: mediumPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommentUserImageWidget(imageUrl: comment.userImage, gender: comment.userGender),
            const SizedBox(width: mediumPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commentNameWidgetBuilder(comment),
                  const SizedBox(height: mediumPadding),
                  commentTextWidgetBuilder(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget commentNameWidgetBuilder(Comment comment) {
    return Text(comment.userName,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.bold));
  }
  Widget commentTextWidgetBuilder() {
    return Text(
        widget.comment.text,
        style: Theme.of(context).textTheme.titleMedium);
  }
}
