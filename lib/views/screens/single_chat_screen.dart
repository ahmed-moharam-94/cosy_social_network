import 'package:flutter/material.dart';
import '../../models/chat.dart';
import '../widgets/chat_widgets/chat_widget.dart';

class SingleChatScreen extends StatelessWidget {
  final Chat chat;
  final String otherUserName;
  final String myName;
  final String otherUserImage;
  final String otherUserGender;
  static const String routeName = 'SingleChatScreen';

  const SingleChatScreen(
      {Key? key,
      required this.chat,
      required this.myName,
        required this.otherUserName,
      required this.otherUserImage,
      required this.otherUserGender})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: ChatWidget(
            chat: chat,
            myName: myName,
            otherUserName: otherUserName,
            otherUserImage: otherUserImage,
            otherUserGender: otherUserGender));
  }
}
