import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cozy_social_media_app/controllers/request_controller.dart';
import 'package:cozy_social_media_app/controllers/user_controller.dart';
import 'package:cozy_social_media_app/models/user.dart';
import 'package:cozy_social_media_app/views/widgets/requests_widgets/request_status_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/enums.dart';
import '../../../constants/strings.dart';
import '../../../controllers/push_notification_controller.dart';
import '../../../models/request.dart';
import '../reusable_widgets/circular_loading_indicator_widget.dart';

class SendRequestButtonWidget extends StatefulWidget {
  final AppUser profileUser;

  const SendRequestButtonWidget({Key? key, required this.profileUser})
      : super(key: key);

  @override
  State<SendRequestButtonWidget> createState() =>
      _SendRequestButtonWidgetState();
}

class _SendRequestButtonWidgetState extends State<SendRequestButtonWidget> {
  late Request request;
  bool isLoading = false;
  bool alreadyRequestSent = false;
  bool alreadyFriends = false;

  void createRequest() {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final profileUserId = widget.profileUser.id;
    final requestId =
        FirebaseFirestore.instance.collection('requests').doc().id;
    request = Request(
        requestId: requestId,
        requestDate: Timestamp.now(),
        senderId: currentUserId,
        receiverId: profileUserId,
        isAccepted: false,
        replied: false);
  }

  Future<void> sendRequest() async {
    // create new request
    setLoadingValue(true);
    createRequest();
    await Provider.of<RequestController>(context, listen: false)
        .sendRequest(request: request);
    // send Push notifications
    sendRequestPushNotification(sentYouFriendRequest);
    setState(() {
      alreadyRequestSent = true;
    });
    setLoadingValue(false);
  }

  Future<void> checkIfRequestStatus() async {
    final senderId = FirebaseAuth.instance.currentUser!.uid;
    final receiverId = widget.profileUser.id;
    setLoadingValue(true);
    bool sentBefore = await wasRequestSentBefore(senderId, receiverId);
    setState(() {
      alreadyRequestSent = sentBefore;
    });

    // check if they are friends
    if (sentBefore) {
      bool friends = await areFriends(senderId, receiverId);
      setState(() {
        alreadyFriends = friends;
      });
    }
    setLoadingValue(false);
  }

  Future<bool> wasRequestSentBefore(String senderId, String receiverId) async {
    return await Provider.of<RequestController>(context, listen: false)
        .wasRequestSentToThisUserBefore(
            senderId: senderId, receiverId: receiverId);
  }

  Future<bool> areFriends(String senderId, String receiverId) async {
    return await Provider.of<RequestController>(context, listen: false)
        .areFriends(profileUserId: widget.profileUser.id);
  }

  Future<void> sendRequestPushNotification(String message) async {
    final currentUserName =
        Provider.of<UserController>(context, listen: false).currentUser.name;
    await Provider.of<PushNotificationController>(context, listen: false)
        .getReceiverDeviceToken(receiverUserId: widget.profileUser.id);
    final devicesTokens =
        Provider.of<PushNotificationController>(context, listen: false)
            .receiverDevicesTokens;
    await Provider.of<PushNotificationController>(context, listen: false)
        .sendPushNotification(
            title: currentUserName,
            type: 'friend_request',
            body: message,
            devicesTokens: devicesTokens);
  }

  void setLoadingValue(bool value) {
    if (mounted) {
      setState(() {
        isLoading = value;
      });
    }
  }

  @override
  void initState() {
    checkIfRequestStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CircularLoadingIndicatorWidget();
    } else if (!isLoading && !alreadyRequestSent) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100))),
          onPressed: sendRequest,
          child: const Text('Send Request'));
    } else if (!isLoading && alreadyRequestSent && !alreadyFriends) {
      return const RequestStatusWidget(status: RequestStatus.sent);
    } else if (!isLoading && alreadyRequestSent && alreadyFriends) {
      return const RequestStatusWidget(status: RequestStatus.friends);
    } else {
      return const Text('Error Happened');
    }
  }
}
