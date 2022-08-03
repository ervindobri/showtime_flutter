import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:show_time/core/utils/navigation.dart';

class CustomBackButton extends StatelessWidget {
  final Color itemColor;
  final Color backgroundColor;
  final String backPage;

  const CustomBackButton({Key? key,required this.itemColor, required this.backPage, required this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: InkWell(
        onTap: () => NavUtils.back(context),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(
              color: backgroundColor.withOpacity(.3),
              spreadRadius: 1,
              blurRadius: 25
            )]
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  Icons.arrow_back_ios,
                  size: 23,
                  color: itemColor,
                ),
                Text(
                  backPage,
                  style: GoogleFonts.raleway(
                    decoration: TextDecoration.underline,
                    color: itemColor,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
