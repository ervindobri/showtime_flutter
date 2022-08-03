import 'package:flutter/material.dart';

enum Transition { fade, slide }

class NavUtils {
  static navigateReplaced(BuildContext context, String path, {dynamic args}) {
    Navigator.pushReplacementNamed(context, path, arguments: args);
  }

  static void navigate(BuildContext context, String path,
      {Transition transition = Transition.fade, dynamic arguments}) {
    Navigator.pushNamed(context, path, arguments: arguments);
  }

  static void back(BuildContext context) {
    Navigator.pop(context);
  }
}
