import 'package:cozy_social_media_app/controllers/user_controller.dart';
import 'package:cozy_social_media_app/views/screens/user_settings_screen.dart';
import 'package:cozy_social_media_app/views/widgets/reusable_widgets/decorated_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/dims.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = 'AdminScreen';

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: const Text('Settings'),
          elevation: 0,
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: tinyPadding),
          child: ListView(
            children: [
              listTileWidgetBuilder(
                  context: context,
                  title: 'Your Profile',
                  onPressed: () => navigateToUserProfile(context)),
              const SizedBox(height: largePadding),
              appVersionText(),
            ],
          ),
        ));
  }

  Widget listTileWidgetBuilder(
      {required BuildContext context,
      required String title,
      required void Function() onPressed}) {
    return DecoratedContainerWidget(
        child: ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: onPressed,
    ));
  }

  void navigateToUserProfile(BuildContext context) {
    final user = Provider.of<UserController>(context, listen: false).currentUser;
    Navigator.of(context)
        .pushNamed(UserSettingsScreen.routeName, arguments: user);
  }

  Widget appVersionText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: mediumPadding),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('App Version'),
            Text('1.0.0'),
          ]),
    );
  }
}
