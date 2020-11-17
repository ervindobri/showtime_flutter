import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eWoke/components/route.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/home/login.dart';
import 'package:eWoke/main.dart';
import 'package:eWoke/models/episode.dart';
import 'package:eWoke/models/user.dart';
import 'package:eWoke/models/watched.dart';
import 'package:eWoke/network/firebase_utils.dart';
import 'package:eWoke/network/network.dart';
import 'package:eWoke/placeholders/schedule_card_placeholder.dart';
import 'package:eWoke/screens/browse_shows.dart';
import 'package:eWoke/screens/full_schedule.dart';
import 'package:eWoke/screens/watched_detail_view.dart';
import 'package:eWoke/screens/discover/discover.dart';
import 'package:eWoke/ui/schedule_card.dart';
import 'package:eWoke/ui/watch_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class HomeView extends StatefulWidget {
  final SessionUser user;
  final List<WatchedTVShow> watchedShowsList;
  final List<Episode> notAiredList;

  const HomeView({Key key, this.user, this.watchedShowsList, this.notAiredList}) : super(key: key);
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {


  PanelState _panelState;
  Widget title =
  Container(color: bgColor, child: Image(image: AssetImage('showTIME.png'), height: 50));
  Widget _customTitle;

  List<Episode> displayScheduledList = [];


  PanelController _pc = new PanelController();




  bool disconnected = true;




  String firstName = "";
  String lastName = "";
  int age = 0;
  String sex = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var watchedShowsStream;

  Future<List<List<Episode>>> _scheduledEpisodes;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _panelState = PanelState.CLOSED;
    // watchedShowList.clear();
    _customTitle = title;
    // allWatchedShows.clear();
    watchedShowsStream = FirestoreUtils().watchedShows.orderBy('lastWatched', descending: true).snapshots();

    // print(widget.notAiredList.length);
    // print("init");
    _scheduledEpisodes = FirestoreUtils().getEpisodeList(watchedShowList.map((e) => int.parse(e.id)).toList());

  }
  @override
  void dispose(){

    _pc = null;
    super.dispose();
  }



  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(50.0),
    topRight: Radius.circular(50.0),
  );

  final double _initFabHeight = 120.0;
  double _panelHeightOpen;


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

    final double _panelHeightClosed = _height/10;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //new line
      key: _drawerKey,
      appBar: new AppBar(
        backgroundColor: bgColor,
        brightness: Brightness.light,
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
                                    "${widget.user.firstName}",
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
                                    "${widget.user.lastName}",
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
                                    "${widget.user.age}",
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
                                    "${widget.user.sex}",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 20, bottom: 10),
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Text(
                                  'Edit',
                                  style: TextStyle(
                                      color: greenColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                            ),
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
                            //TODO: handle clearing and destroying stored data
                            popularShows.clear();
                            limitedShows.clear();

                            await FirebaseAuth.instance.signOut();
                            final login = LoginScreen();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => login,
                                ),(route) => false
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
            child:
            // checkInternetConnectivity()
            // ?
            homeScreenBody(context, _slidingPanelKey)
          //     : Container(
          //   width: _width,
          //   height: _height,
          //
          //   child: FlareActor("assets/no internet.flr",
          //       alignment: Alignment.center,
          //       fit: BoxFit.contain,
          //       animation: "play"),
          // ),
        ),
      ),
    );
  }

  Widget homeScreenBody(BuildContext context, GlobalKey<ScaffoldState> _slidingPanelKey) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    final _panelHeightOpen = _height * .80;
    final _panelHeightClosed = _height/10;
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
                        Center(
                          child: Text(
                            showGreetings(),
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Raleway',
                                fontSize: 22,
                                fontWeight: FontWeight.w700
                            ),
                          ),
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
                                              _width/ 17,
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
                                      createRouteAllShows(AllTVShows()));
                                },
                                child: Container(
                                    child: SizedBox(
                                        width: _width * 0.5,
                                        child: FlareActor(
                                          'assets/blink.flr',
                                          animation: 'Blink',
                                        ))
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
                                          stream:  FirestoreUtils().watchedShows.orderBy('lastWatched', descending: true).snapshots(),
                                          builder: (context, snapshot) {
                                            // print(snapshot.connectionState);
                                            if (snapshot.hasData) {
                                              // print("data");
                                              if ( snapshot.data.documents.length > 0){
                                                watchedShowList.clear();
                                                // allWatchedShows.clear();
                                                snapshot.data.documents
                                                    .forEach((f) {
                                                  // print(f.data);
                                                  // WatchedTVShow show = new WatchedTVShow(
                                                  //     id: f.documentID,
                                                  //     name:
                                                  //     f.data()['name'],
                                                  //     startDate: f.data()[
                                                  //     'start_date'],
                                                  //     runtime: f.data()[
                                                  //     'runtime'],
                                                  //     imageThumbnailPath: f.data()[
                                                  //     'image_thumbnail_path'],
                                                  //     totalSeasons: f.data()[
                                                  //     'total_seasons'],
                                                  //     episodePerSeason: f.data()[
                                                  //     'episodesPerSeason'],
                                                  //     currentSeason: f.data()[
                                                  //     'currentSeason'],
                                                  //     currentEpisode: f.data()[
                                                  //     'currentEpisode'],
                                                  //     firstWatchDate: f.data()[
                                                  //     'startedWatching'],
                                                  //     rating: f.data()['rating'],
                                                  //     lastWatchDate:
                                                  //     f.data()['lastWatched'],
                                                  //     favorite: f.data()['favorite'] ?? false);
                                                  WatchedTVShow show = new WatchedTVShow
                                                      .fromFirestore(
                                                      f.data(), f.documentID);
                                                  watchedShowList.add(show);
                                                  // allWatchedShows.add(show);
                                                });
                                                return createCarouselSlider(
                                                    watchedShowList.take(5)
                                                        .toList(),
                                                    context);
                                              }
                                              else{
                                                return Container(
                                                    height: _height/3,
                                                    child: Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(25.0),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              AutoSizeText(
                                                                "Your watchlist is empty",
                                                                textAlign: TextAlign.center,
                                                                style: GoogleFonts.roboto(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.w700,
                                                                    fontSize: _height/25
                                                                ),
                                                              ),
                                                              AutoSizeText(
                                                                "Press the eye above for magic",
                                                                textAlign: TextAlign.center,
                                                                style: GoogleFonts.roboto(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.w100,
                                                                    fontSize: _height/25
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                    )
                                                );
                                              }

                                            }
                                            else{
                                              // print("no stream");
                                              return Container(
                                                  height: _height/3,
                                                  child: Center(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(25.0),
                                                        child: Text(
                                                          "Press the eye above for magic",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontFamily: 'Raleway',
                                                              fontSize: _height/25
                                                          ),
                                                        ),
                                                      )
                                                  )
                                              );
                                            }
                                          }
                                      )
                                  ),
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
          child: WatchedCard(show: data[itemIndex],
          ),
        ),
        options: CarouselOptions(
          height: MediaQuery.of(context).size.width * .7,
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
                    spreadRadius: -1,
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
                        size: _width/12,
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
    // final _allWatchedShowsStream = FirebaseFirestore.instance
    //     .collection("${auth.currentUser.email}/shows/watched_shows")
    //     .orderBy('lastWatched', descending: true)
    //     .snapshots();
    //TODO: fix false empty schedule
    return Container(
      width: _width,
      height: _height * .41,
      // color: blueColor,
      color: bgColor,
      child: FutureBuilder(
        future: _scheduledEpisodes,
        builder: (context, snapshot) {
          // print(snapshot.connectionState);
          if ( snapshot.hasData){
            // print("data");
            if ( snapshot.data.length > 0){
              displayScheduledList.clear();
              for(int index=0 ; index < min(snapshot.data.length, 5); index++){
                scheduledEpisodes.add(snapshot.data[index]);
                //Calculate episode which is not aired yet to display it
                int notAired = snapshot.data[index].length - 1;
                for(int i=0; i< snapshot.data[index].length ; i++){
                  if ( !snapshot.data[index][i].aired()){
                    notAired = i;
                    break;
                  }
                }
                displayScheduledList.add(snapshot.data[index][notAired]);
              }
              displayScheduledList.sort( (a,b) => a.airDate.compareTo(b.airDate));

              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: min(5,displayScheduledList.length),
                  itemBuilder: (context, int index) {
                    return Center(
                        child: ScheduleCard(
                            episode: displayScheduledList[index])
                    );
                  }
              );
            }
            else{
              return Container(
                  child: SizedBox(
                      width: _width*.6,
                      height: _height*.35,
                      child: FlareActor(
                        "assets/empty.flr",
                        animation: 'Idle',
                      )
                  )
              );
            }
            // print(notAiredList.length);
          }
          else{
            // print("no data");
            if ( widget.notAiredList.length > 0){
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, int index) {
                    return Center(
                        child: ScheduleCard(
                            episode: widget.notAiredList[index])
                    );
                  }
              );
            }
            else{
              return Container(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(greenColor),
                  ),
                ),
              );
            }

          }

        }
      ),
    );
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

  //SEARCH FOR SHOWS





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
    // print(firstName);
    return greetings + ", ${widget.user.firstName}!";
  }



// String getWelcomeMessage(FirebaseAuth auth) async{
//   //get first name
//   Stream<DocumentSnapshot> userData = await FirebaseFirestore.instance.collection(auth.currentUser.email).doc("user").snapshots();
//   print(userData);
// }
}
