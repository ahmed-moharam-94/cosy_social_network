import 'package:cozy_social_media_app/views/widgets/create_post_widgets/create_post_card_widget.dart';
import 'package:flutter/material.dart';
import '../../../constants/dims.dart';
import '../../../models/post.dart';
import 'create_or_update_post_button.dart';

class CreatePostWidget extends StatefulWidget {
  final Post post;
  final bool updateMyPost;
  const CreatePostWidget({Key? key, required this.post, required this.updateMyPost}) : super(key: key);

  @override
  State<CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: mediumPadding),
            // required information
            CreatePostCardWidget(post: widget.post),
            const SizedBox(height: mediumPadding),
            CreateOrUpdatePostButton(
                post: widget.post, updateMyPost: widget.updateMyPost),
            const SizedBox(height: mediumPadding),
          ],
        ),
      ),
    );
  }
}
