import 'package:cozy_social_media_app/models/post.dart';
import 'package:flutter/material.dart';
import '../../../models/comment.dart';
import 'comment_item_widget.dart';

class CommentsListWidget extends StatelessWidget {
  final Post post;
  final List<Comment> comments;
  final List<Comment> userComments;

  const CommentsListWidget(
      {Key? key,
      required this.post,
      required this.comments,
      required this.userComments})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int listItemCount = comments.length + userComments.length;
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          // display the user comments on the top of the list
          if (userComments.isNotEmpty && index < userComments.length) {
            return userCommentsWidgetBuilder(index);
          } else if (comments.isNotEmpty) {
            return othersCommentsWidgetBuilder(index);
          } else {
            return const SizedBox();
          }
        },
        itemCount: listItemCount);
  }

  Widget userCommentsWidgetBuilder(int index) {
    final userComment = userComments[index];
    return Column(children: [
      CommentItemWidget(post: post, comment: userComment),
      const Divider(height: 1, thickness: 0.5),
    ]);
  }

  Widget othersCommentsWidgetBuilder(int index) {
    final comment = comments[index - userComments.length];
    return Column(children: [
      CommentItemWidget(post: post, comment: comment),
      const Divider(height: 1, thickness: 0.5),
    ]);
  }
}
