import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/constants/styles.dart';
import 'package:show_time/get_controllers/auth_controller.dart';
import 'package:show_time/get_controllers/ui_controller.dart';
import 'package:show_time/features/home/presentation/pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController _controller;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController sexController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  AuthController authController = Get.put(AuthController())!;
  UIController uiController = Get.put(UIController())!;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..forward();

    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    sexController.text = GlobalVariables.sexCategories[0];
    ageController.text = 1.toString();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final node = FocusScope.of(context);
    //TODO: web UI
    if (kIsWeb) {
      return Container();
    } else {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation),
        child: Center(
          child: Container(
            width: _width * .81,
            height: _height * .7,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
              boxShadow: [
                BoxShadow(
                  color: GlobalColors.greyTextColor.withOpacity(0.3),
                  spreadRadius: 10,
                  blurRadius: 25,
                  offset: const Offset(0, 5), // changes position of shadow
                ),
              ],
            ),
            child: FadeTransition(
              opacity: Tween<double>(
                begin: 0,
                end: 1,
              ).animate(animation),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(animation),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AutoSizeText(
                          "Complete your profile",
                          maxLines: 2,
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //TODO: ADD AVATARS FOR USERS
                              
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: CircleAvatar(
                              //     backgroundColor: GlobalColors.greyTextColor,
                              //     minRadius: 40,
                              //     maxRadius: 40,
                              //     backgroundImage: AssetImage(
                              //         "assets/showtime-avatar.png"
                              //     ),
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "first Name",
                                      style: GoogleFonts.roboto(
                                          color: GlobalColors.greyTextColor,
                                          fontSize: _width / 20,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: SizedBox(
                                        width: _width / 3,
                                        height: _width / 6,
                                        child: TextFormField(
                                          controller: firstNameController,
                                          keyboardType: TextInputType.name,
                                          textCapitalization:
                                              TextCapitalization.words,

                                          autofocus: false,
                                          validator: (val) {
                                            if (val == "") {
                                              return "Your first name!";
                                            } else {
                                              return null;
                                            }
                                          },
                                          decoration: GlobalStyles.formInputDecoration(),
                                          style: GoogleFonts.roboto(
                                              color:
                                                  GlobalColors.greyTextColor,
                                              fontSize: _width / 20,
                                              fontWeight: FontWeight.w500),
                                          onEditingComplete: () => node
                                              .nextFocus(), // Move focus to next
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "last Name",
                                      style: GoogleFonts.roboto(
                                          color: GlobalColors.greyTextColor,
                                          fontSize: _width / 20,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: SizedBox(
                                        width: _width / 3,
                                        height: _width / 6,
                                        child: TextFormField(
                                          controller: lastNameController,
                                          autofocus: false,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          validator: (val) {
                                            if (val == "") {
                                              return "Your last name!";
                                            } else {
                                              return null;
                                            }
                                          },
                                          decoration: const InputDecoration(
                                            errorStyle: TextStyle(
                                                fontFamily: 'Raleway',
                                                color:
                                                    GlobalColors.orangeColor),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 10.0),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'Doe',
                                            hintStyle: TextStyle(
                                                fontFamily: 'Raleway',
                                                color: GlobalColors
                                                    .greyTextColor,
                                                fontWeight: FontWeight.w300),
                                            focusColor:
                                                GlobalColors.primaryGreen,
                                            enabledBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: GlobalColors
                                                      .primaryBlue),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0)),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: GlobalColors
                                                      .primaryBlue),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0)),
                                            ),
                                            focusedBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: GlobalColors
                                                      .primaryGreen,
                                                  width: 2),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0)),
                                            ),
                                            errorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: GlobalColors
                                                      .orangeColor,
                                                  width: 2),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0)),
                                            ),
                                          ),
                                          style: GoogleFonts.roboto(
                                              color:
                                                  GlobalColors.greyTextColor,
                                              fontSize: _width / 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "age",
                                      style: GoogleFonts.roboto(
                                          color: GlobalColors.greyTextColor,
                                          fontSize: _width / 20,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: Container(
                                        width: _width / 3,
                                        height: _width / 10,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50.0)),
                                          border: Border.all(
                                              color:
                                                  GlobalColors.primaryBlue),
                                        ),
                                        child: CupertinoTheme(
                                          data: CupertinoThemeData(
                                            scaffoldBackgroundColor:
                                                Colors.transparent,
                                            primaryColor: Colors.transparent,
                                            primaryContrastingColor:
                                                Colors.transparent,
                                            barBackgroundColor:
                                                Colors.transparent,
                                            textTheme: CupertinoTextThemeData(
                                              pickerTextStyle:
                                                  GoogleFonts.roboto(
                                                      color: GlobalColors
                                                          .greyTextColor,
                                                      fontSize: 25),
                                            ),
                                          ),
                                          child: CupertinoPicker(
                                            looping: true,
                                            backgroundColor:
                                                Colors.transparent,
                                            // selectionOverlay: Container(
                                            //     child: Padding(
                                            //       padding: const EdgeInsets.only(left: 10.0),
                                            //       child: Row(
                                            //         children: [
                                            //           FaIcon(
                                            //             FontAwesomeIcons.sort,
                                            //             color: GlobalColors.blueColor,
                                            //           )
                                            //         ],
                                            //       ),
                                            //     )
                                            // ),
                                            itemExtent: 50,
                                            onSelectedItemChanged:
                                                (int value) {
                                              ageController.text =
                                                  (value + 1).toString();
                                            },
                                            children: List.generate(
                                                100,
                                                (index) => Center(
                                                      child: Text(
                                                        (index + 1)
                                                            .toString(),
                                                        style: GoogleFonts.roboto(
                                                            color: GlobalColors
                                                                .greyTextColor,
                                                            fontSize:
                                                                _width / 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "sex",
                                      style: GoogleFonts.roboto(
                                          fontSize: _width / 20,
                                          fontWeight: FontWeight.w300,
                                          color: GlobalColors.greyTextColor),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: Container(
                                        width: _width / 3,
                                        height: _width / 10,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50.0)),
                                          border: Border.all(
                                              color:
                                                  GlobalColors.primaryBlue),
                                        ),
                                        child: CupertinoPicker(
                                          // controller: sexController,
                                          looping: true,
                                          // selectionOverlay: Container(
                                          //   child: Padding(
                                          //     padding: const EdgeInsets.only(left: 10.0),
                                          //     child: Row(
                                          //       children: [
                                          //         FaIcon(
                                          //           FontAwesomeIcons.sort,
                                          //           color: GlobalColors.blueColor,
                                          //         )
                                          //       ],
                                          //     ),
                                          //   )
                                          // ),
                                          itemExtent: 50,
                                          onSelectedItemChanged: (int value) {
                                            sexController.text =
                                                GlobalVariables
                                                    .sexCategories[value];
                                          },
                                          children: List.generate(
                                              GlobalVariables
                                                  .sexCategories.length,
                                              (index) => Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15.0),
                                                    child: Text(
                                                      GlobalVariables
                                                              .sexCategories[
                                                          index],
                                                      style: GoogleFonts.roboto(
                                                          color: GlobalColors
                                                              .greyTextColor,
                                                          fontSize:
                                                              _width / 20,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500),
                                                    ),
                                                  ))),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: GetBuilder<AuthController>(
                                  init: authController,
                                  builder: (_) {
                                return TextButton(
                                  // maxWidth: _width / 3,
                                  // minWidth: _width / 3,
                                  // state: buttonState,
                                  onPressed: () {
                                    // setState(() {
                                    //   buttonState = ButtonState.loading;
                                    // });
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      setState(() {
                                        if (_formKey.currentState!
                                            .validate()) {
                                          // print("validated");
                                          authController.updateUserInfo(
                                              firstNameController.text,
                                              lastNameController.text,
                                              int.parse(
                                                  ageController.text),
                                              sexController.text);

                                          // buttonState = ButtonState.success;
                                          // if (buttonState ==
                                          //     ButtonState.success) {
                                          Timer.run(() {
                                            Get.to(const HomeView());
                                          });
                                        }
                                        // else {
                                        //   buttonState = ButtonState.fail;
                                        // }
                                      });
                                    });
                                  },
                                  child: Text(
                                    "Save",
                                    style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: _width / 20),
                                  ),
                                  // padding: const EdgeInsets.all(8.0),
                                  // progressIndicatorAligment: MainAxisAlignment
                                  //     .center,
                                  // radius: 25.0,
                                  // stateWidgets: {
                                  //   ButtonState.idle: Text(
                                  //     "Save",
                                  //     style: GoogleFonts.roboto(
                                  //         color: Colors.white,
                                  //         fontWeight: FontWeight.w500,
                                  //         fontSize: _width / 20
                                  //     ),
                                  //   ),
                                  //   ButtonState.loading: Container(),
                                  //   ButtonState.fail: Text(
                                  //     "Submit Failed",
                                  //     style: GoogleFonts.roboto(
                                  //         color: Colors.white,
                                  //         fontWeight: FontWeight.w500),
                                  //   ),
                                  //   ButtonState.success: FaIcon(
                                  //     FontAwesomeIcons.check,
                                  //     color: Colors.white,
                                  //   )
                                  // },
                                  // stateColors: {
                                  //   ButtonState.idle: GlobalColors
                                  //       .blueColor,
                                  //   ButtonState.loading: GlobalColors
                                  //       .blueColor,
                                  //   ButtonState.fail: GlobalColors
                                  //       .fireColor,
                                  //   ButtonState.success: GlobalColors
                                  //       .greenColor,
                                  // },
                                );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
