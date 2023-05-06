// ignore_for_file: unnecessary_null_comparison

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:show_time/components/custom_elevation.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/constants/styles.dart';
import 'package:show_time/controllers/auth_controller.dart';
import 'package:show_time/controllers/ui_controller.dart';
import 'package:show_time/injection_container.dart';
import 'package:show_time/network/firebase_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:email_validator/email_validator.dart';

import 'package:google_fonts/google_fonts.dart';

class HomeWeb extends StatefulWidget {
  const HomeWeb({Key? key}) : super(key: key);

  @override
  State<HomeWeb> createState() => _HomeWebState();
}

class _HomeWebState extends State<HomeWeb> with TickerProviderStateMixin {
  AuthController authController = sl<AuthController>();
  UiController uiController = sl<UiController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CarouselController _carouselController = CarouselController();

  //State
  double textFieldHeight = 50;
  late Widget eye;
  bool selected = true;
  bool logging = true;
  bool _showPassword = false;
  int _state = 0;

  late Animation<double> animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: this,
    );

    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white24,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: FadeTransition(
              opacity: Tween<double>(
                begin: 0,
                end: 1,
              ).animate(animation),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, .1),
                  end: Offset.zero,
                ).animate(animation),
                child: Container(
                  height: _height * .7,
                  width: _width * .3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: GlobalColors.primaryGreen,
                      boxShadow: [
                        BoxShadow(
                            color: GlobalColors.primaryGreen.withOpacity(.3),
                            blurRadius: 50,
                            spreadRadius: 5)
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            side: const BorderSide(
                                                color:
                                                    GlobalColors.greyTextColor,
                                                width: .3),
                                            borderRadius:
                                                BorderRadius.circular(12)))),
                                child: SizedBox(
                                  width: 160,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Image(
                                          image: AssetImage(
                                              'assets/google_logo.png'),
                                          height: 30,
                                        ),
                                        Text('Google Sign-In',
                                            style: GoogleFonts.lato(
                                                color: GlobalColors
                                                    .greyTextColor)),
                                      ],
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  // print("google sign in!");
                                  authController.signInWithGoogle();
                                },
                              ),
                            ),
                            SizedBox(
                              height: _height / 2,
                              width: _width,
                              child: CarouselSlider(
                                carouselController: _carouselController,
                                options: CarouselOptions(
                                  scrollDirection: Axis.horizontal,
                                  scrollPhysics:
                                      const NeverScrollableScrollPhysics(),
                                  viewportFraction: 1.0,
                                  aspectRatio: .5,
                                ),
                                items: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Center(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 5,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                    color: GlobalColors
                                                        .greyTextColor
                                                        .withOpacity(.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25.0),
                                              child: Form(
                                                key: _formKey,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      25.0,
                                                                  vertical:
                                                                      5.0),
                                                          child: Row(
                                                            children: const [
                                                              Text(
                                                                "E-mail address",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontFamily:
                                                                        'Raleway',
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.0),
                                                          child: TextFormField(
                                                              validator: (value) =>
                                                                  EmailValidator.validate(
                                                                          value!)
                                                                      ? null
                                                                      : "E-mail address is not valid",
                                                              controller:
                                                                  authController
                                                                      .nameController,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .emailAddress,
                                                              autofocus: false,
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontFamily:
                                                                      'Raleway',
                                                                  color: GlobalColors
                                                                      .greyTextColor),
                                                              decoration:
                                                                  GlobalStyles
                                                                      .formInputDecoration()),
                                                        )
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      25.0,
                                                                  vertical:
                                                                      0.0),
                                                          child: Row(
                                                            children: const [
                                                              Text(
                                                                "Password",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontFamily:
                                                                        'Raleway',
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.0),
                                                          child: Stack(
                                                            children: [
                                                              TextFormField(
                                                                validator:
                                                                    (value) {
                                                                  debugPrint(
                                                                      value);
                                                                  return authController
                                                                      .passwordValidator(
                                                                          value!);
                                                                },
                                                                keyboardType:
                                                                    TextInputType
                                                                        .visiblePassword,
                                                                controller:
                                                                    authController
                                                                        .passwordController,
                                                                obscureText:
                                                                    _showPassword,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontFamily:
                                                                      'Raleway',
                                                                  color: GlobalColors
                                                                      .greyTextColor,
                                                                ),
                                                                decoration:
                                                                    GlobalStyles
                                                                        .formInputDecoration(),
                                                              ),
                                                              if (logging)
                                                                SizedBox(
                                                                  height:
                                                                      textFieldHeight,
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              16.0),
                                                                      child: InkWell(
                                                                          onTap: () {
                                                                            setState(
                                                                              () {
                                                                                _showPassword = !_showPassword;
                                                                                eye = _showPassword
                                                                                    ? const FaIcon(
                                                                                        FontAwesomeIcons.eye,
                                                                                        color: GlobalColors.primaryGreen,
                                                                                      )
                                                                                    : const FaIcon(
                                                                                        FontAwesomeIcons.eyeSlash,
                                                                                        color: GlobalColors.primaryGreen,
                                                                                      );
                                                                              },
                                                                            );
                                                                          },
                                                                          child: eye),
                                                                    ),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    AnimatedSizeAndFade(
                                                      // vsync: this,
                                                      child: logging
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          25.0,
                                                                      vertical:
                                                                          25.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: const [
                                                                      Text(
                                                                        "Remember me",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                'Raleway',
                                                                            color:
                                                                                GlobalColors.greyTextColor,
                                                                            fontWeight: FontWeight.w600),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          25.0),
                                                                  child:
                                                                      RoundCheckBox(
                                                                    isChecked:
                                                                        selected,
                                                                    checkedColor:
                                                                        GlobalColors
                                                                            .primaryGreen,
                                                                    // uncheckedColor: GlobalColors.greyTextColor,
                                                                    animationDuration:
                                                                        const Duration(
                                                                            milliseconds:
                                                                                200),
                                                                    borderColor:
                                                                        Colors
                                                                            .white,
                                                                    size: 25,
                                                                    onTap: (value) =>
                                                                        setState(
                                                                      () {
                                                                        selected =
                                                                            value!;
                                                                        authController.selected =
                                                                            value;
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          25.0,
                                                                      vertical:
                                                                          0.0),
                                                                  child: Row(
                                                                    children: const [
                                                                      Text(
                                                                        "Password again",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            fontFamily:
                                                                                'Raleway',
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.w600),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          16.0),
                                                                  child: Stack(
                                                                    children: [
                                                                      TextFormField(
                                                                        validator:
                                                                            (value) {
                                                                          if (value !=
                                                                              authController.passwordController.text) {
                                                                            return "Passwords do not match!";
                                                                          }
                                                                          return null;
                                                                        },
                                                                        keyboardType:
                                                                            TextInputType.visiblePassword,
                                                                        controller:
                                                                            authController.repasswordController,
                                                                        obscureText:
                                                                            true,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                16.0,
                                                                            fontFamily:
                                                                                'Raleway',
                                                                            color:
                                                                                GlobalColors.greyTextColor),
                                                                        decoration:
                                                                            GlobalStyles.formInputDecoration(),
                                                                      ),
                                                                      if (logging)
                                                                        SizedBox(
                                                                          height:
                                                                              textFieldHeight,
                                                                          child: Align(
                                                                              alignment: Alignment.centerRight,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                                                child: InkWell(
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        _showPassword = !_showPassword;
                                                                                        eye = _showPassword
                                                                                            ? const FaIcon(
                                                                                                FontAwesomeIcons.eye,
                                                                                                color: GlobalColors.primaryGreen,
                                                                                              )
                                                                                            : const FaIcon(
                                                                                                FontAwesomeIcons.eyeSlash,
                                                                                                color: GlobalColors.primaryGreen,
                                                                                              );
                                                                                      });
                                                                                    },
                                                                                    child: eye),
                                                                              )),
                                                                        ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                      fadeDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  200),
                                                      sizeDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  200),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //BUTTONS
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 35.0, vertical: 20),
                                        child: Wrap(
                                          spacing:
                                              20, // to apply margin in the main axis of the wrap
                                          runSpacing:
                                              10, // to apply margin in the cross axis of the wrap
                                          // mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              style: GlobalStyles
                                                  .greenButtonStyle(),
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  setState(() {
                                                    _state = 1;
                                                  });
                                                  if (logging) {
                                                    Future.delayed(
                                                        const Duration(
                                                            milliseconds: 300),
                                                        () async {
                                                      // print(nameController.text);
                                                      String authenticate =
                                                          await authController.login(
                                                              authController
                                                                  .nameController
                                                                  .text,
                                                              authController
                                                                  .passwordController
                                                                  .text);
                                                      if (authenticate == '') {
                                                        setState(() {
                                                          _state = 2;
                                                        });
                                                        //TODO: remember info on web

                                                        // Get.to(() =>
                                                        //     BlocProvider<
                                                        //         SplashBloc>(
                                                        //       create: (BuildContext
                                                        //               context) =>
                                                        //           SplashBloc()
                                                        //             ..add(GetSplashEvent(
                                                        //                 true)),
                                                        //       child:
                                                        //           const SplashScreen(),
                                                        //     ));
                                                      } else {
                                                        setState(() {
                                                          _state = 0;
                                                        });
                                                        uiController.showToast(
                                                            context: context,
                                                            color: GlobalColors
                                                                .fireColor,
                                                            icon: FontAwesomeIcons
                                                                .exclamationCircle,
                                                            text: authenticate,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM);
                                                      }
                                                    });
                                                  } else {
                                                    Future.delayed(
                                                        const Duration(
                                                            milliseconds: 300),
                                                        () async {
                                                      String authenticate =
                                                          await authController.register(
                                                              authController
                                                                  .nameController
                                                                  .text,
                                                              authController
                                                                  .passwordController
                                                                  .text);
                                                      authController
                                                          .passwordController
                                                          .clear();
                                                      authController
                                                          .nameController
                                                          .clear();
                                                      if (authenticate ==
                                                          null) {
                                                        setState(() {
                                                          _state = 2;
                                                        });
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    300), () {
                                                          setState(() {
                                                            logging = true;
                                                            _state = 1;
                                                          });
                                                        });
                                                      } else {
                                                        // print(auth);
                                                        setState(() {
                                                          _state = 0;
                                                        });
                                                        Fluttertoast.showToast(
                                                            msg: authenticate,
                                                            toastLength: Toast
                                                                .LENGTH_LONG,
                                                            backgroundColor:
                                                                GlobalColors
                                                                    .orangeColor,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                2);
                                                      }
                                                    });
                                                  }
                                                }
                                              },
                                              child: buttonChild(
                                                  _state,
                                                  logging,
                                                  GlobalColors.primaryGreen),
                                            ),
                                            CustomElevation(
                                              color: CupertinoColors.black
                                                  .withOpacity(.05),
                                              child: OutlinedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(GlobalColors
                                                                  .lightGreenColor),
                                                      shape: MaterialStateProperty.all(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12)))),
                                                  onPressed: () {
                                                    setState(() {
                                                      logging = !logging;
                                                      if (!logging) {
                                                        authController
                                                            .nameController
                                                            .clear();
                                                        authController
                                                            .passwordController
                                                            .clear();
                                                        authController
                                                            .repasswordController
                                                            .clear();
                                                      }
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0),
                                                    child: SizedBox(
                                                      height: textFieldHeight,
                                                      width: _width / 2,
                                                      child: Center(
                                                        child: Text(
                                                          logging
                                                              ? "Register"
                                                              : "Back to login",
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'Raleway',
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _carouselController.nextPage(
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.easeIn);
                                              },
                                              child: Center(
                                                child: Text(
                                                  "Forgot your password?",
                                                  style: GoogleFonts.raleway(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ), //BUTTONS
                                    ],
                                  ),
                                  SizedBox(
                                    width: _width,
                                    height: _height * .7,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 35.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AutoSizeText(
                                            "We will send you a recovery e-mail ASAP",
                                            maxLines: 2,
                                            minFontSize: 17,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.raleway(
                                                color:
                                                    GlobalColors.greyTextColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0.0, vertical: 25),
                                            child: TextFormField(
                                              validator: (value) => EmailValidator
                                                      .validate(value!)
                                                  ? null
                                                  : "E-mail address is not valid",
                                              controller: authController
                                                  .resetController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              autofocus: false,
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontFamily: 'Raleway',
                                                  color: GlobalColors
                                                      .greyTextColor),
                                              decoration: const InputDecoration(
                                                errorStyle: TextStyle(
                                                    fontFamily: 'Raleway',
                                                    color: GlobalColors
                                                        .orangeColor),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 5.0,
                                                        horizontal: 10.0),
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: 'johndoe@example.com',
                                                focusColor:
                                                    GlobalColors.primaryGreen,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: GlobalColors
                                                          .primaryBlue),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              50.0)),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: GlobalColors
                                                          .primaryBlue),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              50.0)),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: GlobalColors
                                                          .primaryGreen,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              50.0)),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: GlobalColors
                                                          .orangeColor,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              50.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        GlobalColors.white),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0)),
                                                )),
                                            onPressed: () async {
                                              if (authController.resetController
                                                  .text.isNotEmpty) {
                                                FirestoreUtils().resetPassword(
                                                    authController
                                                        .resetController.text);
                                              }
                                              //TODO: show success/failure
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: FaIcon(
                                                      FontAwesomeIcons.syncAlt,
                                                      color: GlobalColors
                                                          .primaryGreen),
                                                ),
                                                Text(
                                                  "Reset Password",
                                                  style: GoogleFonts.raleway(
                                                      color: GlobalColors
                                                          .primaryGreen,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20.0),
                                            child: CustomElevation(
                                              color: CupertinoColors.black
                                                  .withOpacity(.05),
                                              child: OutlinedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.white),
                                                    shape: MaterialStateProperty
                                                        .all(RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)))),
                                                onPressed: () {
                                                  //go back
                                                  _carouselController
                                                      .previousPage(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      300),
                                                          curve: Curves.easeIn);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12.0,
                                                          right: 12.0),
                                                  child: SizedBox(
                                                    height: textFieldHeight,
                                                    width: _width / 2,
                                                    child: const Center(
                                                      child: Text(
                                                        "Back",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily: 'Raleway',
                                                          color: GlobalColors
                                                              .primaryGreen,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buttonChild(int _state, logging, Color color) {
  if (_state == 0) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            logging ? "Log in" : "Register",
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'Raleway',
                color: color,
                fontWeight: FontWeight.w600),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: FaIcon(
              FontAwesomeIcons.longArrowAltRight,
              color: color,
            ),
          )
        ],
      ),
    );
  } else if (_state == 1) {
    return Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  } else {
    return Center(child: Icon(Icons.check, color: color));
  }
}
