import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:show_time/constants/custom_variables.dart';
import 'package:show_time/get_controllers/auth_controller.dart';
import 'package:show_time/pages/login.dart';

class SignOutDialog extends StatelessWidget {

  AuthController authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      body: Center(
        child: Container(
            height: Get.height,
            width: Get.width*.3,
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: InkWell(
                      onTap: (){
                        Get.back();
                      },
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: FaIcon(
                        FontAwesomeIcons.timesCircle,
                        color: GlobalColors.greenColor,
                        size: kIsWeb ? 100 : Get.width/3,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: AutoSizeText(
                        'Are you sure you want to sign out?',
                        maxLines: 2,
                        maxFontSize: kIsWeb ? 50 : 20,
                        minFontSize: kIsWeb ? 35 : 13,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutoSizeText(
                      "You will be redirected to the login screen.",
                      maxLines: 2,
                      minFontSize: kIsWeb ? 25 : 10,
                      maxFontSize: kIsWeb ? 50 : 20,
                      style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w300,
                          color: GlobalColors.greyTextColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10, bottom: 10),
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: kIsWeb ? 150 : Get.width*.25,
                                child: Center(
                                  child: AutoSizeText(
                                    'Close',
                                    minFontSize: kIsWeb ? 30 : 10,
                                    maxFontSize: kIsWeb ? 40 : 20,
                                    style: TextStyle(
                                        color: GlobalColors.greenColor,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 25.0, bottom: 10),
                            child: InkWell(
                              onTap: () async {
                                GlobalVariables.clearAll();
                                authController.signOut();
                                await authController.signOutGoogle();
                                Get.offAllNamed('/login');
                              },
                              child: Container(
                                width: kIsWeb ? 150 : Get.width*.25,
                                child: Center(
                                  child: AutoSizeText(
                                    'Sign Out',
                                    minFontSize: kIsWeb ? 30 : 10,
                                    maxFontSize: kIsWeb ? 40 : 20,
                                    style: TextStyle(
                                        color: GlobalColors.greenColor,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ]
                    ),
                  ),
                ]
            )
        ),
      ),
    );
  }
}
