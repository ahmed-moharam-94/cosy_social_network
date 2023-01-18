import 'package:flutter/material.dart';

import '../../../constants/dims.dart';

class DecoratedContainerWidget extends StatelessWidget {
  final Widget child;

  const DecoratedContainerWidget({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
          left: smallPadding,
          right: smallPadding,
          top: smallPadding,
          bottom: 0),
      margin: const EdgeInsets.only(
          left: smallPadding, right: smallPadding, top: smallPadding),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(smallPadding)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(myColorOpacity),
            spreadRadius: mySpreadRadius,
            blurRadius: myBlurRadius,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}
