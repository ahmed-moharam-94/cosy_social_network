import 'package:flutter/material.dart';

class TitleWidgetRow extends StatelessWidget {
  final String title;
  final Widget widget;
  final bool addDivider;

  const TitleWidgetRow(
      {Key? key,
      required this.title,
      required this.widget,
      this.addDivider = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey)),
            widget,
          ],
        ),
        if (addDivider) Divider(color: Colors.grey.shade400, thickness: 1),
      ],
    );
  }
}
