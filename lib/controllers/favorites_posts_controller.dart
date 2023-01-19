import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cozy_social_media_app/web_services/favorite_posts_web_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/post.dart';

class FavoritePostsController with ChangeNotifier {
  final FavoritePostsWebServices favoritePostsWebServices;

  FavoritePostsController(this.favoritePostsWebServices);

  final _firebaseAuth = FirebaseAuth.instance;

  List<Post> _favoritePosts = [];

  List<Post> get favoritePosts {
    return [..._favoritePosts];
  }

  bool isPostFavorite(String postId) {
    bool isFavorite = _favoritePosts.any((post) => post.postId == postId);
    return isFavorite;
  }

  Future<void> favoritePost(Post post) async {
    final _currentUserId = _firebaseAuth.currentUser!.uid;
    try {
      await favoritePostsWebServices.favoritePost(
          postId: post.postId, userId: _currentUserId);
      _favoritePosts.add(post);
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('$error from favoritePost');
      }
    }
  }

  Future<void> unFavoritePost(Post post) async {
    final _currentUserId = _firebaseAuth.currentUser!.uid;

    try {
      await favoritePostsWebServices.unFavoritePost(
          postId: post.postId, userId: _currentUserId);
        _favoritePosts.removeWhere((selectedPost) => selectedPost.postId == post.postId);
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('$error unFavoritePost');
      }
    }
  }

  Future<void> getUserFavoritePosts() async {
    final _currentUserId = _firebaseAuth.currentUser!.uid;
    List<Post> fetchedPosts = [];
    List<QuerySnapshot<Map<String, dynamic>>>? fetchedSnapshots = [];
    try {
      fetchedSnapshots =
          await favoritePostsWebServices.getUserFavoritePosts(_currentUserId);
      if (fetchedSnapshots != null) {
        for (var querySnapshot in fetchedSnapshots) {
          querySnapshot.docs.map((postSnapshot) {
            final Post post = Post.fromMap(postSnapshot.data());
            fetchedPosts.add(post);
          }).toList();
          _favoritePosts = fetchedPosts;
          notifyListeners();
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('$error getUserFavoritePosts');
      }
    }
  }

Future<int> getNumberOfFavorites(String postId) async {
  try {
    return await favoritePostsWebServices.getNumberOfFavorites(postId);
  } catch (error) {
    if (kDebugMode) {
      print('$error getNumberOfFavorites');
    }
    return 0;
  }
}

}
