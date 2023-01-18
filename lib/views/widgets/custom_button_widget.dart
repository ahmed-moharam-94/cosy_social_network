import 'package:cozy_social_media_app/constants/dims.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButtonWidget extends StatelessWidget {
  final IconData? iconData;
  final String description;
  final String? svgAsset;
  final Color color;

  const CustomButtonWidget(
      {Key? key,
      required this.description,
      this.iconData,
      this.svgAsset,
      required this.color})
      : super(key: key);

  Widget iconWidget(BuildContext context) {
    if (iconData == null) {
      return SizedBox(
          width: 25,
          height: 25,
          child: SvgPicture.asset(
            svgAsset!,
            color: color,
          ));
    } else {
      return Icon(
        iconData,
        color: color.withOpacity(0.80),
        size: 30,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: tinyPadding, vertical: tinyPadding),
        padding: const EdgeInsets.symmetric(horizontal: tinyPadding, vertical: tinyPadding),
        decoration: BoxDecoration(
          color: color.withOpacity(0.40),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            iconWidget(context),
            const SizedBox(height: 5),
            Text(description, style: TextStyle(color: color)),
          ],
        ));
  }
}
