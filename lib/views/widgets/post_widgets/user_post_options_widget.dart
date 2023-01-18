import 'package:cozy_social_media_app/models/post.dart';
import 'package:cozy_social_media_app/views/widgets/post_widgets/delete_post_dialog.dart';
import 'package:flutter/material.dart';
import '../../screens/create_post_screen.dart';

enum MenuItems {
  delete,
  edit,
  hide,
  block,
}

class UserPostOptionsWidget extends StatelessWidget {
  final Post post;
  final bool isMyPost;

  const UserPostOptionsWidget(
      {Key? key, required this.post, required this.isMyPost})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert_rounded, color: Colors.grey),
      itemBuilder: (BuildContext context) {
        return [
          if (isMyPost)
            const PopupMenuItem(child: Text('Edit'), value: MenuItems.edit),
          if (isMyPost)
            const PopupMenuItem(child: Text('Delete'), value: MenuItems.delete),
          if (!isMyPost) // todo implement hide post
            const PopupMenuItem(child: Text('Hide'), value: MenuItems.hide),
          if (!isMyPost) // todo implement block user
            const PopupMenuItem(child: Text('Block'), value: MenuItems.block),
        ];
      },
      onSelected: (value) {
        if (value == MenuItems.edit) {
          navigateToCreatePostScreen(context);
        } else if (value == MenuItems.delete) {
          showDeleteDialog(context);
        } else {
          // todo implement bloc user and hide post
        }
      },
    );
  }

  void navigateToCreatePostScreen(context) {
    Navigator.of(context)
        .pushNamed(CreatePostScreen.routeName, arguments: post);
  }

  void showDeleteDialog(context) {
    print(isMyPost);

    showDialog(
        context: context,
        builder: (_) {
          return DeletePostDialog(post: post);
        });
  }
}
