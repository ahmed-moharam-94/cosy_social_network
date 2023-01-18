import 'package:cozy_social_media_app/models/post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/favorites_posts_controller.dart';

class PostFavoriteIconWidget extends StatefulWidget {
  final Post post;

  const PostFavoriteIconWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostFavoriteIconWidget> createState() => _PostFavoriteIconWidgetState();
}

class _PostFavoriteIconWidgetState extends State<PostFavoriteIconWidget> {
  late Post post;
  bool isFavorite = false;
  bool isLoading = false;
  bool firstBuild = true;
  int numberOfFavorites = 0;

  void setIsLoadingValue(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> updateFavorite() async {
    setIsLoadingValue(true);
    if (isFavorite) {
      // if the post is favorite make it unFavorite
      await Provider.of<FavoritePostsController>(context, listen: false)
          .unFavoritePost(widget.post);
    } else {
      await Provider.of<FavoritePostsController>(context, listen: false)
          .favoritePost(widget.post);
    }
    // get number of favorites after updating favorites
    await getNumberOfFavorites();
    setIsLoadingValue(false);
  }

  void isPostFavorite() {
    // listen is true
    final isPostFavorite = Provider.of<FavoritePostsController>(context)
        .isPostFavorite(widget.post.postId);
    setState(() {
      isFavorite = isPostFavorite;
    });
  }

  Future<void> getNumberOfFavorites() async {
    int numberOfFavorites =
        await Provider.of<FavoritePostsController>(context, listen: false)
            .getNumberOfFavorites(widget.post.postId);
    if (mounted) {
      setState(() {
      this.numberOfFavorites = numberOfFavorites;
    });
    }
  }

  @override
  void didChangeDependencies() {
    post = widget.post;
    getNumberOfFavorites();
    isPostFavorite();
    firstBuild = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? loadingIndicatorWidgetBuilder()
        : Row(
            children: [
              IconButton(
                  onPressed: updateFavorite,
                  icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_rounded,
                      color: isFavorite
                          ? Colors.deepOrange
                          : Colors.grey.shade400)),
              Text(numberOfFavorites.toString()),
            ],
          );
  }

  Widget loadingIndicatorWidgetBuilder() {
    return const SizedBox(
        height: 20,
        width: 20,
        child: Center(
            child: CircularProgressIndicator(
          strokeWidth: 2,
        )));
  }
}
