import 'dart:async';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:show_time/components/custom_elevation.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/constants/styles.dart';
import 'package:show_time/core/utils/navigation.dart';
import 'package:show_time/core/utils/utils.dart';
import 'package:show_time/features/watchlist/presentation/widgets/primary_button.dart';
import 'package:show_time/features/watchlist/presentation/widgets/secondary_button.dart';
import 'package:show_time/get_controllers/show_controller.dart';
import 'package:show_time/get_controllers/timer_controller.dart';
import 'package:show_time/get_controllers/ui_controller.dart';
import 'package:show_time/features/home/data/models/watched.dart';
import 'package:show_time/network/firebase_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:simple_animations/simple_animations.dart';

class WatchedDetailView extends StatefulWidget {
  final WatchedTVShow show;

  const WatchedDetailView({Key? key, required this.show}) : super(key: key);
  @override
  _WatchedDetailViewState createState() => _WatchedDetailViewState();
}

class _WatchedDetailViewState extends State<WatchedDetailView>
    with AnimationMixin, AutomaticKeepAliveClientMixin {
  late Future<List<dynamic>> episodes;
  late double _percentage;
  late int _lastWatchedDay;

  late Animation<double> size;

  late Animation<double> animation;
  late AnimationController _controller;
  late Animation<double> sizeAnimation;
  late AnimationController _reverseController;

  late double containerWidth;
  late double containerHeight;

  late Animation<double> _containerSizeAnimation;

  String countdown = "";

  late Timer _timer;

  int _selectedSeason = 1;
  int _selectedEpisode = 1;

  int _episodeLength = 24;

  TimerController timerController = Get.put(TimerController())!;
  UIController uiController = Get.put(UIController())!;
  ShowController showController = Get.put(ShowController())!;

// Setting to true will force the tab to never be disposed. This could be dangerous.
  @override
  bool get wantKeepAlive => true;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    controller.duration = Duration(milliseconds: 250);
    timerController.init(widget.show);

    super.initState();

    //Fetch updated data
    showController.getShowData(widget.show);
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

    setState(() {
      countdown = widget.show.newestEpisodeDifference();
    });
    // startTimer();
  }

  @override
  void dispose() {
    timerController.cancelTimer();
    _controller.dispose();
    _reverseController.dispose();

    super.dispose();
  }

  String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Container(
      width: _width,
      height: _height * .95,
      decoration: BoxDecoration(
        color: GlobalColors.bgColor,
      ),
      child: Container(
        height: _height * .95,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  height: _height * .55,
                  // color: GlobalColors.blueColor,
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
                            color: GlobalColors.greenColor,
                            image: DecorationImage(
                                image: NetworkImage(
                                  widget.show.imageThumbnailPath!,
                                ),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(25.0),
                              bottomLeft: Radius.circular(25.0),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        child: Container(
                            height: _height / 3.5,
                            width: _width * .4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.2),
                                  spreadRadius: 2,
                                  blurRadius: 15,
                                  offset: Offset(
                                      10, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25.0),
                              child: CachedNetworkImage(
                                imageUrl: widget.show.imageThumbnailPath!,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                        child: CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )),
                                errorWidget: (context, url, error) => Center(
                                    child: Icon(
                                  Icons.error,
                                  color: Colors.white,
                                )),
                              ),
                            )),
                      ),
                      Positioned(
                          bottom: 0,
                          child: _yourProgress(
                              _percentage, widget.show, _height, _width)),
                      if (this.widget.show.watchedTimes > 0)
                        Positioned(
                          bottom: _height / 4.5,
                          right: _width / 10,
                          child: InkWell(
                            onTap: () {
                              uiController.showToast(
                                  context: context,
                                  color: GlobalColors.blueColor,
                                  icon: FontAwesomeIcons.history,
                                  text:
                                      "You rewatched ${widget.show.name} ${widget.show.watchedTimes} time(s)");
                            },
                            child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        GlobalColors.blueColor,
                                        Colors.lightBlueAccent
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                          color: GlobalColors.blueColor
                                              .withOpacity(.3),
                                          blurRadius: 5,
                                          spreadRadius: 1)
                                    ]),
                                child: Center(
                                  child: AutoSizeText(
                                      this.widget.show.watchedTimes.toString(),
                                      minFontSize: 20,
                                      maxFontSize: 35,
                                      style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 30)),
                                )),
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
                  child: displayBadges(_height, _width)),
            ),
            // FadeIn(.35,_checkIfPopular(_percentage, show.lastWatchDate, show.hasMoreEpisodes())),
            Spacer(),
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
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 24.0,
                    left: 16,
                    right: 16,
                  ),
                  child: displayActions(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _yourProgress(
      double _percentage, WatchedTVShow show, double _height, double _width) {
    _percentage = show.calculateProgress();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
      child: AnimatedBuilder(
          animation: _reverseController,
          builder: (context, index) {
            return Container(
              width: (_containerSizeAnimation.value) / 4 * _width > _width * .85
                  ? (_containerSizeAnimation.value) / 4 * _width
                  : _width * .85,
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
                  padding:
                      const EdgeInsets.only(left: 25.0, top: 5.0, right: 25.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: AutoSizeText(show.name!,
                              maxFontSize: (_width / 10).roundToDouble(),
                              minFontSize: (_width / 15).roundToDouble(),
                              stepGranularity: .1,
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: 'Raleway',
                                  color: GlobalColors.greyTextColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: _width / 15)),
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
                                    "${removeDecimalZeroFormat((_percentage * 100))}%",
                                    style: GoogleFonts.roboto(
                                      fontSize: _width / 23,
                                      color: GlobalColors.blueColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  progressColor: GlobalColors.blueColor,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      AutoSizeText(
                                        "${widget.show.currentSeason.toString()}",
                                        minFontSize: 20,
                                        maxFontSize: 45,
                                        style: TextStyle(
                                          color: GlobalColors.greyTextColor,
                                          fontSize: 35,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      AutoSizeText(
                                        "Sn",
                                        style: TextStyle(
                                          color: GlobalColors.greenColor,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      AutoSizeText(
                                        "${widget.show.currentEpisode.toString()}",
                                        minFontSize: 20,
                                        maxFontSize: 45,
                                        style: GoogleFonts.roboto(
                                          color: GlobalColors.greyTextColor,
                                          fontSize: 35,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      AutoSizeText(
                                        "Ep",
                                        style: TextStyle(
                                          color: GlobalColors.greenColor,
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
          }),
    );
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
                  child: AutoSizeText("Badges",
                      style: GlobalStyles.sectionStyle()),
                ),
                AutoSizeText(
                  "About",
                  style: TextStyle(
                    color: GlobalColors.greenColor,
                    fontFamily: 'Raleway',
                    fontSize: _width / 20,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              width: _width,
              height: 68,
              child: AnimationLimiter(
                child: ListView.builder(
                  itemCount: badges.length,
                  shrinkWrap: true,
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

  List<Widget> getBadges() {
    List<Widget> badges = [];

    if (widget.show.hasMoreEpisodes()) {
      badges.add(GlobalVariables.allBadges['waiting']!);
    }
    if (_lastWatchedDay < 15) {
      //Display fire badge
      // print("fire");
      badges.add(GlobalVariables.allBadges['fresh']!);
    } else {
      //  Haven't watched in last two weeks
      badges.add(GlobalVariables.allBadges['paused']!);
    }
    if (_percentage < 1.0) {
      badges.add(GlobalVariables.allBadges['watching']!);
    } else {
      badges.add(GlobalVariables.allBadges['finished']!);
    }
    if (widget.show.favorite!) {
      badges.add(GlobalVariables.allBadges['favorite']!);
    }
    return badges;
  }

  Widget createBottomSheet() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
      child: Container(
        height: _height * .45,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: _height / 10,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        "You are watching",
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: GlobalColors.greyTextColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: InkWell(
                        highlightColor: GlobalColors.greenColor,
                        focusColor: GlobalColors.greenColor,
                        splashColor: GlobalColors.greenColor,
                        onTap: () {
                          setState(() {
                            widget.show.currentSeason = _selectedSeason;
                            widget.show.currentEpisode = _selectedEpisode;
                          });
                          widget.show.setLastWatchedDate();
                          FirestoreUtils().updateEpisode(widget.show);
                          Utils.showToast(
                              text: 'Updated successfully!',
                              icon: Icons.done);
                          NavUtils.back(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: GlobalColors.greenColor,
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 12),
                            child: AutoSizeText(
                              "Select",
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                fontSize: 20,
                                fontFamily: 'Raleway',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Container(
                  height: _height / 3,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          AutoSizeText(
                            "Season",
                            minFontSize: 17,
                            maxFontSize: 20,
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w700,
                                // fontSize: 15,
                                color: GlobalColors.greyTextColor),
                          ),
                          Container(
                            height: _height / 5,
                            width: _width / 3,
                            decoration: BoxDecoration(
                                color: GlobalColors.lightGreenColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                              child: CupertinoPicker(
                                itemExtent: 30,
                                useMagnifier: false,
                                diameterRatio: 1,
                                looping: true,
                                onSelectedItemChanged: (int value) {
                                  //selected season
                                  setState(() {
                                    _selectedSeason =
                                        value + this.widget.show.currentSeason;
                                    _episodeLength = this
                                        .widget
                                        .show
                                        .episodePerSeason![
                                            _selectedSeason.toString()]!
                                        .toInt();
                                  });
                                  print(_episodeLength);
                                },
                                children: List.generate(
                                    int.parse(this
                                            .widget
                                            .show
                                            .episodePerSeason!
                                            .keys
                                            .last) -
                                        this.widget.show.currentSeason +
                                        1,
                                    (index) => Text(
                                        (index + this.widget.show.currentSeason)
                                            .toString())),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          AutoSizeText(
                            "Episode",
                            minFontSize: 17,
                            maxFontSize: 20,
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w700,
                                // fontSize: 15,
                                color: GlobalColors.greyTextColor),
                          ),
                          Container(
                            height: _height / 5,
                            width: _width / 3,
                            decoration: BoxDecoration(
                                color: GlobalColors.lightGreenColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                              child: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  //TODO: fix episode selecter with getx
                                  return CupertinoPicker(
                                    itemExtent: 30,
                                    useMagnifier: false,
                                    diameterRatio: 1,
                                    looping: true,
                                    onSelectedItemChanged: (int value) {
                                      //selected season
                                      setState(() {
                                        _selectedEpisode = value + 1;
                                      });
                                    },
                                    children: List.generate(
                                        _episodeLength,
                                        (index) =>
                                            Text((index + 1).toString())),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget displayActions() {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    if (this.widget.show.calculateProgress() < 1.0) {
      return widget.show.nextEpisodeAired()
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SecondaryButton(
                      text: "Unwatch",
                      onPressed: () {
                        showAnimatedDialog(
                          context: context,
                          animationType:
                              DialogTransitionType.slideFromBottomFade,
                          barrierDismissible: false,
                          duration: Duration(milliseconds: 100),
                          builder: (BuildContext context) {
                            return uiController.unwatchDialog(context,
                                showName: widget.show.name!,
                                showID: widget.show.id);
                          },
                        );
                      }),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: PrimaryButton(
                      text: "Next",
                      icon: FaIcon(
                        Icons.add_to_queue,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        try {
                          setState(() {
                            widget.show.incrementEpisodeWatch();
                            widget.show.setLastWatchedDate();
                          });
                          FirestoreUtils().updateEpisode(widget.show);
                          uiController.showToast(
                              context: context,
                              color: GlobalColors.greenColor,
                              text: 'Episode added!',
                              icon: Icons.done);
                        } catch (e, s) {
                          print(s);
                          uiController.showToast(
                              context: context,
                              text: '{$e}:Couldn\'t add episode!',
                              color: GlobalColors.greenColor,
                              icon: Icons.error);
                        }
                      },
                      onLongPress: () {
                        setState(() {
                          _selectedSeason = this.widget.show.currentSeason;
                          _selectedEpisode = this.widget.show.currentEpisode;
                        });
                        showModalBottomSheet(
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25.0),
                                  topRight: Radius.circular(25.0)),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return createBottomSheet();
                            });
                      }),
                )
              ],
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
                          width: _width / 2.5,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                              color:
                                  GlobalColors.lightGreenColor.withOpacity(.3)),
                          child: CustomElevation(
                            color: GlobalColors.greenColor.withOpacity(.2),
                            spreadRadius: -2,
                            blurRadius: 10,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all(
                                    new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(12.0))),
                              ),
                              clipBehavior: Clip.antiAlias,
                              onPressed: () {
                                showAnimatedDialog(
                                  context: context,
                                  animationType:
                                      DialogTransitionType.slideFromBottomFade,
                                  barrierDismissible: false,
                                  duration: Duration(milliseconds: 100),
                                  builder: (_) {
                                    return uiController.unwatchDialog(context,
                                        showName: widget.show.name!,
                                        showID: widget.show.id);
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
                                        color: GlobalColors.greenColor),
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
                          width: _width / 3,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                              color: GlobalColors.fireColor),
                          child: CustomElevation(
                            color: GlobalColors.fireColor.withOpacity(.3),
                            spreadRadius: 2,
                            blurRadius: 15,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    GlobalColors.fireColor),
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shape: MaterialStateProperty.all(
                                    new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(12.0))),
                              ),
                              onPressed: () {
                                print("ep not aired");
                                uiController.showToast(
                                    context: context,
                                    color: GlobalColors.fireColor,
                                    icon: Icons.timer,
                                    text:
                                        "Episode air date: ${widget.show.nextEpisodeAirDate()[1]}");
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Obx(
                                        () => AutoSizeText(
                                          timerController.countDown.value,
                                          maxFontSize: 25,
                                          minFontSize:
                                              12, // for smaller screens
                                          maxLines: 1,
                                          style: GoogleFonts.lato(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
    } else {
      return PrimaryButton(
        onPressed: () {
          //RESET THE NUMBERS AND INCREMENT
          setState(() {
            this.widget.show.watchedTimes += 1;
            this.widget.show.currentSeason = 1;
            this.widget.show.currentEpisode = 0;
          });
          widget.show.setLastWatchedDate();

          this.widget.show.calculateWatchedEpisodes();
          //Reset episode counters;
          FirestoreUtils().incrementWatchedTime(this.widget.show);
        },
        text: "Rewatch",
        icon: FaIcon(
          FontAwesomeIcons.rev,
          color: Colors.white,
          size: 20,
        ),
      );
    }
  }
}
