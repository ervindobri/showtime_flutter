import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_variables.dart';

class GlobalStyles {
  static var radius24 = BorderRadius.circular(24);

  static var noAppbar = AppBar(
    toolbarHeight: 0,
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );

  static ThemeData theme(BuildContext context) => Theme.of(context);

  static TextStyle sectionStyle() {
    return const TextStyle(
      color: GlobalColors.greyTextColor,
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w700,
      fontSize: 20,
    );
  }

  static InputDecoration formInputDecoration({Widget? suffix, String? hint}) =>
      InputDecoration(
        errorStyle: const TextStyle(
            fontFamily: 'Raleway', color: GlobalColors.orangeColor),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        // hintText: 'johndoe@example.com',
        hintText: hint,
        suffix: suffix,
        hintStyle: TextStyle(color: GlobalColors.greyTextColor.withOpacity(.4)),
        focusColor: GlobalColors.primaryGreen,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: GlobalColors.primaryGreen),
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: GlobalColors.primaryGreen),
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: GlobalColors.primaryGreen, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: GlobalColors.orangeColor, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
      );

  static greenButtonStyle() => ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(GlobalColors.primaryGreen),
        padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.fromLTRB(24, 12, 24, 12)),
        shadowColor: MaterialStateProperty.all<Color>(
          GlobalColors.primaryGreen.withOpacity(.12),
        ),
        elevation: MaterialStateProperty.all<double>(24),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      );

  static whiteButtonStyle() => ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.fromLTRB(24, 12, 24, 12)),
        shadowColor: MaterialStateProperty.all<Color>(
            GlobalColors.greyTextColor.withOpacity(.12)),
        elevation: MaterialStateProperty.all<double>(24),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      );
}
