import 'package:cozy_social_media_app/controllers/user_controller.dart';
import 'package:cozy_social_media_app/models/user.dart';
import 'package:cozy_social_media_app/views/widgets/reusable_widgets/decorated_container_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/chat_controller.dart';
import '../../../controllers/messages_controller.dart';
import '../../../controllers/push_notification_controller.dart';
import '../../../models/chat.dart';
import '../../screens/single_chat_screen.dart';
import '../reusable_widgets/user_avatar_widget.dart';
import 'chat_loading_widget.dart';

class ChatItemWidget extends StatefulWidget {
  final Chat chat;

  const ChatItemWidget({Key? key, required this.chat}) : super(key: key);

  @override
  State<ChatItemWidget> createState() => _ChatItemWidgetState();
}

class _ChatItemWidgetState extends State<ChatItemWidget> {
  bool isFirstUserMe = false;
  bool isLoading = false;
  AppUser me = AppUser();
  AppUser otherUser = AppUser();
  String lastMessage = '';
  String lastMessageSender = '';

  void setLoadingValue(bool loading) {
    if (mounted) {
      setState(() {
        isLoading = loading;
      });
    }
  }

  Future<void> getChatInfo() async {
    setLoadingValue(true);
    await isCurrentUserFirstUser();
    await getBothUsersData(isFirstUserMe);
    await getLastMessageInfo();
    setLoadingValue(false);
  }

  Future<void> isCurrentUserFirstUser() async {
    isFirstUserMe = await Provider.of<ChatController>(context, listen: false)
        .isFirstUserId(widget.chat.chatId);
  }

  Future<AppUser> getUserData(String userId) async {
    return await Provider.of<UserController>(context, listen: false).getUserById(userId);
  }

  Future<void> getBothUsersData(bool isFirstUserMe) async {
    // check which user is opening the app and get the other user name and image to display in the chat
    final firstUserId = widget.chat.firstUserId;
    final secondUserId = widget.chat.secondUserId;
    if (isFirstUserMe) {
      // if it's first user get the other user info
        me = await getUserData(firstUserId);
        otherUser = await getUserData(secondUserId);
    } else {
      me = await getUserData(secondUserId);
      otherUser = await getUserData(firstUserId);
    }
  }


  Future<void> getLastMessageInfo() async {
    Map<String, dynamic> messageInfo =
        await Provider.of<MessagesController>(context, listen: false)
            .getLastMessageInfo(widget.chat.chatId);
    // if no messages yet
    if (messageInfo['message'] == null) {
      return;
    }
    if (mounted) {
      setState(() {
        lastMessage = messageInfo['message'];
        // if the last message sent by me replace it with YOu else it will show the second user name
        lastMessageSender = messageInfo['sender'] == '' ? '${otherUser.name}:' : 'You:';
      });
    }
  }

  @override
  void initState() {
    getChatInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading? const ChatLoadingWidget() : DecoratedContainerWidget(
      child: ListTile(
          title: Text(otherUser.name),
          // subtitle: const,
          leading: UserAvatarWidget(
              radius: 45, userImage: otherUser.image, userGender: otherUser.gender),
          subtitle: Text('$lastMessageSender $lastMessage'),
          onTap: navigateToSpecificChat),
    );
  }

  String otherUserId() {
    String otherUserId = '';
    final chat = widget.chat;
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    if (currentUserId == chat.firstUserId) {
      otherUserId = chat.secondUserId;
    } else {
      otherUserId = chat.firstUserId;
    }
    return otherUserId;
  }

  Future<void> navigateToSpecificChat() async {
    // get device token to send push notification
    String receiverId = otherUserId();
    await Provider.of<PushNotificationController>(context, listen: false)
        .getReceiverDeviceToken(receiverUserId: receiverId);
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => SingleChatScreen(
                chat: widget.chat,
                otherUserName: otherUser.name,
                otherUserImage: otherUser.image,
                otherUserGender: otherUser.gender,
                myName: me.name)))
        .then((value) {
      setState(() {
        // update subtitle with last message
        getLastMessageInfo();
      });
    });
  }
}
