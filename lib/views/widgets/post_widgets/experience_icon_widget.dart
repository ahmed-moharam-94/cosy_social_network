import 'package:cozy_social_media_app/models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ExperienceIconWidget extends StatelessWidget {
  final String experience;

  const ExperienceIconWidget({Key? key, required this.experience}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String svgAsset() {
      if (experience == 'Positive') {
        return 'assets/images/positive.svg';
      } else {
        return 'assets/images/negative.svg';
      }
    }

    Color svgColor() {
      if (experience == 'Positive') {
        return Colors.green;
      } else {
        return Colors.red;
      }
    }

    return SizedBox(
      height: 60,
      width: 60,
      child: SvgPicture.asset(
        svgAsset(),
        color: svgColor(),
      ),
    );
  }
}
