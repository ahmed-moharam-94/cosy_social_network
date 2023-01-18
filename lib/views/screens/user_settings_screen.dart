import 'package:cozy_social_media_app/constants/dims.dart';
import 'package:cozy_social_media_app/controllers/user_controller.dart';
import 'package:cozy_social_media_app/views/widgets/reusable_widgets/circular_loading_indicator_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../widgets/user_settings_widgets/choose_gender_widget.dart';
import '../widgets/user_settings_widgets/choose_user_image_widget.dart';
import '../widgets/user_settings_widgets/name_text_field_widget.dart';
import '../widgets/user_settings_widgets/update_profile_button.dart';
import '../widgets/user_settings_widgets/user_bio_text_field_widget.dart';
import '../widgets/user_settings_widgets/user_cover_widget.dart';

class UserSettingsScreen extends StatefulWidget {
  static const String routeName = 'UserSettingsScreen';

  const UserSettingsScreen({Key? key}) : super(key: key);

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  bool isMale = true;
  bool hideBackButton = false;
  late AppUser user = AppUser();

  bool isLoading = false;

  void setLoadingValue(bool value) {
    if (mounted) {
      setState(() {
        isLoading = value;
      });
    }
  }
  Future<void> getUserById() async {
    setLoadingValue(true);
    user = await Provider.of<UserController>(context, listen: false).getUserById(userId);
    setLoadingValue(false);

  }

  @override
  void initState() {
    // user verified his email
    getUserById();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // when navigating from settings screen to update user profile
    final user = ModalRoute.of(context)?.settings.arguments;
    if (user != null) {
      this.user = user as AppUser;
    } else {
      // the user is coming from register screen for the first time
      // so hide back button
      hideBackButton = true;
    }
    super.didChangeDependencies();
  }

  void genderCallback(bool value) {
    setState(() {
      isMale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('Your Profile'),
        elevation: 0,
        leading: hideBackButton
            ? null
            : IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
      ),
      body: isLoading? const CircularLoadingIndicatorWidget() : ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          imageAndCoverWidgetBuilder(),
          const SizedBox(height: mediumPadding),
          nameGenderAndBioWidgetBuilder(),
        ],
      ),
    );
  }

  Widget imageAndCoverWidgetBuilder() {
    return Stack(
      children: [
        ChooseUserCoverWidget(user: user),
        Positioned(
            bottom: mediumPadding,
            left: mediumPadding,
            child: ChooseUserImageWidget(user: user)),
      ],
    );
  }

  Widget nameGenderAndBioWidgetBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: mediumPadding),
      child: Column(
        children: [
          NameTextFieldWidget(user: user),
          const SizedBox(height: mediumPadding),
          ChooseGenderWidget(user: user, isMaleCallBack: genderCallback),
          UserBioTextFieldWidget(user: user),
          const SizedBox(height: largePadding),
          UpdateProfileButton(user: user, updateMyProfile: false),
        ],
      ),
    );
  }
}
