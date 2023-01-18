import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritePostsWebServices {
  final FirebaseFirestore firestore;

  FavoritePostsWebServices(this.firestore);

  Future<void> favoritePost(
      {required String postId, required String userId}) async {
    try {
      // add favorite post id to user collection
      await firestore.collection('users').doc(userId).update({
        'favorites': FieldValue.arrayUnion([postId]),
      });
      // add user id to the favorite post
      await firestore.collection('posts').doc(postId).update({
        'favoriteUsers': FieldValue.arrayUnion([userId]),
      });

    } catch (error) {
      rethrow;
    }
  }

  Future<void> unFavoritePost(
      {required String postId, required String userId}) async {
    try {
      // delete the post id from user
      await firestore.collection('users').doc(userId).update({
        'favorites': FieldValue.arrayRemove([postId]),
      });
      // delete the user id from post
      await firestore.collection('posts').doc(postId).update({
        'favoriteUsers': FieldValue.arrayRemove([userId]),
      });

    } catch (error) {
      rethrow;
    }
  }

  Future<List<String>> getUserFavoritePostsIds({required String userId}) async {
    List<String> favoritePostsIds = [];
    try {
      var doc = await firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        Map<String, dynamic> docData = doc.data()!;
        if (docData['favorites'] != null) {
          favoritePostsIds = docData['favorites'].cast<String>();
        }
      }
    } catch (error) {
      rethrow;
    }
    return favoritePostsIds;
  }

  Future<List<QuerySnapshot<Map<String, dynamic>>>?> getUserFavoritePosts(
      String userId) async {
    List<QuerySnapshot<Map<String, dynamic>>>? _fetchedPostsSnapshots = [];
    try {
      List<String> favoritePostsIds =
          await getUserFavoritePostsIds(userId: userId);

      // batch list for firebase where in query lists <= 10
      List<List<String>> subLists = batchList(favoritePostsIds);

      for (List<String> ids in subLists)  {
        QuerySnapshot<Map<String, dynamic>>? _fetchedPostsSnapshot;
        // get posts raw data
        if (favoritePostsIds.isNotEmpty) {
          _fetchedPostsSnapshot = await firestore
              .collection('posts')
              .where('postId',
              whereIn:
              ids) // use where to filter user post from showing in home screen
              .get();
        }
        _fetchedPostsSnapshots.add(_fetchedPostsSnapshot!);
      }
    } catch (error) {
      rethrow;
    }
    return _fetchedPostsSnapshots;
  }

  List<List<String>> batchList(List<String> items) {
    // batch list to lists with length <= 10
    // required for firebase query using where in
    List<List<String>> subLists = [];
    int step = 10;
    for (int i = 0; i < items.length; i += step) {
      List<String> subList = [];
      int end = i + step > items.length? i + (items.length - i): i + step;
      subList = items.sublist(i, end);
      subLists.add(subList);
    }
    return subLists;
  }

  Future<int> getNumberOfFavorites(String postId) async {
    int numberOfFavorites = 0;
    try {
     var favPost =  await firestore.collection('posts').doc(postId).get();
     if (favPost.data() != null) {
       List favorites = favPost.data()!['favoriteUsers'];
       numberOfFavorites = favorites.length;
     }
    } catch (error) {
      rethrow;
    }
    return numberOfFavorites;
  }
}


