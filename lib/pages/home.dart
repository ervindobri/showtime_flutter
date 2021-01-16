import 'dart:async';
import 'dart:ui';
import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eWoke/components/route.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/database/user_data_dao.dart';
import 'package:eWoke/home/login.dart';
import 'package:eWoke/models/user.dart';
import 'package:eWoke/models/watched.dart';
import 'package:eWoke/network/firebase_utils.dart';
import 'package:eWoke/network/network.dart';
import 'package:eWoke/providers/show_provider.dart';
import 'package:eWoke/providers/user_provider.dart';
import 'package:eWoke/screens/browse_shows.dart';
import 'package:eWoke/screens/full_schedule.dart';
import 'package:eWoke/screens/watched_detail_view.dart';
import 'package:eWoke/screens/discover/discover.dart';
import 'package:eWoke/ui/schedule_card.dart';
import 'package:eWoke/ui/watch_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class HomeView extends StatefulWidget {
  final SessionUser user;
  final List<WatchedTVShow> watchedShowsList;
  final UserDao dao;

  const HomeView({Key key, this.user, this.watchedShowsList, this.dao})
      : super(key: key);
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  PanelState _panelState;
  Widget title = Container(
      color: GlobalColors.bgColor,
      child: Image(image: AssetImage('showTIME.png'), height: 50));
  Widget _customTitle;
  PanelController _pc = new PanelController();
  ShowProvider showProvider;

  @override
  void initState() {
    super.initState();
    _panelState = PanelState.OPEN;
    _customTitle = title;
    print("homeinit!");
  }

  @override
  void dispose() {
    _pc = null;
    super.dispose();
  }

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(50.0),
    topRight: Radius.circular(50.0),
  );

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();
    final GlobalKey<ScaffoldState> _slidingPanelKey =
    new GlobalKey<ScaffoldState>();
    // double _height = MediaQuery
    //     .of(context)
    //     .size
    //     .height;

    showProvider = Provider.of<ShowProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //new line
      key: _drawerKey,
      appBar: new AppBar(
        backgroundColor: GlobalColors.bgColor,
        brightness: Brightness.light,
        centerTitle: true,
        shadowColor: Colors.grey,
        elevation: 0.0,
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
                          color: GlobalColors.greyTextColor),
                      titlePadding: EdgeInsets.only(
                          top: 5.0,
                          // bottom: 10.0,
                          left: 25.0,
                          right: 25.0),
                      content: Container(
                        height: 260,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: GlobalColors.greyTextColor,
                                minRadius: 40,
                                maxRadius: 40,
                                backgroundImage:
                                AssetImage("assets/showtime-avatar.png"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "First Name : ",
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: GlobalColors.greyTextColor),
                                  ),
                                  Text(
                                    "${widget.user.firstName}",
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w100,
                                        color: GlobalColors.greyTextColor),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Last Name : ",
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: GlobalColors.greyTextColor),
                                  ),
                                  Text(
                                    "${widget.user.lastName}",
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w100,
                                        color: GlobalColors.greyTextColor),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Age : ",
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: GlobalColors.greyTextColor),
                                  ),
                                  Text(
                                    "${widget.user.age}",
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w100,
                                        color: GlobalColors.greyTextColor),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Sex : ",
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: GlobalColors.greyTextColor),
                                  ),
                                  Text(
                                    "${widget.user.sex}",
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w100,
                                        color: GlobalColors.greyTextColor),
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
                              padding:
                              const EdgeInsets.only(right: 20, bottom: 10),
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Text(
                                  'Edit',
                                  style: TextStyle(
                                      color: GlobalColors.greenColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(right: 10, bottom: 10),
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Text(
                                  'Close',
                                  style: TextStyle(
                                      color: GlobalColors.greenColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300),
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
                    color: GlobalColors.greenColor,
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
                        color: GlobalColors.greyTextColor),
                    titlePadding: EdgeInsets.only(
                        top: 5.0, bottom: 25.0, left: 25.0, right: 25.0),
                    //TODO content add rive animation
                    content: AutoSizeText(
                      "You will be redirected to the login screen.",
                      maxLines: 2,
                      minFontSize: 10,
                      maxFontSize: 20,
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          // fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: GlobalColors.greyTextColor),
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
                                color: GlobalColors.greenColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 25.0, bottom: 10),
                        child: InkWell(
                          onTap: () async {
                            GlobalVariables.clearAll();
                            // await authService.signOut();
                            await context.read<UserProvider>().signOut();
                            await context.read<UserProvider>().signOutGoogle();

                            final login = LoginScreen(dao: widget.dao);

                            Navigator.pop(context);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => login,
                                ),
                                    (route) => false);
                          },
                          child: Text(
                            'Sign Out',
                            style: TextStyle(
                                color: GlobalColors.greenColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w900),
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
                  color: GlobalColors.greenColor,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: GlobalColors.bgColor,
      body: Container(
        color: GlobalColors.greenColor,
        child: SafeArea(
            child: homeScreenBody(context, _slidingPanelKey)
        ),
      ),
    );
  }

    Widget homeScreenBody(BuildContext context,
      GlobalKey<ScaffoldState> _slidingPanelKey) {
    final double _width = MediaQuery
        .of(context)
        .size
        .width;
    final double _height = MediaQuery
        .of(context)
        .size
        .height;
    final _panelHeightOpen = _height * .80;
    final _panelHeightClosed = _height / 10;
    return Center(
      child: Stack(
        children: <Widget>[
          Container(
            width: _width,
            height: _height,
            color: GlobalColors.bgColor,
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
                          highlightColor: GlobalColors.greenColor,
                          baseColor: GlobalColors.blueColor,
                          direction: ShimmerDirection.ltr,
                          period: const Duration(seconds: 10),
                          child: Container(
                            height: _height * 0.07,
                            width: _width * .8,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(25.0)),
                              gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    GlobalColors.greenColor,
                                    GlobalColors.blueColor,
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
                                fontWeight: FontWeight.w700),
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
                    color: GlobalColors.bgColor,
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
                                color: GlobalColors.greyTextColor,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w900,
                              )),
                        ),
                        Container(
                          width: _width,
                          height: _height * .21,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: GlobalVariables.DISCOVER_DATA.length,
                              shrinkWrap: true,
                              itemBuilder: (context, int index) {
                                return createColorfulCard(index,
                                    GlobalVariables.DISCOVER_DATA[index]);
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
                    color: GlobalColors.bgColor,
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
                                    color: GlobalColors.greyTextColor,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w900,
                                  )),
                              InkWell(
                                onTap: () =>
                                    Navigator.of(context).push(
                                        CupertinoPageRoute(
                                            builder: (builder) =>
                                                FullSchedule())),
                                child: Container(
                                  width: 70,
                                  height: 30,
                                  child: Center(
                                    child: Text("All",
                                        style: TextStyle(
                                          fontSize: _height / 35,
                                          color: GlobalColors.greenColor,
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
                color: GlobalColors.greenColor.withOpacity(0.15),
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
                  color: GlobalColors.greenColor,
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
                          width: _width * .3,
                          height: 6,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(25.0))),
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
                        GlobalColors.greenColor,
                        GlobalColors.blueColor,
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
                              padding:
                              const EdgeInsets.symmetric(horizontal: 25.0),
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
                                                  color:
                                                  Colors.black.withOpacity(.2),
                                                ),
                                              ],
                                              color: Colors.white,
                                              fontSize: _width / 17,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Raleway',
                                            )),
                                      ),
                                      fadeDuration:
                                      const Duration(milliseconds: 100),
                                      sizeDuration:
                                      const Duration(milliseconds: 200),
                                    ),
                                  )),
                            ),
                          ),
                          OpenContainer(
                            closedElevation: 20,
                            closedColor: Colors.transparent,
                            closedShape: CircleBorder(),
                            // transitionDuration: Duration(seconds: 1),
                            closedBuilder: (BuildContext context, void Function() action) {
                              return Container(
                                width: _width * 0.5,
                                height: _width * 0.25,
                                child: Center(
                                  child: Container(
                                      width: _width * 0.6,
                                      height: _width * 0.25,
                                      color: Colors.white,
                                      child: FlareActor(
                                        'assets/blink.flr',
                                        animation: 'Blink',
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              );
                            },
                            openBuilder: (BuildContext context, void Function({Object returnValue}) action) {
                              return AllTVShows();
                            },
                            transitionType: ContainerTransitionType.fade,

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
                                  padding: EdgeInsets.only(left: 32, right: 32),
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
                                              fontSize: MediaQuery
                                                  .of(context)
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
                                          stream: FirestoreUtils()
                                              .watchedShows
                                              .orderBy('lastWatched',
                                              descending: true)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            // print(snapshot.connectionState);
                                            if (snapshot.hasData) {
                                              // print("data");
                                              if (snapshot
                                                  .data.documents.length >
                                                  0) {
                                                GlobalVariables.watchedShowList
                                                    .clear();
                                                // allWatchedShows.clear();
                                                snapshot.data.documents
                                                    .forEach((f) {
                                                  WatchedTVShow show =
                                                  new WatchedTVShow
                                                      .fromFirestore(
                                                      f.data(),
                                                      f.documentID);
                                                  GlobalVariables
                                                      .watchedShowList
                                                      .add(show);
                                                });
                                                return createCarouselSlider(
                                                    GlobalVariables
                                                        .watchedShowList
                                                        .take(5)
                                                        .toList(),
                                                    context);
                                              } else {
                                                return Container(
                                                    height: _height / 3,
                                                    child: Center(
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets.all(
                                                              25.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              AutoSizeText(
                                                                "Your watchlist is empty",
                                                                textAlign: TextAlign
                                                                    .center,
                                                                style: GoogleFonts
                                                                    .roboto(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                    fontSize:
                                                                    _height /
                                                                        25),
                                                              ),
                                                              AutoSizeText(
                                                                "Press the eye above for magic",
                                                                textAlign: TextAlign
                                                                    .center,
                                                                style: GoogleFonts
                                                                    .roboto(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w100,
                                                                    fontSize:
                                                                    _height /
                                                                        25),
                                                              ),
                                                            ],
                                                          ),
                                                        )));
                                              }
                                            } else {
                                              // print("no stream");
                                              return Container(
                                                  height: _height / 3,
                                                  child: Center(
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(
                                                            25.0),
                                                        child: Text(
                                                          "Press the eye above for magic",
                                                          textAlign:
                                                          TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontFamily: 'Raleway',
                                                              fontSize:
                                                              _height / 25),
                                                        ),
                                                      )));
                                            }
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
        itemBuilder: (BuildContext context, int itemIndex) =>
            InkWell(
              onTap: () {
                showModalBottomSheet<dynamic>(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0)),
                    ),
                    context: context,
                    builder: (BuildContext context) {
                      return _createRouteShowDetail(data, itemIndex);
                    },
                    isScrollControlled: true);
                // Navigator.push(context, _createRouteShowDetail(data, itemIndex)),
              },
              child: WatchedCard(
                show: data[itemIndex],
              ),
            ),
        options: CarouselOptions(
          height: MediaQuery
              .of(context)
              .size
              .width * .7,
          enableInfiniteScroll: false,
        ),
      ),
    );
  }

    Widget createColorfulCard(int index, List<dynamic> data) {
    double _width = MediaQuery
        .of(context)
        .size
        .width;
    double _height = MediaQuery
        .of(context)
        .size
        .height;
    return Padding(
      padding: index != GlobalVariables.DISCOVER_DATA.length - 1
          ? const EdgeInsets.only(left: 25.0)
          : const EdgeInsets.symmetric(horizontal: 25.0),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
            SecondPageRoute(list: data),
        ),
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
                        size: _width / 12,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 15),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      data[0],
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        shadows: [
                          new BoxShadow(
                              color: Colors.black.withOpacity(.15),
                              spreadRadius: 1.2,
                              blurRadius: 5,
                              offset: Offset(0, 3.0))
                        ],
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
    double _width = MediaQuery
        .of(context)
        .size
        .width;
    double _height = MediaQuery
        .of(context)
        .size
        .height;

    var shows = (context)
        .watch<ShowProvider>()
        .scheduledList;
    if ( shows.length > 0){
      return Container(
          width: _width,
          height: _height * .41,
          color: GlobalColors.bgColor,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, int index) {
                return Center(
                    child: ScheduleCard(episode: shows[index]));
              })
      );
    }
    else{
      return Container(

      );
    }

  }

    Widget _createRouteShowDetail(List<WatchedTVShow> data, int index) {
    double _height = MediaQuery
        .of(context)
        .size
        .height;
    double _width = MediaQuery
        .of(context)
        .size
        .width;

    Future<List<dynamic>> episodes = new Network().getEpisodes(
        showID: data[index].id);
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
      child: FutureBuilder<Object>(
          future: episodes,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              data[index].episodes = snapshot.data;
              return WatchedDetailView(show: data[index]);
            } else {
              return Container(
                width: _width,
                height: _height * .95,
                color: GlobalColors.bgColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: _width,
                      // color: Colors.black,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              GlobalColors.greenColor),
                          // backgroundColor: GlobalColors.greenColor,
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

    String showGreetings() {
    var timeNow = DateTime
        .now()
        .hour;
    String greetings = "";
    if (timeNow <= 12) {
      greetings = 'Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      greetings = 'Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      greetings = 'Good Evening';
    } else {
      greetings = 'Good Night';
    }
    // print(firstName);
    return greetings + ", ${widget.user.firstName}!";
  }
}