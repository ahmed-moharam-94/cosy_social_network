import 'package:cozy_social_media_app/controllers/user_controller.dart';
import 'package:cozy_social_media_app/models/user.dart';
import 'package:cozy_social_media_app/views/widgets/post_widgets/post_reaction_tool_bar_widget.dart';
import 'package:cozy_social_media_app/views/widgets/reusable_widgets/image_viewer_widget.dart';
import 'package:cozy_social_media_app/views/widgets/post_widgets/post_opinion_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/dims.dart';
import '../../../controllers/comment_controller.dart';
import '../../../controllers/post_controller.dart';
import '../../../models/post.dart';
import '../../screens/user_profile_screen.dart';
import '../comments_widget/comments_sheet_widget.dart';
import '../reusable_widgets/decorated_container_widget.dart';
import 'post_loading_indicator_widget.dart';
import '../reusable_widgets/user_avatar_widget.dart';
import 'experience_icon_widget.dart';
import 'name_and_topic_widget.dart';

class SinglePostWidget extends StatefulWidget {
  final Post post;
  final bool
      fromComment; // if we are from comment screen don't open comment screen if we press again on the widget
  const SinglePostWidget(
      {Key? key, required this.post, this.fromComment = false})
      : super(key: key);

  @override
  State<SinglePostWidget> createState() => _SinglePostWidgetState();
}

class _SinglePostWidgetState extends State<SinglePostWidget> {
  bool isLoading = false;
  late Post post;
  bool isMyPost = false;
  int numberOfComments = 0;
  bool bottomSheetIsOpened = true;
  AppUser user = AppUser();

  void setIsLoadingValue(bool value) {
    if (mounted) {
      setState(() {
        isLoading = value;
      });
    }
  }

  Future<void> getPostData() async {
    setIsLoadingValue(true);
    await getUserById();
    await getNumberOfComments();
    isThisMyPost();
    setIsLoadingValue(false);
  }

  Future<void> getUserById() async {
    user = await Provider.of<UserController>(context, listen: false)
        .getUserById(post.userId);
  }

  Future<void> getNumberOfComments() async {
    if (mounted) {
      numberOfComments =
          await Provider.of<CommentController>(context, listen: false)
              .getNumberOfComments(widget.post.postId);
    }
  }

  Future<void> updateNumberOfComments() async {
    setIsLoadingValue(true);
    int numberOfComments =
        await Provider.of<CommentController>(context, listen: false)
            .getNumberOfComments(widget.post.postId);
    if (mounted) {
      setState(() {
        this.numberOfComments = numberOfComments;
      });
    }
    setIsLoadingValue(false);
  }

  void showCommentsBottomSheet() {
    // set bottom sheet is opened
    bottomSheetIsOpened = true;
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        builder: (_) {
          return SizedBox(
              height: MediaQuery.of(context).size.height * .90,
              child: CommentSheetWidget(post: widget.post));
        }).then((value) async {
      // set bottom sheet is closed
      bottomSheetIsOpened = false;
      // update number of comments when closing the sheet
      await updateNumberOfComments();
    });
  }

  Future<void> getPosts() async {
    setIsLoadingValue(true);
    await Provider.of<PostController>(context, listen: false).getAllPosts();
    setIsLoadingValue(false);
  }

  void navigateToPostUserProfileScreen() {
    // navigate to user profile if it is not my post
    if (!isMyPost) {
      String userId = widget.post.userId;
      Navigator.of(context)
          .pushNamed(UserProfileScreen.routeName, arguments: userId);
    }
  }

  void isThisMyPost() {
    if (mounted) {
      isMyPost = Provider.of<PostController>(context, listen: false)
          .isMyPost(widget.post);
    }
  }

  @override
  void didChangeDependencies() {
    post = widget.post;
    getPostData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool postHaveImage = post.postImage != '';
    return isLoading
        ? PostLoadingIndicator(postHasImage: postHaveImage)
        : GestureDetector(
            onTap: showCommentsBottomSheet,
            child: DecoratedContainerWidget(
                child: postContentWidgetBuilder(isMyPost)),
          );
  }

  Widget postContentWidgetBuilder(bool isMyPost) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userAvatarAndExperienceImageWidgetBuilder(),
            const SizedBox(width: smallPadding),
            postContentWidget(),
          ],
        ),
        PostReactionToolBar(
            post: post, isMyPost: isMyPost, numberOfComments: numberOfComments),
      ],
    );
  }

  Widget userAvatarAndExperienceImageWidgetBuilder() {
    return Column(
      children: [
        GestureDetector(
          onTap: navigateToPostUserProfileScreen,
          child: UserAvatarWidget(
              userImage: user.image, userGender: user.gender, radius: 70),
        ),
        const SizedBox(height: mediumPadding),
        ExperienceIconWidget(experience: post.experience),
      ],
    );
  }

  Widget postContentWidget() {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NameAndTopicWidget(
            post: post,
            user: user,
          ),
          const SizedBox(height: mediumPadding),
          PostOpinion(post: post),
          if (post.postImage != '')
            const SizedBox(
              height: mediumPadding,
            ),
          if (post.postImage != '')
            ImageViewerWidget(image: post.postImage, userName: user.name),
        ],
      ),
    );
  }
}
