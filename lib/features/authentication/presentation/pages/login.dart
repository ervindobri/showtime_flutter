import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_time/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:show_time/features/authentication/presentation/widgets/login_sheet.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/constants/strings.dart';
import 'package:show_time/core/constants/styles.dart';
import 'package:show_time/features/home/presentation/widgets/home_web.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:show_time/injection_container.dart';
import 'package:simple_animations/simple_animations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with AnimationMixin {
  bool selected = false; // remember me
  bool logging = true;

  FaIcon eye =
      const FaIcon(FontAwesomeIcons.eye, color: GlobalColors.primaryGreen);
  var animationName = 'Shrink';

  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool _fingerprintAnimStopped = true;
  bool _isBgAnimStopped = true;

  // late Animation<double> animation;
  // late AnimationController _controller;

  //TODO: fix animation
  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(
    //   duration: const Duration(milliseconds: 300),
    //   vsync: this,
    // );

    // animation = CurvedAnimation(
    //   parent: _controller,
    //   curve: Curves.easeInCubic,
    // );
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
      await Future.delayed(const Duration(milliseconds: 800));
      // if (!controller.)
      setState(() {
        startAnimation = true;
        _isBgAnimStopped = false;
      });
    }

    await Future.delayed(const Duration(milliseconds: 300));
    // _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    if (kIsWeb) {
      return const HomeWeb();
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: GlobalStyles.noAppbar,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: _width / 2,
              height: _height * .1,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/showTIMEsmall.png"),
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(
              width: _width,
              height: _height,
              child: FlareActor("assets/flowingbg.flr",
                  isPaused: _isBgAnimStopped,
                  fit: BoxFit.cover,
                  animation: "in"),
            ),
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 48.0, sigmaY: 24.0),
                  child: Container(
                    height: _height * .6,
                    width: _width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: GlobalColors.white.withOpacity(.4),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                iconSize: 64,
                                icon: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Image(
                                      image:
                                          AssetImage('assets/google_logo.png'),
                                      height: 48,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  print("google sign in!");
                                  // authController.signInWithGoogle();
                                  //TODO: auth with google
                                },
                              ),
                              //TODO: auth bloc - canCheckBiometrics
                              if (true) ...[
                                const Text("or"),
                                IconButton(
                                  iconSize: 64,
                                  highlightColor: GlobalColors.primaryGreen,
                                  onPressed: () {
                                    //TODO: auth with biometry
                                  },
                                  icon: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: FlareActor(
                                          "assets/fingerprint.flr",
                                          isPaused: _fingerprintAnimStopped,
                                          fit: BoxFit.contain,
                                          animation: "Untitled"),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Expanded(
                            child: Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: TextButton(
                                onPressed: openBottomSheet,
                                child: Text(GlobalStrings.emailLoginInstead,
                                    style: GlobalStyles.theme(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                            decoration:
                                                TextDecoration.underline,
                                            color: GlobalColors.white,
                                            fontWeight: FontWeight.w900)),
                              ),
                            ),
                          )
                        ]),
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
    // _controller.dispose();
    super.dispose();
  }

  void openBottomSheet() {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        context: context,
        builder: (context) {
          return BlocProvider.value(
            value: sl<AuthBloc>(),
            child: const LoginSheet(),
          );
        });
  }
}
