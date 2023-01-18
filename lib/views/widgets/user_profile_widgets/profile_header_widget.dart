import 'package:cozy_social_media_app/constants/dims.dart';
import 'package:cozy_social_media_app/views/widgets/user_profile_widgets/user_cover_image.dart';
import 'package:flutter/material.dart';
import '../../../models/user.dart';
import '../reusable_widgets/user_avatar_widget.dart';

class ProfileHeaderWidget extends StatefulWidget {
  final AppUser profileUser;

  const ProfileHeaderWidget({Key? key, required this.profileUser}) : super(key: key);

  @override
  State<ProfileHeaderWidget> createState() => _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends State<ProfileHeaderWidget> {


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SliverAppBar(
      excludeHeaderSemantics: true,
      title: Text(widget.profileUser.name),
      expandedHeight: screenHeight * 0.30,
      backgroundColor: Colors.white,
      forceElevated: false,
      elevation: 0.0,
      pinned: true,
      snap: true,
      floating: true,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black), onPressed: (){
        Navigator.of(context).pop();
      }),
      flexibleSpace: flexibleSpaceBarWidgetBuilder(context, screenHeight),
    );
  }

  Widget flexibleSpaceBarWidgetBuilder(BuildContext context, double screenHeight) {
    return FlexibleSpaceBar(
      background: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            children: [
              UserCoverImageWidget(coverUrl: widget.profileUser.cover, userName: widget.profileUser.name),
              Positioned(
                bottom: mediumPadding,
                left: smallPadding,
                child: UserAvatarWidget(
                     userGender: widget.profileUser.gender, userImage: widget.profileUser.image, radius: 100),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
