import 'package:flutter/material.dart';
import '../../../constants/dims.dart';
import '../../../models/post.dart';
import '../post_widgets/single_post_widget.dart';

class UserPostsListWidget extends StatefulWidget {
  const UserPostsListWidget({Key? key}) : super(key: key);

  @override
  State<UserPostsListWidget> createState() => _UserPostsListWidgetState();
}

class _UserPostsListWidgetState extends State<UserPostsListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: tinyPadding),
      // sliver: SliverList(
      //     delegate: SliverChildBuilderDelegate(
      //           (context, index) {
      //         final Post _post = _posts[index];
      //         return Provider.value(
      //           value: _posts[index],
      //           child: Column(
      //             children: [
      //               SinglePostWidget(
      //                   post: _post),
      //               // add padding at the last index
      //               if (index == _posts.length - 1)
      //                 bottomPaddingWidget(),
      //             ],
      //           ),
      //         );
      //       },
      //       childCount: _posts.length,
      //     )),
    );
  }

  Widget loadingIndicatorWidgetBuilder() {
    return  SliverToBoxAdapter(child: Column(
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
                  'User doesn\'t have any post yet.',
                  style: TextStyle(fontSize: 18),
                )),
          ],
        ));
  }
}
