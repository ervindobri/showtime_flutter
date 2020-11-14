import 'dart:async';

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
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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


  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(
        backgroundColor: bgColor,
        shadowColor: Colors.transparent,
        brightness: Brightness.light,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: bgColor,
          child: Column(
            children: [
              //ANIMATE IN LOGO
              Padding(
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
              // PROGRESS BAR TO LOAD HOME STUFF
              FutureBuilder(
                  future: _currentUserObject,
                  builder: (context, uSnapshot) {
                    if  (uSnapshot.hasData && uSnapshot.data.firstName != null) {
                        currentUser = uSnapshot.data;
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
                                      print(snapshot.data);
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
                                        height: _height/4,
                                        // color: Colors.black,
                                        child: Center(
                                          child: FlareActor("assets/loadingcouch.flr",
                                              alignment: Alignment.center,
                                              fit: BoxFit.contain,
                                              animation: "load"),
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
                      return Container(
                        width: _width,
                        height: _height*.9,
                        child: Column(
                          children: [
                            Text(
                              "Complete your profile",
                              style: GoogleFonts.roboto(
                                fontSize: 25,
                              ),
                            ),
                            Container(
                              height: _height/2,
                              width: _width,
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
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "First Name",
                                          style: TextStyle(
                                              fontFamily: 'Raleway',
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                              color: greyTextColor
                                          ),
                                        ),
                                        Container(
                                          width: _width/3,
                                          child: TextFormField(
                                            controller: firstNameController,
                                            keyboardType: TextInputType.emailAddress,
                                            autofocus: false,
                                            decoration: const InputDecoration(
                                              errorStyle: TextStyle(
                                                  fontFamily: 'Raleway',
                                                  color: orangeColor
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
                                            style: TextStyle(
                                                fontFamily: 'Raleway',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w100,
                                                color: greyTextColor
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
                                          .spaceAround,
                                      children: [
                                        Text(
                                          "Last Name : ",
                                          style: TextStyle(
                                              fontFamily: 'Raleway',
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: greyTextColor
                                          ),
                                        ),
                                        Container(
                                          width: _width/3,
                                          child: TextFormField(
                                            controller: lastNameController,
                                            autofocus: false,
                                            decoration: const InputDecoration(
                                              errorStyle: TextStyle(
                                                  fontFamily: 'Raleway',
                                                  color: orangeColor
                                              ),
                                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                              filled: true,
                                              fillColor: Colors.white,
                                              hintText: 'johndoe@example.com',
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
                                            style: TextStyle(
                                                fontFamily: 'Raleway',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w100,
                                                color: greyTextColor
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
                                          .spaceAround,

                                      children: [
                                        Text(
                                          "Age : ",
                                          style: TextStyle(
                                              fontFamily: 'Raleway',
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: greyTextColor
                                          ),
                                        ),
                                        Container(
                                          width: _width/3,

                                          child: TextFormField(
                                            controller: ageController,
                                            autofocus: false,
                                            decoration: const InputDecoration(
                                              errorStyle: TextStyle(
                                                  fontFamily: 'Raleway',
                                                  color: orangeColor
                                              ),
                                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                              filled: true,
                                              fillColor: Colors.white,
                                              hintText: 'johndoe@example.com',
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
                                            style: TextStyle(
                                                fontFamily: 'Raleway',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w100,
                                                color: greyTextColor
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
                                          .spaceAround,
                                      children: [
                                        Text(
                                          "Sex: ",
                                          style: TextStyle(
                                              fontFamily: 'Raleway',
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: greyTextColor
                                          ),
                                        ),
                                        Container(
                                          width: _width/3,

                                          child: TextFormField(
                                            controller: sexController,
                                            style: TextStyle(
                                                fontFamily: 'Raleway',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w100,
                                                color: greyTextColor
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
