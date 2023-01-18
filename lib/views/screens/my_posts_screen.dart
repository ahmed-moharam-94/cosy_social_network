import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/post_controller.dart';
import '../widgets/post_widgets/posts_list_widget.dart';
import '../widgets/sliver_appbar_widget.dart';
import 'create_post_screen.dart';

class MyPostsScreen extends StatefulWidget {
  static const String routeName = 'YourPostsScreen';

  const MyPostsScreen({Key? key}) : super(key: key);

  @override
  State<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> {
  bool isLoading = false;

  void setLoadingValue(bool value) {
    if (mounted) {
      setState(() {
        isLoading = value;
      });
    }
  }

  Future<void> getMyPosts() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    setLoadingValue(true);
    await Provider.of<PostController>(context, listen: false)
        .getSpecificUserPosts(userId: userId);
    setLoadingValue(false);
  }

  @override
  void initState() {
    getMyPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _posts = Provider.of<PostController>(context).specificUserPosts;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: RefreshIndicator(
          onRefresh: getMyPosts,
          displacement: 100,
          edgeOffset: 100,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CustomSliverAppBarWidget(
                  title: 'Your Posts',
                  firstIcon: Icons.add,
                  firstCallBack: () => navigateToCreatePostScreen(context)),
              PostsListWidget(posts: _posts),
            ],
          ),
        ));
  }

  void navigateToCreatePostScreen(BuildContext context) {
    Navigator.of(context).pushNamed(CreatePostScreen.routeName);
  }
}
