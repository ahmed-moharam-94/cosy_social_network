import 'package:cozy_social_media_app/constants/dims.dart';
import 'package:flutter/material.dart';
import '../../../models/post.dart';
import '../custom_button_widget.dart';
import '../title_widget_row.dart';

class ChooseExperienceWidget extends StatefulWidget {
  final Post post;

  const ChooseExperienceWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<ChooseExperienceWidget> createState() => _ChooseExperienceWidgetState();
}

class _ChooseExperienceWidgetState extends State<ChooseExperienceWidget> {
  // initialize is muslim equal true
  bool _isPositive = true;

  void toggleReligion({required bool isPositive, required Post post}) {
    setState(() {
      _isPositive = isPositive;
      if (isPositive) {
        post.experience = 'Positive';
      } else {
        post.experience = 'Negative';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Post post = widget.post;
    // if updating my post get the post religion value
    _isPositive = post.experience == 'Positive';
    return TitleWidgetRow(
        title: 'Experience',
        widget: Row(
          children: [
            const SizedBox(width: smallPadding),
            GestureDetector(
              child: CustomButtonWidget(
                  svgAsset: 'assets/images/positive.svg',
                  description: 'Positive',
                  color: _isPositive
                      ? Colors.green
                      : Colors.grey),
              onTap: () => toggleReligion(isPositive: true, post: post),
            ),
            const SizedBox(width: tinyPadding),
            GestureDetector(
              child: CustomButtonWidget(
                  svgAsset: 'assets/images/negative.svg',
                  description: 'Negative',
                  color: _isPositive
                      ? Colors.grey
                      : Colors.red),
              onTap: () => toggleReligion(isPositive: false, post: post),
            ),
          ],
        ));
  }
}
