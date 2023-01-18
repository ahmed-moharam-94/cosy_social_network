import 'package:cozy_social_media_app/controllers/user_controller.dart';
import 'package:cozy_social_media_app/models/user.dart';
import 'package:cozy_social_media_app/views/widgets/user_settings_widgets/user_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/dims.dart';

class CustomSliverAppBarWidget extends StatelessWidget {
  final String title;
  final void Function()? firstCallBack;
  final void Function()? secondCallBack;
  final IconData? firstIcon;
  final IconData? secondIcon;
  final bool isInHomeScreen;

  const CustomSliverAppBarWidget(
      {Key? key,
      this.isInHomeScreen = false,
      required this.title,
      this.firstCallBack,
      this.secondCallBack,
      this.firstIcon,
      this.secondIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 80,
      toolbarHeight: smallPadding,
      backgroundColor: Colors.white,
      forceElevated: false,
      elevation: 0.0,
      pinned: true,
      floating: true,
      automaticallyImplyLeading: false,
      flexibleSpace: flexibleSpaceBarWidgetBuilder(context),
    );
  }

  Widget flexibleSpaceBarWidgetBuilder(context) {
    return FlexibleSpaceBar(
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: mediumPadding),
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            // get status bar size
            SizedBox(height: MediaQuery.of(context).viewPadding.top),
            const SizedBox(
              height: mediumPadding,
            ),
            flexibleSpaceWidgetBuilder(context),
          ],
        ),
      ),
    );
  }

  Widget flexibleSpaceWidgetBuilder(context) {
    AppUser user = AppUser();
    if (isInHomeScreen) {
       user = Provider.of<UserController>(context, listen: false).currentUser;
    }
    return Row(
      children: [
        if (!isInHomeScreen) appBarTitle(context),
        if (isInHomeScreen)
          UserImageWidget(
            radius: 60,
            imageUrl: user.image,
            gender: user.gender,
          ),
        const Expanded(child: SizedBox()),
        appBarIconButtonBuilder(icon: secondIcon, onPressed: secondCallBack),
        appBarIconButtonBuilder(icon: firstIcon, onPressed: firstCallBack),
      ],
    );
  }

  Widget appBarTitle(BuildContext context) {
    return Text(title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold));
  }

  Widget appBarIconButtonBuilder(
      {required IconData? icon, required void Function()? onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.black, size: 26),
    );
  }
}
