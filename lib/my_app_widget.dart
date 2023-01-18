import 'package:cozy_social_media_app/views/screens/auth_screen.dart';
import 'package:cozy_social_media_app/views/screens/main_screen.dart';
import 'package:cozy_social_media_app/web_services/chat_web_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/dims.dart';
import 'controllers/auth_controller.dart';
import 'controllers/chat_controller.dart';
import 'controllers/comment_controller.dart';
import 'controllers/favorites_posts_controller.dart';
import 'controllers/messages_controller.dart';
import 'controllers/post_controller.dart';
import 'controllers/push_notification_controller.dart';
import 'controllers/request_controller.dart';
import 'controllers/topic_controller.dart';
import 'controllers/user_controller.dart';
import 'helpers/custom_route_animation.dart';
import 'router/app_router.dart';
import 'web_services/auth_web_services.dart';
import 'web_services/comments_web_service.dart';
import 'web_services/device_token_web_services.dart';
import 'web_services/favorite_posts_web_services.dart';
import 'web_services/messages_web_services.dart';
import 'web_services/post_web_service.dart';
import 'web_services/request_web_services.dart';
import 'web_services/topics_web_service.dart';
import 'web_services/user_web_services.dart';

class MyApp extends StatefulWidget {
  final AppRouter appRouter;
  final AuthWebServices authWebServices;
  final UserWebServices userWebServices;
  final TopicWebServices topicWebServices;
  final PostWebServices postWebService;
  final CommentsWebServices commentsWebServices;
  final FavoritePostsWebServices favoritePostsWebServices;
  final RequestWebServices requestWebServices;
  final ChatWebServices chatWebServices;
  final MessagesWebService messagesWebService;
  final PushNotificationWebServices deviceTokenWebServices;

  const MyApp({
    Key? key,
    required this.appRouter,
    required this.userWebServices,
    required this.authWebServices,
    required this.topicWebServices,
    required this.postWebService,
    required this.commentsWebServices,
    required this.favoritePostsWebServices,
    required this.requestWebServices,
    required this.chatWebServices,
    required this.messagesWebService,
    required this.deviceTokenWebServices,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool notificationStartApp = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthController(widget.authWebServices)),
        ChangeNotifierProvider(
            create: (_) => UserController(widget.userWebServices)),
        ChangeNotifierProvider(
            create: (_) => TopicsController(widget.topicWebServices)),
        ChangeNotifierProvider(
            create: (_) => PostController(widget.postWebService)),
        ChangeNotifierProvider(
            create: (_) => CommentController(widget.commentsWebServices)),
        ChangeNotifierProvider(
            create: (_) =>
                FavoritePostsController(widget.favoritePostsWebServices)),
        ChangeNotifierProvider(
            create: (_) => RequestController(widget.requestWebServices)),
        ChangeNotifierProvider(
            create: (_) => ChatController(widget.chatWebServices)),
        ChangeNotifierProvider(
            create: (_) => MessagesController(widget.messagesWebService)),
        ChangeNotifierProvider(
            create: (_) =>
                PushNotificationController(widget.deviceTokenWebServices)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cozy Social Network',
        onGenerateRoute: widget.appRouter.onGenerateRoute,
        theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CustomPageTransitionBuilder(),
          }),
          backgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
              color: Colors.white,
              titleTextStyle: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.red,
            secondary: Colors.black.withOpacity(0.70),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                minimumSize: const Size(60, 40),
                shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(buttonsRadius)))),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: TextButton.styleFrom(
                  minimumSize: const Size(30, 40),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(buttonsRadius)))),
        ),
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return const MainScreen();
              }
              return const AuthenticationScreen();
            }),
      ),
    );
  }
}
