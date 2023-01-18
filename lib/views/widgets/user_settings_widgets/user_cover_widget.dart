import 'dart:io';

import 'package:cozy_social_media_app/constants/dims.dart';
import 'package:cozy_social_media_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../controllers/user_controller.dart';

class ChooseUserCoverWidget extends StatefulWidget {
  final AppUser user;

  const ChooseUserCoverWidget({Key? key, required this.user}) : super(key: key);

  @override
  State<ChooseUserCoverWidget> createState() => _UserCoverImageState();
}

class _UserCoverImageState extends State<ChooseUserCoverWidget> {
  String coverUrl = '';

  // get image from user
  File? _storedImage;

  Future<void> _chooseImage() async {
    final ImagePicker _picker = ImagePicker();
    final _imageFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: double.infinity,
        maxWidth: double.infinity,
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
          .setUserCoverImageFile(_storedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppUser user = widget.user;
    coverUrl = user.cover;

    return Column(
      children: [
        if (_storedImage == null && coverUrl == '') noCoverWidgetBuilder(),
        if (_storedImage != null) // stored image
          storedCoverImageBuilder(),
        if (coverUrl != '' && _storedImage == null) // network image
          networkCoverBuilder()
      ],
    );
  }

  Widget noCoverWidgetBuilder() {
    String chooseCover = 'Choose Cover Image';
    return GestureDetector(
      onTap: _chooseImage,
      child: Stack(
        children: [
          SizedBox(
              width: double.infinity,
              height: 200,
              child: SvgPicture.asset('assets/images/auth_screen_image.svg')),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: mediumPadding, vertical: mediumPadding),
                alignment: Alignment.bottomRight,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                ),
                child: Text(chooseCover,
                    style: const TextStyle(color: Colors.white))),
          ),
        ],
      ),
    );
  }

  Widget storedCoverImageBuilder() {
    // will be displayed only if the user choose an avatar wither for first time or update the post
    // show if (_storedImage != null)
    return GestureDetector(
      onTap: _chooseImage,
      child: SizedBox(
          width: double.infinity,
          height: 200,
          child: Image(
            image: FileImage(_storedImage!),
            fit: BoxFit.cover,
          )),
    );
  }

  Widget networkCoverBuilder() {
    // will be displayed only if the user updating a post that have an imageUrl and hasn't choose another image yet.
    // show if (imageUrl != '' && _storedImage == null)
    return GestureDetector(
      onTap: _chooseImage,
      child: SizedBox(
          width: double.infinity,
          height: 200,
          child: Image(
            image: NetworkImage(coverUrl),
            fit: BoxFit.cover,
          )),
    );
  }
}
