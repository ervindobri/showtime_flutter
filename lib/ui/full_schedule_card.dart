import 'dart:async';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/features/home/data/models/countdown.dart';
import 'package:show_time/features/home/data/models/episode.dart';
import 'package:show_time/models/tvshow.dart';
import 'package:show_time/models/tvshow_details.dart';
import 'package:show_time/features/home/data/models/watched.dart';
import 'package:show_time/network/firebase_utils.dart';
import 'package:show_time/network/network.dart';
import 'package:show_time/screens/detail_view.dart';
import 'package:show_time/features/watchlist/presentation/widgets/detail_view/watched_detail_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:google_fonts/google_fonts.dart';

class FullScheduleCard extends StatefulWidget {
  final List<Episode> episodes;

  const FullScheduleCard({Key? key, required this.episodes}) : super(key: key);

  @override
  _FullScheduleCardState createState() => _FullScheduleCardState();
}

class _FullScheduleCardState extends State<FullScheduleCard>
    with AnimationMixin {
  late Countdown countdown;
  late Timer _timer;

  var countDownStyle = GoogleFonts.poppins(
      textStyle: const TextStyle(
          fontSize: 24,
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w200,
          color: Colors.white));

  late Animation<double> animation;
  late AnimationController _controller;
  late bool _tapped;

  late WatchedTVShow show;
  late Future<List<dynamic>> episodesObject;

  late TVShowDetails showDetails;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    _getShowDetails();

    _tapped = false;
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    );
    setState(() {
      countdown = widget.episodes[0].getDifference();
    });
    startTimer();
    _tapped = false;
  }

  getDetailResults({required TVShow show}) =>
      Network().getDetailResults(show: show);

  _getShowDetails() async {
    TVShow show = await Network().getShowInfo(
        showID: widget.episodes[0].embedded!['show']['id'].toString());
    showDetails = await getDetailResults(show: show);
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() => countdown = widget.episodes[0].getDifference());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    const BorderRadius _radius = BorderRadius.all(Radius.circular(24.0));
    const BorderRadius _smallRadius = BorderRadius.all(Radius.circular(12.0));

    final Future<List<dynamic>> episodesObject = Network().getEpisodes(
        showID: widget.episodes[0].embedded!['show']['id'].toString());

    final _cardHeight = _height * .45;
    final _cardWidth = _width * .65;
    // startTimer();

    double _animatedWidth = 50.0;
    double _animatedHeight = _cardHeight * .75;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Center(
          child: InkWell(
        onTap: () {
          setState(() {
            if (!_tapped) {
              _animatedWidth = _width * .65;
              _animatedHeight = _height * .45;
              _tapped = !_tapped;
              _controller.forward();
            } else {
              _animatedWidth = _width / 7;
              _animatedHeight = (_height * .6) * .58;
              _tapped = !_tapped;
              _controller.reverse();
            }
          });
        },
        child: Container(
          height: _height * .6,
          width: _width * .8,
          decoration: const BoxDecoration(
            borderRadius: _radius,
            // color: Colors.blueAccent,
          ),
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Positioned(
                top: 24,
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.episodes[0].embedded!['show']['image']
                          ['medium'],
                      imageBuilder: (context, imageProvider) => Container(
                        width: _cardWidth,
                        height: _cardHeight,
                        decoration: BoxDecoration(
                          color: GlobalColors.primaryBlue,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                          borderRadius: _radius,
                          boxShadow: [
                            BoxShadow(
                              color: countdown.days <= 3
                                  ? GlobalColors.fireColor.withOpacity(.3)
                                  : GlobalColors.primaryGreen.withOpacity(.3),
                              blurRadius: 15.0,
                              spreadRadius: -4,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    Visibility(
                      visible: _tapped,
                      child: ClipRRect(
                        borderRadius: _radius,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaY: 5.0, sigmaX: 5.0),
                          child: FadeTransition(
                            opacity: Tween<double>(
                              begin: 0,
                              end: 1,
                            ).animate(animation),
                            child: Container(
                              width: _width * .65,
                              height: _height * .45,
                              decoration: BoxDecoration(
                                color: CupertinoColors.black.withOpacity(.4),
                                borderRadius: _tapped
                                    ? const BorderRadius.all(
                                        Radius.circular(24.0))
                                    : const BorderRadius.only(
                                        bottomLeft: Radius.circular(24.0),
                                        topRight: Radius.circular(24.0),
                                      ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0.0),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Flex(
                                          direction: Axis.vertical,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20.0),
                                              child: Center(
                                                child: Text(
                                                    countdown.displayLetters,
                                                    style: countDownStyle),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 10),
                                              child: SizedBox(
                                                height: 1.5,
                                                width: double.infinity,
                                                child: Container(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 24),
                                        child: Container(
                                          height: _width / 4,
                                          decoration: const BoxDecoration(
                                            borderRadius: _smallRadius,
                                            color: Colors.white,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0, vertical: 5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      AutoSizeText(
                                                        "Next up",
                                                        minFontSize: 10,
                                                        maxFontSize: 15,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize:
                                                                    _width / 24,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                // fontFamily: 'Raleway',
                                                                color: GlobalColors
                                                                    .greyTextColor),
                                                      ),
                                                      AutoSizeText(
                                                        "1/${widget.episodes.length.toString()}",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize:
                                                                    _width / 24,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                // fontFamily: 'Raleway',
                                                                color: GlobalColors
                                                                    .greyTextColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: SizedBox(
                                                    height: .69,
                                                    width: double.infinity,
                                                    child: Container(
                                                      color: GlobalColors
                                                          .greyTextColor,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: AutoSizeText(
                                                      latestEpisode()!,
                                                      minFontSize: 8,
                                                      maxLines: 2,
                                                      maxFontSize: 20,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          // fontSize: _width/23,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: 'Raleway',
                                                          color: GlobalColors
                                                              .greyTextColor),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            bottom: 10.0,
                                            left: 3,
                                            right: 3),
                                        child: SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(0, 0.1),
                                            end: Offset.zero,
                                          ).animate(animation),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: TextButton(
                                                  // highlightColor: Colors.black,
                                                  // color:
                                                  //     GlobalColors.primaryBlue,
                                                  // shape: const CircleBorder(),
                                                  onPressed: () {
                                                    // setState(() => _tapped = !_tapped);
                                                    showModalBottomSheet<
                                                            dynamic>(
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    24.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    24.0),
                                                          ),
                                                        ),
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          // print(widget.episodes[0].embedded['show']['id']);
                                                          return ClipRRect(
                                                            borderRadius: const BorderRadius
                                                                    .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        24.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        24.0)),
                                                            child:
                                                                FutureBuilder(
                                                                    future: FirestoreUtils().getWatchedShowData(widget
                                                                        .episodes[
                                                                            0]
                                                                        .embedded![
                                                                            'show'][
                                                                            'id']
                                                                        .toString()),
                                                                    builder: (context,
                                                                        AsyncSnapshot
                                                                            snapshot) {
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return Container(
                                                                          width:
                                                                              _width,
                                                                          height:
                                                                              _height * .95,
                                                                          color:
                                                                              GlobalColors.bgColor,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: _width,
                                                                                // color: Colors.black,
                                                                                child: const Center(
                                                                                  child: CircularProgressIndicator(
                                                                                    valueColor: AlwaysStoppedAnimation<Color>(GlobalColors.primaryGreen),
                                                                                    // backgroundColor: GlobalColors.greenColor,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      } else {
                                                                        WatchedTVShow
                                                                            show =
                                                                            WatchedTVShow.fromFirestore(snapshot.data!.data(),
                                                                                widget.episodes[0].embedded!['show']['id'].toString());
                                                                        // print(
                                                                        //     "fetching episode data");
                                                                        return FutureBuilder<
                                                                                Object>(
                                                                            future:
                                                                                episodesObject,
                                                                            builder:
                                                                                (context, AsyncSnapshot snapshot) {
                                                                              if (snapshot.hasData) {
                                                                                show.episodes = snapshot.data as List<Episode>;
                                                                                return WatchedDetailView(show: show);
                                                                              } else {
                                                                                return Container(
                                                                                  width: _width,
                                                                                  height: _height * .95,
                                                                                  color: GlobalColors.bgColor,
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: _width,
                                                                                        // color: Colors.black,
                                                                                        child: const Center(
                                                                                          child: CircularProgressIndicator(
                                                                                            valueColor: AlwaysStoppedAnimation<Color>(GlobalColors.primaryGreen),
                                                                                            // backgroundColor: GlobalColors.greenColor,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              }
                                                                            });
                                                                      }
                                                                    }),
                                                          );
                                                        },
                                                        isScrollControlled:
                                                            true);
                                                  },
                                                  child: Container(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Center(
                                                      child: FaIcon(
                                                        FontAwesomeIcons.couch,
                                                        size: 30.0,
                                                        color: CupertinoColors
                                                            .white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: TextButton(
                                                  // highlightColor: Colors.black,
                                                  // color:
                                                  //     GlobalColors.primaryGreen,
                                                  // shape: const CircleBorder(),
                                                  onPressed: () {
                                                    // print(showDetails.toString());
                                                    showModalBottomSheet(
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          24.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          24.0)),
                                                        ),
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return DetailView(
                                                              show:
                                                                  showDetails);
                                                        },
                                                        isScrollControlled:
                                                            true);
                                                  },
                                                  child: Container(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Center(
                                                      child: FaIcon(
                                                        FontAwesomeIcons
                                                            .infoCircle,
                                                        size: 30.0,
                                                        color: CupertinoColors
                                                            .white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
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
                      ),
                    ),
                    Visibility(
                      visible: !_tapped ? true : false,
                      child: Positioned(
                        right: 0,
                        child: countdown.days > 0
                            ? ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(24.0),
                                  topRight: Radius.circular(24.0),
                                ),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 5.0, sigmaY: 5.0),
                                  child: Container(
                                    width: _animatedWidth.toDouble(),
                                    height: _animatedHeight.toDouble(),
                                    decoration: BoxDecoration(
                                      color:
                                          CupertinoColors.black.withOpacity(.4),
                                      borderRadius: _tapped
                                          ? const BorderRadius.all(
                                              Radius.circular(24.0))
                                          : const BorderRadius.only(
                                              bottomLeft: Radius.circular(24.0),
                                              topRight: Radius.circular(24.0),
                                            ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 30.0),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 15),
                                        child: Flex(
                                          direction: Axis.vertical,
                                          children: [
                                            AutoSizeText(
                                                countdown.days.toString(),
                                                maxLines: 1,
                                                minFontSize: 10,
                                                maxFontSize: 18,
                                                style: countDownStyle),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: SizedBox(
                                                height: 2,
                                                width: 30,
                                                child: Container(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            AutoSizeText(
                                                countdown.hours.toString(),
                                                maxFontSize: 20,
                                                style: countDownStyle),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: SizedBox(
                                                height: 2,
                                                width: 30,
                                                child: Container(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            AutoSizeText(
                                                countdown.minutes.toString(),
                                                maxFontSize: 20,
                                                style: countDownStyle),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: SizedBox(
                                                height: 2,
                                                width: 30,
                                                child: Container(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            AutoSizeText(
                                                countdown.seconds.toString(),
                                                maxFontSize: 20,
                                                style: countDownStyle),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  width: _width / 2,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: _radius,
                      gradient: LinearGradient(
                        colors: countdown.days <= 3
                            ? [Colors.orange, GlobalColors.orangeColor]
                            : [
                                GlobalColors.primaryGreen,
                                GlobalColors.lightGreenColor
                              ],
                        stops: const [.01, 20],
                      )),
                  child: Center(
                      child: Text(getTopLabel(countdown.days),
                          style: TextStyle(
                              color: CupertinoColors.white,
                              fontSize: _width / 20,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w700))),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  String getTopLabel(int days) {
    // print(countdown);
    if (days > 0) {
      return "In ${days.abs()} day(s)";
    } else if (days == 0) {
      return "Available to watch";
    } else {
      return "${days.abs()} day(s) ago";
    }
  }

  String? latestEpisode() {
    for (Episode x in widget.episodes) {
      if (!x.aired()) {
        return x.name;
      }
    }
    return widget.episodes[0].name;
  }
}
