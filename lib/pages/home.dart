import 'dart:math';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:show_time/components/sign_out_dialog.dart';
import 'package:show_time/constants/custom_variables.dart';
import 'package:show_time/get_controllers/auth_controller.dart';
import 'package:show_time/get_controllers/show_controller.dart';
import 'package:show_time/pages/login.dart';
import 'package:show_time/models/user.dart';
import 'package:show_time/models/watched.dart';
import 'package:show_time/network/firebase_utils.dart';
import 'package:show_time/screens/browse_shows.dart';
import 'package:show_time/screens/full_schedule.dart';
import 'package:show_time/screens/discover/discover.dart';
import 'package:show_time/ui/colorful_card_home.dart';
import 'package:show_time/ui/schedule_card.dart';
import 'package:show_time/ui/watch_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sliding_sheet/sliding_sheet.dart';

class HomeView extends StatefulWidget {

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>  with AnimationMixin {
  // late PanelState _panelState;
  Widget title = Container(
      color: GlobalColors.bgColor,
      child: Image(image: AssetImage('showTIME.png'), height: 50));
  late Widget _customTitle;
  // PanelController _pc = new PanelController();


  late SessionUser currentUser;

  //GetX
  ShowController showController = Get.put(ShowController())!;
  AuthController authController = Get.put(AuthController())!;

  ScrollController  _scheduleScrollController = ScrollController();

  @override
  void initState() {
    print("home init!");
    super.initState();
    _customTitle = title;
    currentUser = authController.sessionUser.value!;

  }

  @override
  void dispose() {
    super.dispose();
  }
  SheetController slidingController = SheetController();

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(25.0),
    topRight: Radius.circular(25.0),
  );


  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();
    final GlobalKey<ScaffoldState> _slidingPanelKey = new GlobalKey<ScaffoldState>();


