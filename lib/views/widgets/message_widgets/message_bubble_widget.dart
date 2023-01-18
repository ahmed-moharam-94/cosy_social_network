import 'package:cozy_social_media_app/views/widgets/reusable_widgets/user_avatar_widget.dart';
import 'package:flutter/material.dart';
import '../../../constants/dims.dart';
import '../../../constants/strings.dart';
import '../reusable_widgets/image_viewer_widget.dart';

class MessageBubbleWidget extends StatelessWidget {
  final String message;
  final bool isMe;
  final String otherUserGender;
  final String otherUserImage;

  const MessageBubbleWidget(
      {Key? key,
      required this.message,
      required this.isMe,
      required this.otherUserGender,
      required this.otherUserImage,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;
    bool isMessageImage = message.contains(imageMessageBucket);

    return isMessageImage
        ? imageMessageWidgetBuilder()
        : textMessageWidgetBuilder(context, screenWidth);
  }

  Widget imageMessageWidgetBuilder() {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isMe) const SizedBox(width: tinyPadding),
        Container(
          constraints: const BoxConstraints(
            maxHeight: 300,
            maxWidth: 300
          ),
          margin: const EdgeInsets.symmetric(vertical: tinyPadding),
          child: ImageViewerWidget(image: message, userName: ''),
        )
      ],
    );
  }

  Widget textMessageWidgetBuilder(
    BuildContext context,
      double screenWidth
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        // if it is the other user show his image avatar
        if (!isMe)
          UserAvatarWidget(
            radius: 50,
            userImage: otherUserImage,
            userGender: otherUserGender,
          ),
        messageBodyWidgetBuilder(screenWidth, context),
      ],
    );
  }

  Widget messageBodyWidgetBuilder(double screenWidth, BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth:  screenWidth - 150,
      ),
      margin: isMe
          ? const EdgeInsets.only(
          left: 0,
          right: tinyPadding,
          top: tinyPadding,
          bottom: tinyPadding)
          : const EdgeInsets.only(
          left: tinyPadding,
          right: 0,
          top: tinyPadding,
          bottom: tinyPadding),
      padding: const EdgeInsets.all(mediumPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(generalRadius),
              topRight: const Radius.circular(generalRadius),
              bottomLeft: isMe
                  ? const Radius.circular(generalRadius)
                  : const Radius.circular(0),
              bottomRight: isMe
                  ? const Radius.circular(0)
                  : const Radius.circular(generalRadius)),
          color: isMe
              ? Theme.of(context).colorScheme.primary.withOpacity(0.85)
              : Theme.of(context).colorScheme.secondary.withOpacity(0.85),
        ),
      child: Text(message,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.white)),
    );
  }
}
