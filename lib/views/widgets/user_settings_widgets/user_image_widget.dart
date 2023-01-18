import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserImageWidget extends StatelessWidget {
  final double radius;
  final String imageUrl;
  final String gender;

  const UserImageWidget(
      {Key? key,
        required this.radius,
        required this.imageUrl,
        required this.gender})
      : super(key: key);

  String get image {
    if (imageUrl == '') {
      if (gender == 'Male') {
        return 'assets/images/man.svg';
      } else {
        return 'assets/images/woman.svg';
      }
    } else {
      return imageUrl;
    }
  }

  Color get _frameColor {
    if (gender == 'Male') {
      return Colors.black54;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (imageUrl != '')
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
              backgroundImage: NetworkImage(imageUrl),
            ),
          ),
        if (imageUrl == '')
          Container(
            decoration: BoxDecoration(
              color: gender == 'Male'? Theme.of(context).colorScheme.secondary.withOpacity(
                  0.2) : Theme.of(context).colorScheme.primary.withOpacity(0.2),
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              border: Border.all(color: _frameColor, width: 3),
            ),
            alignment: Alignment.center,
            width: radius,
            height: radius,
            child: SvgPicture.asset(image, fit: BoxFit.contain, height: 50,width: 50),
          ),
      ],
    );
  }
}
