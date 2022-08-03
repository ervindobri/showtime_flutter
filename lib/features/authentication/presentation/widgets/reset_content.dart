import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:show_time/components/custom_elevation.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/network/firebase_utils.dart';

class ResetContent extends StatelessWidget {
  final TextEditingController? resetController;
  const ResetContent({Key? key, this.resetController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Container(
      width: _width,
      height: _height * .7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              "We will send you a recovery e-mail ASAP",
              maxLines: 2,
              minFontSize: 17,
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                  color: GlobalColors.greyTextColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45.0, vertical: 25),
            child: TextFormField(
              validator: (value) => EmailValidator.validate(value!)
                  ? null
                  : "E-mail address is not valid",
              controller: resetController,
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              style: new TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Raleway',
                  color: GlobalColors.greyTextColor),
              decoration: const InputDecoration(
                errorStyle: TextStyle(
                    fontFamily: 'Raleway', color: GlobalColors.orangeColor),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                filled: true,
                fillColor: Colors.white,
                hintText: 'johndoe@example.com',
                focusColor: GlobalColors.greenColor,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: GlobalColors.blueColor),
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: GlobalColors.blueColor),
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: GlobalColors.greenColor, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: GlobalColors.orangeColor, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                ),
              ),
            ),
          ),
          TextButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(GlobalColors.greenColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                )),
            onPressed: () async {
              // if (authController.resetController.text.isNotEmpty) {
              //   FirestoreUtils().resetPassword(
              //       authController.resetController.text);
              // }
              //TODO: show success/failure
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                  height: _height / 20,
                  width: _width / 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Reset Password",
                        style: GoogleFonts.raleway(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      )
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomElevation(
              color: CupertinoColors.black.withOpacity(.05),
              child: OutlinedButton(
                  // focusColor: GlobalColors.greenColor,
                  // highlightedBorderColor: GlobalColors.greenColor,
                  // color: Colors.white,
                  // highlightColor: GlobalColors.lightGreenColor,
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  // ),
                  onPressed: () {
                    //go back
                    // _carouselController.previousPage(
                    //     duration: Duration(milliseconds: 100),
                    //     curve: Curves.easeIn);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Container(
                      height: 50,
                      width: _width / 2,
                      child: Center(
                        child: Text(
                          "Back",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Raleway',
                              color: GlobalColors.greenColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
