import 'package:cozy_social_media_app/controllers/user_controller.dart';
import 'package:cozy_social_media_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/strings.dart';
import '../../screens/main_screen.dart';

class UpdateProfileButton extends StatefulWidget {
  final AppUser user;
  final bool updateMyProfile;

  const UpdateProfileButton(
      {Key? key, required this.user, required this.updateMyProfile})
      : super(key: key);

  @override
  State<UpdateProfileButton> createState() =>
      _UpdateProfileButtonState();
}

class _UpdateProfileButtonState extends State<UpdateProfileButton> {
  bool _isLoading = false;

  Future<void> _createOrUpdateProfile(AppUser user, bool isUpdatingProfile) async {
    bool isRequiredInfoComplete = isRequiredInformationComplete(user);
    if (isRequiredInfoComplete) {
       await updateProfile(user);
      displayMessageSnackBar(
          profileUpdated);
      navigateToHomeScreen();
    } else {
      displayMessageSnackBar(completeYourProfile);
    }
  }

  bool isRequiredInformationComplete(AppUser user) {
    if (user.name != '' &&
        user.gender != '') {
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateProfile(AppUser user) async {
    isLoadingValue(true);
    await Provider.of<UserController>(context, listen: false)
        .sendUserData(user);
    isLoadingValue(false);
  }

  void isLoadingValue(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void displayMessageSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 5)));
  }

  void navigateToHomeScreen() {
    // 1 -> userScreen
    Map<String, int> screenData = {'screenIndex': 0};
    Navigator.of(context)
        .pushReplacementNamed(MainScreen.routeName, arguments: screenData);
  }

  @override
  Widget build(BuildContext context) {
    final AppUser user = widget.user;
    bool isUpdatingPost = widget.updateMyProfile;
    return SizedBox(
        width: double.infinity,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ElevatedButton(
                onPressed: () => _createOrUpdateProfile(user, isUpdatingPost),
                child: isUpdatingPost
                    ? const Text('Update Profile')
                    : const Text('Save Profile')));
  }
}
