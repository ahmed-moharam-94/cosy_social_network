import 'package:cozy_social_media_app/views/screens/user_settings_screen.dart';
import 'package:cozy_social_media_app/views/screens/verify_email_screen.dart';
import 'package:flutter/material.dart';
import '../views/screens/settings_screen.dart';
import '../views/screens/auth_screen.dart';
import '../views/screens/main_screen.dart';
import '../views/screens/create_post_screen.dart';
import '../views/screens/grouped_chats_screen.dart';
import '../views/screens/home_screen.dart';
import '../views/screens/requests_screen.dart';
import '../views/screens/user_profile_screen.dart';
import '../views/screens/my_posts_screen.dart';

// AppRouter class: Navigate to application screens
class AppRouter {
  // method to generate screen routes
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case AuthenticationScreen.routeName:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const AuthenticationScreen(),
        );
      case VerifyEmailScreen.routeName:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const VerifyEmailScreen(),
        );
      case HomeScreen.routeName:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const HomeScreen(),
        );
      case MainScreen.routeName:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const MainScreen(),
        );
      case CreatePostScreen.routeName:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const CreatePostScreen(),
        );
      case GroupedChatsScreen.routeName:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const GroupedChatsScreen(),
        );
      case RequestsScreen.routeName:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const RequestsScreen(),
        );
      case MyPostsScreen.routeName:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const MyPostsScreen(),
        );

      case SettingsScreen.routeName:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const SettingsScreen(),
        );
      case UserSettingsScreen.routeName:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const UserSettingsScreen(),
        );
      case UserProfileScreen.routeName:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const UserProfileScreen(),
        );
      default:
        return null;
    }
  }
}
