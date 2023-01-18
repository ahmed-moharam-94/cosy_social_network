import 'package:flutter/material.dart';
import '../../../constants/dims.dart';
import '../../../models/post.dart';
import 'add_image_widget.dart';
import 'opinion_text_field_widget.dart';
import 'choose_topic_widget.dart';
import 'choose_experience.dart';

class CreatePostCardWidget extends StatelessWidget {
  final Post post;
  const CreatePostCardWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: mediumPadding, vertical: smallPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(generalRadius),
        color: Colors.white.withOpacity(0.80),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.30),
            spreadRadius: 6,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: smallPadding),
          ChooseTopicWidget(post: post),
          ChooseExperienceWidget(post: post),
          OpinionTextFieldWidget(post: post),
          const SizedBox(height: smallPadding),
          AddImageButton(post: post),
          const SizedBox(height: smallPadding),
        ],
      ),
    );
  }
}
