import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:show_time/components/custom_elevation.dart';
import 'package:show_time/components/toast.dart';
import 'package:show_time/constants/custom_variables.dart';
import 'package:show_time/get_controllers/auth_controller.dart';
import 'package:show_time/network/firebase_utils.dart';
import 'package:show_time/pages/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simple_animations/simple_animations.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with AnimationMixin {
  bool selected = false; // remember me
  bool logging = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  bool _showPassword = true;

  FaIcon eye = FaIcon(FontAwesomeIcons.eye, color: GlobalColors.greenColor);
  int _state = 0;
  var animationName = 'Shrink';
  late FToast fToast;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  late bool _fingerprintAnimStopped;

  late Animation<double> animation;
  late AnimationController _controller;

  bool _isBgAnimStopped = true;

  CarouselController _carouselController = CarouselController();

  AuthController authController = Get.put(AuthController())!;

  // UserDao dao;






  @override
  void initState() {
    initialTimer();
    _fingerprintAnimStopped = true;
    super.initState();
    fToast = FToast();
    fToast.init(context);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: this,
    );

    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    );
  }

  var startAnimation = false;

  initialTimer() async {
    await new Future.delayed(const Duration(milliseconds: 2000));
    setState(() {
      startAnimation = true;
      _isBgAnimStopped = false;
    });
    await new Future.delayed(const Duration(milliseconds: 300));
    _controller.forward();
  }

  //TODO: refactor to auth controller




  // /password validator possible structure
  passwordValidator(String password) {
    if (password.isEmpty) {
      return 'Password empty';
    } else if (password.length < 3) {
      return 'PasswordShort';
    }
    return null;
  }



  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            top: !startAnimation
                ? _height/3
                : 30,
            curve: Curves.decelerate,
            left: _width/4,
            right: _width/4,
            child: Container(
              width: _width / 2,
              height: _height * .1,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/showTIMEsmall.png"),
                      fit: BoxFit.cover)),
            ),
          ),
          Container(
            width: _width,
            height: _height,
            child: FlareActor("assets/flowingbg.flr",
                isPaused: _isBgAnimStopped,
                fit: BoxFit.cover,
                animation: "in"),
          ),
          FadeTransition(
          opacity: Tween<double>(
          begin: 0,
          end: 1,
          ).animate(animation),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, 1),
                end: Offset.zero,
              ).animate(animation),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                          child: Container(
                            height: _height * .7,
                            width: _width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: GlobalColors.bgColor.withOpacity(.2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FlatButton(
                                        textColor: GlobalColors.greyTextColor,
                                        highlightColor: GlobalColors.greenColor,
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(color: GlobalColors.greyTextColor, width: .3),
                                            borderRadius: BorderRadius.circular(15)),
                                        child: Container(
                                          width: 150,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Image(
                                                  image: AssetImage(
                                                      'assets/google_logo.png'),
                                                  height: 30,
                                                ),
                                                Text('Google Sign-In'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          print("google sign in!");
                                          authController.signInWithGoogle();
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "or"
                                      ),
                                    ),
                                    if ( authController.canCheckBiometrics)
                                      GetBuilder<AuthController>(
                                        init: authController,
                                        builder: (_) {
                                          return InkWell(
                                            highlightColor: GlobalColors.greenColor,
                                            onTap: authController.authenticateUserWithFingerprint,
                                            child: Padding(
                                              padding: const EdgeInsets.all(25.0),
                                              child: Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: FlareActor("assets/fingerprint.flr",
                                                      isPaused: _fingerprintAnimStopped,
                                                      fit: BoxFit.contain,
                                                      animation: "Untitled"),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: FractionalOffset.bottomCenter,
                                        child: InkWell(
                                          onTap: openBottomSheet,
                                          child: Container(
                                            child: Text(
                                              "Login with Email and Password instead",
                                              style: TextStyle(
                                                  fontFamily: 'Raleway',
                                                  color: Colors.white,
                                                shadows: [BoxShadow(
                                                  color: GlobalColors.greyTextColor,
                                                  spreadRadius: -2,
                                                  blurRadius: 20
                                                )]
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonChild() {
    if (_state == 0) {
      return Text(
        logging ? "Log in" : "Register",
        style: TextStyle(
            fontSize: 15,
            fontFamily: 'Raleway',
            color: Colors.white,
            fontWeight: FontWeight.w600),
      );
    } else if (_state == 1) {
      return Container(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  void openBottomSheet() {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final textFieldHeight = 45.0;
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25)
        ),
        context: context,
        builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: _height*.8,
              width: _width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25)
              ),
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
                    height: _height*.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25)
                    ),
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
                                        color: GlobalColors.greyTextColor.withOpacity(.3),
                                        borderRadius: BorderRadius.circular(25)
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                  child: Container(
                                    child: GetBuilder<AuthController>(
                                      init: authController,
                                      builder: (_) => Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 25.0, vertical: 5.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "E-mail address",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontFamily: 'Raleway',
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 15.0),
                                                  child: Container(
                                                    // height: textFieldHeight,
                                                    child: TextFormField(
                                                      validator: (value) =>
                                                      EmailValidator.validate(value)
                                                          ? null
                                                          : "E-mail address is not valid",
                                                      controller: authController.nameController,
                                                      keyboardType:
                                                      TextInputType.emailAddress,
                                                      autofocus: false,
                                                      style: new TextStyle(
                                                          fontSize: 15.0,
                                                          fontFamily: 'Raleway',
                                                          color: GlobalColors.greyTextColor),
                                                      decoration: const InputDecoration(
                                                        errorStyle: TextStyle(
                                                            fontFamily: 'Raleway',
                                                            color: GlobalColors.orangeColor),
                                                        contentPadding: EdgeInsets.symmetric(
                                                            vertical: 5.0, horizontal: 10.0),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        hintText: 'johndoe@example.com',
                                                        focusColor: GlobalColors.greenColor,
                                                        enabledBorder:
                                                        const OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: GlobalColors.blueColor),
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(50.0)),
                                                        ),
                                                        border: const OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: GlobalColors.blueColor),
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(50.0)),
                                                        ),
                                                        focusedBorder:
                                                        const OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: GlobalColors.greenColor,
                                                              width: 2),
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(50.0)),
                                                        ),
                                                        errorBorder: const OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: GlobalColors.orangeColor,
                                                              width: 2),
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(50.0)),
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
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 25.0, vertical: 0.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "Password",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontFamily: 'Raleway',
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 15.0),
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        // height: textFieldHeight,
                                                        child: TextFormField(
                                                          validator: (value) {
                                                            debugPrint(value);
                                                            return passwordValidator(value!);
                                                          },
                                                          keyboardType: TextInputType.visiblePassword,
                                                          controller: authController.passwordController,
                                                          obscureText: _showPassword,
                                                          style: new TextStyle(
                                                              fontSize: 15.0,
                                                              fontFamily: 'Raleway',
                                                              color:
                                                              GlobalColors.greyTextColor),
                                                          decoration: const InputDecoration(
                                                              contentPadding:
                                                              EdgeInsets.symmetric(
                                                                  vertical: 1.0,
                                                                  horizontal: 10.0),
                                                              errorStyle: TextStyle(
                                                                  fontFamily: 'Raleway',
                                                                  color: GlobalColors
                                                                      .orangeColor),
                                                              errorText: null,
                                                              errorMaxLines: 1,
                                                              filled: true,
                                                              fillColor: Colors.white,
                                                              hintText: 'password1234',
                                                              focusColor:
                                                              GlobalColors.greenColor,
                                                              enabledBorder:
                                                              const OutlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                    color: GlobalColors
                                                                        .greenColor),
                                                                borderRadius:
                                                                const BorderRadius.all(
                                                                    Radius.circular(
                                                                        50.0)),
                                                              ),
                                                              border:
                                                              const OutlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                    color: GlobalColors
                                                                        .greenColor),
                                                                borderRadius:
                                                                const BorderRadius.all(
                                                                    Radius.circular(
                                                                        50.0)),
                                                              ),
                                                              focusedBorder:
                                                              const OutlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                    color: GlobalColors
                                                                        .greenColor,
                                                                    width: 1.5),
                                                                borderRadius:
                                                                const BorderRadius.all(
                                                                    Radius.circular(
                                                                        50.0)),
                                                              ),
                                                              errorBorder:
                                                              const OutlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                    color: GlobalColors
                                                                        .orangeColor,
                                                                    width: 1.5),
                                                                borderRadius:
                                                                const BorderRadius.all(
                                                                    Radius.circular(
                                                                        50.0)),
                                                              )),
                                                        ),
                                                      ),
                                                      if (logging)
                                                        Container(
                                                          height: textFieldHeight,
                                                          child: Align(
                                                              alignment:
                                                              Alignment.centerRight,
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal: 15.0),
                                                                child: InkWell(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        _showPassword =
                                                                        !_showPassword;
                                                                        eye = _showPassword
                                                                            ? FaIcon(
                                                                          FontAwesomeIcons
                                                                              .eye,
                                                                          color: GlobalColors
                                                                              .greenColor,
                                                                        )
                                                                            : FaIcon(
                                                                          FontAwesomeIcons
                                                                              .eyeSlash,
                                                                          color: GlobalColors
                                                                              .greenColor,
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
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 25.0,
                                                        vertical: 5.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Remember me",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontFamily: 'Raleway',
                                                              color: GlobalColors.greyTextColor,
                                                              fontWeight:
                                                              FontWeight.w600),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 25.0),
                                                    child: CircularCheckBox(
                                                      value: this.selected,
                                                      activeColor: GlobalColors.greenColor,
                                                      materialTapTargetSize: MaterialTapTargetSize.padded,
                                                      inactiveColor: GlobalColors.greyTextColor,
                                                      hoverColor: GlobalColors.blueColor,
                                                      checkColor: Colors.white,
                                                      focusColor: GlobalColors.greyTextColor,
                                                      onChanged: (value) =>
                                                          setState(() {
                                                            this.selected = value;
                                                            authController.selected = value;
                                                          }),
                                                    ),
                                                  ),
                                                ],
                                              )
                                                  : Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 25.0,
                                                        vertical: 0.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Password again",
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
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          // height: textFieldHeight,
                                                          child: TextFormField(
                                                            validator: (value) {
                                                              if (value !=
                                                                  authController.passwordController
                                                                      .text) {
                                                                return "Passwords do not match!";
                                                              }
                                                              return null;
                                                            },
                                                            keyboardType: TextInputType
                                                                .visiblePassword,
                                                            controller:
                                                            authController.repasswordController,
                                                            obscureText: true,
                                                            style: new TextStyle(
                                                                fontSize: 15.0,
                                                                fontFamily: 'Raleway',
                                                                color: GlobalColors
                                                                    .greyTextColor),
                                                            decoration:
                                                            const InputDecoration(
                                                                contentPadding: EdgeInsets
                                                                    .symmetric(
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
                                                                errorMaxLines: 1,
                                                                filled: true,
                                                                fillColor:
                                                                Colors.white,
                                                                hintText:
                                                                'password1234',
                                                                focusColor:
                                                                GlobalColors
                                                                    .greenColor,
                                                                enabledBorder:
                                                                const OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: GlobalColors
                                                                          .greenColor),
                                                                  borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          50.0)),
                                                                ),
                                                                border:
                                                                const OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: GlobalColors
                                                                          .greenColor),
                                                                  borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          50.0)),
                                                                ),
                                                                focusedBorder:
                                                                const OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: GlobalColors
                                                                          .greenColor,
                                                                      width: 1.5),
                                                                  borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          50.0)),
                                                                ),
                                                                errorBorder:
                                                                const OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: GlobalColors
                                                                          .orangeColor,
                                                                      width: 1.5),
                                                                  borderRadius:
                                                                  const BorderRadius
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
                                                                              ? FaIcon(
                                                                            FontAwesomeIcons
                                                                                .eye,
                                                                            color:
                                                                            GlobalColors.greenColor,
                                                                          )
                                                                              : FaIcon(
                                                                            FontAwesomeIcons
                                                                                .eyeSlash,
                                                                            color:
                                                                            GlobalColors.greenColor,
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
                                              fadeDuration: const Duration(milliseconds: 200),
                                              sizeDuration: const Duration(milliseconds: 200),
                                            ),
                                          ],
                                        ),
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
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: CustomElevation(
                                      color: CupertinoColors.black.withOpacity(.15),
                                      spreadRadius: -2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                        color: GlobalColors.greenColor,
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: TextButton(
                                          //     borderRadius: BorderRadius.circular(12.0)),
                                          onPressed: () async {
                                            if (_formKey.currentState!.validate()) {
                                              setState(() {
                                                _state = 1;
                                              });
                                              if (logging) {
                                                Future.delayed(
                                                    const Duration(milliseconds: 300),
                                                        () async {
                                                      // print(nameController.text);
                                                          String authenticate = await authController.login(authController.nameController.text,authController.passwordController.text);
                                                      if (authenticate == '') {
                                                        setState(() {
                                                          _state = 2;
                                                        });
                                                        //TODO: add biometric switch
                                                        await authController.addUser(authController.nameController.text, authController.passwordController.text);
                                                        authController.rememberInfo(authController.nameController.text, authController.passwordController.text);
                                                        Get.off(() => SplashScreen());
                                                      }
                                                      else {
                                                        setState(() {
                                                          _state = 0;
                                                        });
                                                        Widget toast = CustomToast(
                                                            color: GlobalColors.fireColor,
                                                            icon: FontAwesomeIcons
                                                                .exclamationCircle,
                                                            text: "$authenticate");
                                                        fToast.showToast(
                                                          child: toast,
                                                          gravity: ToastGravity.BOTTOM,
                                                          toastDuration: Duration(seconds: 3),
                                                        );
                                                      }
                                                    });
                                              }
                                              else {
                                                Future.delayed(
                                                    const Duration(milliseconds: 300),
                                                        () async {
                                                      String authenticate =
                                                      await authController.register(
                                                          authController.nameController.text,
                                                          authController.passwordController.text);
                                                      authController.passwordController.clear();
                                                      authController.nameController.clear();
                                                      if (authenticate == null) {
                                                        setState(() {
                                                          _state = 2;
                                                        });
                                                        Future.delayed(
                                                            const Duration(milliseconds: 300),
                                                                () {
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
                                                            msg: "$authenticate",
                                                            toastLength: Toast.LENGTH_LONG,
                                                            backgroundColor:
                                                            GlobalColors.orangeColor,
                                                            gravity: ToastGravity.BOTTOM,
                                                            timeInSecForIosWeb: 2);
                                                      }
                                                    });
                                              }
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Container(
                                                height: _height / 20,
                                                width: _width / 2,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    buttonChild(),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 20.0),
                                                      child: FaIcon(
                                                        FontAwesomeIcons.longArrowAltRight,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomElevation(
                                      color: CupertinoColors.black.withOpacity(.05),
                                      child: OutlinedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                          overlayColor: MaterialStateProperty.all<Color>(GlobalColors.greenColor),
                                        ),
                                          onPressed: () {
                                            setState(() {
                                              logging = !logging;
                                              if (!logging) {
                                                authController.nameController.clear();
                                                authController.passwordController.clear();
                                                authController.repasswordController.clear();
                                              }
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left:8.0, right: 8.0),
                                            child: Container(
                                              height: textFieldHeight,
                                              width: _width / 2,
                                              child: Center(
                                                child: Text(
                                                  logging ? "Register" : "Back to login",
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
                                  TextButton(
                                    onPressed: (){
                                      _carouselController.nextPage(
                                          duration: Duration(milliseconds: 100), curve: Curves.easeIn);
                                    }, child: Text(
                                    "Forgot your password?",
                                    style: GoogleFonts.raleway(
                                      color: GlobalColors.greyTextColor.withOpacity(.4),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300
                                    ),
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
                  Container(
                    width: _width,
                    height: _height*.7,
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
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 45.0,vertical: 25),
                          child: TextFormField(
                            validator: (value) =>
                            EmailValidator.validate(value)
                                ? null
                                : "E-mail address is not valid",
                            controller: authController.resetController,
                            keyboardType: TextInputType.emailAddress,
                            autofocus: false,
                            style: new TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'Raleway',
                                color: GlobalColors.greyTextColor),
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(
                                  fontFamily: 'Raleway',
                                  color: GlobalColors.orangeColor),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'johndoe@example.com',
                              focusColor: GlobalColors.greenColor,
                              enabledBorder:
                              const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: GlobalColors.blueColor),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(50.0)),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: GlobalColors.blueColor),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(50.0)),
                              ),
                              focusedBorder:
                              const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: GlobalColors.greenColor,
                                    width: 2),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(50.0)),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: GlobalColors.orangeColor,
                                    width: 2),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(50.0)),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(GlobalColors.greenColor),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)
                              ),
                            )
                          ),
                          onPressed: () async {
                            if ( authController.resetController.text.isNotEmpty){
                              FirestoreUtils().resetPassword(authController.resetController.text);
                            }
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
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600
                                      ),

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
                                  _carouselController.previousPage(duration: Duration(milliseconds: 100), curve: Curves.easeIn);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left:12.0, right: 12.0),
                                  child: Container(
                                    height: textFieldHeight,
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
                  ),
                ]
              ),
            );
          }
        );
    });
  }
}
