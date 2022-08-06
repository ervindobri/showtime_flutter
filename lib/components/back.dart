import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:show_time/core/utils/navigation.dart';

class CustomBackButton extends StatelessWidget {
  final Color itemColor;
  final Color backgroundColor;
  final String backPage;

  const CustomBackButton(
      {Key? key,
      required this.itemColor,
      required this.backPage,
      this.backgroundColor = Colors.transparent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => NavUtils.back(context),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.chevronLeft,
              size: 20,
              color: itemColor,
            ),
            const SizedBox(width: 4),
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
    );
  }
}
