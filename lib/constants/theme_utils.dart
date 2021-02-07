import 'dart:ui';

import 'package:flutter/material.dart';

import 'custom_variables.dart';

abstract class ShowTheme{
    static double height = window.physicalSize.height / window.devicePixelRatio;
    static double width = window.physicalSize.width / window.devicePixelRatio;

    static TextStyle watchCardTitleStyle = TextStyle(
      fontWeight: FontWeight.w700,
      color: GlobalColors.greyTextColor,
      // fontSize: MediaQuery.of(context).size.height/30,
      fontFamily: 'Raleway',
    );

  static var listWatchCardSubStyle = TextStyle(
    color: GlobalColors.watchCardFontColor,
    fontFamily: 'Raleway',
    fontSize: width / 20,
  );

  static var listWatchCardPercentStyle = TextStyle(
      fontFamily: 'Raleway',
      fontSize: width/ 15,
      fontWeight: FontWeight.w700,
      color: GlobalColors.blueColor);

  static var listWatchCardBadgeStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'Raleway',
    fontWeight: FontWeight.w700,
    fontSize: width / 25,
  );

  static const radius25 = const BorderRadius.all(Radius.circular(25));

    Size displaySize(BuildContext context) {
      debugPrint('Size = ' + MediaQuery.of(context).size.toString());
      return MediaQuery.of(context).size;
    }

  static TextStyle listWatchCardTitleStyle = TextStyle(
    color: GlobalColors.watchCardFontColor,
    fontFamily: 'Raleway',
    fontWeight: FontWeight.w700,
    // fontSize: _width / 15,
  );

  static var listWatchCardDaysStyle = TextStyle(
    color: GlobalColors.watchCardFontColor,
    fontFamily: 'Raleway',
    fontWeight: FontWeight.w700,
    fontSize: width / 10,
  );

    static const radius50 = BorderRadius.all(Radius.circular(50.0));
}