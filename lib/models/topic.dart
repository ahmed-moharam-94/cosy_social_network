import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Topic {
  late String name;
  late String color;
  late List<String> posts;

  Topic({
    required this.name,
    required this.color,
    required this.posts,
  });

  factory Topic.fromMap(Map<String, dynamic> topicData) {
    return Topic(
        name: topicData['name'] ?? 'error',
        color: topicData['color'] ?? 'red' ,
        posts: topicData['posts'] ?? [] );
  }

}
