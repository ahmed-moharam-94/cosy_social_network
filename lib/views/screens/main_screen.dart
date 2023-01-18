import 'package:cozy_social_media_app/controllers/auth_controller.dart';
import 'package:cozy_social_media_app/controllers/topic_controller.dart';
import 'package:cozy_social_media_app/controllers/user_controller.dart';
import 'package:cozy_social_media_app/views/screens/favorites_screen.dart';
import 'package:cozy_social_media_app/views/screens/my_posts_screen.dart';
import 'package:cozy_social_media_app/views/screens/requests_screen.dart';
import 'package:cozy_social_media_app/views/screens/user_settings_screen.dart';
import 'package:cozy_social_media_app/views/screens/verify_email_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import '../../helpers/notification_service.dart';
import '../widgets/reusable_widgets/circular_loading_indicator_widget.dart';
import '../widgets/reusable_widgets/decorated_navigation_bar_widget.dart';
import 'grouped_chats_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  static const routeName = 'MainScreen';

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool firstBuild = true;
  int _screenIndex = 0;
  String userName = '';
  int onDidReceivedIndex = 0;
  bool isLoading = false;

  void setLoadingValue(bool value) {
    if (mounted) {
      setState(() {
        isLoading = value;
      });
    }
  }

  final List<Widget> _screensList = [
    const HomeScreen(),
    const MyPostsScreen(),
    const FavoriteScreen(),
    const GroupedChatsScreen(),
    const RequestsScreen(),
  ];

  void _selectScreen(int index) {
    setState(() {
      _screenIndex = index;
    });
  }

  Future<void> notificationStarTheApp() async {
    var details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (details != null) {
      if (details.didNotificationLaunchApp) {
        setState(() {
          _screenIndex = 2;
        });
      }
    }
  }

  @override
  void initState() {
    NotificationService().requestFCMPermissions();
    NotificationService().initNotification(
        flutterLocalNotificationsPlugin, onDidReceiveNotificationResponse);
    handleNotificationInForeground();
    handleNotificationInBackground();
    handleNotificationInTerminated();
    getInitialData();
    super.initState();
  }

  // handle notifications
  void handleNotificationInForeground() {
    //only works if app in foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.data['type'] == 'friend_request') {
        // friend request
        onDidReceivedIndex = 4;
      } else {
        // new message
        onDidReceivedIndex = 3;
      }
    });
  }

  void handleNotificationInBackground() {
    // only works if app in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((message) {

      if (message.data['type'] == 'friend_request') {
        // friend request
        setState(() {
          _screenIndex = 4;
        });
      } else {
        // new message
        setState(() {
          _screenIndex = 3;
        });
      }
    });
  }

  void handleNotificationInTerminated() {
    // only works when app is terminated (first start)
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {

        if (message.data['type'] == 'friend_request') {
          // friend request
          setState(() {
            _screenIndex = 4;
          });
        } else {
          // new message
          setState(() {
            _screenIndex = 3;
          });
        }
      }
    });
  }

  void onDidReceiveNotificationResponse(NotificationResponse response) async {
    setState(() {
      _screenIndex = onDidReceivedIndex;
    });
  }

  void screenNavigatorCallback() {
    final screenData = ModalRoute.of(context)?.settings.arguments;
    if (screenData != null) {
      int screenIndex = (screenData as Map<String, int>)['screenIndex']!;
      if (firstBuild) {
        _selectScreen(screenIndex);
        firstBuild = false;
      }
    }
  }

  Future<void> getInitialData() async {
    setLoadingValue(true);
    // get the existing user data
    await getUserData();
    final currentUser =
        Provider.of<UserController>(context, listen: false).currentUser;

    // if first time user register navigate to user profile so he can choose his name and image
    if (!currentUser.isVerified) {
      final email = Provider.of<UserController>(context, listen: false).currentUser.email;
      // send otp code
      await Provider.of<AuthController>(context, listen: false).sendOtp(email);
      // navigate to verify user account
      navigateToVerificationScreen();
    } else if (currentUser.name == '') {
      // navigate to setup user profile
      navigateToUserProfile();
    }
    // get topics
    await Provider.of<TopicsController>(context, listen: false).getTopics();
    setLoadingValue(false);
  }

  void navigateToUserProfile() {
    // if first time user register navigate to user profile so he can choose his name and image
    Navigator.of(context).pushReplacementNamed(UserSettingsScreen.routeName);
  }

  void navigateToVerificationScreen() {
    // if first time user register navigate to user profile so he can choose his name and image
    Navigator.of(context).pushReplacementNamed(VerifyEmailScreen.routeName);
  }

  Future<void> getUserData() async {
    await Provider.of<UserController>(context, listen: false).getCurrentUserData();
  }

  @override
  void didChangeDependencies() {
    screenNavigatorCallback();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavigationBarBuilder(),
      body: isLoading
          ? const CircularLoadingIndicatorWidget()
          : _screensList[_screenIndex],
    );
  }

  Widget bottomNavigationBarBuilder() {
    return BottomNavigationBarDecoration(
      bottomBarWidget: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        currentIndex: _screenIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey.shade500,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Your Posts'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Chats'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notification_important), label: 'Requests'),
        ],
        onTap: (index) {
          _selectScreen(index);
        },
      ),
    );
  }
}
