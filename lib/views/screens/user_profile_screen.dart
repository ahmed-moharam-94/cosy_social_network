import 'package:cozy_social_media_app/controllers/user_controller.dart';
import 'package:cozy_social_media_app/models/user.dart';
import 'package:cozy_social_media_app/views/widgets/post_widgets/post_loading_indicator_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/dims.dart';
import '../../controllers/post_controller.dart';
import '../widgets/post_widgets/posts_list_widget.dart';
import '../widgets/user_profile_widgets/profile_header_widget.dart';
import '../widgets/user_profile_widgets/user_bio_widget.dart';
import '../widgets/user_profile_widgets/user_profile_loading_widget.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = 'UserProfileScreen';

  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  AppUser profileUser = AppUser();
  bool isLoading = false;
  bool firstBuild = true;

  void setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> getUserById(String userId) async {
    profileUser = await Provider.of<UserController>(context, listen: false)
        .getUserById(userId);
  }

  Future<void> getUserPosts(String userId) async {
    await Provider.of<PostController>(context, listen: false)
        .getSpecificUserPosts(userId: userId);
  }

  Future<void> getProfileData(String userId) async {
    setIsLoading(true);
    await getUserById(userId);
    await getUserPosts(userId);
    setIsLoading(false);
  }


  @override
  void didChangeDependencies() {
    if (firstBuild) {
      var userData = ModalRoute
          .of(context)!
          .settings
          .arguments;
      if (userData != null) {
        String userId = userData as String;
        getProfileData(userId);
      }
    }
    firstBuild = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _posts = Provider.of<PostController>(context).specificUserPosts;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            if (isLoading) loadingIndicatorWidgetBuilder(),
            if (!isLoading) ProfileHeaderWidget(profileUser: profileUser),
            if (!isLoading)
              SliverToBoxAdapter(
                child: UserBioAndSendRequestWidget(profileUser: profileUser),
              ),
            if (!isLoading) PostsListWidget(posts: _posts),
          ],
        ),
    );
  }

  Widget loadingIndicatorWidgetBuilder() {
    return const SliverToBoxAdapter(
        child: LoadingProfileWidget());
  }
}
