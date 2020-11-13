import 'dart:async';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eWoke/components/badge.dart';
import 'package:eWoke/components/custom_elevation.dart';
import 'package:eWoke/components/dialogs.dart';
import 'package:eWoke/components/toast.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/models/watched.dart';
import 'package:eWoke/network/firebase_utils.dart';
import 'package:eWoke/network/network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:status_alert/status_alert.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flare_flutter/flare_actor.dart';

import '../main.dart';

class WatchedDetailView extends StatefulWidget {
  final WatchedTVShow show;

  const WatchedDetailView({Key key, this.show}) : super(key: key);
  @override
  _WatchedDetailViewState createState() => _WatchedDetailViewState();
}

class _WatchedDetailViewState extends State<WatchedDetailView> with AnimationMixin {
  RefreshController _refreshController;
  Future<List<dynamic>> episodes;
  double _percentage;
  int _lastWatchedDay;

  Animation<double> size;

  Animation<double> animation;
  AnimationController _controller;

  Animation<double> sizeAnimation;
  AnimationController _reverseController;

  double containerWidth;
  double containerHeight;

  Animation<double> _containerSizeAnimation;

  FToast fToast;


  String countdown = "";
  Timer _timer;

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fToast = FToast();
    fToast.init(context);

    controller.duration = Duration(milliseconds: 250);
// <-- start the animation playback

    super.initState();
    // print("NR of episodes: ${widget.show.episodes.length}");

    _refreshController = RefreshController(initialRefresh: false);
    //Fetch updated data
    _getShowData(widget.show);

    //UPDATE IF NECCESSARY
    // updateEpisode(widget.show);

    _percentage = widget.show.calculateProgress();
    _lastWatchedDay = widget.show.diffDays().abs();


