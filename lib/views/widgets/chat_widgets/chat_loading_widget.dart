import 'package:flutter/material.dart';

import '../../../constants/dims.dart';
import '../reusable_widgets/decorated_container_widget.dart';

class ChatLoadingWidget extends StatelessWidget {
  const ChatLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedContainerWidget(
        child: ListTile(
          leading: fakeUserAvatar(),
          title: fakeNameWidgetBuilder(),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: smallPadding),
              fakeRequestContent(),
            ],
          ),
        ));
  }

  Widget fakeUserAvatar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        border: Border.all(color: Colors.grey, width: 3),
      ),
      alignment: Alignment.center,
      height: 50,
      width: 50,
    );
  }

  Widget fakeNameWidgetBuilder() {
    return Container(
      height: 20,
      width: 150,
      decoration: const BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.all(Radius.circular(smallPadding)),
      ),
    );
  }

  Widget fakeRequestContent() {
    return Container(
      height: 20,
      width: 170,
      decoration: const BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.all(Radius.circular(smallPadding)),
      ),
    );
  }
}

