import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:show_time/constants/custom_variables.dart';
import 'package:show_time/get_controllers/auth_controller.dart';
import 'package:show_time/get_controllers/show_controller.dart';
import 'package:show_time/models/episode.dart';
import 'package:show_time/models/watched.dart';
import 'package:show_time/providers/connectivity_service.dart';
import 'package:show_time/ui/create_profile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:simple_animations/simple_animations.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AnimationMixin {

  late StreamSubscription<ConnectivityResult> subscription;
  var connectionStatus;
  bool allDone = false;
  List<Episode> notAiredList = [];

  var animationName = 'Shrink';
  late Animation<double> animation;
  late AnimationController _controller;
  bool allCompleted = false;
  late Timer completed;
  late QuerySnapshot watchedShowsSnapshot;
  List<WatchedTVShow> watchedShowsList = [];

  ShowController showController = Get.put(ShowController())!;
  AuthController authController = Get.put(AuthController())!;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )
      ..forward();

    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );


    //TODO: CHECK ACTIVE CONNECTION WITH GETX

    //Fetch current user and show data
    authController.getUserData();
    showController.initialize();
    print("splash init");

  }

  @override
  void dispose() {
    completed.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _width = Get.width;
    final _height = Get.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.bgColor,
        shadowColor: Colors.transparent,
        brightness: Brightness.light,
        toolbarHeight: 0,
      ),
      body: Container(
        width: _width,
        color: GlobalColors.bgColor,
        height: _height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //ANIMATE IN LOGO
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, -1),
                end: Offset.zero,
              ).animate(animation),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10),
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    width: _width / 2,
                    height: _height*.15,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/showTIMEsmall.png"),
                            fit: BoxFit.cover)),
                  ),
                ),
              ),
            ),
            // PROGRESS BAR TO LOAD HOME STUFF
            splashBody(_width, _height, context),
          ],
        ),
      ),
    );
  }

  Widget splashBody(double _width, double _height, BuildContext context) {
    if (connectionStatus == ConnectivityStatus.Offline) {
      return Container(
        width: _width,
        height: _height * .6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FaIcon(
                      FontAwesomeIcons.exclamationCircle,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "No internet connection",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    return GetBuilder<AuthController>(
      init: authController,
      builder: (_){
        if (authController.user == null) {
          return CreateProfile();
        }
        else {
          return GetX<ShowController>(
            init: showController,
            builder: (_){
              if (showController.notAired.isNotEmpty) {
                Timer.run(() {
                  print("go to home!");
                  Get.offAll(() => HomeView());
                });
                return loadingCouch();
              }
              else {
                return loadingCouch();
              }
            },
          );
        }
      },
    );

  }

  Widget loadingCouch() {
    return Center(
      child: Container(
        width: Get.width * .5,
        height: Get.height * .2,
        // color: Colors.black,
        child: SizedBox(
          child: Center(
            child: FlareActor("assets/loadingcouch.flr",
                alignment: Alignment.bottomCenter,
                fit: BoxFit.contain,
                animation: "load"),
          ),
        ),
      ),
    );
  }
}