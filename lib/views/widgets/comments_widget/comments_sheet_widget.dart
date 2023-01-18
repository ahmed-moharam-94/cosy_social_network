import 'package:cozy_social_media_app/models/post.dart';
import 'package:cozy_social_media_app/views/widgets/post_widgets/post_reaction_tool_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/comment_controller.dart';
import '../../../controllers/user_controller.dart';
import '../../../models/user.dart';
import 'comment_text_field_widget.dart';
import 'comments_list_widget.dart';

class CommentSheetWidget extends StatefulWidget {
  final Post post;

  const CommentSheetWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<CommentSheetWidget> createState() => _CommentSheetWidgetState();
}

class _CommentSheetWidgetState extends State<CommentSheetWidget> {
  late double screenHeight;
  late Post post;
  late AppUser user;
  bool isLoading = false;
  bool firstBuild = true;

  Future<void> getPostComments() async {
    await getAllCommentsExceptUserComment();
    await getCommentsExceptUserComments();
  }

  Future<void> getAllCommentsExceptUserComment() async {
    await Provider.of<CommentController>(context, listen: false)
        .getUserComments(post.postId);
  }

  Future<void> getCommentsExceptUserComments() async {
    await Provider.of<CommentController>(context, listen: false)
        .getPostCommentsExceptUsersComment(post.postId);
  }

  void getCurrentUserData() {
    user = Provider.of<UserController>(context, listen: false).currentUser;
  }

  void setIsLoadingValue(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  void initState() {
    getCurrentUserData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    screenHeight = MediaQuery.of(context).size.height;
    post = widget.post;
    if (firstBuild) {
      setIsLoadingValue(true);
      getPostComments();
      setIsLoadingValue(false);
      getNumberOfComments();
    }
    firstBuild = false;
    super.didChangeDependencies();
  }

  int numberOfComments = 0;

  Future<void> getNumberOfComments() async {
    setIsLoadingValue(true);
    int numberOfComments =
        await Provider.of<CommentController>(context, listen: false)
            .getNumberOfComments(widget.post.postId);
    setState(() {
      this.numberOfComments = numberOfComments;
    });
    setIsLoadingValue(false);
  }

  void writeCommentCallback(bool value) {
    // get the post comments after write a comment
    getPostComments();
    setState(() {
      numberOfComments++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: isLoading
          ? loadingIndicatorWidgetBuilder()
          : Consumer<CommentController>(
              builder: (_, provider, ch) {
                final _comments = provider.allComments;
                final _userComments = provider.userComments;
                return Column(
                  children: [
                    PostReactionToolBar(
                        post: post,
                        isMyPost: false,
                        numberOfComments: numberOfComments),
                    const Divider(height: 2, thickness: 2),
                    Expanded(
                      child: CommentsListWidget(
                        post: widget.post,
                        comments: _comments,
                        userComments: _userComments,
                      ),
                    ),
                    CommentTextFieldWidget(
                        screenHeight: screenHeight,
                        post: widget.post,
                        user: user,
                        writeCommentCallback: writeCommentCallback),
                  ],
                );
              },
            ),
    );
  }

  Widget loadingIndicatorWidgetBuilder() {
    return const Center(child: CircularProgressIndicator());
  }
}
