import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'custom_variables.dart';

abstract class ShowTheme {
  static double height = window.physicalSize.height / window.devicePixelRatio;
  static double width = window.physicalSize.width / window.devicePixelRatio;
  static var defaultFontFamily = 'Raleway';

  static var defaultTextStyle = TextStyle(
    color: GlobalColors.greyTextColor,
    fontFamily: defaultFontFamily,
  );

  static var defaultBoldTextStyle = TextStyle(
      color: GlobalColors.greyTextColor,
      fontFamily: defaultFontFamily,
      fontWeight: FontWeight.w700);

  static TextStyle watchCardTitleStyle = TextStyle(
    fontWeight: FontWeight.w700,
    color: GlobalColors.greyTextColor,
    // fontSize: MediaQuery.of(context).size.height/30,
    fontFamily: defaultFontFamily,
  );

  static var listWatchCardSubStyle = TextStyle(
    color: GlobalColors.white,
    fontFamily: defaultFontFamily,
  );

  static var listWatchCardPercentStyle = TextStyle(
      fontFamily: defaultFontFamily,
      fontSize: width / 15,
      fontWeight: FontWeight.w700,
      color: GlobalColors.primaryBlue);

  static var listWatchCardBadgeStyle = TextStyle(
    color: Colors.white,
    fontFamily: defaultFontFamily,
    fontWeight: FontWeight.w700,
    fontSize: height / 30,
  );

  static const radius24 = BorderRadius.all(Radius.circular(24));

  static var topRadius25 = const BorderRadius.only(
    topLeft: Radius.circular(25),
    topRight: Radius.circular(25),
  );

  Size displaySize(BuildContext context) {
    debugPrint('Size = ' + MediaQuery.of(context).size.toString());
    return MediaQuery.of(context).size;
  }

  static TextStyle listWatchCardTitleStyle = TextStyle(
    color: GlobalColors.greyTextColor,
    fontFamily: defaultFontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 16,
  );

  static var listWatchCardDaysStyle = TextStyle(
    color: GlobalColors.white,
    fontFamily: defaultFontFamily,
    fontWeight: FontWeight.w700,
  );

  static const radius50 = BorderRadius.all(Radius.circular(50.0));
}
