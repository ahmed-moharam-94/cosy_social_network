import 'package:flutter/material.dart';

import '../../../constants/dims.dart';

class TextFieldDecorationWidget extends StatelessWidget {
  final Widget textFieldWidget;
  const TextFieldDecorationWidget({Key? key, required this.textFieldWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: largePadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(generalRadius),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.20),
        ),
        child: textFieldWidget);
  }
}
