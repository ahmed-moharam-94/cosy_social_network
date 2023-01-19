import 'package:cozy_social_media_app/constants/dims.dart';
import 'package:cozy_social_media_app/controllers/post_controller.dart';
import 'package:cozy_social_media_app/models/user.dart';
import 'package:cozy_social_media_app/views/widgets/requests_widgets/send_request_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../reusable_widgets/decorated_container_widget.dart';

class UserBioAndSendRequestWidget extends StatefulWidget {
  final AppUser profileUser;

  const UserBioAndSendRequestWidget({Key? key, required this.profileUser})
      : super(key: key);

  @override
  State<UserBioAndSendRequestWidget> createState() =>
      _UserBioAndSendRequestWidgetState();
}

class _UserBioAndSendRequestWidgetState
    extends State<UserBioAndSendRequestWidget> {
  bool isLoading = false;
  int numberOfPosts = 0;

  void setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> getUserPostsNumber() async {
    setIsLoading(true);
    // print(widget.profileUser.id);
    numberOfPosts = await Provider.of<PostController>(context, listen: false)
        .getUserPostsNumber(widget.profileUser.id);
    setIsLoading(false);
  }

  @override
  void initState() {
    getUserPostsNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.profileUser;
    return Padding(
      padding: const EdgeInsets.all(tinyPadding),
      child: DecoratedContainerWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user.bio.isNotEmpty) aboutMeWidgetBuilder(user.bio),
            numberOfPostsAndRequestButtonWidgetBuilder(),
            const SizedBox(height: mediumPadding),
          ],
        ),
      ),
    );
  }

  Widget loadingIndicatorWidgetBuilder() {
    return Column(
      children: const [
        SizedBox(height: hugePadding),
        CircularProgressIndicator(),
      ],
    );
  }

  Widget aboutMeWidgetBuilder(String bio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About Me:',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        Text(bio, overflow: TextOverflow.fade),
        const SizedBox(height: smallPadding)
      ],
    );
  }

  Widget numberOfPostsAndRequestButtonWidgetBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isLoading) loadingIndicatorWidgetBuilder(),
        if (!isLoading)
          Text(
            'Number of posts: $numberOfPosts',
            style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
        SendRequestButtonWidget(profileUser: widget.profileUser),
      ],
    );
  }
}
