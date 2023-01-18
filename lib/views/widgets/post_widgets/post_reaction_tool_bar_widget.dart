import 'package:cozy_social_media_app/models/post.dart';
import 'package:cozy_social_media_app/views/widgets/post_widgets/post_favorite_icon_widget.dart';
import 'package:cozy_social_media_app/views/widgets/post_widgets/user_post_options_widget.dart';
import 'package:flutter/material.dart';
import 'comment_icon_widget.dart';

class PostReactionToolBar extends StatelessWidget {
  final Post post;
  final bool isMyPost;
  final int numberOfComments;

  const PostReactionToolBar(
      {Key? key,
      required this.post,
      required this.isMyPost,
      required this.numberOfComments})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CommentIconWidget(post: post, commentsNumber: numberOfComments),
          PostFavoriteIconWidget(post: post),
          UserPostOptionsWidget(post: post, isMyPost: isMyPost),
        ],
      ),
    );
  }
}
