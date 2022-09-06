// ignore_for_file: avoid_print

import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:show_time/components/custom_elevation.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/constants/styles.dart';
import 'package:show_time/core/utils/navigation.dart';
import 'package:show_time/core/utils/utils.dart';
import 'package:show_time/features/home/data/models/episode.dart';
import 'package:show_time/features/watchlist/presentation/widgets/detail_view/watched_detail_view_placeholder.dart';
import 'package:show_time/features/watchlist/presentation/widgets/primary_button.dart';
import 'package:show_time/features/watchlist/presentation/widgets/secondary_button.dart';
import 'package:show_time/controllers/show_controller.dart';
import 'package:show_time/controllers/timer_controller.dart';
import 'package:show_time/controllers/ui_controller.dart';
import 'package:show_time/features/home/data/models/watched.dart';
import 'package:show_time/injection_container.dart';
import 'package:show_time/network/firebase_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:show_time/network/network.dart';
import 'package:show_time/ui/toast.dart';
import 'package:simple_animations/simple_animations.dart';

class WatchedDetailWrapper extends StatefulWidget {
  final WatchedTVShow show;
  const WatchedDetailWrapper({Key? key, required this.show}) : super(key: key);

  @override
  State<WatchedDetailWrapper> createState() => _WatchedDetailWrapperState();
}

class _WatchedDetailWrapperState extends State<WatchedDetailWrapper> {
  late final Future<List<Episode>> episodes;

  @override
  void initState() {
    episodes = Network().getEpisodes(showID: widget.show.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
      child: FutureBuilder<List<Episode>>(
        future: episodes,
        builder: (context, snapshot) {
          // print(snapshot.error);
          if (snapshot.hasData) {
            sl<ShowController>().currentEpisodes.value =
                snapshot.data as List<Episode>;
            return WatchedDetailView(show: widget.show);
          } else {
            return const WatchedDetailViewPlaceholder();
          }
        },
      ),
    );
  }
}

class WatchedDetailView extends StatefulWidget {
  final WatchedTVShow show;

  const WatchedDetailView({Key? key, required this.show}) : super(key: key);
  @override
  _WatchedDetailViewState createState() => _WatchedDetailViewState();
}

