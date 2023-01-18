import 'package:cloud_firestore/cloud_firestore.dart';

class TopicWebServices {
  final FirebaseFirestore firestore;

  TopicWebServices(this.firestore);

  Future<QuerySnapshot<Map<String, dynamic>>> getTopics() async {
    try {
      return await firestore.collection('topics').orderBy('name').get();
    } catch (error) {
      rethrow;
    }
  }
}
