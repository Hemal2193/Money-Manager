import 'package:flutter/material.dart';

class PageTransition extends PageRouteBuilder {
  final Widget enterPage;

  PageTransition(page, {required this.enterPage})
      : super(
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    enterPage,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        FadeTransition(
          opacity: animation,
          child: child,
        ),
  );
}