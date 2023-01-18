import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/dims.dart';
import '../../controllers/favorites_posts_controller.dart';
import '../../models/post.dart';
import '../widgets/post_widgets/single_post_widget.dart';
import '../widgets/sliver_appbar_widget.dart';

class FavoriteScreen extends StatefulWidget {
  static const String routeName = 'UserScreen';

  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder(
        future: Provider.of<FavoritePostsController>(context, listen: false)
            .getUserFavoritePosts(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final List<Post> userFavoritePosts =
                Provider.of<FavoritePostsController>(context).favoritePosts;
            return Center(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const CustomSliverAppBarWidget(
                      title: 'Favorite Posts',
                  ),
                  if (userFavoritePosts.isEmpty) noFavoritesPostsYet(),
                  if (userFavoritePosts.isNotEmpty)
                    favoritePostsListBuilder(userFavoritePosts),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget noFavoritesPostsYet() {
    return SliverToBoxAdapter(
        child: Column(
      children: const [
        SizedBox(height: 50),
        Center(
            child: Text(
          'You don\'t have any favorite posts yet',
          style: TextStyle(fontSize: 18),
        )),
      ],
    ));
  }

  Widget favoritePostsListBuilder(List<Post> posts) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: tinyPadding),
      sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
        (context, index) {
          return SinglePostWidget(
              post: posts[index]);
        },
        childCount: posts.length,
      )),
    );
  }
}
