import 'package:cozy_social_media_app/views/widgets/auth_widgets/register_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'auth_widget_bubble_decoration.dart';
import 'login_widget.dart';

class AuthenticationWidget extends StatefulWidget {
  const AuthenticationWidget({Key? key}) : super(key: key);

  @override
  State<AuthenticationWidget> createState() => _AuthenticationWidgetState();
}

class _AuthenticationWidgetState extends State<AuthenticationWidget>
    with SingleTickerProviderStateMixin {
  // toggle between login and register widget
  bool _isLogin = true;

  // bool isLogin: call back from login widget and register widget
  void _toggleLoginCallback(bool isLogin) {
    _isLogin = isLogin;
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: _screenHeight,
      child: Stack(
        children: [
          // Orange  top-left decoration bubble
          const AuthWidgetDecoration(
              size: 170, top: -50, left: -100, bottom: null, right: null),
          // Orange top-right decoration bubble
          const AuthWidgetDecoration(
            size: 100,
            top: 50,
            left: null,
            bottom: null,
            right: -50,
          ),
          // Orange left-bottom decoration bubble
          const AuthWidgetDecoration(
            size: 150,
            top: null,
            left: -30,
            bottom: -50,
            right: null,
          ),
          Positioned.fill(
              child: ListView(
            reverse: false,
            shrinkWrap: true,
            children: [
              SizedBox(height: _screenHeight * .08),
              authWidgetImageBuilder(_screenHeight),
              SizedBox(height: _screenHeight * .04),
              toggleBetweenLoginAndCreateAccountWidgetBuilder(),
            ],
          ))
        ],
      ),
    );
  }

  Widget authWidgetImageBuilder(double screenHeight) {
    return SizedBox(
      height: screenHeight * 0.3,
      child: SvgPicture.asset('assets/images/auth_screen_image.svg'),
    );
  }

  Widget toggleBetweenLoginAndCreateAccountWidgetBuilder() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 0),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
                  .animate(animation),
          child: child,
        );
      },
      child: _isLogin
          ? LoginWidget(loginCallBack: _toggleLoginCallback)
          : RegisterWidget(registerCallback: _toggleLoginCallback),
    );
  }
}
