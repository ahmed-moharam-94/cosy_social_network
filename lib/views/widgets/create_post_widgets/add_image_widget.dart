import 'dart:io';

import 'package:cozy_social_media_app/controllers/post_controller.dart';
import 'package:cozy_social_media_app/models/post.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddImageButton extends StatefulWidget {
  final Post post;
  const AddImageButton({Key? key, required this.post}) : super(key: key);

  @override
  State<AddImageButton> createState() => _AddImageButtonState();
}

class _AddImageButtonState extends State<AddImageButton> {
  String imageUrl = '';
  // get image from user
  File? _storedImage;

  Future<void> _chooseImage() async {
    final ImagePicker _picker = ImagePicker();
    final _imageFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 500,
        maxWidth: 500,
        imageQuality: 100);
    if (_imageFile == null) {
      // if user choose didn't choose an avatar image
      return;
    } else {
      // if user choose an avatar image
      setState(() {
        _storedImage = File(_imageFile.path);
      });
      Provider.of<PostController>(context, listen: false)
          .setImageFile(_storedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    imageUrl = widget.post.postImage;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Add Image', style: TextStyle(color: Colors.grey),),
            IconButton(onPressed: _chooseImage, icon: const Icon(Icons.image, color: Colors.grey)),
          ],),
        if (_storedImage != null) // stored image
          storedAvatarBuilder(),
        if (imageUrl != '' && _storedImage == null) // network image
          networkAvatarBuilder(),
      ],
    );
  }

  Widget networkAvatarBuilder() {
    // will be displayed only if the user updating a post that have an imageUrl and hasn't choose another image yet.
    // show if (imageUrl != '' && _storedImage == null)
    return Image.network(imageUrl);
  }

  Widget storedAvatarBuilder() {
    // will be displayed only if the user choose an avatar wither for first time or update the post
    // show if (_storedImage != null)
    return  Image.file(_storedImage!);
  }


}
