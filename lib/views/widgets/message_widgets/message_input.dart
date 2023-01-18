import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cozy_social_media_app/views/widgets/reusable_widgets/circular_loading_indicator_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../constants/dims.dart';
import '../../../constants/strings.dart';
import '../../../controllers/messages_controller.dart';
import '../../../controllers/push_notification_controller.dart';
import '../../../models/chat.dart';
import '../../../models/message.dart';

class MessageInput extends StatefulWidget {
  final Chat chat;
  final String myName;

  const MessageInput({Key? key, required this.chat, required this.myName})
      : super(key: key);

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _firestore = FirebaseFirestore.instance;
  final _senderId = FirebaseAuth.instance.currentUser!.uid;
  final _textInputController = TextEditingController();
  final _imagePicker = ImagePicker();
  bool isLoading = false;
  String _message = '';

  void _sendMessage(BuildContext context) async {
    // unFocus keyboard
    unFocusKeyboardWhenSendingMessage(context);
    // if message is empty return
    if (_message.isEmpty) return;
    cleatTextField();
    await sendTextMessageToFirebase(context);
    // send push notification
    sendMessagePushNotification(_message);
  }

  void unFocusKeyboardWhenSendingMessage(context) {
    FocusScope.of(context).unfocus();
  }

  void cleatTextField() {
    if (mounted) {
      setState(() {
        _textInputController.clear();
      });
    }
  }

  Future<void> sendTextMessageToFirebase(BuildContext context) async {
    final messageId = _firestore.collection('messages').doc().id;

    Message message = Message(
        id: messageId,
        chatId: widget.chat.chatId,
        createDate: Timestamp.now(),
        senderId: _senderId,
        text: _message);
    await Provider.of<MessagesController>(context, listen: false)
        .sendTextMessage(message);
  }

  Future<File> pickImageFile() async {
    File imageFile;
    final pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: double.infinity, maxHeight: double.infinity,imageQuality: 100);
    imageFile = File(pickedImage!.path);
    return imageFile;
  }

  Future<void> sendImageToFirebase(BuildContext context, File imageFile) async {
    final messageId = _firestore.collection('messages').doc().id;

    Message message = Message(
        id: messageId,
        chatId: widget.chat.chatId,
        createDate: Timestamp.now(),
        senderId: _senderId,
        text: '');
    await Provider.of<MessagesController>(context, listen: false)
        .sendImageMessage(message, imageFile);
  }

  Future<void> sendMessagePushNotification(String message) async {
    final devicesTokens =
        Provider.of<PushNotificationController>(context, listen: false)
            .receiverDevicesTokens;
    print(devicesTokens);
    await Provider.of<PushNotificationController>(context, listen: false)
        .sendPushNotification(
            title: widget.myName, type: 'chat_message', body: message, devicesTokens: devicesTokens);
  }

  Future<void> _sendImage(BuildContext context) async {
    File imageFile = await pickImageFile();
    setIsLoadingValue(true);
    await sendImageToFirebase(context, imageFile);
    setIsLoadingValue(false);
    sendMessagePushNotification('Sent an attachment');
  }

  void setIsLoadingValue(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoading) const CircularLoadingIndicatorWidget(),
        messageInputWidgetBuilder(),
      ],
    );
  }

  Widget messageInputWidgetBuilder() {
    return Row(
      children: [
        sendMessageTextFieldWidgetBuilder(),
        sendTextIconWidgetBuilder(context),
        sendImageIconWidgetBuilder(context)
      ],
    );
  }

  Widget sendMessageTextFieldWidgetBuilder() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: largePadding),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.all(
                Radius.circular(sendMessageTextFieldRadius))),
        child: TextField(
          controller: _textInputController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            label: Text(writeYourMessage, style: TextStyle(color: Colors.grey)),
          ),
          onChanged: (value) {
            setState(() {
              _message = value;
            });
          },
        ),
      ),
    );
  }

  Widget sendTextIconWidgetBuilder(context) {
    return IconButton(
      icon: const Icon(Icons.image, color: Colors.grey),
      onPressed: () async {
        await _sendImage(context);
      },
    );
  }

  Widget sendImageIconWidgetBuilder(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.send,
          color: _textInputController.text.trim().isEmpty
              ? Colors.grey
              : Theme.of(context).colorScheme.primary),
      onPressed: _textInputController.text.trim().isEmpty
          ? null
          : () {
              _sendMessage(context);
            },
    );
  }
}
