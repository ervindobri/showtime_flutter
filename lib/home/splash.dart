import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/models/episode.dart';
import 'package:eWoke/models/user.dart';
import 'package:eWoke/models/watched.dart';
import 'package:eWoke/network/firebase_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_animations/simple_animations.dart';

import '../main.dart';
import 'home.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AnimationMixin {
  Stream<QuerySnapshot> _watchedShowsStream;
  // Stream<QuerySnapshot> _allWatchedShowsStream;



  StreamSubscription<ConnectivityResult> subscription;
  var connectionStatus;

  Future<List<List<Episode>>> _scheduledEpisodes;
  List<int> watchedShowIdList = [];

  SessionUser currentUser = SessionUser();

  bool allDone = false;
  Future<SessionUser> _currentUserObject;

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

  var notCompleted = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: this,
    )..forward();

    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    );

    //Listen to actve/inactive connection
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        connectionStatus = result;
      });
    });

    _currentUserObject = FirestoreUtils().getUserData();

    if ( allWatchedShows.isEmpty){
      _watchedShowsStream = FirestoreUtils().watchedShows.snapshots();
    }
    sexController.text = sexCategories[0];
    ageController.text = 1.toString();
  }

  @override
  void dispose() {
    // _allWatchedShowsStream = null;
    _watchedShowsStream = null;
    subscription = null;
    _currentUserObject = null;
    super.dispose();

  }

  bool checkInternetConnectivity() {
    if (connectionStatus == ConnectivityResult.none) {
      return false;
    }
    else{
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    checkInternetConnectivity();


    print("splash");
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: bgColor,
      //   shadowColor: Colors.transparent,
      //   brightness: Brightness.light,
      //   toolbarHeight: 0,
      // ),
      body: SingleChildScrollView(
        child: Container(
          color: blueColor,
          child: Stack(
            children: [
              Container(
                width: _width,
                  height: _height,
                  child: SizedBox(
                      width: _width * 0.5,
                      child: FlareActor(
                        'assets/flowingbg.flr',
                        shouldClip: false,
                        callback: (boom){
                          print(boom);
                          setState(() {
                            animationName = 'Flow';
                          });
                        },
                        animation: animationName,
                        fit: BoxFit.cover,
                      ))
              ),
              Column(
                children: [
                  //ANIMATE IN LOGO
                    SlideTransition(
                        position: Tween<Offset>(
                            begin: Offset(1, 0),
                            end: Offset.zero,
                    ).animate(animation),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
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
                  FutureBuilder(
                      future: _currentUserObject,
                      builder: (context, uSnapshot) {
                        if  (uSnapshot.hasData && uSnapshot.data.firstName != null) {
                            currentUser = uSnapshot.data;
                            // setState(() {
                              notCompleted = false;
                            // });
                            print("current user: $currentUser");
                            _watchedShowsStream = FirestoreUtils().watchedShows.orderBy('lastWatched', descending: true).snapshots();
                            return StreamBuilder(
                                stream: _watchedShowsStream,
                                builder: (context, snapshot) {
                                  if ( snapshot.hasData){
                                    watchedShowIdList.clear();
                                    watchedShowList.clear();
                                    // allWatchedShows.clear();
                                    snapshot.data.documents
                                        .forEach((f) {
                                      watchedShowIdList.add(int.parse(f.documentID));
                                      WatchedTVShow show = new WatchedTVShow.fromFirestore(f.data(), f.documentID);
                                      watchedShowList.add(show);
                                      // allWatchedShows.add(show);
                                    });
                                    _scheduledEpisodes = FirestoreUtils().getEpisodeList(watchedShowIdList);
                                    print(watchedShowList.length);
                                  }
                                  return FutureBuilder(
                                      future: _scheduledEpisodes,
                                      builder: (context, snapshot) {
                                        if ( snapshot.hasData){
                                          print("loading scheduled episodes");
                                          // print(snapshot.data);
                                          if ( snapshot.data.length > 0){
                                            for(int index=0 ; index < 5; index++){
                                              scheduledEpisodes.add(snapshot.data[index]);
                                              int notAired = snapshot.data[index].length - 1;
                                              for(int i=0; i< snapshot.data[index].length ; i++){
                                                if ( !snapshot.data[index][i].aired()){
                                                  notAired = i;
                                                  break;
                                                }
                                              }
                                              notAiredList.add(snapshot.data[index][notAired]);
                                            }
                                          }
                                          notAiredList.sort( (a,b) => a.airDate.compareTo(b.airDate));

                                          // print(notAiredList.length);
                                          Timer.run(() {
                                            final home = HomeView(
                                              user: currentUser,
                                              notAiredList: notAiredList,
                                              watchedShowsList: watchedShowList,
                                            );
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(CupertinoPageRoute(
                                              builder: (context) => home,
                                            ),(route) => false);
                                          });
                                        }
                                        return Center(
                                          child: Container(
                                            width: _width*.5,
                                            height: _height*.75,
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
                                  );
                                }
                            );
                        }
                        else{
                          //TODO: create your profile
                          final node = FocusScope.of(context);

                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0, 1),
                              end: Offset.zero,
                            ).animate(animation),
                            child: Center(
                              child: Container(
                                width: _width*.81,
                                height: _height*.7,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: greyTextColor.withOpacity(0.3),
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
                                                    //     backgroundColor: greyTextColor,
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
                                                                color: greyTextColor,
                                                                fontSize: _width/20,
                                                                fontWeight: FontWeight.w300
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                                            child: Container(
                                                              width: _width/3,
                                                              height: _width/6,
                                                              child: TextFormField(
                                                                controller: firstNameController,
                                                                keyboardType: TextInputType.name,
                                                                textCapitalization: TextCapitalization.words,

                                                                autofocus: false,
                                                                validator: (val){
                                                                  if ( val == ""){
                                                                    return "Your first name!";
                                                                  }
                                                                  else{
                                                                    return null;
                                                                  }
                                                                },
                                                                decoration: const InputDecoration(
                                                                  errorStyle: TextStyle(
                                                                      fontFamily: 'Raleway',
                                                                      color: orangeColor
                                                                  ),
                                                                  hintStyle: TextStyle(
                                                                      fontFamily: 'Raleway',
                                                                      color: greyTextColor,
                                                                      fontWeight: FontWeight.w300
                                                                  ),
                                                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                                                  filled: true,
                                                                  fillColor: Colors.white,
                                                                  hintText: 'John',
                                                                  focusColor: greenColor,
                                                                  enabledBorder: const OutlineInputBorder(
                                                                    borderSide:
                                                                    BorderSide(color: blueColor),
                                                                    borderRadius: BorderRadius.all(
                                                                        Radius.circular(50.0)),
                                                                  ),
                                                                  border: const OutlineInputBorder(
                                                                    borderSide:
                                                                    BorderSide(color: blueColor),
                                                                    borderRadius: BorderRadius.all(
                                                                        Radius.circular(50.0)),
                                                                  ),
                                                                  focusedBorder: const OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: greenColor, width: 2),
                                                                    borderRadius: BorderRadius.all(
                                                                        Radius.circular(50.0)),
                                                                  ),
                                                                  errorBorder: const OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: orangeColor, width: 2),
                                                                    borderRadius: BorderRadius.all(
                                                                        Radius.circular(50.0)),
                                                                  ),
                                                                ),
                                                                style: GoogleFonts.roboto(
                                                                    color: greyTextColor,
                                                                    fontSize: _width/20,
                                                                    fontWeight: FontWeight.w500
                                                                ),
                                                                onEditingComplete: () => node.nextFocus(), // Move focus to next

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
                                                                color: greyTextColor,
                                                                fontSize: _width/20,
                                                                fontWeight: FontWeight.w300
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                                            child: Container(
                                                              width: _width/3,
                                                              height: _width/6,
                                                              child: TextFormField(
                                                                controller: lastNameController,
                                                                autofocus: false,
                                                                textCapitalization: TextCapitalization.words,
                                                                validator: (val) {
                                                                  if ( val == ""){
                                                                    return "Your last name!";
                                                                  }
                                                                  else{
                                                                    return null;
                                                                  }
                                                                },
                                                                decoration: const InputDecoration(
                                                                  errorStyle: TextStyle(
                                                                      fontFamily: 'Raleway',
                                                                      color: orangeColor
                                                                  ),
                                                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                                                  filled: true,
                                                                  fillColor: Colors.white,
                                                                  hintText: 'Doe',
                                                                  hintStyle: TextStyle(
                                                                      fontFamily: 'Raleway',
                                                                      color: greyTextColor,
                                                                      fontWeight: FontWeight.w300
                                                                  ),
                                                                  focusColor: greenColor,
                                                                  enabledBorder: const OutlineInputBorder(
                                                                    borderSide:
                                                                    BorderSide(color: blueColor),
                                                                    borderRadius: BorderRadius.all(
                                                                        Radius.circular(50.0)),
                                                                  ),
                                                                  border: const OutlineInputBorder(
                                                                    borderSide:
                                                                    BorderSide(color: blueColor),
                                                                    borderRadius: BorderRadius.all(
                                                                        Radius.circular(50.0)),
                                                                  ),
                                                                  focusedBorder: const OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: greenColor, width: 2),
                                                                    borderRadius: BorderRadius.all(
                                                                        Radius.circular(50.0)),
                                                                  ),
                                                                  errorBorder: const OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: orangeColor, width: 2),
                                                                    borderRadius: BorderRadius.all(
                                                                        Radius.circular(50.0)),
                                                                  ),
                                                                ),
                                                                  style: GoogleFonts.roboto(
                                                                    color: greyTextColor,
                                                                    fontSize: _width/20,
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
                                                                color: greyTextColor,
                                                                fontSize: _width/20,
                                                                fontWeight: FontWeight.w300
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                                            child: Container(
                                                              width: _width/3,
                                                              height: _width/10,
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(50.0)),
                                                                border:  Border.all(
                                                                    color: blueColor
                                                                ),
                                                              ),
                                                              child: CupertinoTheme(
                                                                data: CupertinoThemeData(
                                                                  scaffoldBackgroundColor: Colors.transparent,
                                                                  primaryColor: Colors.transparent,
                                                                  primaryContrastingColor: Colors.transparent,
                                                                  barBackgroundColor: Colors.transparent,
                                                                  textTheme: CupertinoTextThemeData(

                                                                    pickerTextStyle: GoogleFonts.roboto(
                                                                      color: greyTextColor,
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
                                                                  //             color: blueColor,
                                                                  //           )
                                                                  //         ],
                                                                  //       ),
                                                                  //     )
                                                                  // ),
                                                                  itemExtent: 50, onSelectedItemChanged: (int value) {
                                                                  ageController.text = (value+1).toString();
                                                                },
                                                                  children: List.generate(100, (index) =>
                                                                      Center(
                                                                        child: Text(
                                                                            (index+1).toString(),
                                                                            style: GoogleFonts.roboto(
                                                                                color: greyTextColor,
                                                                                fontSize: _width/20,
                                                                                fontWeight: FontWeight.w500
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
                                                                fontSize: _width/20,
                                                                fontWeight: FontWeight.w300,
                                                                color: greyTextColor
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                                            child: Container(
                                                              width: _width/3,
                                                              height: _width/10,

                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(50.0)),
                                                                border:  Border.all(
                                                                    color: blueColor
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
                                                                //           color: blueColor,
                                                                //         )
                                                                //       ],
                                                                //     ),
                                                                //   )
                                                                // ),
                                                                itemExtent: 50, onSelectedItemChanged: (int value) {
                                                                  sexController.text = sexCategories[value];
                                                              },
                                                                children: List.generate(sexCategories.length, (index) =>
                                                                    Align(
                                                                      alignment: Alignment.centerRight,
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(right: 15.0),
                                                                          child: Text(
                                                                              sexCategories[index],
                                                                            style: GoogleFonts.roboto(
                                                                                color: greyTextColor,
                                                                                fontSize: _width/20,
                                                                                fontWeight: FontWeight.w500
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
                                                          maxWidth: _width/3,
                                                          minWidth: _width/3,
                                                          state: buttonState,
                                                          onPressed: (){
                                                              setState(() {
                                                                buttonState = ButtonState.loading;
                                                              });
                                                              Future.delayed(Duration(seconds: 2), () {
                                                                setState(() {
                                                                  if ( _formKey.currentState.validate()){
                                                                    print("validated");
                                                                    currentUser.id = auth.currentUser.uid;
                                                                    currentUser.emailAddress = auth.currentUser.email;
                                                                    currentUser.firstName = firstNameController.text;
                                                                    currentUser.lastName = lastNameController.text;
                                                                    currentUser.age = int.parse(ageController.text);
                                                                    currentUser.sex= sexController.text;
                                                                    print(currentUser);
                                                                    FirestoreUtils().updateUserInfo(currentUser);
                                                                    buttonState = ButtonState.success;
                                                                    if ( buttonState == ButtonState.success){
                                                                      Future.delayed(Duration(seconds: 2),(){
                                                                        final home = HomeView(
                                                                          user: currentUser,
                                                                          notAiredList: notAiredList,
                                                                          watchedShowsList: watchedShowList,
                                                                        );
                                                                        Navigator.of(context)
                                                                            .pushAndRemoveUntil(CupertinoPageRoute(
                                                                          builder: (context) => home,
                                                                        ),(route) => false);
                                                                      });
                                                                    }
                                                                  }
                                                                  else{
                                                                    buttonState = ButtonState.fail;
                                                                  }
                                                                });
                                                              });


                                                          },
                                                          padding: const EdgeInsets.all(8.0),
                                                          progressIndicatorAligment: MainAxisAlignment.center,
                                                          radius: 25.0,
                                                          stateWidgets: {
                                                            ButtonState.idle: Text(
                                                              "Save",
                                                              style: GoogleFonts.roboto(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.w500,
                                                                fontSize: _width/20
                                                              ),
                                                            ),
                                                            ButtonState.loading: Container(),
                                                            ButtonState.fail: Text(
                                                              "Submit Failed",
                                                              style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.w500),
                                                            ),
                                                            ButtonState.success: FaIcon(
                                                              FontAwesomeIcons.check,
                                                              color: Colors.white,
                                                            )
                                                          },
                                                          stateColors: {
                                                            ButtonState.idle: blueColor,
                                                            ButtonState.loading: blueColor,
                                                            ButtonState.fail: fireColor,
                                                            ButtonState.success: greenColor,
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

                      }
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
