import 'package:cozy_social_media_app/controllers/topic_controller.dart';
import 'package:cozy_social_media_app/models/topic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/post.dart';
import '../title_widget_row.dart';

class ChooseTopicWidget extends StatefulWidget {
  final Post post;

  const ChooseTopicWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<ChooseTopicWidget> createState() => _ChooseTopicWidgetState();
}

class _ChooseTopicWidgetState extends State<ChooseTopicWidget> {

  @override
  Widget build(BuildContext context) {
    final Post post = widget.post;
    final List<Topic> topics = Provider
        .of<TopicsController>(context, listen: false)
        .topics;
    String topicText = post.topic;
    return TitleWidgetRow(
        title: 'Topic',
        widget: Expanded(
          child: Container(
            height: 30,
            margin: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Theme
                      .of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.05),
                  Theme
                      .of(context)
                      .colorScheme
                      .primary
                      .withOpacity(.1),
                ]),
                borderRadius: const BorderRadius.all(
                    Radius.circular(10))),
            child: DropdownButton<String>(
              value: topicText ,
              icon: Icon(
                Icons.arrow_drop_down_outlined,
                color:
                Theme
                    .of(context)
                    .colorScheme
                    .primary,
              ),
              underline: Container(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .primary),
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  topicText = value!;
                });
                post.topic =
                    topicText;
              },
              items: topics.map((topic) {
                return DropdownMenuItem(
                    alignment: Alignment.center,
                    value: topic.name, child: Text(topic.name));
              }).toList(),
            ),
          ),
        ));
  }
}
