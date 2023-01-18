import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cozy_social_media_app/controllers/messages_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/dims.dart';
import '../../../models/chat.dart';
import 'message_bubble_widget.dart';

class MessagesListWidget extends StatelessWidget {
  final Chat chat;
  final String otherUserName;
  final String otherUserImage;
  final String otherUserGender;

  const MessagesListWidget({
    Key? key,
    required this.chat,
    required this.otherUserName,
    required this.otherUserImage,
    required this.otherUserGender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String chatId = chat.chatId;
    return StreamBuilder<QuerySnapshot>(
      stream: Provider.of<MessagesController>(context).getMessagesStream(),
      builder: (context, streamSnapShot) {
        if (streamSnapShot.connectionState == ConnectionState.waiting) {
          return loadingIndicatorWidgetBuilder();
        } else if (streamSnapShot.data!.docs.isNotEmpty) {
          final messages = streamSnapShot.data!.docs
              .where((message) => message['chatId'] == chatId)
              .toList() as List<QueryDocumentSnapshot<Map<String, dynamic>>>;
          return Padding(
            padding: const EdgeInsets.all(mediumPadding),
            child: messagesListWidgetBuilder(messages, context),
          );
        } else {
          return noMessagesWidgetBuilder(context);
        }
      },
    );
  }

  Widget appBarWidgetBuilder(context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
      child: Row(
        children: [
          GestureDetector(
              child: const Icon(Icons.arrow_back_ios_outlined),
              onTap: () {
                Navigator.of(context).pop();
              }),
          const SizedBox(width: smallPadding),
          Expanded(
            child: Text(otherUserName,
                maxLines: 1,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Widget loadingIndicatorWidgetBuilder() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget messagesListWidgetBuilder(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> messages,
      BuildContext context) {
    final _firebaseAuth = FirebaseAuth.instance;

    return Column(
      children: [
        appBarWidgetBuilder(context),
        Expanded(
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final _message = messages[index]['text'];
                final _isMe = messages[index]['senderId'] ==
                    _firebaseAuth.currentUser!.uid;
                return MessageBubbleWidget(
                  otherUserGender: otherUserGender,
                  otherUserImage: otherUserImage,
                  message: _message,
                  isMe: _isMe,
                );
              }),
        ),
      ],
    );
  }

  Widget noMessagesWidgetBuilder(BuildContext context) {
    return Column(
      children: [
        appBarWidgetBuilder(context),
        const Expanded(child: Center(child: Text('no messages yet'))),
      ],
    );
  }
}
