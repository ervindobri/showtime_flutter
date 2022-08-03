import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/utils/navigation.dart';

class SignOutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
        height: 320,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: FaIcon(
              FontAwesomeIcons.questionCircle,
              color: GlobalColors.greenColor,
              size: kIsWeb ? 100 : 100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: AutoSizeText(
                'Are you sure you want to sign out?',
                maxLines: 2,
                maxFontSize: kIsWeb ? 50 : 24,
                minFontSize: kIsWeb ? 35 : 16,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              "You will be redirected to the login screen.",
              maxLines: 2,
              minFontSize: kIsWeb ? 25 : 16,
              maxFontSize: kIsWeb ? 50 : 20,
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w300,
                  color: GlobalColors.greyTextColor),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: kIsWeb
                          ? 150
                          : MediaQuery.of(context).size.width * .25,
                      child: Center(
                        child: AutoSizeText(
                          'Close',
                          minFontSize: kIsWeb ? 30 : 20,
                          maxFontSize: kIsWeb ? 40 : 25,
                          style: TextStyle(
                              color: GlobalColors.greenColor,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      // GlobalVariables.clearAll();
                      // authController.signOut();
                      // await authController.signOutGoogle();
                      NavUtils.navigateReplaced(context, '/login');
                    },
                    child: Container(
                      width: kIsWeb
                          ? 150
                          : MediaQuery.of(context).size.width * .25,
                      child: Center(
                        child: AutoSizeText(
                          'Sign Out',
                          minFontSize: kIsWeb ? 30 : 20,
                          maxFontSize: kIsWeb ? 40 : 25,
                          style: TextStyle(
                              color: GlobalColors.greenColor,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  )
                ]),
          ),
        ]));
  }
}
