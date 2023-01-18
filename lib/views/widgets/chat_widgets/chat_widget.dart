import 'package:flutter/material.dart';
import '../../../constants/dims.dart';
import '../../../models/chat.dart';
import '../message_widgets/message_input.dart';
import '../message_widgets/messages_list_widget.dart';

class ChatWidget extends StatelessWidget {
  final Chat chat;
  final String myName;
  final String otherUserName;
  final String otherUserImage;
  final String otherUserGender;

  const ChatWidget(
      {Key? key,
      required this.chat,
      required this.myName,
        required this.otherUserName,
      required this.otherUserImage,
      required this.otherUserGender})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(smallPadding),
      child: Column(
        children: <Widget>[
          Expanded(
              child: MessagesListWidget(
            chat: chat,
            otherUserName: otherUserName,
            otherUserGender: otherUserGender,
            otherUserImage: otherUserImage,
          )),
          MessageInput(chat: chat, myName: myName),
        ],
      ),
    );
  }

}
