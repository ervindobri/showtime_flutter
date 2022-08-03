import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_time/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:show_time/features/authentication/presentation/widgets/login_sheet.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/constants/strings.dart';
import 'package:show_time/core/constants/styles.dart';
import 'package:show_time/features/home/presentation/widgets/home_web.dart';
import 'package:show_time/features/watchlist/presentation/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:show_time/injection_container.dart';
import 'package:simple_animations/simple_animations.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with AnimationMixin {
  bool selected = false; // remember me
  bool logging = true;

  FaIcon eye = FaIcon(FontAwesomeIcons.eye, color: GlobalColors.greenColor);
  var animationName = 'Shrink';

  final GoogleSignIn googleSignIn = GoogleSignIn();
  late bool _fingerprintAnimStopped;
  bool _isBgAnimStopped = true;

  late Animation<double> animation;
  late AnimationController _controller;

  //TODO: fix animation
  @override
  void initState() {
    super.initState();
    _fingerprintAnimStopped = true;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: this,
    );

    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    );
    initialTimer();
  }

  var startAnimation = false;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  initialTimer() async {
    if (!kIsWeb) {
      await new Future.delayed(const Duration(milliseconds: 1000));
      // if (!controller.)
      setState(() {
        startAnimation = true;
        _isBgAnimStopped = false;
      });
    }

    await new Future.delayed(const Duration(milliseconds: 300));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    if (kIsWeb) {
      return HomeWeb();
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: GlobalStyles.noAppbar,
        body: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              top: !startAnimation ? _height / 3 : 30,
              curve: Curves.decelerate,
              left: _width / 4,
              right: _width / 4,
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
                        padding: const EdgeInsets.all(24),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
                            child: Container(
                              height: _height * .6,
                              width: _width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: GlobalColors.white.withOpacity(.4),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 30.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SecondaryButton(
                                        text: "",
                                        suffixIcon: Image(
                                          image: AssetImage(
                                              'assets/google_logo.png'),
                                          height: 30,
                                        ),
                                        onPressed: () async {
                                          print("google sign in!");
                                          // authController.signInWithGoogle();
                                          //TODO: auth with google
                                        },
                                      ),
                                      //TODO: auth bloc - canCheckBiometrics
                                      if (true) ...[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("or"),
                                        ),
                                        InkWell(
                                          highlightColor:
                                              GlobalColors.greenColor,
                                          onTap: () {
                                            //TODO: auth with biometry
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(25.0),
                                            child: Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: FlareActor(
                                                    "assets/fingerprint.flr",
                                                    isPaused:
                                                        _fingerprintAnimStopped,
                                                    fit: BoxFit.contain,
                                                    animation: "Untitled"),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      Expanded(
                                        child: Align(
                                          alignment:
                                              FractionalOffset.bottomCenter,
                                          child: InkWell(
                                            onTap: openBottomSheet,
                                            child: Container(
                                              child: Text(
                                                  GlobalStrings
                                                      .emailLoginInstead,
                                                  style: GlobalStyles
                                                          .theme(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          color: GlobalColors
                                                              .white,
                                                          fontWeight:
                                                              FontWeight.w900)),
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void openBottomSheet() {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        context: context,
        builder: (context) {
          return BlocProvider(
            create: (context) => sl<AuthBloc>(),
            child: LoginSheet(),
          );
        });
  }
}
