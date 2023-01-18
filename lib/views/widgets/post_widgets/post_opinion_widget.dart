import 'package:cozy_social_media_app/models/post.dart';
import 'package:flutter/material.dart';

class PostOpinion extends StatelessWidget {
  final Post post;
  const PostOpinion({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      post.opinion,
      style: Theme.of(context).textTheme.bodyMedium,
    );

  }
}
