import 'package:flutter/material.dart';

import '../../../constants/dims.dart';

class BottomNavigationBarDecoration extends StatelessWidget {
  final Widget bottomBarWidget;

  const BottomNavigationBarDecoration({Key? key, required this.bottomBarWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(generalRadius),
            topLeft: Radius.circular(generalRadius)),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(myColorOpacity),
              spreadRadius: mySpreadRadius,
              blurRadius: myBlurRadius),
        ],
      ),
      height: 70,
      child: bottomBarWidget,
    );
  }
}
