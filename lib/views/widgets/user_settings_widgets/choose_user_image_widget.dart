import 'dart:io';

import 'package:cozy_social_media_app/controllers/user_controller.dart';
import 'package:cozy_social_media_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../user_settings_widgets/user_image_widget.dart';


class ChooseUserImageWidget extends StatefulWidget {
  final AppUser user;

  const ChooseUserImageWidget(
      {Key? key, required this.user})
      : super(key: key);

  @override
  State<ChooseUserImageWidget> createState() => _ChooseUserImageWidgetState();
}

class _ChooseUserImageWidgetState extends State<ChooseUserImageWidget> {
  String imageUrl = '';
  // get image from user
  File? _storedImage;

  Future<void> _chooseImage() async {
    final ImagePicker _picker = ImagePicker();
    final _imageFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 150,
        maxWidth: 150,
        imageQuality: 100);

    if (_imageFile == null) {
      // if user choose didn't choose an avatar image
      return;
    } else {
      // if user choose an avatar image
      setState(() {
        _storedImage = File(_imageFile.path);
      });
      Provider.of<UserController>(context, listen: false)
          .setUserImageFile(_storedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppUser user = widget.user;
    imageUrl = user.image;

    return Column(children: [
      if (_storedImage == null && imageUrl == '')
        maleAndFemaleDefaultAvatarBuilder(),
      if (_storedImage != null) // stored image
        storedAvatarBuilder(),
      if (imageUrl != '' && _storedImage == null) // network image
        networkAvatarBuilder(),
    ]);
  }

  Widget maleAndFemaleDefaultAvatarBuilder() {
    // will be displayed only if the user didn't choose an avatar and he didn't update a post that have an imageUrl
    // show if (_storedImage == null && imageUrl == '')
    return GestureDetector(
      onTap: _chooseImage,
      child: UserImageWidget(
          radius: 60, imageUrl: imageUrl, gender: widget.user.gender),
    );
  }

  Widget storedAvatarBuilder() {
    // will be displayed only if the user choose an avatar wither for first time or update the post
    // show if (_storedImage != null)
    return GestureDetector(
      onTap: _chooseImage,
      child: Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: CircleAvatar(
              backgroundColor: Colors.transparent,
              maxRadius: 60,
              backgroundImage: FileImage(_storedImage!))),
    );
  }

  Widget networkAvatarBuilder() {
    // will be displayed only if the user updating a post that have an imageUrl and hasn't choose another image yet.
    // show if (imageUrl != '' && _storedImage == null)
    return GestureDetector(
      onTap: _chooseImage,
      child: Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: CircleAvatar(
              backgroundColor: Colors.transparent,
              maxRadius: 60,
              backgroundImage: NetworkImage(imageUrl))),
    );
  }
}
