import 'package:cozy_social_media_app/models/user.dart';
import 'package:flutter/material.dart';

import '../../../constants/dims.dart';
import '../custom_button_widget.dart';
import '../title_widget_row.dart';

class ChooseGenderWidget extends StatefulWidget {
  final AppUser user;
  final void Function(bool) isMaleCallBack;

  const ChooseGenderWidget(
      {Key? key, required this.user, required this.isMaleCallBack})
      : super(key: key);

  @override
  State<ChooseGenderWidget> createState() => _ChooseGenderWidgetState();
}

class _ChooseGenderWidgetState extends State<ChooseGenderWidget> {
  // initialize gender is true
  bool _isMale = true;

  void toggleGender({required bool isMale, required AppUser user}) {
    setState(() {
      _isMale = isMale;
      if (isMale) {
        user.gender = 'Male';
      } else {
        user.gender = 'Female';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    // if updating my post get the post gender value
    _isMale = user.gender == 'Male';
    return TitleWidgetRow(
        title: 'Gender',
        widget: Row(
          children: [
            GestureDetector(
              child: CustomButtonWidget(
                  iconData: Icons.man,
                  description: 'Male',
                  color: _isMale
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade500),
              onTap: () {
                toggleGender(isMale: true, user: user);
                widget.isMaleCallBack(true);
              },
            ),
            const SizedBox(width: mediumPadding),
            GestureDetector(
              child: CustomButtonWidget(
                  iconData: Icons.woman,
                  description: 'Female',
                  color: _isMale
                      ? Colors.grey.shade500
                      : Theme.of(context).colorScheme.primary),
              onTap: () {
                toggleGender(isMale: false, user: user);
                widget.isMaleCallBack(false);
              },
            ),
          ],
        ));
  }
}
