// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cozy_social_media_app/my_app_widget.dart';
import 'package:cozy_social_media_app/router/app_router.dart';
import 'package:cozy_social_media_app/web_services/auth_web_services.dart';
import 'package:cozy_social_media_app/web_services/chat_web_services.dart';
import 'package:cozy_social_media_app/web_services/comments_web_service.dart';
import 'package:cozy_social_media_app/web_services/device_token_web_services.dart';
import 'package:cozy_social_media_app/web_services/favorite_posts_web_services.dart';
import 'package:cozy_social_media_app/web_services/messages_web_services.dart';
import 'package:cozy_social_media_app/web_services/post_web_service.dart';
import 'package:cozy_social_media_app/web_services/request_web_services.dart';
import 'package:cozy_social_media_app/web_services/topics_web_service.dart';
import 'package:cozy_social_media_app/web_services/user_web_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final _firestore = FirebaseFirestore.instance;
    final _firebaseAuth = FirebaseAuth.instance;
    final _firebaseStorage = FirebaseStorage.instance;


    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      appRouter: AppRouter(),
      authWebServices: AuthWebServices(_firestore, _firebaseAuth),
      userWebServices: UserWebServices(_firestore, _firebaseAuth, _firebaseStorage),
      topicWebServices: TopicWebServices(_firestore),
      commentsWebServices: CommentsWebServices(_firestore, _firebaseAuth),
      postWebService: PostWebServices(_firestore, _firebaseStorage),
      favoritePostsWebServices: FavoritePostsWebServices(_firestore),
      requestWebServices: RequestWebServices(_firestore, _firebaseAuth),
      chatWebServices: ChatWebServices(_firestore, _firebaseAuth),
      messagesWebService: MessagesWebService(_firestore, _firebaseStorage),
      deviceTokenWebServices: PushNotificationWebServices(_firestore),
    ));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
