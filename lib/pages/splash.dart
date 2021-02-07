import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/database/user_data_dao.dart';
import 'package:eWoke/get_controllers/auth_controller.dart';
import 'package:eWoke/get_controllers/show_controller.dart';
import 'package:eWoke/models/episode.dart';
import 'package:eWoke/models/user.dart';
import 'package:eWoke/models/watched.dart';
import 'package:eWoke/network/firebase_utils.dart';
import 'package:eWoke/providers/connectivity_service.dart';
import 'package:eWoke/providers/show_provider.dart';
import 'package:eWoke/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';

import 'package:eWoke/main.dart';
import 'home.dart';
import 'package:progress_state_button/progress_button.dart';

class SplashScreen extends StatefulWidget {
  final UserDao dao;
  SplashScreen({this.dao});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AnimationMixin {

  StreamSubscription<ConnectivityResult> subscription;
  var connectionStatus;
  SessionUser currentUser = SessionUser();
  bool allDone = false;
  List<Episode> notAiredList = [];
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController ageController = new TextEditingController();
  TextEditingController sexController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  ButtonState buttonState = ButtonState.idle;
  var animationName = 'Shrink';
  Animation<double> animation;
  AnimationController _controller;
  bool allCompleted = false;
  Timer completed;
  QuerySnapshot watchedShowsSnapshot;
  List<WatchedTVShow> watchedShowsList = [];
  ShowProvider showProvider;

  ShowController showController = Get.put(ShowController());
  AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: this,
    )
      ..forward();

    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );


    //TODO: CHECK ACTIVE CONNECTION WITH GETX

    sexController.text = GlobalVariables.sexCategories[0];
    ageController.text = 1.toString();

    //Fetch current user and show data
    authController.getUserData();
    showController.initialize();

    //Call timer to check if all tasks finished
    Timer.periodic(Duration(seconds: 1), (completed) {
      if (allCompleted) {
        print("HOME");
        final home = HomeView(
            dao: widget.dao
        );

        Navigator.of(context)
            .pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) =>
                home
            ), (route) => false);

        completed.cancel();
      }
    });
  }

  @override
  void dispose() {
    // _watchedShowsStream = null;
    subscription = null;
    completed?.cancel();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery
        .of(context)
        .size
        .width;
    final _height = MediaQuery
        .of(context)
        .size
        .height;



    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.bgColor,
        shadowColor: Colors.transparent,
        brightness: Brightness.light,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: GlobalColors.blueColor,
          child: Stack(
            children: [
              Container(
                width: _width,
                height: _height,
              ),
              Column(
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
                          height: _height / 5.5,
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
            ],
          ),
        ),
      ),
    );
  }

  createProfile(double _width, double _height, BuildContext context) {
    final node = FocusScope.of(context);
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, 1),
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
                offset: Offset(0, 5), // changes position of shadow
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
                begin: Offset(0, 0.1),
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
                      child: Container(
                        // height: _height*.7,
                        // width: _width,
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
                                          fontWeight: FontWeight.w300
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: Container(
                                        width: _width / 3,
                                        height: _width / 6,
                                        child: TextFormField(
                                          controller: firstNameController,
                                          keyboardType: TextInputType.name,
                                          textCapitalization: TextCapitalization
                                              .words,

                                          autofocus: false,
                                          validator: (val) {
                                            if (val == "") {
                                              return "Your first name!";
                                            }
                                            else {
                                              return null;
                                            }
                                          },
                                          decoration: const InputDecoration(
                                            errorStyle: TextStyle(
                                                fontFamily: 'Raleway',
                                                color: GlobalColors.orangeColor
                                            ),
                                            hintStyle: TextStyle(
                                                fontFamily: 'Raleway',
                                                color: GlobalColors
                                                    .greyTextColor,
                                                fontWeight: FontWeight.w300
                                            ),
                                            contentPadding: EdgeInsets
                                                .symmetric(vertical: 10.0,
                                                horizontal: 10.0),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'John',
                                            focusColor: GlobalColors.greenColor,
                                            enabledBorder: const OutlineInputBorder(
                                              borderSide:
                                              BorderSide(color: GlobalColors
                                                  .blueColor),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0)),
                                            ),
                                            border: const OutlineInputBorder(
                                              borderSide:
                                              BorderSide(color: GlobalColors
                                                  .blueColor),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0)),
                                            ),
                                            focusedBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: GlobalColors
                                                      .greenColor, width: 2),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0)),
                                            ),
                                            errorBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: GlobalColors
                                                      .orangeColor, width: 2),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0)),
                                            ),
                                          ),
                                          style: GoogleFonts.roboto(
                                              color: GlobalColors.greyTextColor,
                                              fontSize: _width / 20,
                                              fontWeight: FontWeight.w500
                                          ),
                                          onEditingComplete: () =>
                                              node
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
                                  mainAxisAlignment: MainAxisAlignment
                                      .end,
                                  children: [
                                    Text(
                                      "last Name",
                                      style: GoogleFonts.roboto(
                                          color: GlobalColors.greyTextColor,
                                          fontSize: _width / 20,
                                          fontWeight: FontWeight.w300
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: Container(
                                        width: _width / 3,
                                        height: _width / 6,
                                        child: TextFormField(
                                          controller: lastNameController,
                                          autofocus: false,
                                          textCapitalization: TextCapitalization
                                              .words,
                                          validator: (val) {
                                            if (val == "") {
                                              return "Your last name!";
                                            }
                                            else {
                                              return null;
                                            }
                                          },
                                          decoration: const InputDecoration(
                                            errorStyle: TextStyle(
                                                fontFamily: 'Raleway',
                                                color: GlobalColors.orangeColor
                                            ),
                                            contentPadding: EdgeInsets
                                                .symmetric(vertical: 10.0,
                                                horizontal: 10.0),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'Doe',
                                            hintStyle: TextStyle(
                                                fontFamily: 'Raleway',
                                                color: GlobalColors
                                                    .greyTextColor,
                                                fontWeight: FontWeight.w300
                                            ),
                                            focusColor: GlobalColors.greenColor,
                                            enabledBorder: const OutlineInputBorder(
                                              borderSide:
                                              BorderSide(color: GlobalColors
                                                  .blueColor),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0)),
                                            ),
                                            border: const OutlineInputBorder(
                                              borderSide:
                                              BorderSide(color: GlobalColors
                                                  .blueColor),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0)),
                                            ),
                                            focusedBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: GlobalColors
                                                      .greenColor, width: 2),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0)),
                                            ),
                                            errorBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: GlobalColors
                                                      .orangeColor, width: 2),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0)),
                                            ),
                                          ),
                                          style: GoogleFonts.roboto(
                                              color: GlobalColors.greyTextColor,
                                              fontSize: _width / 20,
                                              fontWeight: FontWeight.w500
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
                                  mainAxisAlignment: MainAxisAlignment
                                      .end,

                                  children: [
                                    Text(
                                      "age",
                                      style: GoogleFonts.roboto(
                                          color: GlobalColors.greyTextColor,
                                          fontSize: _width / 20,
                                          fontWeight: FontWeight.w300
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: Container(
                                        width: _width / 3,
                                        height: _width / 10,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          border: Border.all(
                                              color: GlobalColors.blueColor
                                          ),
                                        ),
                                        child: CupertinoTheme(
                                          data: CupertinoThemeData(
                                            scaffoldBackgroundColor: Colors
                                                .transparent,
                                            primaryColor: Colors.transparent,
                                            primaryContrastingColor: Colors
                                                .transparent,
                                            barBackgroundColor: Colors
                                                .transparent,
                                            textTheme: CupertinoTextThemeData(

                                              pickerTextStyle: GoogleFonts
                                                  .roboto(
                                                  color: GlobalColors
                                                      .greyTextColor,
                                                  fontSize: 25
                                              ),
                                            ),
                                          ),
                                          child: CupertinoPicker(
                                            looping: true,
                                            backgroundColor: Colors.transparent,
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
                                            onSelectedItemChanged: (int value) {
                                              ageController.text =
                                                  (value + 1).toString();
                                            },
                                            children: List.generate(
                                                100, (index) =>
                                                Center(
                                                  child: Text(
                                                    (index + 1).toString(),
                                                    style: GoogleFonts.roboto(
                                                        color: GlobalColors
                                                            .greyTextColor,
                                                        fontSize: _width / 20,
                                                        fontWeight: FontWeight
                                                            .w500
                                                    ),
                                                  ),
                                                )
                                            ),
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
                                  mainAxisAlignment: MainAxisAlignment
                                      .end,
                                  children: [
                                    Text(
                                      "sex",
                                      style: GoogleFonts.roboto(
                                          fontSize: _width / 20,
                                          fontWeight: FontWeight.w300,
                                          color: GlobalColors.greyTextColor
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: Container(
                                        width: _width / 3,
                                        height: _width / 10,

                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          border: Border.all(
                                              color: GlobalColors.blueColor
                                          ),
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
                                            sexController.text = GlobalVariables
                                                .sexCategories[value];
                                          },
                                          children: List.generate(
                                              GlobalVariables.sexCategories
                                                  .length, (index) =>
                                              Align(
                                                  alignment: Alignment
                                                      .centerRight,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .only(right: 15.0),
                                                    child: Text(
                                                      GlobalVariables
                                                          .sexCategories[index],
                                                      style: GoogleFonts.roboto(
                                                          color: GlobalColors
                                                              .greyTextColor,
                                                          fontSize: _width / 20,
                                                          fontWeight: FontWeight
                                                              .w500
                                                      ),
                                                    ),
                                                  )
                                              )
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                    child: ProgressButton(
                                      maxWidth: _width / 3,
                                      minWidth: _width / 3,
                                      state: buttonState,
                                      onPressed: () {
                                        setState(() {
                                          buttonState = ButtonState.loading;
                                        });
                                        Future.delayed(
                                            Duration(seconds: 1), () {
                                          setState(() {
                                            if (_formKey.currentState
                                                .validate()) {
                                              // print("validated");
                                              currentUser.id =
                                                  auth.currentUser.uid;
                                              currentUser.emailAddress =
                                                  auth.currentUser.email;
                                              currentUser.firstName =
                                                  firstNameController.text;
                                              currentUser.lastName =
                                                  lastNameController.text;
                                              currentUser.age =
                                                  int.parse(ageController.text);
                                              currentUser.sex =
                                                  sexController.text;
                                              // print(currentUser);
                                              FirestoreUtils().updateUserInfo(
                                                  currentUser);
                                              buttonState = ButtonState.success;
                                              if (buttonState ==
                                                  ButtonState.success) {
                                                allCompleted = true;
                                              }
                                            }
                                            else {
                                              buttonState = ButtonState.fail;
                                            }
                                          });
                                        });
                                      },
                                      padding: const EdgeInsets.all(8.0),
                                      progressIndicatorAligment: MainAxisAlignment
                                          .center,
                                      radius: 25.0,
                                      stateWidgets: {
                                        ButtonState.idle: Text(
                                          "Save",
                                          style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: _width / 20
                                          ),
                                        ),
                                        ButtonState.loading: Container(),
                                        ButtonState.fail: Text(
                                          "Submit Failed",
                                          style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        ButtonState.success: FaIcon(
                                          FontAwesomeIcons.check,
                                          color: Colors.white,
                                        )
                                      },
                                      stateColors: {
                                        ButtonState.idle: GlobalColors
                                            .blueColor,
                                        ButtonState.loading: GlobalColors
                                            .blueColor,
                                        ButtonState.fail: GlobalColors
                                            .fireColor,
                                        ButtonState.success: GlobalColors
                                            .greenColor,
                                      },

                                    )
                                ),
                              )
                            ],
                          ),
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

  Widget splashBody(double _width, double _height, BuildContext context) {
    // print(currentUser);
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
    if (authController.sessionUser.value == null) {
        return createProfile(_width, _height, context);
      }
      else {
          return GetX<ShowController>(
            init: showController,
            builder: (controller){
              if (controller.notAired.isNotEmpty) {
                Timer.run(() {
                  setState(() {
                    allCompleted = true;
                  });
                });
                return Center(
                  child: Container(
                    width: _width * .5,
                    height: _height * .75,
                    // color: Colors.black,
                    child: SizedBox(
                      child: Center(
                        child: FlareActor("assets/loadingcouch-white.flr",
                            alignment: Alignment.bottomCenter,
                            fit: BoxFit.contain,
                            animation: "load"),
                      ),
                    ),
                  ),
                );
              }
              else {
                return Center(
                  child: Container(
                    width: _width * .5,
                    height: _height * .75,
                    // color: Colors.black,
                    child: SizedBox(
                      child: Center(
                        child: FlareActor("assets/loadingcouch-white.flr",
                            alignment: Alignment.bottomCenter,
                            fit: BoxFit.contain,
                            animation: "load"),
                      ),
                    ),
                  ),
                );
              }
            },
          );
      }
  }
}