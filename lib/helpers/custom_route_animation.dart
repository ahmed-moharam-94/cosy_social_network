import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({required WidgetBuilder builder, required RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return CupertinoPageTransition(
        linearTransition: true,
        primaryRouteAnimation: animation,
        secondaryRouteAnimation: secondaryAnimation,
        child: child);
  }
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return  CupertinoPageTransition(
        linearTransition: true,
        primaryRouteAnimation: animation,
        secondaryRouteAnimation: secondaryAnimation,
        child: child);
  }
}
