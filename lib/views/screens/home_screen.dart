import 'package:cozy_social_media_app/controllers/favorites_posts_controller.dart';
import 'package:cozy_social_media_app/views/screens/settings_screen.dart';
import 'package:cozy_social_media_app/views/widgets/reusable_widgets/circular_loading_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import '../../constants/dims.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/post_controller.dart';
import '../widgets/post_widgets/posts_list_widget.dart';
import '../widgets/sliver_appbar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'HomeScreen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


  Future<void> _getFavoritePosts(BuildContext context) async {
    setLoadingValue(true);
    await Provider.of<FavoritePostsController>(context, listen: false)
        .getUserFavoritePosts();
    setLoadingValue(false);
  }

  void displayErrorSnackBar(error, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(error.toString())));
  }

  void navigateToAuthScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthenticationScreen()),
        (route) => false);
  }

  // sign out
  Future<void> _logout(BuildContext context) async {
    setLoadingValue(true);
    try {
      await Provider.of<AuthController>(context, listen: false).signOut();
      // navigate only when success
      navigateToAuthScreen(context);
    } on FirebaseAuthException catch (error) {
      displayErrorSnackBar(error, context);
    } catch (error) {
      displayErrorSnackBar(error, context);
    }
    setLoadingValue(false);
  }

  void setLoadingValue(bool value) {
    if (mounted) {
      setState(() {
        isLoading = value;
      });
    }
  }

  Future<void> getUserPosts() async {
    setLoadingValue(true);
    await Provider.of<PostController>(context, listen: false)
        .getAllPosts();
    setLoadingValue(false);
  }


  @override
  void initState() {
    _getFavoritePosts(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _posts = Provider.of<PostController>(context).allPosts;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: RefreshIndicator(
        onRefresh: getUserPosts,
        displacement: 100,
        edgeOffset: 100,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBarWidget(
                isInHomeScreen: true,
                title: 'Home Screen',
                firstIcon: Icons.logout,
                firstCallBack: () => _logout(context),
                secondIcon: Icons.settings,
                secondCallBack: () => navigateToSettingsScreen(context)),
             if (isLoading)
               const SliverToBoxAdapter(child: CircularLoadingIndicatorWidget()),
             if (!isLoading)
              PostsListWidget(posts: _posts),
          ],
        ),
      ),
    );
  }

  Widget loadingIndicatorWidgetBuilder() {
    return SliverToBoxAdapter(
        child: Column(
      children: const [
        SizedBox(height: hugePadding),
        CircularProgressIndicator(),
      ],
    ));
  }

  void navigateToSettingsScreen(context) {
    Navigator.of(context).pushNamed(SettingsScreen.routeName);
  }
}
