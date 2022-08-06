import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/constants/styles.dart';

class ResetContent extends StatefulWidget {
  final CarouselController carouselController;
  const ResetContent({Key? key, required this.carouselController})
      : super(key: key);

  @override
  State<ResetContent> createState() => _ResetContentState();
}

class _ResetContentState extends State<ResetContent> {
  final TextEditingController resetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "We will send you a recovery e-mail as soon as possible.",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
              color: GlobalColors.greyTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            validator: (value) => EmailValidator.validate(value!)
                ? null
                : "E-mail address is not valid",
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            style: const TextStyle(
                fontSize: 15.0,
                fontFamily: 'Raleway',
                color: GlobalColors.greyTextColor),
            decoration:
                GlobalStyles.formInputDecoration(hint: 'email@example.com'),
          ),
          const Spacer(),
          Column(
            children: [
              TextButton(
                style: GlobalStyles.greenButtonStyle(),
                onPressed: () async {
                  // if (authController.resetController.text.isNotEmpty) {
                  //   FirestoreUtils().resetPassword(
                  //       authController.resetController.text);
                  // }
                  //TODO: show success/failure
                },
                child: Center(
                  child: Text(
                    "Reset Password",
                    style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                style: GlobalStyles.whiteButtonStyle(),
                onPressed: () {
                  //go back
                  widget.carouselController.previousPage(
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeIn);
                },
                child: const Center(
                  child: Text(
                    "Back",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Raleway',
                      color: GlobalColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
