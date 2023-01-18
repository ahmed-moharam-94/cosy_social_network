import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/chat_controller.dart';
import '../widgets/chat_widgets/chats_list_widget.dart';
import '../widgets/sliver_appbar_widget.dart';

class GroupedChatsScreen extends StatefulWidget {
  static const String routeName = 'ChatScreen';

  const GroupedChatsScreen({Key? key}) : super(key: key);

  @override
  State<GroupedChatsScreen> createState() => _GroupedChatsScreenState();
}

class _GroupedChatsScreenState extends State<GroupedChatsScreen> {
  bool isLoading = false;

  @override
  void initState() {
    getChats();
    super.initState();
  }

  Future<void> getChats() async {
    setLoadingValue(true);
    await Provider.of<ChatController>(context, listen: false).getChats();
    setLoadingValue(false);
  }

  void setLoadingValue(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: isLoading
            ? loadingIndicatorWidgetBuilder()
            : Consumer<ChatController>(builder: (_, provider, __) {
                final _chats = provider.chats;
                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      const CustomSliverAppBarWidget(title: 'Your Chats'),
                      if (_chats.isEmpty)
                        emptyChatsWidgetBuilder(),
                      if (_chats.isNotEmpty)
                      ChatsListWidget(chats: _chats),
                    ],
                  );
              }));
  }

  Widget emptyChatsWidgetBuilder() {
    return const SliverToBoxAdapter(
      child: Center(
          child: Text(
        'You don\'t have chats yet',
        style: TextStyle(fontSize: 18),
      )),
    );
  }

  Widget loadingIndicatorWidgetBuilder() {
    return const Center(child: CircularProgressIndicator());
  }
}
