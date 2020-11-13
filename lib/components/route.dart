import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

Route createRouteAllShows(Widget child) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        SharedAxisTransition(
            animation: animation,
            transitionType: SharedAxisTransitionType.vertical,
            secondaryAnimation: secondaryAnimation,
            child: child),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.fastOutSlowIn;
      var tween =
      Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}