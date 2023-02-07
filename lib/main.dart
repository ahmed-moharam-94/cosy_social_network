import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'my_app_widget.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling fcm background message");
  }
}

Future<void> main() async {
  // change statue bar color to transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  // initialize firebase when app starts
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final _firestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instance;

  runApp(MyApp(
    appRouter: AppRouter(),
    authWebServices: AuthWebServices(_firestore, _firebaseAuth),
    userWebServices:
        UserWebServices(_firestore, _firebaseAuth, _firebaseStorage),
    topicWebServices: TopicWebServices(_firestore),
    postWebService: PostWebServices(_firestore, _firebaseStorage),
    commentsWebServices: CommentsWebServices(_firestore, _firebaseAuth),
    favoritePostsWebServices: FavoritePostsWebServices(_firestore),
    requestWebServices: RequestWebServices(_firestore, _firebaseAuth),
    chatWebServices: ChatWebServices(_firestore, _firebaseAuth),
    messagesWebService: MessagesWebService(_firestore, _firebaseStorage),
    deviceTokenWebServices: PushNotificationWebServices(_firestore),
  ));
}