    return Scaffold(
      resizeToAvoidBottomInset: false,
      // new line
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
                                    "${currentUser.firstName}",
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
                                    "${currentUser.lastName}",
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
                                    "${currentUser.age}",
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
                                    "${currentUser.sex}",
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
              Get.dialog(
                  SignOutDialog(),
                  barrierColor: Colors.white.withOpacity(.2));
              // showAnimatedDialog(
              //   context: context,
              //   animationType: DialogTransitionType.slideFromTopFade,
              //   barrierDismissible: true,
              //   duration: Duration(milliseconds: 100),
              //   builder: (BuildContext context) {
              //     return CustomDialogWidget(
              //       backgroundColor: Colors.grey.shade100,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.all(Radius.circular(25)),
              //       ),
              //       title: Center(
              //         child: AutoSizeText(
              //           'Are you sure you want to sign out?',
              //           maxLines: 2,
              //           maxFontSize: 20,
              //           minFontSize: 13,
              //           textAlign: TextAlign.center,
              //         ),
              //       ),
              //       titleTextStyle: TextStyle(
              //           fontFamily: 'Raleway',
              //           fontSize: 25,
              //           fontWeight: FontWeight.w700,
              //           color: GlobalColors.greyTextColor),
              //       titlePadding: EdgeInsets.only(
              //           top: 5.0, bottom: 25.0, left: 25.0, right: 25.0),
              //       //TODO content add rive animation
              //       content: AutoSizeText(
              //         "You will be redirected to the login screen.",
              //         maxLines: 2,
              //         minFontSize: 10,
              //         maxFontSize: 20,
              //         style: TextStyle(
              //             fontFamily: 'Raleway',
              //             // fontSize: 15,
              //             fontWeight: FontWeight.w300,
              //             color: GlobalColors.greyTextColor),
              //       ),
              //       elevation: 5,
              //       actions: [
              //         Padding(
              //           padding: const EdgeInsets.only(right: 10, bottom: 10),
              //           child: InkWell(
              //             onTap: () => Navigator.pop(context),
              //             child: Text(
              //               'Close',
              //               style: TextStyle(
              //                   color: GlobalColors.greenColor,
              //                   fontSize: 20,
              //                   fontWeight: FontWeight.w300),
              //             ),
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.only(right: 25.0, bottom: 10),
              //           child: InkWell(
              //             onTap: () async {
              //               GlobalVariables.clearAll();
              //               // await authService.signOut();
              //               authController.signOut();
              //               await authController.signOutGoogle();
              //               Get.offAll(() => LoginScreen());
              //             },
              //             child: Text(
              //               'Sign Out',
              //               style: TextStyle(
              //                   color: GlobalColors.greenColor,
              //                   fontSize: 20,
              //                   fontWeight: FontWeight.w900),
              //             ),
              //           ),
              //         )
              //       ],
              //     );
              //   },
              // );
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
      body: SafeArea(
          child: homeScreenBody(context, _slidingPanelKey)
      ),
    );
  }

    Widget homeScreenBody(BuildContext context, GlobalKey<ScaffoldState> _slidingPanelKey) {
    final double _width = Get.size.width;
    final double _height = Get.size.height;

    return Center(
      child: Stack(
        children: <Widget>[
          Container(
            width: _width,
            height: _height,
            color: GlobalColors.bgColor,
            child: SingleChildScrollView(
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
                          //TODO: shimmer not working on web
                          // Shimmer.fromColors(
                          //   highlightColor: GlobalColors.greenColor,
                          //   baseColor: GlobalColors.blueColor,
                          //   direction: ShimmerDirection.ltr,
                          //   period: const Duration(seconds: 10),
                          //   child:
                            Container(
                              height: _height * 0.07,
                              width: _width * .8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      GlobalColors.greenColor,
                                      GlobalColors.blueColor,
                                    ]),
                              ),
                            ),
                          // ),
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
                                  return ColorfulCard(
                                      index: index,
                                      data: GlobalVariables.DISCOVER_DATA[index],
                                    maxWidth: kIsWeb ? 200 : _width/3,
                                    maxHeight: kIsWeb ? 200 : _width/3,
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
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
                                                  FullSchedule( ))),
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
                          _buildScheduledShowView(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SlidingSheet(
            elevation: 8,
            cornerRadius: 25,
            controller: slidingController,
            scrollSpec: ScrollSpec(
              overscroll: false,
              overscrollColor: GlobalColors.greenColor,
              physics: AlwaysScrollableScrollPhysics()
            ),
            snapSpec: SnapSpec(
              snappings: [0.15, 1],
              positioning: SnapPositioning.relativeToSheetHeight,
            ),
            shadowColor: GlobalColors.greenColor.withOpacity(0.15),
            extendBody: true,
            builder: (_, state) {
              return SheetListenerBuilder(
                // buildWhen can be used to only rebuild the widget when needed.
                buildWhen: (oldState, newState) => oldState.progress != newState.progress,
                builder: (context, state) {
                  return Container(
                    height: _height * 0.8,
                    width: _width,
                    decoration: BoxDecoration(
                      // borderRadius: radius,
                      gradient: const LinearGradient(
                          stops: [0.6, 5.0],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            GlobalColors.greenColor,
                            GlobalColors.blueColor,
                          ]),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                            children: [
                              Opacity(
                        opacity: 1 - state.progress,
                        child: Center(
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
                              Opacity(
                                opacity: state.progress,
                                child: Container(
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 25.0),
                                    child: Container(
                                      height: 30,
                                      child: Text(
                                          "What are we watching today?",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: _height / 30,

                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Raleway',
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Get.to('/search', transition: Transition.cupertino);
                            } ,
                            child: SizedBox(
                              width: kIsWeb ? 150 : min(_width * 0.6, 90),
                              height: kIsWeb ? 150 : min(_width * 0.6, 90),
                              child: FlareActor(
                                'assets/blink.flr',
                                animation: 'Blink',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: _width / 10,
                          ),
                          Column(
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
                                            fontSize: _height/30,
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
                                        builder: (context, AsyncSnapshot snapshot) {
                                          // print(snapshot.connectionState);
                                          //TODO: change global stuff to show controller
                                          if (snapshot.hasData && snapshot.data != null) {
                                            // print("data");
                                            if (snapshot.data!.docs.length > 0) {
                                              GlobalVariables.watchedShowList
                                                  .clear();
                                              snapshot.data!.docs
                                                  .forEach((DocumentSnapshot f) {
                                                WatchedTVShow show = new WatchedTVShow.fromFirestore(f.data()!, f.id);
                                                GlobalVariables
                                                    .watchedShowList
                                                    .add(show);
                                              });
                                              return createCarouselSlider(
                                                  GlobalVariables
                                                      .watchedShowList
                                                      .take(5)
                                                      .toList());
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
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // SlidingUpPanel(
          //   controller: _pc,
          //   maxHeight: _panelHeightOpen,
          //   minHeight: _panelHeightClosed,
          //   key: _slidingPanelKey,
          //   defaultPanelState: _panelState,
          //   boxShadow: [
          //     BoxShadow(
          //       color: GlobalColors.greenColor.withOpacity(0.15),
          //       spreadRadius: 10,
          //       blurRadius: 25,
          //       offset: Offset(0, -10), // changes position of shadow
          //     ),
          //   ],
          //   panelSnapping: true,
          //   collapsed: Center(
          //     child: Container(
          //       height: _height * 0.8,
          //       width: _width,
          //       decoration: BoxDecoration(
          //         borderRadius: radius,
          //         color: GlobalColors.greenColor,
          //       ),
          //       child:
          //       // Shimmer.fromColors(
          //       //   period: const Duration(milliseconds: 3500),
          //       //   baseColor: Colors.white54,
          //       //   highlightColor: Colors.white,
          //       //   child:
          //         kIsWeb && Get.width > 646
          //             ? InkWell(
          //           onTap: () => _pc.open(),
          //               child: Center(
          //                 child: Container(
          //                   width: Get.width/3,
          //                   height: 50,
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(25)
          //           ),
          //           child: Center(
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceAround,
          //               children: [
          //                 FaIcon(
          //                   FontAwesomeIcons.arrowAltCircleUp,
          //                   color: GlobalColors.greenColor,
          //                 ),
          //                 Text(
          //                     "Open panel",
          //                     style: TextStyle(
          //                       color: GlobalColors.greenColor,
          //                       fontWeight: FontWeight.w700,
          //                       fontSize: Get.height/30
          //                     )
          //                     ,
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //               ),
          //             )
          //             : Container(
          //           height: 30,
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               Container(
          //                 width: _width * .3,
          //                 height: 6,
          //                 decoration: BoxDecoration(
          //                     color: Colors.white,
          //                     borderRadius:
          //                     BorderRadius.all(Radius.circular(25.0))),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     // ),
          //   ),
          //   panel: Container(
          //     height: _height * 0.8,
          //     width: _width,
          //     decoration: BoxDecoration(
          //       borderRadius: radius,
          //       gradient: const LinearGradient(
          //           stops: [0.6, 5.0],
          //           begin: Alignment.topRight,
          //           end: Alignment.bottomLeft,
          //           colors: [
          //             GlobalColors.greenColor,
          //             GlobalColors.blueColor,
          //           ]),
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.only(top: 15.0),
          //       child: SingleChildScrollView(
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: <Widget>[
          //             Container(
          //               child: Padding(
          //                 padding:
          //                 const EdgeInsets.symmetric(horizontal: 25.0),
          //                 child: Center(
          //                     child:
          //                     // Shimmer.fromColors(
          //                     //   period: const Duration(milliseconds: 3500),
          //                     //   baseColor: Colors.white54,
          //                     //   highlightColor: Colors.white,
          //                     //   child:
          //                       AnimatedSizeAndFade(
          //                         vsync: this,
          //                         child: Container(
          //                           height: 30,
          //                           child: Text(
          //                               "What are we watching today?",
          //                               textAlign: TextAlign.center,
          //                               style: TextStyle(
          //                                 color: Colors.white,
          //                                 fontSize: _height / 30,
          //
          //                                 fontWeight: FontWeight.bold,
          //                                 fontFamily: 'Raleway',
          //                               )),
          //                         ),
          //                         fadeDuration:
          //                         const Duration(milliseconds: 100),
          //                         sizeDuration:
          //                         const Duration(milliseconds: 200),
          //                       ),
          //                     // )
          //                 ),
          //               ),
          //             ),
          //             InkWell(
          //                   onTap: () {
          //                     Get.to(() => AllTVShows(), transition: Transition.cupertino);
          //                   } ,
          //                   child: SizedBox(
          //                     width: kIsWeb ? 150 : min(_width * 0.6, 90),
          //                     height: kIsWeb ? 150 : min(_width * 0.6, 90),
          //                     child: FlareActor(
          //                       'assets/blink.flr',
          //                       animation: 'Blink',
          //                       fit: BoxFit.cover,
          //                     ),
          //                   ),
          //             ),
          //             SizedBox(
          //               height: _width / 10,
          //             ),
          //             Column(
          //               children: <Widget>[
          //                 //Label - LAst watched
          //                 Container(
          //                   padding: EdgeInsets.only(left: 32, right: 32),
          //                   child: Align(
          //                     alignment: Alignment.centerLeft,
          //                     child: Row(
          //                       mainAxisAlignment:
          //                       MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Text("Last watched",
          //                             textAlign: TextAlign.left,
          //                             style: TextStyle(
          //                               shadows: <Shadow>[
          //                                 Shadow(
          //                                   offset: Offset(0.0, 3.0),
          //                                   blurRadius: 6.0,
          //                                   color: Colors.black
          //                                       .withOpacity(.2),
          //                                 ),
          //                               ],
          //                               color: Colors.white,
          //                               fontSize: _height/30,
          //                               fontFamily: "Raleway",
          //                               fontWeight: FontWeight.w900,
          //                             )),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //                 // Horizontal scrollview container
          //                 Container(
          //                   child: Align(
          //                       alignment: Alignment.bottomCenter,
          //                       child: StreamBuilder(
          //                           stream: FirestoreUtils()
          //                               .watchedShows
          //                               .orderBy('lastWatched',
          //                               descending: true)
          //                               .snapshots(),
          //                           builder: (context, AsyncSnapshot snapshot) {
          //                             // print(snapshot.connectionState);
          //                             if (snapshot.hasData && snapshot.data != null) {
          //                               // print("data");
          //                               if (snapshot.data!.docs.length > 0) {
          //                                 GlobalVariables.watchedShowList
          //                                     .clear();
          //                                 // allWatchedShows.clear();
          //                                 snapshot.data!.docs
          //                                     .forEach((f) {
          //                                   WatchedTVShow show =
          //                                   new WatchedTVShow
          //                                       .fromFirestore(
          //                                       f.data(),
          //                                       f.id);
          //                                   GlobalVariables
          //                                       .watchedShowList
          //                                       .add(show);
          //                                 });
          //                                 return createCarouselSlider(
          //                                     GlobalVariables
          //                                         .watchedShowList
          //                                         .take(5)
          //                                         .toList());
          //                               } else {
          //                                 return Container(
          //                                     height: _height / 3,
          //                                     child: Center(
          //                                         child: Padding(
          //                                           padding:
          //                                           const EdgeInsets.all(
          //                                               25.0),
          //                                           child: Column(
          //                                             mainAxisAlignment:
          //                                             MainAxisAlignment
          //                                                 .center,
          //                                             children: [
          //                                               AutoSizeText(
          //                                                 "Your watchlist is empty",
          //                                                 textAlign: TextAlign
          //                                                     .center,
          //                                                 style: GoogleFonts
          //                                                     .roboto(
          //                                                     color: Colors
          //                                                         .white,
          //                                                     fontWeight:
          //                                                     FontWeight
          //                                                         .w700,
          //                                                     fontSize:
          //                                                     _height /
          //                                                         25),
          //                                               ),
          //                                               AutoSizeText(
          //                                                 "Press the eye above for magic",
          //                                                 textAlign: TextAlign
          //                                                     .center,
          //                                                 style: GoogleFonts
          //                                                     .roboto(
          //                                                     color: Colors
          //                                                         .white,
          //                                                     fontWeight:
          //                                                     FontWeight
          //                                                         .w100,
          //                                                     fontSize:
          //                                                     _height /
          //                                                         25),
          //                                               ),
          //                                             ],
          //                                           ),
          //                                         )));
          //                               }
          //                             } else {
          //                               // print("no stream");
          //                               return Container(
          //                                   height: _height / 3,
          //                                   child: Center(
          //                                       child: Padding(
          //                                         padding:
          //                                         const EdgeInsets.all(
          //                                             25.0),
          //                                         child: Text(
          //                                           "Press the eye above for magic",
          //                                           textAlign:
          //                                           TextAlign.center,
          //                                           style: TextStyle(
          //                                               color: Colors
          //                                                   .white,
          //                                               fontFamily: 'Raleway',
          //                                               fontSize:
          //                                               _height / 25),
          //                                         ),
          //                                       )));
          //                             }
          //                           })),
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          //   borderRadius: radius,
          // ),
        ],
      ),
    );
  }

    Widget createCarouselSlider(List<WatchedTVShow> data) {
    if ( kIsWeb){
      return Center(
        child: Container(
          width: Get.width,
          height: 300,
          child: ListView.builder(
            itemCount: data.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int itemIndex) =>
                  WatchedCardWeb(
                    show: data[itemIndex],
                    maxWidth: max(Get.width/data.length - 10, 300),
                    maxHeight: max(Get.width/data.length -100, 210),
                  ),
          ),
        ),
      );
    }
    else{
      return Center(
        child: CarouselSlider.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int itemIndex, int what) =>
              WatchedCard(
                  show: data[itemIndex],
                ),
          options: CarouselOptions(
            height: Get.size.width * .7,
            enableInfiniteScroll: false,
          ),
        ),
      );
    }

  }

    Widget createColorfulCard(int index, List<dynamic> data) {
    return Padding(
      padding: index != GlobalVariables.DISCOVER_DATA.length - 1
          ? const EdgeInsets.only(left: 25.0)
          : const EdgeInsets.symmetric(horizontal: 25.0),
      child: InkWell(
        onTap: () => Get.toNamed('/discover', arguments: data),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: Get.size.height / 4.5,
            height: Get.size.height * .18,
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
            child: SingleChildScrollView(
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
                          size: Get.size.width / 12,
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
                          fontSize: Get.size.width / 25,
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
      ),
    );
  }

    Widget _buildScheduledShowView(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Obx( () {
      if ( showController.notAired.length > 0){
        return kIsWeb
          ? Container(
            width: _width,
            height: _height,
            child: StaggeredGridView.countBuilder(
              physics: NeverScrollableScrollPhysics(),
                staggeredTileBuilder: (int index) =>
                new StaggeredTile.count(1, 1),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 2.0,
              itemCount: showController.notAired.length,
              itemBuilder: (context, int index) {
                return Center(
                    child: ScheduleCard(episode: showController.notAired[index]));
              }, crossAxisCount: 4,
        ),
          )
          : Container(
            width: _width,
            height: _height * .41,
            color: GlobalColors.bgColor,
            child: Scrollbar(
              controller: _scheduleScrollController,
              thickness: 20,
              isAlwaysShown: true,
              child: ListView.builder(
                controller: _scheduleScrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: showController.notAired.length,
                  itemBuilder: (context, int index) {
                    return Center(
                        child: ScheduleCard(episode: showController.notAired[index]));
                  }),
            )
      );
      }
      else{
      return Container(
        child: Center(
          child: Text(
            "empty as fuck bro"

          ),
        ),
      );
      }
    });




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
    return greetings + ", ${currentUser.firstName}!";
  }
}