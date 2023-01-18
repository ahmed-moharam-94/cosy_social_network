import 'package:flutter/material.dart';
import '../../../models/chat.dart';
import 'chat_item_widget.dart';

class ChatsListWidget extends StatelessWidget {
  final List<Chat> chats;
  const ChatsListWidget({Key? key, required this.chats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final _chat = chats[index];
          return ChatItemWidget(chat: _chat);
        }, childCount: chats.length));
  }
}
