import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/dims.dart';
import '../../../constants/strings.dart';
import '../../../controllers/post_controller.dart';
import '../../../models/post.dart';
import '../../../views/widgets/post_widgets/single_post_widget.dart';

class PostsListWidget extends StatefulWidget {
  final bool isMyPosts;
  final List<Post> posts;

  const PostsListWidget({Key? key, this.isMyPosts = false, required this.posts})
      : super(key: key);

  @override
  State<PostsListWidget> createState() => _PostsListWidgetState();
}

class _PostsListWidgetState extends State<PostsListWidget> {
  bool isLoading = false;

  void setLoadingValue(bool value) {
    if (mounted) {
      setState(() {
        isLoading = value;
      });
    }
  }

  Future<void> getAllPosts() async {
    setLoadingValue(true);
    await Provider.of<PostController>(context, listen: false).getAllPosts();
    setLoadingValue(false);
  }

  @override
  void initState() {
    getAllPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostController>(builder: (_, postController, ch) {
      final _posts = widget.posts;
      if (isLoading) {
        return loadingIndicatorWidgetBuilder();
      } else if (!isLoading && _posts.isEmpty) {
        return noPostsYetWidgetBuilder();
      } else if (!isLoading && _posts.isNotEmpty) {
        return postsListWidgetBuilder(_posts);
      } else {
        return const Text('Error Happened');
      }
    });
  }

  // add padding at the last index
  Widget bottomPaddingWidget() {
    return const Padding(padding: EdgeInsets.only(bottom: largePadding));
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

  Widget noPostsYetWidgetBuilder() {
    return SliverToBoxAdapter(
        child: Column(
      children: const [
        SizedBox(height: 50),
        Center(
            child: Text(
          noPostsYet,
          style: TextStyle(fontSize: 18),
        )),
      ],
    ));
  }

  Widget postsListWidgetBuilder(List<Post> posts) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: tinyPadding),
      sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
        (context, index) {
          final Post _post = posts[index];
          return Column(
            children: [
              SinglePostWidget(post: _post),
              // add padding at the last index
              if (index == posts.length - 1) bottomPaddingWidget(),
            ],
          );
        },
        childCount: posts.length,
      )),
    );
  }
}
