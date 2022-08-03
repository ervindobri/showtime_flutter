import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:show_time/components/custom_elevation.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/utils/navigation.dart';
import 'package:show_time/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:show_time/features/authentication/presentation/widgets/reset_content.dart';
import 'package:show_time/features/home/presentation/widgets/home_web.dart';

class LoginSheet extends StatefulWidget {
  const LoginSheet({Key? key}) : super(key: key);

  @override
  _LoginSheetState createState() => _LoginSheetState();
}

class _LoginSheetState extends State<LoginSheet> with TickerProviderStateMixin {
  bool selected = false; // remember me
  bool logging = true;

  bool _showPassword = true;

  FaIcon eye = FaIcon(FontAwesomeIcons.eye, color: GlobalColors.greenColor);
  int _state = 0;
  var animationName = 'Shrink';
  CarouselController _carouselController = CarouselController();
  TextEditingController nameController =
      TextEditingController(text: 'dobriervin@yahoo.com');
  TextEditingController passwordController =
      TextEditingController(text: 'djcaponegood');
  TextEditingController repasswordController = TextEditingController();
  TextEditingController resetController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double textFieldHeight = 45;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      // TODO: implement listener
      if (state is LoginSuccessful) {
        NavUtils.navigateReplaced(context, '/home', args: state.user);
      }
    }, builder: (context, state) {
      print(state);
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: _height * .8,
            width: _width,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(24)),
            child: CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  scrollDirection: Axis.horizontal,
                  scrollPhysics: NeverScrollableScrollPhysics(),
                  viewportFraction: 1.0,
                  aspectRatio: .5,
                ),
                items: [
                  Container(
                    height: _height * .8,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(24)),
                    child: Stack(
                      children: [
                        Container(
                          height: _height,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 5,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: GlobalColors.greyTextColor
                                            .withOpacity(.3),
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Container(
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
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 25.0,
                                                        vertical: 5.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "E-mail address",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontFamily: 'Raleway',
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child: Container(
                                                  // height: textFieldHeight,
                                                  child: TextFormField(
                                                    validator: (value) =>
                                                        EmailValidator.validate(
                                                                value!)
                                                            ? null
                                                            : "E-mail address is not valid",
                                                    controller: nameController,
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    autofocus: false,
                                                    style: new TextStyle(
                                                        fontSize: 15.0,
                                                        fontFamily: 'Raleway',
                                                        color: GlobalColors
                                                            .greyTextColor),
                                                    decoration:
                                                        const InputDecoration(
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
                                                      hintText:
                                                          'johndoe@example.com',
                                                      focusColor: GlobalColors
                                                          .greenColor,
                                                      enabledBorder:
                                                          const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: GlobalColors
                                                                .blueColor),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                      ),
                                                      border:
                                                          const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: GlobalColors
                                                                .blueColor),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                      ),
                                                      focusedBorder:
                                                          const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: GlobalColors
                                                                .greenColor,
                                                            width: 2),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                      ),
                                                      errorBorder:
                                                          const OutlineInputBorder(
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
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 25.0,
                                                        vertical: 0.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Password",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontFamily: 'Raleway',
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      // height: textFieldHeight,
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          // debugPrint(value);
                                                          // return passwordValidator(
                                                          //         value!);
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .visiblePassword,
                                                        controller:
                                                            passwordController,
                                                        obscureText:
                                                            _showPassword,
                                                        style: new TextStyle(
                                                            fontSize: 15.0,
                                                            fontFamily:
                                                                'Raleway',
                                                            color: GlobalColors
                                                                .greyTextColor),
                                                        decoration:
                                                            const InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        vertical:
                                                                            1.0,
                                                                        horizontal:
                                                                            10.0),
                                                                errorStyle: TextStyle(
                                                                    fontFamily:
                                                                        'Raleway',
                                                                    color: GlobalColors
                                                                        .orangeColor),
                                                                errorText: null,
                                                                errorMaxLines:
                                                                    1,
                                                                filled: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                hintText:
                                                                    'password1234',
                                                                focusColor:
                                                                    GlobalColors
                                                                        .greenColor,
                                                                enabledBorder:
                                                                    const OutlineInputBorder(
                                                                  borderSide:
                                                                      const BorderSide(
                                                                          color:
                                                                              GlobalColors.greenColor),
                                                                  borderRadius: const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          50.0)),
                                                                ),
                                                                border:
                                                                    const OutlineInputBorder(
                                                                  borderSide:
                                                                      const BorderSide(
                                                                          color:
                                                                              GlobalColors.greenColor),
                                                                  borderRadius: const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          50.0)),
                                                                ),
                                                                focusedBorder:
                                                                    const OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: GlobalColors
                                                                          .greenColor,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius: const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          50.0)),
                                                                ),
                                                                errorBorder:
                                                                    const OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: GlobalColors
                                                                          .orangeColor,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius: const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          50.0)),
                                                                )),
                                                      ),
                                                    ),
                                                    if (logging)
                                                      Container(
                                                        height: textFieldHeight,
                                                        child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      15.0),
                                                              child: InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      _showPassword =
                                                                          !_showPassword;
                                                                      eye = _showPassword
                                                                          ? FaIcon(
                                                                              FontAwesomeIcons.eye,
                                                                              color: GlobalColors.greenColor,
                                                                            )
                                                                          : FaIcon(
                                                                              FontAwesomeIcons.eyeSlash,
                                                                              color: GlobalColors.greenColor,
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
                                          AnimatedSizeAndFade(
                                            vsync: this,
                                            child: logging
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    25.0,
                                                                vertical: 25.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "Remember me",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      'Raleway',
                                                                  color: GlobalColors
                                                                      .greyTextColor,
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
                                                                    25.0),
                                                        child: RoundCheckBox(
                                                          isChecked:
                                                              this.selected,
                                                          checkedColor:
                                                              GlobalColors
                                                                  .greenColor,
                                                          // uncheckedColor: GlobalColors.greyTextColor,
                                                          borderColor:
                                                              GlobalColors
                                                                  .greenColor,
                                                          size: 25,
                                                          onTap: (value) =>
                                                              setState(() {
                                                            // this.selected =
                                                            //     value!;
                                                            // authController
                                                            //     .selected = value;
                                                          }),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    25.0,
                                                                vertical: 0.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "Password again",
                                                              style: TextStyle(
                                                                  fontSize: 20,
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
                                                                    15.0),
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              // height: textFieldHeight,
                                                              child:
                                                                  TextFormField(
                                                                validator:
                                                                    (value) {
                                                                  // if (value !=
                                                                  //     authController
                                                                  //         .passwordController
                                                                  //         .text) {
                                                                  //   return "Passwords do not match!";
                                                                  // }
                                                                  // return null;
                                                                },
                                                                keyboardType:
                                                                    TextInputType
                                                                        .visiblePassword,
                                                                controller:
                                                                    repasswordController,
                                                                obscureText:
                                                                    true,
                                                                style: new TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    fontFamily:
                                                                        'Raleway',
                                                                    color: GlobalColors
                                                                        .greyTextColor),
                                                                decoration:
                                                                    const InputDecoration(
                                                                        contentPadding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                1.0,
                                                                            horizontal:
                                                                                10.0),
                                                                        errorStyle: TextStyle(
                                                                            fontFamily:
                                                                                'Raleway',
                                                                            color: GlobalColors
                                                                                .orangeColor),
                                                                        errorText:
                                                                            null,
                                                                        errorMaxLines:
                                                                            1,
                                                                        filled:
                                                                            true,
                                                                        fillColor:
                                                                            Colors
                                                                                .white,
                                                                        hintText:
                                                                            'password1234',
                                                                        focusColor:
                                                                            GlobalColors
                                                                                .greenColor,
                                                                        enabledBorder:
                                                                            const OutlineInputBorder(
                                                                          borderSide:
                                                                              const BorderSide(color: GlobalColors.greenColor),
                                                                          borderRadius:
                                                                              const BorderRadius.all(Radius.circular(50.0)),
                                                                        ),
                                                                        border:
                                                                            const OutlineInputBorder(
                                                                          borderSide:
                                                                              const BorderSide(color: GlobalColors.greenColor),
                                                                          borderRadius:
                                                                              const BorderRadius.all(Radius.circular(50.0)),
                                                                        ),
                                                                        focusedBorder:
                                                                            const OutlineInputBorder(
                                                                          borderSide: const BorderSide(
                                                                              color: GlobalColors.greenColor,
                                                                              width: 1.5),
                                                                          borderRadius:
                                                                              const BorderRadius.all(Radius.circular(50.0)),
                                                                        ),
                                                                        errorBorder:
                                                                            const OutlineInputBorder(
                                                                          borderSide: const BorderSide(
                                                                              color: GlobalColors.orangeColor,
                                                                              width: 1.5),
                                                                          borderRadius:
                                                                              const BorderRadius.all(Radius.circular(50.0)),
                                                                        )),
                                                              ),
                                                            ),
                                                            if (logging)
                                                              Container(
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
                                                                              15.0),
                                                                      child: InkWell(
                                                                          onTap: () {
                                                                            setState(() {
                                                                              _showPassword = !_showPassword;
                                                                              eye = _showPassword
                                                                                  ? FaIcon(
                                                                                      FontAwesomeIcons.eye,
                                                                                      color: GlobalColors.greenColor,
                                                                                    )
                                                                                  : FaIcon(
                                                                                      FontAwesomeIcons.eyeSlash,
                                                                                      color: GlobalColors.greenColor,
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
                                            fadeDuration: const Duration(
                                                milliseconds: 200),
                                            sizeDuration: const Duration(
                                                milliseconds: 200),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: _width / 10,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: _height / 3,
                              width: _width * .8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomElevation(
                                    color:
                                        GlobalColors.greenColor.withOpacity(.5),
                                    spreadRadius: -2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: GlobalColors.greenColor,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: TextButton(
                                        //     borderRadius: BorderRadius.circular(12.0)),
                                        onPressed: () async {
                                          await validateForm(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: buttonChild(
                                              _state, logging, Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: OutlinedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          overlayColor:
                                              MaterialStateProperty.all<Color>(
                                                  GlobalColors.lightGreenColor
                                                      .withOpacity(.4)),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            logging = !logging;
                                            if (!logging) {
                                              nameController.clear();
                                              passwordController.clear();
                                              repasswordController.clear();
                                            }
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0),
                                          child: Container(
                                            height: textFieldHeight,
                                            child: Center(
                                              child: Text(
                                                logging
                                                    ? "Register"
                                                    : "Back to login",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: 'Raleway',
                                                    color:
                                                        GlobalColors.greenColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        )),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _carouselController.nextPage(
                                          duration: Duration(milliseconds: 100),
                                          curve: Curves.easeIn);
                                    },
                                    child: Text(
                                      "Forgot your password?",
                                      style: GoogleFonts.raleway(
                                          color: GlobalColors.greyTextColor
                                              .withOpacity(.4),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ), //BUTTONS
                      ],
                    ),
                  ),
                  ResetContent(resetController: resetController)
                ]),
          );
        },
      );
    });
  }

  Future<void> validateForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _state = 1;
      });
      if (logging) {
        Future.delayed(const Duration(milliseconds: 300), () async {
          // print(nameController.text);
          context.read<AuthBloc>().add(
              EmailLoginEvent(nameController.text, passwordController.text));

          // if (authenticate == '') {
          //   setState(() {
          //     _state = 2;
          //   });
          //   //TODO: add biometric switch
          //   // await authController.addUser(authController.nameController.text, authController.passwordController.text);
          //   authController.rememberInfo(authController.nameController.text,
          //       authController.passwordController.text);
          //   Get.off(() => BlocProvider<SplashBloc>(
          //       create: (BuildContext context) =>
          //           SplashBloc()..add(GetSplashEvent(true)),
          //       child: SplashScreen()));
          // } else {
          //   setState(() {
          //     _state = 0;
          //   });
          //   uiController.showToast(
          //       context: context,
          //       color: GlobalColors.fireColor,
          //       icon: FontAwesomeIcons.exclamationCircle,
          //       text: "$authenticate",
          //       gravity: ToastGravity.BOTTOM);
          // }
        });
      } else {
        Future.delayed(const Duration(milliseconds: 300), () async {
          print("register");
          // String authenticate = await authController.register(
          //     authController.nameController.text,
          //     authController.passwordController.text);
          // authController.passwordController.clear();
          // authController.nameController.clear();
          // if (authenticate == null) {
          //   setState(() {
          //     _state = 2;
          //   });
          //   Future.delayed(const Duration(milliseconds: 300), () {
          //     setState(() {
          //       logging = true;
          //       _state = 1;
          //     });
          //   });
          // } else {
          //   // print(auth);
          //   setState(() {
          //     _state = 0;
          //   });
          //   Fluttertoast.showToast(
          //       msg: "$authenticate",
          //       toastLength: Toast.LENGTH_LONG,
          //       backgroundColor: GlobalColors.orangeColor,
          //       gravity: ToastGravity.BOTTOM,
          //       timeInSecForIosWeb: 2);
          // }
        });
      }
    }
  }
}
