import 'package:cozy_social_media_app/constants/dims.dart';
import 'package:cozy_social_media_app/controllers/topic_controller.dart';
import 'package:cozy_social_media_app/models/topic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';

class TopicChipWidget extends StatefulWidget {
  final String title;

  const TopicChipWidget({Key? key, required this.title}) : super(key: key);

  @override
  State<TopicChipWidget> createState() => _TopicChipWidgetState();
}

class _TopicChipWidgetState extends State<TopicChipWidget> {
  late Topic topic;

  @override
  void initState() {
    topic = Provider.of<TopicsController>(context, listen: false)
        .findTopicByName(widget.title);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: tinyPadding),
      child: Center(
          child: Text(
        widget.title,
        overflow: TextOverflow.ellipsis,
        style:
            TextStyle(color: Colors.grey.shade50, fontWeight: FontWeight.bold),
      )),
      decoration: BoxDecoration(
        color: topicColor(topic),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}
