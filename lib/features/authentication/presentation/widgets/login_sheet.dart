import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:show_time/controllers/auth_controller.dart';
import 'package:show_time/controllers/show_controller.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/constants/styles.dart';
import 'package:show_time/core/utils/navigation.dart';
import 'package:show_time/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:show_time/features/authentication/presentation/widgets/reset_content.dart';
import 'package:show_time/features/home/presentation/widgets/home_web.dart';
import 'package:show_time/injection_container.dart';
import 'package:show_time/models/user.dart';

class LoginSheet extends StatefulWidget {
  const LoginSheet({Key? key}) : super(key: key);

  @override
  _LoginSheetState createState() => _LoginSheetState();
}

class _LoginSheetState extends State<LoginSheet> with TickerProviderStateMixin {
  bool selected = false; // remember me
  bool logging = true;

  bool _showPassword = true;

  FaIcon eye =
      const FaIcon(FontAwesomeIcons.eye, color: GlobalColors.primaryGreen);
  int _state = 0;
  var animationName = 'Shrink';
  final CarouselController _carouselController = CarouselController();
  TextEditingController nameController =
      TextEditingController(text: 'dobriervin@yahoo.com');
  TextEditingController passwordController =
      TextEditingController(text: 'djcaponegood');
  TextEditingController repasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) async {
      if (state is LoginSuccessful) {
        sl<AuthController>().currentUserEmail.value = state.user.user!.email!;
        await sl<ShowController>().initialize();
        NavUtils.navigateReplaced(context, '/home', args: state.user);
      }
    }, builder: (context, state) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: _height * .75,
            width: _width,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                )),
            child: CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  scrollDirection: Axis.horizontal,
                  scrollPhysics: const NeverScrollableScrollPhysics(),
                  viewportFraction: 1.0,
                  aspectRatio: .5,
                ),
                items: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 4,
                          width: 100,
                          margin: const EdgeInsets.only(bottom: 48),
                          decoration: BoxDecoration(
                              color: GlobalColors.greyTextColor.withOpacity(.3),
                              borderRadius: BorderRadius.circular(24)),
                        ),
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "E-mail address",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.normal,
                                        color: GlobalColors.greyTextColor,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      validator: (value) =>
                                          EmailValidator.validate(value!)
                                              ? null
                                              : "E-mail address is not valid",
                                      controller: nameController,
                                      keyboardType: TextInputType.emailAddress,
                                      autofocus: false,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Raleway',
                                          color: GlobalColors.greyTextColor),
                                      decoration:
                                          GlobalStyles.formInputDecoration(),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Password",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Raleway',
                                        color: GlobalColors.greyTextColor,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      controller: passwordController,
                                      obscureText: _showPassword,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Raleway',
                                        color: GlobalColors.greyTextColor,
                                      ),
                                      decoration:
                                          GlobalStyles.formInputDecoration(
                                              suffix:
                                                  // logging
                                                  // ?
                                                  InkWell(
                                        onTap: () {
                                          setState(() {
                                            _showPassword = !_showPassword;
                                            eye = _showPassword
                                                ? const FaIcon(
                                                    FontAwesomeIcons.eye,
                                                    color: GlobalColors
                                                        .primaryGreen,
                                                  )
                                                : const FaIcon(
                                                    FontAwesomeIcons.eyeSlash,
                                                    color: GlobalColors
                                                        .primaryGreen,
                                                  );
                                          });
                                        },
                                        child: eye,
                                      )
                                              // : const SizedBox(),
                                              ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 16),
                                AnimatedSizeAndFade(
                                  vsync: this,
                                  child: logging
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: const [
                                                Text(
                                                  "Remember me",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'Raleway',
                                                      color: GlobalColors
                                                          .greyTextColor,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            RoundCheckBox(
                                              isChecked: selected,
                                              checkedColor:
                                                  GlobalColors.primaryGreen,
                                              // uncheckedColor: GlobalColors.greyTextColor,
                                              borderColor:
                                                  GlobalColors.primaryGreen,
                                              size: 24,
                                              onTap: (value) => setState(() {
                                                selected = value!;
                                                // authController
                                                //     .selected = value;
                                              }),
                                            ),
                                          ],
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Password again",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Raleway',
                                                color:
                                                    GlobalColors.greyTextColor,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Stack(
                                              children: [
                                                TextFormField(
                                                  validator: (value) {
                                                    return null;

                                                    // if (value !=
                                                    //     authController
                                                    //         .passwordController
                                                    //         .text) {
                                                    //   return "Passwords do not match!";
                                                    // }
                                                    // return null;
                                                  },
                                                  keyboardType: TextInputType
                                                      .visiblePassword,
                                                  controller:
                                                      repasswordController,
                                                  obscureText: true,
                                                  style: const TextStyle(
                                                      fontSize: 15.0,
                                                      fontFamily: 'Raleway',
                                                      color: GlobalColors
                                                          .greyTextColor),
                                                  decoration: GlobalStyles
                                                      .formInputDecoration(),
                                                ),
                                                if (logging)
                                                  Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    15.0),
                                                        child: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                _showPassword =
                                                                    !_showPassword;
                                                                eye = _showPassword
                                                                    ? const FaIcon(
                                                                        FontAwesomeIcons
                                                                            .eye,
                                                                        color: GlobalColors
                                                                            .primaryGreen,
                                                                      )
                                                                    : const FaIcon(
                                                                        FontAwesomeIcons
                                                                            .eyeSlash,
                                                                        color: GlobalColors
                                                                            .primaryGreen,
                                                                      );
                                                              });
                                                            },
                                                            child: eye),
                                                      )),
                                              ],
                                            )
                                          ],
                                        ),
                                  fadeDuration:
                                      const Duration(milliseconds: 200),
                                  sizeDuration:
                                      const Duration(milliseconds: 200),
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    TextButton(
                                      style: GlobalStyles.greenButtonStyle(),
                                      onPressed: () async {
                                        await validateForm(context);
                                      },
                                      child: buttonChild(
                                          _state, logging, Colors.white),
                                    ),
                                    const SizedBox(height: 12),
                                    TextButton(
                                      style: GlobalStyles.whiteButtonStyle(),
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
                                      child: Center(
                                        child: Text(
                                          logging
                                              ? "Register"
                                              : "Back to login",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Raleway',
                                            color: GlobalColors.primaryGreen,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    TextButton(
                                      onPressed: () {
                                        _carouselController.nextPage(
                                            duration: const Duration(
                                                milliseconds: 100),
                                            curve: Curves.easeIn);
                                      },
                                      child: Text(
                                        "Forgot your password?",
                                        style: GoogleFonts.raleway(
                                            color: GlobalColors.greyTextColor
                                                .withOpacity(.4),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    )
                                  ],
                                ),

                                ///Actions
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ResetContent(carouselController: _carouselController)
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
          // await authController.addUser(authController.nameController.text, authController.passwordController.text);
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