    _controller = AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: this,
    )..forward();

    _reverseController = AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: this,
    );

    sizeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    );

    _containerSizeAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            curve: Curves.fastOutSlowIn, parent: _reverseController));

    _reverseController.forward();

    setState(() {
      countdown = widget.show.episodes[widget.show.calculateWatchedEpisodes() == 0 ? 0: widget.show.calculateWatchedEpisodes()- 1].getDifference();
    });
    startTimer();

    print(this.widget.show.watchedTimes);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _refreshController.dispose();
    _controller.dispose();
    _reverseController.dispose();
    super.dispose();
  }

  void enterRefresh() {
    _refreshController.requestLoading();
  }


  void _updateSize(double width, double height) {
    setState(() {
      containerWidth = width;
      containerHeight = height;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // WatchedTVShow show = widget.show;
    DragStartDetails startVerticalDragDetails;
    DragUpdateDetails updateVerticalDragDetails;

    // print("AIRED ${show.nextEpisodeAired()}");
    // _getEpisodes();
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Container(
            width: _width,
            height: _height*.95,
            decoration: BoxDecoration(
              color: bgColor,
            ),
            child: Container(
              height: _height*.95,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Container(
                        height: _height * .55,
                        // color: blueColor,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            SizeTransition(
                              axis: Axis.vertical,
                              axisAlignment: -1,
                              sizeFactor: sizeAnimation,
                              child: Container(
                                height: _height * .4,
                                decoration: BoxDecoration(
                                  color: greenColor,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      widget.show.imageThumbnailPath,
                                    ),
                                    fit: BoxFit.cover
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(25.0),
                                    bottomLeft: Radius.circular(25.0),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 50,
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaY: 20.0, sigmaX: 20.0),
                                child: Container(
                                  height: _height/3.5,
                                  width: _width*.4,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(.2),
                                        spreadRadius: 2,
                                        blurRadius: 15,
                                        offset: Offset(10, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25.0),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.show.imageThumbnailPath,
                                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                                          Center(child: CircularProgressIndicator(value: downloadProgress.progress, valueColor: AlwaysStoppedAnimation(Colors.white),)),
                                      errorWidget: (context, url, error) => Center(child: Icon(Icons.error, color: Colors.white,)),
                                    ),
                                  )
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                child:
                                _yourProgress(_percentage, widget.show, _height, _width)
                            ),
                            if ( this.widget.show.watchedTimes > 0) Positioned(
                              bottom: _height/4.5,
                              right: _width/10,
                              child: InkWell(
                                onTap:(){
                                  Widget toast = CustomToast
                                    (
                                      color: blueColor,
                                      icon: FontAwesomeIcons.history,
                                      text: "You rewatched ${widget.show.name} ${widget.show.watchedTimes} time(s)"
                                  );
                                  fToast.showToast(
                                    child: toast,
                                    gravity: ToastGravity.BOTTOM,
                                    toastDuration: Duration(seconds: 2),
                                  );
                              },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        blueColor,
                                        Colors.lightBlueAccent
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: blueColor.withOpacity(.3),
                                        blurRadius: 5,
                                        spreadRadius: 1
                                      )
                                    ]
                                  ),
                                  child: Center(
                                    child: AutoSizeText(
                                        this.widget.show.watchedTimes.toString(),
                                      minFontSize: 20,
                                      maxFontSize: 35,
                                      style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 30
                                    )
                                    ),
                                  )
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  FadeTransition(
                      opacity: Tween<double>(
                          begin: 0,
                          end: 1,
                      ).animate(animation),
                      child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, 0.1),
                            end: Offset.zero,
                          ).animate(animation),
                          child: displayBadges(_height, _width)
                      ),
                  ),
                  // FadeIn(.35,_checkIfPopular(_percentage, show.lastWatchDate, show.hasMoreEpisodes())),
                  Expanded(
                    child: Align(
                        alignment: Alignment.bottomCenter,
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
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child:  displayActions(),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          );
  }
  //TODO: REFACTOR FIRESTORE


  Widget _checkIfPopular(double percentage, String lastWatchDate, bool status, double _height, double _width) {
    // print(status);
    if (percentage == 1.0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: _height / 6.5,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .7,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  stops: [.5, 50],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    greenColor,
                    lightGreenColor,
                  ]),
              color: fireColor,
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
            ),
            child: Row(
              children: <Widget>[
                ClipOval(
                  child: Container(
                    width: _height / 10,
                    height: _height / 10,
                    padding: EdgeInsets.all(5),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.checkDouble,
                        size: _height / 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Text("You finished this show",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Raleway',
                        fontSize: MediaQuery.of(context).size.width / 25,
                      )),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
            child: Container(
              child: status
                  ? Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.binoculars,
                          color: greyTextColor,
                          size: 30,
                        ),
                        Text("More episodes coming soon",
                            style: TextStyle(
                              color: greyTextColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Raleway',
                              fontSize: MediaQuery.of(context).size.width / 25,
                            )),
                      ],
                    )
                  : Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.questionCircle,
                          color: greyTextColor,
                          size: 30,
                        ),
                        Text("This show has ENDED",
                            style: TextStyle(
                              color: greyTextColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Raleway',
                              fontSize: MediaQuery.of(context).size.width / 25,
                            )),
                      ],
                    ),
            ),
          )
        ],
      );
    }
    else {
      if (widget.show.diffDays().abs() < 15) {
        return Container(
          width: _width * .7,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                stops: [.5, 50],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  fireColor,
                  Colors.orange,
                ]),
            color: fireColor,
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
          child: Row(
            children: <Widget>[
              ClipOval(
                child: Container(
                  width: _height / 10,
                  height: _height / 10,
                  padding: EdgeInsets.all(5),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.fire,
                      size: _height / 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Text("You seem to like this show",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Raleway',
                      fontSize: _width / 30,
                    )),
              )
            ],
          ),
        );
      } else {
        // return Positioned(
        //   child: Container(
        //     width: MediaQuery.of(context).size.width,
        //     child: Row(
        //       children: [
        //         Container(
        //             width: 100,
        //             height: 100,
        //             child: FlareActor("assets/waiting.flr", alignment:Alignment.center, fit:BoxFit.fitWidth, animation:"swing")
        //         ),
        //         Text(
        //             "Episode airing soon!",
        //             style: TextStyle(
        //               fontSize: MediaQuery.of(context).size.width/25,
        //               fontFamily: 'Raleway',
        //               fontWeight: FontWeight.w500,
        //               color: greyTextColor,
        //             )
        //         ),
        //       ],
        //     ),
        //   ),
        // );
      }
      return Container();
    }
  }

  Widget _yourProgress(double _percentage, WatchedTVShow show, double _height, double _width) {
    _percentage = show.calculateProgress();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
      child: AnimatedBuilder(
        animation: _reverseController,
        builder: (context, index) {
          return Container(
            width: (_containerSizeAnimation.value)/4 * _width > _width*.85 ? (_containerSizeAnimation.value)/4 * _width  : _width*.85,
            // height: _height*.25,
            // height: _height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(2, 5), // changes position of shadow
                ),
              ],
            ),
            child: FadeTransition(
              opacity: Tween<double>(
                begin: 0,
                end: 1,
              ).animate(animation),
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 5.0, right: 25.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: AutoSizeText(
                            show.name,
                            maxFontSize: (_width/10).roundToDouble(),
                            minFontSize: (_width/15).roundToDouble(),
                            stepGranularity: .1,
                            maxLines: 2,
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                color: greyTextColor,
                                fontWeight: FontWeight.w900,
                                fontSize: _width / 15)
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: _width / 4,
                              child: new CircularPercentIndicator(
                                animation: true,
                                animationDuration: 500,
                                curve: Curves.easeOutExpo,
                                radius: _width / 4.3,
                                lineWidth: 12,
                                circularStrokeCap: CircularStrokeCap.round,
                                percent: _percentage,
                                center: new AutoSizeText(
                                  "${(_percentage * 100).toStringAsFixed(2)}%",
                                  style: GoogleFonts.roboto(
                                    fontSize: _width / 23,
                                    color: blueColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                progressColor: blueColor,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    AutoSizeText(
                                      "${widget.show.currentSeason.toString()}",
                                      minFontSize: 20,
                                      maxFontSize: 45,
                                      style: TextStyle(
                                        color: greyTextColor,
                                        fontSize: 35,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    AutoSizeText(
                                      "Sn",
                                      style: TextStyle(
                                        color: greenColor,
                                        fontFamily: 'Raleway',
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    AutoSizeText(
                                      "${widget.show.currentEpisode.toString()}",
                                      minFontSize: 20,
                                      maxFontSize: 45,
                                      style: GoogleFonts.roboto(
                                        color: greyTextColor,
                                        fontSize: 35,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    AutoSizeText(
                                      "Ep",
                                      style: TextStyle(
                                        color: greenColor,
                                        fontFamily: 'Raleway',
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
          );
        }
      ),
    );
  }


  _getShowData(WatchedTVShow show) async {
    try{
      List<dynamic> list = await new Network().getDetailUpdates(showID: show.id);
      // print(list);
      // print(episodes.length);
      var snapshots = FirestoreUtils().watchedShows.doc(show.id).snapshots();
      snapshots.first.then((value) {
        show.currentSeason = value.data()['currentSeason'];
        show.totalSeasons = list[0];
        show.episodePerSeason = list[1];
        show.currentEpisode = value.data()['currentEpisode'];
        // return show;
      });
    }
    catch(e ){
      print(e);
      rethrow;
    }

  }

  Widget displayBadges(double _height, double _width) {
    List<Widget> badges = getBadges();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
      child: Container(
          // color: Colors.grey,
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    "Badges",
                    style: TextStyle(
                      color: greyTextColor,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w700,
                      fontSize: _width / 20,
                    ),
                  ),
                ),
                AutoSizeText(
                  "About",
                  style: TextStyle(
                    color: greenColor,
                    fontFamily: 'Raleway',
                    fontSize: _width / 20,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Container(
              width: _width,
              height: _height/9,
              child: AnimationLimiter(
                  child: ListView.builder(
                    itemCount: badges.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          horizontalOffset: 20.0,
                          child: badges[index],
                        ),
                      );
                    },
                  ),
              ),
            ),
          )
        ],
      )),
    );
  }

  List<Widget>getBadges() {
    List<Widget> badges = [];

    if (widget.show.hasMoreEpisodes()) {
      badges.add(allBadges['waiting']);
    }
    if (_lastWatchedDay < 15) {
      //Display fire badge
      // print("fire");
      badges.add(allBadges['fresh']);
    }
    else{
      //  Haven't watched in last two weeks
      badges.add(allBadges['paused']);
    }
    if ( _percentage < 1.0){
      badges.add(allBadges['watching']);

    }
    else{
      badges.add(allBadges['finished']);
    }
    if ( widget.show.favorite){
      badges.add(allBadges['favorite']);
    }
    return badges;
  }

  Widget displayActions() {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    // print(_percentage);
    if (this.widget.show.calculateProgress() < 1.0) {
      return widget.show.nextEpisodeAired()
          ? Container(
        // color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: _width/2.5,
                    height: _width/7,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        color: lightGreenColor.withOpacity(.3)
                    ),
                    child: FlatButton(
                      splashColor: Colors.white,
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0)),
                      clipBehavior: Clip.antiAlias,
                      onPressed: () {
                        showAnimatedDialog(
                          context: context,
                          animationType: DialogTransitionType.slideFromBottomFade,
                          barrierDismissible: false,
                          duration: Duration(milliseconds: 100),
                          builder: (BuildContext context) {
                            return unwatchDialog(context, widget.show.name, widget.show.id);
                          },
                        );
                      },
                      child: Center(
                        child: Text(
                          "Unwatch",
                          style: TextStyle(
                            color: greenColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: _width/2.5,
                    height: _width/7,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        color: greenColor.withOpacity(1)
                    ),
                    child: FlatButton(
                      splashColor: Colors.white,
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0)),
                      onPressed: () {
                        try {
                          setState(() {
                            widget.show.incrementEpisodeWatch();
                          });
                          widget.show.setLastWatchedDate();
                          FirestoreUtils().updateEpisode(widget.show);
                          StatusAlert.show(
                            context,
                            duration:
                            Duration(
                                seconds:
                                1),
                            blurPower: 15.0,
                            title:
                            'Episode added',
                            configuration:
                            IconConfiguration(
                                icon: Icons
                                    .done),
                          );
                        } catch (e, s) {
                          print(s);
                          StatusAlert.show(
                            context,
                            duration:
                            Duration(
                                seconds: 1),
                            blurPower: 15.0,
                            title:
                            '{$e}:Couldn\'t add episode!',
                            configuration:
                            IconConfiguration(
                                icon: Icons
                                    .error),
                          );
                        }

                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Next",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Container(
                              child: FaIcon(
                                Icons.add_to_queue,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
          : Column(
            children: [
              Container(
        child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: _width/2.5,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        color: lightGreenColor.withOpacity(.3)
                    ),
                    child: FlatButton(
                      splashColor: Colors.white,
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0)),
                      clipBehavior: Clip.antiAlias,
                      onPressed: () {
                        showAnimatedDialog(
                          context: context,
                          animationType: DialogTransitionType.slideFromBottomFade,
                          barrierDismissible: false,
                          duration: Duration(milliseconds: 100),
                          builder: (BuildContext context) {
                            return unwatchDialog(context, widget.show.name, widget.show.id);
                          },
                        );
                      },
                      child: Center(
                        child: Text(
                          "Unwatch",
                            style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                            fontSize: 22,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w500,
                            color: greenColor
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: _width/2.5,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        color: fireColor
                    ),
                    child: FlatButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.redAccent,
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0)),
                      onPressed: () {
                        print("ep not aired");
                        Widget toast = CustomToast(color: fireColor,icon: Icons.timer, text: "Episode air date: ${widget.show.nextEpisodeAirDate()[1]}");
                        fToast.showToast(
                          child: toast,
                          gravity: ToastGravity.TOP,
                          toastDuration: Duration(seconds: 2),
                        );
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AutoSizeText(
                                countdown.toString(),
                                maxFontSize: 16,
                                minFontSize: 10,
                                style: GoogleFonts.roboto(
                                    // fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
        ),
      ),
            ],
          );
    }
    else{
     return Container(
       child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: Container(
           width: _width/2,
           height: 50,
           decoration: BoxDecoration(
               borderRadius: BorderRadius.all(Radius.circular(25.0)),
               color: greenColor
           ),
           child: CustomElevation(
             color: greenColor.withOpacity(.4),
             child: FlatButton(
               splashColor: lightGreenColor,
               shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0)),
               clipBehavior: Clip.antiAlias,
               onPressed: () {
                 //RESET THE NUMBERS AND INCREMENT
                 setState(() {
                     this.widget.show.watchedTimes+=1;
                     this.widget.show.currentSeason = 1;
                     this.widget.show.currentEpisode = 0;
                 });
                 widget.show.setLastWatchedDate();

                 this.widget.show.calculateWatchedEpisodes();
                  //Reset episode counters;
                  FirestoreUtils().incrementWatchedTime(this.widget.show);
               },
               child: Center(
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     FaIcon(
                       FontAwesomeIcons.rev,
                       color: Colors.white,
                       size: 25,
                     ),
                     AutoSizeText(
                       "Rewatch",
                       style: GoogleFonts.roboto(
                         textStyle: TextStyle(
                             fontSize: 22,
                             fontFamily: 'Raleway',
                             fontWeight: FontWeight.w500,
                             color: Colors.white
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
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        oneSec,
            (Timer timer) {
          setState(() => countdown = widget.show.episodes[widget.show.calculateWatchedEpisodes() == 0 ? 0: widget.show.calculateWatchedEpisodes()- 1].getDifference());
        }
    );
  }
}