class _WatchedDetailViewState extends State<WatchedDetailView>
    with AnimationMixin {
  late Future<List<dynamic>> episodes;
  late double _percentage;
  late int _lastWatchedDay;

  late Animation<double> size;

  late Animation<double> animation;
  late AnimationController _controller;
  late Animation<double> sizeAnimation;
  late AnimationController _reverseController;
  late Animation<double> _containerSizeAnimation;

  String countdown = "";

  int _selectedSeason = 1;
  int _selectedEpisode = 1;

  int _episodeLength = 24;

  TimerController timerController = sl<TimerController>();
  UiController uiController = sl<UiController>();
  ShowController showController = sl<ShowController>();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    showController.getShowData(widget.show.id);

    controller.duration = const Duration(milliseconds: 240);
    timerController.init(widget.show);
    super.initState();

    //Fetch updated data
    _percentage = widget.show.calculatedProgress;
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
      curve: Curves.fastOutSlowIn,
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

  //TODO: extension function from this function
  String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    return Container(
      width: _width,
      height: _height * .95,
      decoration: const BoxDecoration(
        color: GlobalColors.bgColor,
      ),
      child: SizedBox(
        height: _height * .95,
        child: ValueListenableBuilder<WatchedTVShow?>(
            valueListenable: showController.current,
            builder: (context, show, child) {
              if (show == null) {
                return const SizedBox();
              }
              return Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      SizedBox(
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
                                  color: GlobalColors.primaryGreen,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        widget.show.imageThumbnailPath,
                                      ),
                                      fit: BoxFit.cover),
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(24.0),
                                    bottomLeft: Radius.circular(24.0),
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(24.0)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(.2),
                                        spreadRadius: 2,
                                        blurRadius: 15,
                                        offset: const Offset(10,
                                            0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24.0),
                                    child: CachedNetworkImage(
                                      imageUrl: show.imageThumbnailPath,
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          Center(
                                              child: CircularProgressIndicator(
                                        value: downloadProgress.progress,
                                        valueColor:
                                            const AlwaysStoppedAnimation(
                                                Colors.white),
                                      )),
                                      errorWidget: (context, url, error) =>
                                          const Center(
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
                                    _percentage, show, _height, _width)),
                            if (widget.show.watchedTimes > 0)
                              Positioned(
                                bottom: _height / 4.5,
                                right: _width / 10,
                                child: InkWell(
                                  onTap: () {
                                    uiController.showToast(
                                        context: context,
                                        color: GlobalColors.primaryBlue,
                                        icon: FontAwesomeIcons.history,
                                        text:
                                            "You rewatched ${widget.show.name} ${widget.show.watchedTimes} time(s)");
                                  },
                                  child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: const LinearGradient(
                                            colors: [
                                              GlobalColors.primaryBlue,
                                              Colors.lightBlueAccent
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                                color: GlobalColors.primaryBlue
                                                    .withOpacity(.3),
                                                blurRadius: 5,
                                                spreadRadius: 1)
                                          ]),
                                      child: Center(
                                        child: AutoSizeText(
                                            show.watchedTimes.toString(),
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
                  //TODO: extract fade & slide widget to reusable
                  FadeTransition(
                    opacity: Tween<double>(
                      begin: 0,
                      end: 1,
                    ).animate(animation),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: displayBadges(_height, _width),
                    ),
                  ),
                  // FadeIn(.35,_checkIfPopular(_percentage, show.lastWatchDate, show.hasMoreEpisodes())),
                  const Spacer(),
                  //TODO: extract fade & slide widget to reusable

                  FadeTransition(
                    opacity: Tween<double>(
                      begin: 0,
                      end: 1,
                    ).animate(animation),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 24.0,
                          left: 16,
                          right: 16,
                        ),
                        child: displayActions(show),
                      ),
                    ),
                  ),
                  SizedBox(height: bottomPadding),
                ],
              );
            }),
      ),
    );
  }

  Widget _yourProgress(
      double _percentage, WatchedTVShow show, double _height, double _width) {
    _percentage = show.calculatedProgress;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
      child: AnimatedBuilder(
        animation: _reverseController,
        builder: (context, index) {
          return Container(
            width: (_containerSizeAnimation.value) / 4 * _width > _width * .85
                ? (_containerSizeAnimation.value) / 4 * _width
                : _width * .85,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(24.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4), // changes position of shadow
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
            child: FadeTransition(
              opacity: Tween<double>(
                begin: 0,
                end: 1,
              ).animate(animation),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      show.name,
                      maxLines: 2,
                      style: const TextStyle(
                          fontFamily: 'Raleway',
                          color: GlobalColors.greyTextColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 20),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: CircularPercentIndicator(
                          animation: true,
                          animationDuration: 500,
                          curve: Curves.fastOutSlowIn,
                          radius: 48,
                          animateFromLastPercent: true,
                          lineWidth: 12,
                          circularStrokeCap: CircularStrokeCap.round,
                          percent: _percentage,
                          center: AutoSizeText(
                            "${removeDecimalZeroFormat((_percentage * 100))}%",
                            style: GoogleFonts.poppins(
                              fontSize: _width / 23,
                              color: GlobalColors.primaryBlue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          progressColor: GlobalColors.primaryBlue,
                          backgroundColor:
                              GlobalColors.primaryBlue.withOpacity(.2),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    show.currentSeason.toString(),
                                    style: GoogleFonts.poppins(
                                      color: GlobalColors.greyTextColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const AutoSizeText(
                                    "Sn",
                                    style: TextStyle(
                                      color: GlobalColors.primaryGreen,
                                      fontFamily: 'Raleway',
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Text(
                                        show.currentEpisode.toString(),
                                        style: GoogleFonts.poppins(
                                          color: GlobalColors.greyTextColor,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        "/${widget.show.totalEpisodesThisSeason.toString()}",
                                        style: GoogleFonts.poppins(
                                          color: GlobalColors.greyTextColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const AutoSizeText(
                                    "Ep",
                                    style: TextStyle(
                                      color: GlobalColors.primaryGreen,
                                      fontFamily: 'Raleway',
                                      fontSize: 20,
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget displayBadges(double _height, double _width) {
    List<Widget> badges = getBadges();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
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
                    color: GlobalColors.primaryGreen,
                    fontFamily: 'Raleway',
                    fontSize: _width / 20,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: SizedBox(
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
      ),
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

  Widget createBottomSheet(WatchedTVShow show) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
      child: SizedBox(
        height: _height * .45,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: _height / 10,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15.0),
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
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: PrimaryButton(
                        text: "Select",
                        onPressed: () {
                          setState(() {
                            show.currentSeason = _selectedSeason;
                            show.currentEpisode = _selectedEpisode;
                          });
                          show.setLastWatchedDate();
                          FirestoreUtils().updateEpisode(widget.show);
                          Utils.showToast(
                              text: 'Updated successfully!', icon: Icons.done);
                          NavUtils.back(context);
                        },
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
                          const AutoSizeText(
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
                                        value + show.currentSeason;
                                    _episodeLength = widget
                                        .show
                                        .episodePerSeason[
                                            _selectedSeason.toString()]!
                                        .toInt();
                                  });
                                  print(_episodeLength);
                                },
                                children: List.generate(
                                  int.parse(show.episodePerSeason.keys.last) -
                                      show.currentSeason +
                                      1,
                                  (index) => Text(
                                    (index + show.currentSeason).toString(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const AutoSizeText(
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

  Widget displayActions(WatchedTVShow show) {
    // final _width = MediaQuery.of(context).size.width;
    // final _height = MediaQuery.of(context).size.height;
    if (show.calculatedProgress < 1.0) {
      return show.nextEpisodeAired
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
                          duration: const Duration(milliseconds: 100),
                          builder: (BuildContext context) {
                            return UnwatchDialog(show: show);
                          },
                        );
                      }),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PrimaryButton(
                      text: "Next",
                      icon: const FaIcon(
                        Icons.add_to_queue,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        try {
                          setState(() {
                            show.incrementEpisodeWatch();
                            show.setLastWatchedDate();
                          });
                          FirestoreUtils().updateEpisode(show);
                          uiController.showToast(
                              context: context,
                              color: GlobalColors.primaryGreen,
                              text: 'Episode added!',
                              icon: Icons.done);
                        } catch (e, s) {
                          print(s);
                          uiController.showToast(
                              context: context,
                              text: '{$e}:Couldn\'t add episode!',
                              color: GlobalColors.primaryGreen,
                              icon: Icons.error);
                        }
                      },
                      onLongPress: () {
                        setState(() {
                          _selectedSeason = show.currentSeason;
                          _selectedEpisode = show.currentEpisode;
                        });
                        showModalBottomSheet(
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24.0),
                                  topRight: Radius.circular(24.0)),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return createBottomSheet(show);
                            });
                      }),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                          duration: const Duration(milliseconds: 100),
                          builder: (BuildContext context) {
                            return UnwatchDialog(show: show);
                          },
                        );
                      }),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomElevation(
                    color: GlobalColors.fireColor.withOpacity(.3),
                    spreadRadius: 2,
                    blurRadius: 16,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(GlobalColors.fireColor),
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        print("ep not aired");
                        uiController.showToast(
                            context: context,
                            color: GlobalColors.fireColor,
                            icon: Icons.timer,
                            text:
                                "Episode air date: ${show.nextEpisodeAirDate()[1]}");
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ValueListenableBuilder<String>(
                                  valueListenable: timerController.countDown,
                                  builder: (context, value, __) {
                                    return Text(
                                      value,
                                      maxLines: 1,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: Colors.white),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
    } else {
      return TextButton.icon(
        style: GlobalStyles.greenButtonStyle(),
        onPressed: () {
          //RESET THE NUMBERS AND INCREMENT
          setState(() {
            show.watchedTimes += 1;
            show.currentSeason = 1;
            show.currentEpisode = 0;
          });
          show.setLastWatchedDate();

          show.calculateWatchedEpisodes();
          //Reset episode counters;
          FirestoreUtils().incrementWatchedTime(show);
        },
        label: const Text(
          'Rewatch',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        icon: const FaIcon(
          FontAwesomeIcons.rev,
          color: Colors.white,
          size: 20,
        ),
      );
    }
  }
}

class UnwatchDialog extends StatelessWidget {
  final WatchedTVShow show;
  const UnwatchDialog({Key? key, required this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialogWidget(
      backgroundColor: Colors.grey.shade100,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      title: Center(
        child: Text(
          'Sure you want to unwatch ${show.name}?',
        ),
      ),
      content: const Center(child: Text('Show content will be lost.')),
      contentTextStyle: const TextStyle(
          fontFamily: 'Raleway',
          fontSize: 15,
          fontWeight: FontWeight.w300,
          color: GlobalColors.greyTextColor),
      contentPadding: const EdgeInsets.all(24),
      titleTextStyle: const TextStyle(
          fontFamily: 'Raleway',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: GlobalColors.greyTextColor),
      titlePadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      elevation: 5,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10, bottom: 5),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: const SizedBox(
              width: 60,
              height: 30,
              child: Text(
                'Close',
                style: TextStyle(
                    color: GlobalColors.primaryGreen,
                    fontSize: 20,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 24.0, bottom: 5),
          child: InkWell(
            onTap: () {
              try {
                FirestoreUtils().watchedShows.doc(show.id).delete();
                showToast(
                  text: 'Show unwatched!',
                  icon: Icons.done,
                  color: GlobalColors.primaryGreen,
                  context: context,
                );
                //removed
                GlobalVariables.watchedShowList
                    .removeWhere((element) => element.name == show.name);
                NavUtils.back(context);
                NavUtils.back(context);
              } catch (exception) {
                showToast(
                    text: "Couldn'\t unwatch show!",
                    icon: Icons.error,
                    context: context,
                    color: GlobalColors.fireColor);
                // Get.back();
              }
            },
            child: const SizedBox(
              width: 100,
              height: 30,
              // color: Colors.grey,
              child: Center(
                child: Text(
                  'Unwatch',
                  style: TextStyle(
                      color: GlobalColors.primaryGreen,
                      fontSize: 20,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
