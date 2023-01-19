import 'package:cozy_social_media_app/models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../post_widgets/image_detail_widget.dart';

class UserAvatarWidget extends StatelessWidget {
  final String userImage;
  final String userGender;
  final double radius;

  const UserAvatarWidget(
      {Key? key,
        required this.userImage,
        required this.userGender,
        required this.radius})
      : super(key: key);

  String get image {
    // if user image url is empty return default gender image
    if (userImage == '') {
      if (userGender == 'Male') {
        return 'assets/images/man.svg';
      } else {
        return 'assets/images/woman.svg';
      }
    } else {
      return userImage;
    }
  }

  Color get _frameColor {
    if (userGender == 'Male') {
      return Colors.black54;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (userImage != '')
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              border: Border.all(color: _frameColor, width: 3),
            ),
            alignment: Alignment.center,
            width: radius,
            height: radius,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              maxRadius: radius,
              backgroundImage: NetworkImage(userImage),
            ),
          ),
        if (userImage == '')
          Container(
            decoration: BoxDecoration(
              color: userGender == 'Male'
                  ? Theme.of(context).colorScheme.secondary.withOpacity(0.2)
                  : Theme.of(context).colorScheme.primary.withOpacity(0.2),
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              border: Border.all(color: _frameColor, width: 3),
            ),
            alignment: Alignment.center,
            width: radius,
            height: radius,
            child: SvgPicture.asset(image,
                fit: BoxFit.contain, height: 50, width: 50),
          ),
      ],
    );
  }
}
