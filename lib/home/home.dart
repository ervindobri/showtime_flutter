import 'dart:async';
import 'dart:ui';
import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/home/login.dart';
import 'package:eWoke/main.dart';
import 'package:eWoke/models/episode.dart';
import 'package:eWoke/models/user.dart';
import 'package:eWoke/models/watched.dart';
import 'package:eWoke/network/network.dart';
import 'package:eWoke/placeholders/schedule_card_placeholder.dart';
import 'package:eWoke/screens/browse_shows.dart';
import 'package:eWoke/screens/full_schedule.dart';
import 'package:eWoke/screens/watched_detail_view.dart';
import 'file:///C:/Users/Winter/IdeaProjects/eWoke/lib/screens/discover/discover.dart';
import 'package:eWoke/ui/schedule_card.dart';
import 'package:eWoke/ui/watch_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  Stream<QuerySnapshot> _watchedShowsStream;
  Stream<QuerySnapshot> _allWatchedShowsStream;

  PanelState _panelState;
  Widget title =
      Container(color: bgColor, child: Image(image: AssetImage('showTIME.png'), height: 50));
  Widget _customTitle;



  PanelController _pc = new PanelController();
  AnimationController animationController;
  Animation<double> animation;

  StreamSubscription<ConnectivityResult> subscription;
  var connectionStatus;

  Future<List<List<Episode>>> _scheduledEpisodes;
  List<int> watchedShowIdList = new List<int>();

  bool disconnected = true;



  Future<SessionUser> _currentUserObject;
  SessionUser currentUser = SessionUser();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _panelState = PanelState.CLOSED;
    watchedShowList.clear();
    _customTitle = title;
    allWatchedShows.clear();

    //Listen to actve/inactive connection
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        connectionStatus = result;
      });
    });

    // getUserRoleWithFuture();
    _currentUserObject = getUserData();
    getUserData().then((value) => currentUser = value);

    _allWatchedShowsStream = FirebaseFirestore.instance
        .collection("${auth.currentUser.email}/shows/watched_shows")
        .orderBy('lastWatched', descending: true)
        .snapshots();

    print(_allWatchedShowsStream);
  }

  bool checkInternetConnectivity() {
    if (connectionStatus == ConnectivityResult.none) {
        return false;
    }
    else{
      return true;
    }
  }

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(50.0),
    topRight: Radius.circular(50.0),
  );

  final double _initFabHeight = 120.0;
  double _panelHeightOpen;
  double _panelHeightClosed = 50.0;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();
    final GlobalKey<ScaffoldState> _slidingPanelKey =
    new GlobalKey<ScaffoldState>();
    double _width = MediaQuery
        .of(context)
        .size
        .width;
    double _height = MediaQuery
        .of(context)
        .size
        .height;
    _panelHeightOpen = MediaQuery
        .of(context)
        .size
        .height * .80;
    checkInternetConnectivity();


    return Scaffold(
      resizeToAvoidBottomInset: false,
      //new line
      key: _drawerKey,
      appBar: new AppBar(
        backgroundColor: bgColor,
        centerTitle: true,
        shadowColor: Colors.grey,
        elevation: 0.0,
        //TODO: DONE change title to logo later
        title: _customTitle,
        leading: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: InkWell(
              onTap: () async {
                showAnimatedDialog(
                  context: context,
                  animationType: DialogTransitionType.slideFromLeftFade,
                  barrierDismissible: true,
                  duration: Duration(milliseconds: 100),
                  builder: (BuildContext context) {
                    return CustomDialogWidget(
                      backgroundColor: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      title: Center(
                        child: Text(
                          'Profile',
                        ),
                      ),
                      titleTextStyle: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: greyTextColor
                      ),
                      titlePadding: EdgeInsets.only(
                          top: 5.0,
                          // bottom: 10.0,
                          left: 25.0,
                          right: 25.0
                      ),
                      //TODO content add rive animation
                      content: Container(
                        height: 260,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: greyTextColor,
                                minRadius: 40,
                                maxRadius: 40,
                                backgroundImage: AssetImage(
                                    "assets/showtime-avatar.png"
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceAround,

                                children: [
                                  Text(
                                    "First Name : ",
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: greyTextColor
                                    ),
                                  ),
                                  Text(
                                    "${currentUser.firstName}",
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w100,
                                        color: greyTextColor
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
                                  Text(
                                    "${currentUser.lastName}",
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w100,
                                        color: greyTextColor
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
                                  Text(
                                    "${currentUser.age}",
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w100,
                                        color: greyTextColor
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
                                    "Sex : ",
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: greyTextColor
                                    ),
                                  ),
                                  Text(
                                    "${currentUser.sex}",
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w100,
                                        color: greyTextColor
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      elevation: 5,
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10, bottom: 10),
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'Close',
                              style: TextStyle(
                                  color: greenColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                // color: CupertinoColors.black,
                width: 100,
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.userCircle,
                    color: greenColor,
                    // size: 40,
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () async {
              showAnimatedDialog(
                context: context,
                animationType: DialogTransitionType.slideFromTopFade,
                barrierDismissible: true,
                duration: Duration(milliseconds: 100),
                builder: (BuildContext context) {
                  return CustomDialogWidget(
                    backgroundColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    title: Center(
                      child: Text(
                        'Are you sure you want to sign out?',
                      ),
                    ),
                    titleTextStyle: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: greyTextColor
                    ),
                    titlePadding: EdgeInsets.only(
                        top: 5.0,
                        bottom: 25.0,
                        left: 25.0,
                        right: 25.0
                    ),
                    //TODO content add rive animation
                    content: Text(
                      "You will be redirected to the login screen.",
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 15,
                          fontWeight: FontWeight.w100,
                          color: greyTextColor
                      ),
                    ),
                    elevation: 5,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10, bottom: 10),
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Close',
                            style: TextStyle(
                                color: greenColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w300
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 25.0, bottom: 10),
                        child: InkWell(
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                )
                            );
                          },
                          child: Text(
                            'Sign Out',
                            style: TextStyle(
                                color: greenColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w900
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              );
            },
            child: Container(
              // color: CupertinoColors.black,
              width: 100,
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.signOutAlt,
                  color: greenColor,
                ),
              ),
            ),
          ),

        ],
      ),
      backgroundColor: bgColor,
      body: Container(
        color: greenColor,
        child: SafeArea(
          child: checkInternetConnectivity()
              ? homeScreenBody(context, _slidingPanelKey)
              : Container(
            width: _width,
            height: _height,

            child: FlareActor("assets/no internet.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "play"),
          ),
        ),
      ),
    );
  }

  Widget homeScreenBody(BuildContext context, GlobalKey<ScaffoldState> _slidingPanelKey) {
      if ( auth != null){
        _watchedShowsStream = FirebaseFirestore.instance
            .collection("${auth.currentUser.email}/shows/watched_shows")
            .orderBy('lastWatched', descending: true)
            .snapshots();
      }
      double _width = MediaQuery.of(context).size.width;
      double _height = MediaQuery.of(context).size.height;
      _panelHeightOpen = MediaQuery.of(context).size.height * .80;

      return Center(
        child: Stack(
                children: <Widget>[
                  Container(
                    width: _width,
                    height: _height,
                    color: bgColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Shimmer.fromColors(
                                  highlightColor: greenColor,
                                  baseColor: blueColor,
                                  direction: ShimmerDirection.ltr,
                                  period: const Duration(seconds: 10),
                                  child: Container(
                                    height: _height * 0.07,
                                    width: _width*.8,

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            greenColor,
                                            blueColor,
                                          ]),
                                    ),
                                  ),
                                ),
                                FutureBuilder(
                                    future: _currentUserObject,
                                  builder: (context, snapshot) {
                                      if  (snapshot.hasData){
                                        return Center(
                                          child: Text(
                                            showGreetings(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Raleway',
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700
                                            ),
                                          ),
                                        );
                                      }
                                      else{
                                        return Container(
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation(Colors.white),
                                            ),
                                          ),
                                        );
                                      }
                                  }
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
  //                    color: Colors.redAccent,
                            height: _height * .25,
                            color: bgColor,
                            width: _width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                  child: Text("Discover",
                                      style: TextStyle(
                                        fontSize: _height / 30,
                                        color: greyTextColor,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.w900,
                                      )),
                                ),
                                Container(
                                  width: _width,
                                  height: _height * .21,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: DISCOVER_DATA.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, int index) {
                                        return createColorfulCard(
                                            index, DISCOVER_DATA[index]);
                                      }),
                                )
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
  //                    color: Colors.redAccent,
  //                     height: _height * .42,
                            width: _width,
                            color: bgColor,
                            // color: Colors.black,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Schedule",
                                          style: TextStyle(
                                            fontSize: _height / 30,
                                            color: greyTextColor,
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.w900,
                                          )
                                      ),
                                      InkWell(
                                        onTap: () => Navigator.of(context)
                                            .push(CupertinoPageRoute(builder: (builder) => FullSchedule())),
                                        child: Container(
                                          width: 70,
                                          height: 30,
                                          child: Center(
                                            child: Text("All",
                                                style: TextStyle(
                                                  fontSize: _height / 35,
                                                  color: greenColor,
                                                  fontFamily: 'Raleway',
                                                  fontWeight: FontWeight.w500,
                                                )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildScheduledShowView(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SlidingUpPanel(
                    controller: _pc,
                    maxHeight: _panelHeightOpen,
                    minHeight: _panelHeightClosed,
                    key: _slidingPanelKey,
                    defaultPanelState: _panelState,
                    boxShadow: [
                      BoxShadow(
                        color: greenColor.withOpacity(0.15),
                        spreadRadius: 10,
                        blurRadius: 25,
                        offset: Offset(0, -10), // changes position of shadow
                      ),
                    ],
                    panelSnapping: true,
                    collapsed: Center(
                      child: Container(
                        height: _height * 0.8,
                        width: _width,
                        decoration: BoxDecoration(
                          borderRadius: radius,
                          color: greenColor,
                        ),
                        child: Shimmer.fromColors(
                          period: const Duration(milliseconds: 3500),
                          baseColor: Colors.white54,
                          highlightColor: Colors.white,
                          child: Container(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: _width*.3,
                                  height: 6,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(25.0))
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    panel: Center(
                      child: Container(
                        height: _height * 0.8,
                        width: _width,
                        decoration: BoxDecoration(
                          borderRadius: radius,
                          gradient: LinearGradient(
                              stops: [0.6, 5.0],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                greenColor,
                                blueColor,
                              ]),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: Center(
                                          child: Shimmer.fromColors(
                                            period: const Duration(milliseconds: 3500),
                                            baseColor: Colors.white54,
                                            highlightColor: Colors.white,
                                            child: AnimatedSizeAndFade(
                                              vsync: this,
                                              child: Container(
                                                height: 30,
                                                child: Text(
                                                    "What are we watching today?",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      shadows: <Shadow>[
                                                        Shadow(
                                                          offset: Offset(0.0, 3.0),
                                                          blurRadius: 6.0,
                                                          color: Colors.black.withOpacity(.2),
                                                        ),
                                                      ],
                                                      color: Colors.white,
                                                      fontSize:
                                                      MediaQuery.of(context).size.width /
                                                          20,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Raleway',
                                                    )),
                                              ),
                                              fadeDuration: const Duration(milliseconds: 100),
                                              sizeDuration: const Duration(milliseconds: 200),
                                            ),
                                          )

                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: _height / 30,
                                  ),
                                  Container(
                                    width: _width * 0.5,
                                    height: _width * 0.3,
                                    child: Center(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              _createRouteAllShows(AllTVShows()));
                                        },
                                        child: Container(
                                            child: SizedBox(
                                                width: _width * 0.5,
                                                child: FlareActor(
                                                  'assets/blink.flr',
                                                  animation: 'Blink',
                                                ))
                                          // child: FaIcon(
                                          //   Icons.add_to_queue,
                                          //   color: greenColor,
                                          //   size: MediaQuery
                                          //       .of(context)
                                          //       .size
                                          //       .width * 0.2,
                                          // ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: _width / 10,
                                  ),
                                  Container(
  //                          color: Colors.red,
                                    child: Column(
                                      children: <Widget>[
                                        //Label - LAst watched
                                        Container(
                                          padding:
                                          EdgeInsets.only(left: 32, right: 32),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("Last watched",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      shadows: <Shadow>[
                                                        Shadow(
                                                          offset: Offset(0.0, 3.0),
                                                          blurRadius: 6.0,
                                                          color: Colors.black
                                                              .withOpacity(.2),
                                                        ),
                                                      ],
                                                      color: Colors.white,
                                                      fontSize: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                          30,
                                                      fontFamily: "Raleway",
                                                      fontWeight: FontWeight.w900,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Horizontal scrollview container
                                        Container(
                                          child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: StreamBuilder(
                                                  stream: _watchedShowsStream,
                                                  builder: (context, snapshot) {
                                                    List<Widget> children;
                                                    if (snapshot.hasError) {
                                                      children = <Widget>[
                                                        Icon(
                                                          Icons.error_outline,
                                                          color: Colors.white,
                                                          size: 60,
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.only(
                                                              top: 16),
                                                          child: Text(
                                                              'Error: ${snapshot.error}'),
                                                        )
                                                      ];
                                                    } else {
                                                      switch (
                                                      snapshot.connectionState) {
                                                        case ConnectionState.waiting:
  //                                                    print("waiting");
  //                                                    children = <Widget>[ createCarouselSlider(watchedShowList, context) ];
                                                          children = <Widget>[
                                                            Container(
                                                              height: MediaQuery.of(
                                                                  context)
                                                                  .size
                                                                  .height *
                                                                  0.4,
                                                              child: Center(
                                                                child: Theme(
                                                                  data: Theme.of(
                                                                      context)
                                                                      .copyWith(
                                                                      accentColor:
                                                                      Colors
                                                                          .white),
                                                                  child:
                                                                  CircularProgressIndicator(
                                                                    strokeWidth: 6.5,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ];
                                                          break;
                                                        default:
                                                          watchedShowList.clear();
                                                          allWatchedShows.clear();
                                                          snapshot.data.documents
                                                              .forEach((f) {
                                                            // print(f.data);
                                                            WatchedTVShow show = new WatchedTVShow(
                                                                id: f.documentID,
                                                                name:
                                                                f.data()['name'],
                                                                startDate: f.data()[
                                                                'start_date'],
                                                                runtime: f.data()[
                                                                'runtime'],
                                                                imageThumbnailPath: f.data()[
                                                                'image_thumbnail_path'],
                                                                totalSeasons: f.data()[
                                                                'total_seasons'],
                                                                episodePerSeason: f.data()[
                                                                'episodesPerSeason'],
                                                                currentSeason: f.data()[
                                                                'currentSeason'],
                                                                currentEpisode: f.data()[
                                                                'currentEpisode'],
                                                                firstWatchDate: f.data()[
                                                                'startedWatching'],
                                                                rating: f.data()['rating'],
                                                                lastWatchDate:
                                                                f.data()['lastWatched'],
                                                                favorite: f.data()['favorite'] ?? false);
                                                            watchedShowList.add(show);
                                                            allWatchedShows.add(show);
                                                          });
                                                          children = <Widget>[
                                                            createCarouselSlider(
                                                                watchedShowList.take(5).toList(),
                                                                context)
                                                          ];
                                                          break;
                                                      }
                                                    }
                                                    return Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                      children: children,
                                                    );
                                                  })),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    borderRadius: radius,
                  ),
                ],
                ),
              );
  }

  Widget createCarouselSlider(List<WatchedTVShow> data, BuildContext context) {
    return Center(
      child: CarouselSlider.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int itemIndex) => InkWell(
          onTap: () {
            showModalBottomSheet<dynamic>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0)),
                ),
                context: context,
                builder: (BuildContext context) {
                  return _createRouteShowDetail(data,itemIndex);
                },
                isScrollControlled: true);
            // Navigator.push(context, _createRouteShowDetail(data, itemIndex)),

          },
          child: Dismissible(
            key: Key('some key here'),
            direction: DismissDirection.down,
            onDismissed: (_) => Navigator.pop(context),
            child: WatchedCard(show: data[itemIndex],
            ),
          ),
        ),
        options: CarouselOptions(
          height: MediaQuery.of(context).size.width * .65,
          enableInfiniteScroll: false,
        ),
      ),
    );
  }

  Widget createColorfulCard(int index, List<dynamic> data) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Padding(
      padding: index != DISCOVER_DATA.length - 1
          ? const EdgeInsets.only(left: 25.0)
          : const EdgeInsets.symmetric(horizontal: 25.0),
      child: InkWell(
        onTap: () => Navigator.push(context, SecondPageRoute(list: data)),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: _height / 4.5,
            height: _height * .18,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    new Color(data[1]),
                    new Color(data[2]),
                  ]),
              borderRadius: const BorderRadius.all(Radius.circular(25.0)),
              boxShadow: [
                new BoxShadow(
                    color: new Color(data[1]).withOpacity(.3),
                    blurRadius: 5.0,
                    spreadRadius: 1,
                    offset: Offset(0, 3)),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      // color: Colors.black,
                      height: 10,
                      child: FaIcon(
                        data[3],
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      data[0],
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        shadows: [new BoxShadow(
                          color: Colors.black.withOpacity(.15),
                          spreadRadius: 1.2,
                          blurRadius: 5,
                          offset: Offset(0,3.0)
                        )],
                        color: Colors.white,
                        fontSize: _width / 25,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScheduledShowView() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    if ( _allWatchedShowsStream == null){
      _allWatchedShowsStream = FirebaseFirestore.instance
          .collection("${auth.currentUser.email}/shows/watched_shows")
          .orderBy('lastWatched', descending: true)
          .snapshots();
    }


    return Container(
      width: _width,
      height: _height * .41,
      // color: blueColor,
      color: bgColor,

      child: watchedShowIdList.length == 0
          ? StreamBuilder(
              stream: _allWatchedShowsStream,
              builder: (context, snapshot) {
                watchedShowIdList.clear();
                if (snapshot.hasData) {
                  // print("data");
                  snapshot.data.documents.forEach((f) {
                    watchedShowIdList.add(int.parse(f.documentID));
                  });
                  _scheduledEpisodes = getEpisodeList(watchedShowIdList);

                  return Center(
                    child: FutureBuilder(
                      future: _scheduledEpisodes,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        print("building scheduled view");
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Container(
                              // height: MediaQuery.of(context).size.height * 0.4,
                              child: Shimmer.fromColors(
                                loop: 1,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 2,
                                    itemBuilder: (_, index) =>
                                        ScheduleCardPlaceholder()),
                                baseColor: Colors.grey[300],
                                highlightColor: Colors.white,
                              ),
                            );
                          default:
                            if (snapshot.hasError)
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: Center(
                                  child: Text(
                                    "Please ensure you have an active internet connection",
                                    textAlign: TextAlign.center,

                                  ),
                                ),
                              );
                            else
                              print("building list${snapshot.data.length}" );

                              return snapshot.data.length == 0
                                  ? Container(
                                  width: _width*.8,
                                  child: SizedBox(
                                      child: FlareActor(
                                          "assets/empty.flr",
                                        animation: "Idle",
                                      )
                                  )
                              ) : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.length < 5
                                      ? snapshot.data.length
                                      : 5,
                                  itemBuilder: (context, int index) {
                                    scheduledEpisodes.add(snapshot.data[index]);
                                    return Center(
                                        child: ScheduleCard(
                                            episode: snapshot.data[index][0]));
                                  });

                            return Text('Result: ${snapshot.data}');
                        }
                      },
                    ),
                  );

                } else {
                  print("no scheduled view");
                  _allWatchedShowsStream = FirebaseFirestore.instance
                      .collection("${auth.currentUser.email}/shows/watched_shows")
                      .orderBy('lastWatched', descending: true)
                      .snapshots();
                  print(_allWatchedShowsStream.length.then((value) => value));
                  return Container(
                    child: SizedBox(
                      child: FlareActor(
                        "assets/empty.flr"
                      )
                    )
                  );
                }
              })
          : Center(
              child: FutureBuilder(
                future: _scheduledEpisodes,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Shimmer.fromColors(
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (_, index) =>
                                  ScheduleCardPlaceholder()),
                          baseColor: Colors.grey[100],
                          highlightColor: Colors.grey[300],
                        ),
                      );
                    default:
                        scheduledEpisodes.clear();
                        snapshot.data.forEach((list) {
                            scheduledEpisodes.add(list);
                        });
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, int index) {
//                            print(snapshot.data[index]);

                            return Center(
                                child: ScheduleCard(
                                    episode: snapshot.data[index][0]));
                          });
                      return Text('Result: ${snapshot.data}');
                  }
                },
              ),
            ),
    );
  }

  Future<List<List<Episode>>> getEpisodeList(List<int> watchedShowIdList) async {
      EpisodeList episodes = await Network().getScheduledEpisodes();
      List<List<Episode>> list = [];

    watchedShowIdList.forEach((id) {
      List<Episode> current = new List<Episode>();
      episodes.episodes.forEach((episode) {
        if (episode.embedded['show']['id'] == id) {
          current.add(episode);
        }
      });
      if (current.length > 0) {
        list.add(current);
      }
    });

    //Sort by airdate instead id
    list.sort((a, b) => a[0].airDate.compareTo(b[0].airDate));
    print("Scheduled shows:${list.length}");
    return list;
  }

  Widget _createRouteShowDetail(List<WatchedTVShow> data, int index) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    Future<List<dynamic>> episodes = new Network().getEpisodes(showID: data[index].id);
    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
      child: FutureBuilder<Object>(
              future: episodes,
              builder: (context, snapshot) {
                if ( snapshot.hasData){
                  data[index].episodes = snapshot.data;
                  return WatchedDetailView(show: data[index]);
                }
                else{
                  return Container(
                    width: _width,
                    height: _height*.95,
                    color: bgColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: _width,
                          // color: Colors.black,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(greenColor),
                              // backgroundColor: greenColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
            }),
    );
  }

  Route _createRouteAllShows(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          SharedAxisTransition(
              animation: animation,
              transitionType: SharedAxisTransitionType.vertical,
              secondaryAnimation: secondaryAnimation,
              child: child),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.fastOutSlowIn;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }


  Future<SessionUser> getUserData() async {
    String currID = auth.currentUser.email;
    print(currID);
    SessionUser user = SessionUser();
    var snapshots = FirebaseFirestore.instance
        .doc("$currID/user")
        .snapshots();
    snapshots.forEach((element) {
      if ( element.exists){
        // print(element.data());
        // print(auth.currentUser.uid);
        user.id = auth.currentUser.uid;
        user.emailAddress = currID;
        user.firstName = element.data()['firstName'];
        user.lastName = element.data()['lastName'];
        user.sex = element.data()['sex'];
        user.age = element.data()['age'];
        // var sessionUser = user = SessionUser.fromSnapshot(element.data());
        // user = SessionUser(emailAddress: auth.currentUser.email,firstName: element.data()['firstName'],lastName: element.data()['lastName'], sex: element.data()['sex'] ,age: element.data()['age']);
        return user;
      }
    });

    return user;

  }

  String showGreetings() {
    var timeNow = DateTime.now().hour;
    String greetings =  "";
    if (timeNow <= 12) {
      greetings =  'Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      greetings =  'Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      greetings =  'Good Evening';
    } else {
      greetings =  'Good Night';
    }
    return greetings + ", ${currentUser.firstName}!";
  }



  // String getWelcomeMessage(FirebaseAuth auth) async{
  //   //get first name
  //   Stream<DocumentSnapshot> userData = await FirebaseFirestore.instance.collection(auth.currentUser.email).doc("user").snapshots();
  //   print(userData);
  // }
}
