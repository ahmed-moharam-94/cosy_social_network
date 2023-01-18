import 'package:cozy_social_media_app/models/post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/comment_controller.dart';
import '../comments_widget/comments_sheet_widget.dart';

class CommentIconWidget extends StatefulWidget {
  final Post post;
  final int commentsNumber;

  const CommentIconWidget(
      {Key? key, required this.post, required this.commentsNumber})
      : super(key: key);

  @override
  State<CommentIconWidget> createState() => _CommentIconWidgetState();
}

class _CommentIconWidgetState extends State<CommentIconWidget> {
  int numberOfComments = 0;
  bool isLoading = false;
  bool bottomSheetIsOpened = true;

  void setIsLoadingValue(bool value) {
    if (mounted) {
      setState(() {
      isLoading = value;
    });
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

  void updateWhenCommentFromSheet() {
    if (mounted) {
      setState(() {
        numberOfComments = widget.commentsNumber;
      });
    }
  }

  void updateWhenUserWriteCommentFromBottomSheet() {
    // update the number of comments when the user write comment in the bottom sheet bar
    // only run when the bottom sheet is open
    if (bottomSheetIsOpened) {
      updateWhenCommentFromSheet();
    }
  }

  @override
  void didChangeDependencies() {
    updateNumberOfComments();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    updateWhenUserWriteCommentFromBottomSheet();
      return isLoading?  loadingIndicatorWidgetBuilder() : Row(
      children: [
        IconButton(
          icon: Icon(Icons.comment_rounded, color: Colors.grey.shade400),
          onPressed: showCommentsBottomSheet,
        ),
        Text(numberOfComments.toString()),
      ],
    );
  }


  Widget loadingIndicatorWidgetBuilder() {
    return const SizedBox(
        height: 20,
        width: 20,
        child: Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
              strokeWidth: 2,
            )));
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
}
