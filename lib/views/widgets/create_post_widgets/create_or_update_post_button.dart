import 'package:cozy_social_media_app/controllers/user_controller.dart';
import 'package:cozy_social_media_app/models/user.dart';
import 'package:cozy_social_media_app/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/strings.dart';
import '../../../controllers/post_controller.dart';
import '../../../models/post.dart';

class CreateOrUpdatePostButton extends StatefulWidget {
  final Post post;
  final bool updateMyPost;

  const CreateOrUpdatePostButton(
      {Key? key, required this.post, required this.updateMyPost})
      : super(key: key);

  @override
  State<CreateOrUpdatePostButton> createState() =>
      _CreateOrUpdatePostButtonState();
}

class _CreateOrUpdatePostButtonState extends State<CreateOrUpdatePostButton> {
  bool _isLoading = false;

  Future<void> _createOrUpdatePost(Post post, bool isUpdatingPost) async {
    bool isRequiredInfoComplete = isRequiredInformationComplete(post);
    final user = Provider.of<UserController>(context, listen: false).currentUser;

    if (isRequiredInfoComplete) {
      await updatePost(post, user);
      displayMessageSnackBar(yourPostHasBeenPublished);
      navigateToUserPostsScreen();
    } else {
      displayMessageSnackBar(writeYourOpinion);
    }
  }

  bool isRequiredInformationComplete(Post post) {
    if (post.topic != '' &&
        post.experience != '' &&
        post.opinion != '') {
      return true;
    } else {
      return false;
    }
  }


  Future<void> updatePost(Post post, AppUser user) async {
    isLoadingValue(true);
    await Provider.of<PostController>(context, listen: false)
        .createAndUpdateMyPost(post, user);
    isLoadingValue(false);
  }

  void isLoadingValue(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void displayMessageSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(message), duration: const Duration(seconds: 3)));
    }
  }

  void navigateToUserPostsScreen() {
    Navigator.of(context).pushNamed(MainScreen.routeName, arguments: {'screenIndex': 1});
  }

  @override
  Widget build(BuildContext context) {
    final Post post = widget.post;
    bool isUpdatingPost = widget.updateMyPost;
    return SizedBox(
        width: double.infinity,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ElevatedButton(
                onPressed: () => _createOrUpdatePost(post, isUpdatingPost),
                child: isUpdatingPost
                    ? const Text('Update Post')
                    : const Text('Create Post')));
  }
}
