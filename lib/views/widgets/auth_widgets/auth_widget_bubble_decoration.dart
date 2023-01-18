import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class AuthWidgetDecoration extends StatelessWidget {
  final double size;
  final double? top;
  final double? left;
  final double? bottom;
  final double? right;
  const AuthWidgetDecoration({Key? key, required this.size, required this.left, required this.top, required this.right, required this.bottom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      bottom: bottom,
      right: right,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
            color:  authScreenDecorationOrange.withOpacity(.3),
            borderRadius: const BorderRadius.all(Radius.circular(500))),
      ),
    );
  }
}
