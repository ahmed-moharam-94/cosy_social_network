import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/post.dart';
import '../widgets/create_post_widgets/create_post_widget.dart';

class CreatePostScreen extends StatefulWidget {
  static const String routeName = 'CreatePostScreen';

  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  // initialize post data
  late Post _post;

  // create new post and not update post by default
  bool updateMyPost = false;

  @override
  void initState() {
    // initialize the post
    _post = Post(
      topic: 'Arts',
      experience: 'Positive',
      postId: '',
      userId: '',
      postDate: Timestamp.now(),
      postImage: '',
      userGender: 'Male',
      opinion: '',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // get Post data if it's my post
    final _existingPost = ModalRoute.of(context)?.settings.arguments;
    // check if there is arguments if user update his posts
    if (_existingPost != null) {
        updateMyPost = true;
        _post = _existingPost as Post;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('Create Post'),
        elevation: 0,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: CreatePostWidget(post: _post, updateMyPost: updateMyPost),
    );
  }
}
