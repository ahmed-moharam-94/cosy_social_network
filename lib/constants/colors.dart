
import 'package:cozy_social_media_app/models/topic.dart';
import 'package:flutter/material.dart';

import 'enums.dart';

final Color facebookColor = Colors.blue[800]!;
const Color authScreenDecorationOrange = Color(0x0ff24100);


Color  statusColor(RequestStatus status) {
  if (status == RequestStatus.friends) {
    return Colors.blue;
  } else {
    return Colors.pink;
  }
}

Color topicColor(Topic topic) {
  if (topic.color == 'amber') {
    return Colors.amber;
  } else if (topic.color == 'brown') {
    return Colors.brown;
  } else if (topic.color == 'green') {
    return Colors.green;
  } else if (topic.color == 'purple') {
    return Colors.purple;
  } else if (topic.color == 'teal') {
    return Colors.teal;
  } else {
    if (topic.color == 'blue') {
      return Colors.blue;
    } else if (topic.color == 'deepPurple') {
      return Colors.deepPurple;
    } else {
      return Colors.indigo;
    }
  }
}