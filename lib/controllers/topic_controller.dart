
import 'package:cozy_social_media_app/web_services/topics_web_service.dart';
import 'package:flutter/foundation.dart';

import '../models/topic.dart';

class TopicsController with ChangeNotifier {
  final TopicWebServices topicWebServices;

  TopicsController(this.topicWebServices);

  List<Topic> _topics = [];

  List<Topic> get topics {
    return [..._topics];
  }

  Future<void> getTopics() async {
    final List<Topic> fetchedTopics = [];
    try {
      var topicsQuery = await topicWebServices.getTopics();
      if (topicsQuery.docs.isNotEmpty) {
        topicsQuery.docs.map((topicData) {
          final topic = Topic.fromMap(topicData.data());
          fetchedTopics.add(topic);
        }).toList();
      }
      _topics = fetchedTopics;
      notifyListeners();

    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Topic findTopicByName(String name) {
    return _topics.firstWhere((topic) => topic.name == name);
  }

}