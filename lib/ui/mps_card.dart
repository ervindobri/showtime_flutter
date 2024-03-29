// ignore_for_file: avoid_print

import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:show_time/core/constants/custom_variables.dart';
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

import '../main.dart';

class PopularCard extends StatefulWidget {
  final TVShow show;

  const PopularCard({Key? key, required this.show}) : super(key: key);
  @override
  _PopularCardState createState() => _PopularCardState();
}

class _PopularCardState extends State<PopularCard> with AnimationMixin {
  late bool _tapped;

  late Animation<double> animation;
  late AnimationController _controller;
  late TVShowDetails showDetails;
  late bool _added;

  @override
  void initState() {
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

    // print(widget.show);
    _getShowDetails();

    _checkIfAdded().then((value) => _added = value);
  }

  @override
  void didUpdateWidget(PopularCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkIfAdded();
    _getShowDetails();
  }

  check() async {
    _added = await FirestoreUtils().checkIfShowExists(widget.show.id);
  }

  Future<dynamic> _checkIfAdded() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection("${auth.currentUser!.email}/shows/watched_shows")
        .doc(widget.show.id)
        .get();

    return docSnapshot.exists;
  }

  getDetailResults({required TVShow show}) =>
      Network().getDetailResults(show: show);

  _getShowDetails() async {
//    print("getting details: ${widget.show.name}");
    showDetails = await getDetailResults(show: widget.show);
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    const _radius = BorderRadius.all(Radius.circular(24));

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => print('Tapped'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              widget.show.name,
              style: const TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 16,
                  color: GlobalColors.greyTextColor,
                  fontWeight: FontWeight.w700),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _tapped = !_tapped;
                _tapped == true ? _controller.forward() : _controller.reverse();
              });
            },
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.show.imageThumbnailPath!,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      height: _height / 3.1,
                      decoration: BoxDecoration(
                        color: Colors.transparent.withOpacity(.2),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                        backgroundBlendMode: BlendMode.multiply,
                        borderRadius: _radius,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.2),
                              blurRadius: 10.0,
                              spreadRadius: 2,
                              offset: const Offset(0, 0)),
                        ],
                      ),
                    );
                  },
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Visibility(
                  visible: _tapped ? true : false,
                  child: Opacity(
                    opacity: _tapped ? 1 : .0,
                    child: ClipRRect(
                      borderRadius: _radius,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                        child: Container(
                          height: _height / 3.1,
                          width: _width,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(.56),
                              borderRadius: _radius),
                          child: FadeTransition(
                            opacity: Tween<double>(
                              begin: 0,
                              end: 1,
                            ).animate(animation),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 18.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              const Text(
                                                "Rating",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Raleway',
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              Container(
                                                height: 30,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: GlobalColors
                                                              .goldColor
                                                              .withOpacity(.3),
                                                          blurRadius: 15.0,
                                                          spreadRadius: -2,
                                                          offset: const Offset(
                                                              2, 2)),
                                                    ],
                                                    color:
                                                        GlobalColors.goldColor),
                                                child: Center(
                                                  child: AutoSizeText(
                                                    "${widget.show.rating}",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Raleway',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: _width / 20),
                                                  ),
                                                ),
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
                                              const Text(
                                                "Year",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Raleway',
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              Container(
                                                height: 30,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: GlobalColors
                                                              .pinkColor
                                                              .withOpacity(.3),
                                                          blurRadius: 15.0,
                                                          spreadRadius: -2,
                                                          offset: const Offset(
                                                              0, 3)),
                                                    ],
                                                    shape: BoxShape.rectangle,
                                                    color:
                                                        GlobalColors.pinkColor),
                                                child: Center(
                                                  child: AutoSizeText(
                                                    widget.show.startDateString
                                                        .split('-')[0],
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Raleway',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: _width / 20),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0,
                                        bottom: 0.0,
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
                                              // color: GlobalColors.primaryBlue,
                                              // shape: RoundedRectangleBorder(
                                              //     borderRadius:
                                              //         BorderRadius.circular(
                                              //             24)),
                                              onPressed: () {
                                                // print(widget.show.id);
                                                _checkIfAdded().then(
                                                    (value) => _added = value);
                                                if (!_added) {
                                                  WatchedTVShow show =
                                                      FirestoreUtils()
                                                          .addToWatchedShows(
                                                              showDetails);
                                                  GlobalVariables
                                                      .watchedShowList
                                                      .add(show);
                                                  //TODO: change status alert

                                                  // StatusAlert.show(
                                                  //   context,
                                                  //   duration: Duration(seconds: 2),
                                                  //   blurPower: 5.0,
                                                  //   title: 'Show added',
                                                  //   configuration: IconConfiguration(
                                                  //       icon: Icons.done),
                                                  // );
                                                  setState(() => _added = true);
                                                } else {
                                                  setState(
                                                      () => _tapped = false);

                                                  showModalBottomSheet<dynamic>(
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  24),
                                                          topRight:
                                                              Radius.circular(
                                                                  24),
                                                        ),
                                                      ),
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        // print(list.length);
                                                        WatchedTVShow show;
                                                        Future<List<dynamic>>
                                                            episodes;
                                                        try {
                                                          show = GlobalVariables
                                                              .watchedShowList
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .id ==
                                                                      widget
                                                                          .show
                                                                          .id);
                                                          episodes = Network()
                                                              .getEpisodes(
                                                                  showID:
                                                                      show.id);
                                                          return ClipRRect(
                                                            borderRadius: const BorderRadius
                                                                    .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        24),
                                                                topRight: Radius
                                                                    .circular(
                                                                        24)),
                                                            child: FutureBuilder<
                                                                    Object>(
                                                                future:
                                                                    episodes,
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    show.episodes = snapshot
                                                                            .data
                                                                        as List<
                                                                            Episode>;
                                                                    // print(show.episodes.length);
                                                                    // print(data[index].episodes.length);
                                                                    return WatchedDetailView(
                                                                        show:
                                                                            show);
                                                                  } else {
                                                                    return Container(
                                                                      width:
                                                                          _width,
                                                                      height:
                                                                          _height *
                                                                              .95,
                                                                      color: GlobalColors
                                                                          .bgColor,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                _width,
                                                                            // color: Colors.black,
                                                                            child:
                                                                                const Center(
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
                                                                }),
                                                          );
                                                        } catch (e) {
                                                          print(
                                                              "No such show: $e");
                                                          Navigator.pop(
                                                              context);
                                                          return Container();
                                                        }
                                                      },
                                                      isScrollControlled: true);
                                                }
                                              },
                                              child: const Center(
                                                child: Icon(
                                                  FontAwesomeIcons.couch,
                                                  size: 20.0,
                                                  color: CupertinoColors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: TextButton(
                                              // highlightColor: Colors.black,
                                              // color: GlobalColors.primaryGreen,
                                              // shape: const CircleBorder(),
                                              onPressed: () {
                                                setState(() {
                                                  _tapped = false;
                                                });
                                                showModalBottomSheet(
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(24),
                                                        topRight:
                                                            Radius.circular(24),
                                                      ),
                                                    ),
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return DetailView(
                                                          show: showDetails);
                                                    },
                                                    isScrollControlled: true);
                                              },
                                              child: Container(
                                                width: _width / 8,
                                                height: _width / 8,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Center(
                                                  child: FaIcon(
                                                    FontAwesomeIcons.infoCircle,
                                                    size: 24,
                                                    color:
                                                        CupertinoColors.white,
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
