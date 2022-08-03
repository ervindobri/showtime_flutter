import 'package:flutter/material.dart';

import 'custom_variables.dart';

class GlobalStyles {
  static var radius24 = BorderRadius.circular(24);

  static var noAppbar = AppBar(
    toolbarHeight: 0,
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
  );

  static ThemeData theme(BuildContext context) => Theme.of(context);

  static TextStyle sectionStyle() {
    return TextStyle(
      color: GlobalColors.greyTextColor,
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w700,
      fontSize: 20,
    );
  }
}
