import 'package:cozy_social_media_app/controllers/user_controller.dart';
import 'package:cozy_social_media_app/models/user.dart';
import 'package:cozy_social_media_app/views/screens/user_profile_screen.dart';
import 'package:cozy_social_media_app/views/widgets/requests_widgets/accept_or_reject_buttons_widget.dart';
import 'package:cozy_social_media_app/views/widgets/reusable_widgets/decorated_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/request.dart';
import '../../../constants/strings.dart';
import 'request_loading_indicator.dart';
import '../reusable_widgets/user_avatar_widget.dart';

class ReceivedRequestItemWidget extends StatefulWidget {
  final Request request;

  const ReceivedRequestItemWidget({Key? key, required this.request})
      : super(key: key);

  @override
  State<ReceivedRequestItemWidget> createState() => _ReceivedRequestItemWidgetState();
}

class _ReceivedRequestItemWidgetState extends State<ReceivedRequestItemWidget> {
  AppUser user = AppUser();
  bool isLoading = false;

  void setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> getUserById() async {
    final senderId = widget.request.senderId;
    setIsLoading(true);
    user = await Provider.of<UserController>(context, listen: false)
        .getUserById(senderId);
    setIsLoading(false);
  }

  @override
  void initState() {
    getUserById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const RequestLoadingIndicator() : DecoratedContainerWidget(
        child: ListTile(
      leading: UserAvatarWidget(
          userGender: user.gender, userImage: user.image, radius: 50),
      title: Text(
        user.name,
        style: const TextStyle(fontSize: 18),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            sentYouRequest,
            style: TextStyle(fontSize: 16),
          ),
          AcceptAndRejectButtonWidget(request: widget.request),
        ],
      ),
      onTap: () => navigateToUserProfile(context),
    ));
  }

  void navigateToUserProfile(BuildContext context) {
    Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: widget.request.senderId);
  }
}
