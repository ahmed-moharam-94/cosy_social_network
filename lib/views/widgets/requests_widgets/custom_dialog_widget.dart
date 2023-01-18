import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cozy_social_media_app/models/request.dart';
import 'package:cozy_social_media_app/views/widgets/reusable_widgets/circular_loading_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/dims.dart';
import '../../../constants/strings.dart';
import '../../../controllers/chat_controller.dart';
import '../../../controllers/request_controller.dart';
import '../../../models/chat.dart';
import '../../../models/post.dart';

class CustomDialogWidget extends StatefulWidget {
  final Request request;
  final bool acceptButtonPressed;

  const CustomDialogWidget(
      {Key? key, required this.acceptButtonPressed, required this.request})
      : super(key: key);

  @override
  State<CustomDialogWidget> createState() => _CustomDialogWidgetState();
}

class _CustomDialogWidgetState extends State<CustomDialogWidget> {
  bool isLoading = false;

  void setLoadingValue(bool value) {
    if (mounted) {
      setState(() {
        isLoading = value;
      });
    }
  }

  void replyToRequest({required BuildContext context}) async {
    // if user come from accept button then the reply will accept
    // if user come from reject button then the reply will reject
    setLoadingValue(true);
    await Provider.of<RequestController>(context, listen: false)
        .acceptOrRejectRequest(
            requestId: widget.request.requestId,
            receiverId: widget.request.receiverId,
            isAccepted: widget.acceptButtonPressed,
            senderId: widget.request.senderId);
    // if user accept the request  create chat
    if (widget.acceptButtonPressed) {
      await createChat(context);
    }
    Navigator.pop(context);
    setLoadingValue(false);
  }

  Future<void> createChat(context) async {
    final String chatId =
        FirebaseFirestore.instance.collection('chats').doc().id;
    Chat chat = Chat(
        chatId: chatId,
        firstUserId: widget.request.senderId,
        secondUserId: widget.request.receiverId,
        approvedRequestId: widget.request.requestId,
        chatCreatedDate: Timestamp.now());
    await Provider.of<ChatController>(context, listen: false)
        .createChat(chat: chat);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularLoadingIndicatorWidget()
        : AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(dialogRadius)),
            ),
            title: widget.acceptButtonPressed
                ? const Text(acceptTheRequestAlertDialogString)
                : const Text(rejectTheRequestString),
            content: widget.acceptButtonPressed
                ? const Text(alertDialogAcceptContentString)
                : const Text(alertDialogRejectContentString),
            actions: [
              TextButton(
                  onPressed: () {
                    replyToRequest(context: context);
                  },
                  child: widget.acceptButtonPressed
                      ? const Text('       Accept      ')
                      : const Text('      Reject      ')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('      Back      ')),
            ],
          );
  }
}
