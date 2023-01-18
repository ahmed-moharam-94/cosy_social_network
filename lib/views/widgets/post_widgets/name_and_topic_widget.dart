import 'package:cozy_social_media_app/models/user.dart';
import 'package:cozy_social_media_app/views/widgets/topic_widgets/topic_chip_widget.dart';
import 'package:flutter/material.dart';
import '../../../models/post.dart';

class NameAndTopicWidget extends StatelessWidget {
  final Post post;
  final AppUser user;
  const NameAndTopicWidget({Key? key, required this.post, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(user.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
        ),
        TopicChipWidget(title: post.topic),
      ],
    );
  }
}
