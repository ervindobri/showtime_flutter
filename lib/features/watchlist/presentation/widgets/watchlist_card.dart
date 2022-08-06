import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hovering/hovering.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/constants/theme_utils.dart';
import 'package:show_time/controllers/ui_controller.dart';
import 'package:show_time/features/home/data/models/episode.dart';
import 'package:show_time/features/home/data/models/watched.dart';
import 'package:show_time/injection_container.dart';
import 'package:show_time/network/firebase_utils.dart';
import 'package:show_time/network/network.dart';
import 'package:show_time/features/watchlist/presentation/widgets/detail_view/watched_detail_view_placeholder.dart';
import 'package:show_time/features/watchlist/presentation/widgets/detail_view/watched_detail_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';

class WatchedCardInList extends StatefulWidget {
  final WatchedTVShow show;

  const WatchedCardInList({Key? key, required this.show}) : super(key: key);

  @override
  _WatchedCardInListState createState() => _WatchedCardInListState();
}

class _WatchedCardInListState extends State<WatchedCardInList> {
  IconData _icon = FontAwesomeIcons.heart;

  bool _added = true;
  bool dialogOpen = false;
  UiController uiController = sl<UiController>();
  late Timer hoverTimer;

  @override
  void initState() {
    super.initState();
    _icon = widget.show.favorite!
        ? FontAwesomeIcons.solidHeart
        : FontAwesomeIcons.heart;
    checkFavorite();
  }

  checkFavorite() async {
    _added = await FirestoreUtils().isFavorite(widget.show.id);
    widget.show.favorite = _added;
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    const double cardHeight = kIsWeb ? 450 : 100;
    final double cardWidth = kIsWeb ? 300 : _width;
    const double spaceFill = 50;

    if (kIsWeb) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          width: cardWidth + spaceFill,
          height: cardHeight + spaceFill,
          // color: Colors.blue,
          child: Center(
            child: Stack(
              children: [
                MouseRegion(
                  onEnter: (event) {
                    //start timer
                    hoverTimer = Timer.periodic(
                        const Duration(milliseconds: 350), (timer) {
                      uiController.hoverTimeout++;
                      if (uiController.hoverTimeout == 3) {
                        uiController.detailDialog(widget.show);
                      }
                    });
                  },
                  onExit: (event) {
                    hoverTimer.cancel();
                    uiController.hoverTimeout = 0;
                  },
                  child: InkWell(
                    onTap: () {
                      if (kIsWeb || MediaQuery.of(context).size.width > 666) {
                        //open details popup
                        // Get.defaultDialog(
                        //     title: widget.show.name,
                        //     content: Container(
                        //       width: 500,
                        //       height: 500,
                        //       color: GlobalColors.bgColor,
                        //     ));
                      } else {
                        showModalBottomSheet<dynamic>(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24.0),
                                  topRight: Radius.circular(24.0)),
                            ),
                            context: context,
                            builder: (_) {
                              return buildShowDetails(
                                  widget.show, _width, _height);
                            },
                            isScrollControlled: true);
                      }
                    },
                    child: HoverAnimatedContainer(
                      width: cardWidth,
                      hoverDecoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(.3),
                              blurRadius: 30.0,
                              spreadRadius: -2,
                              offset: const Offset(0, 3)),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(.4),
                              blurRadius: 10.0,
                              spreadRadius: -2,
                              offset: const Offset(0, 3)),
                        ],
                      ),
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: LinearPercentIndicator(
                                progressColor: GlobalColors.primaryBlue,
                                animation: true,
                                backgroundColor: Colors.grey.shade100,
                                alignment: MainAxisAlignment.center,
                                lineHeight: 10,
                                width: cardWidth * .8,
                                percent: widget.show.calculatedProgress,
                                linearStrokeCap: LinearStrokeCap.roundAll,
                              ),
                            ),
                            //Image
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  width: cardWidth * .9,
                                  height: cardHeight * .7,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            widget.show.imageThumbnailPath),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(24),
                                    // topLeft: Radius.circular(24.0),
                                    // topRight: Radius.circular(24.0)
                                    // ),
                                  ),
                                ),
                              ),
                            ),
                            //Text and progress bar
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: cardHeight * .6,
                  left: 15,
                  child: buildFavoriteIcon(widget.show),
                ),
                // Positioned(
                //   right: 10,
                //   bottom: 10,
                //   child: Align(
                //       alignment: Alignment.bottomCenter,
                //       child: Padding(
                //         padding: const EdgeInsets.only(left:50.0),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             widget.show.calculateProgress() == 1.0
                //                 ? Container(
                //               child: Badge(description: "Finished",icon: FontAwesomeIcons.checkDouble, colors:[GlobalColors.greenColor, Colors.greenAccent], size: _height/20,),
                //             )
                //                 : Container(
                //               height: 1,
                //               width: 1,
                //             ),
                //             _ratingBadge(),
                //           ],
                //         ),
                //       )
                //   ),
                // ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: InkWell(
          onTap: () {
            showModalBottomSheet<dynamic>(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0)),
                ),
                context: context,
                builder: (_) {
                  return buildShowDetails(widget.show, _width, _height);
                },
                isScrollControlled: true);
          },
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                width: cardWidth,
                height: cardHeight,
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(widget.show.imageThumbnailPath),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: cardWidth - 100,
                            child: Text(
                              widget.show.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: ShowTheme.listWatchCardTitleStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(
                            widget.show.startDate.year.toString(),
                            style: ShowTheme.listWatchCardTitleStyle.copyWith(
                                fontSize: 14,
                                color:
                                    GlobalColors.greyTextColor.withOpacity(.4)),
                          ),
                        ],
                      ),
                    ),
                    // ClipRRect(
                    //   borderRadius: const BorderRadius.only(
                    //       topRight: Radius.circular(24.0),
                    //       bottomRight: Radius.circular(24.0)),
                    //   child: Column(
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: AutoSizeText(
                    //           widget.show.name!,
                    //           minFontSize: (_width / 20).roundToDouble(),
                    //           maxFontSize: (_width / 10).roundToDouble(),
                    //           stepGranularity: .1,
                    //           maxLines: 2,
                    //           textAlign: TextAlign.center,
                    //           style: ShowTheme.listWatchCardTitleStyle,
                    //         ),
                    //       ),
                    //       _checkFinishedShow(cardWidth),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                left: 50 + 10 + 12,
                child: buildFavoriteIcon(widget.show),
              ),
              Positioned(
                  right: 24,
                  top: cardHeight / 2 - 16,
                  child: Container(
                    width: cardWidth / 4,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: GlobalColors.primaryGreen,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "S${widget.show.currentSeason}",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          "E${widget.show.currentEpisode}",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      );
    }
  }

  Widget buildFavoriteIcon(WatchedTVShow show) {
    // final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: InkWell(
        onTap: () async {
          if (!_added) {
            FirestoreUtils().favoriteShow(show, true);
            FirestoreUtils().addToFavorites(show);
            GlobalVariables.favorites.add(show);
            setState(() {
              _icon = FontAwesomeIcons.solidHeart;
              _added = true;
            });
            Fluttertoast.showToast(
                msg: "${widget.show.name} added to favorites!",
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: GlobalColors.pinkColor,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 2);
          } else {
            FirestoreUtils().favoriteShow(show, false);
            FirestoreUtils().deleteFromFavorites(show);
            setState(() {
              _icon = FontAwesomeIcons.heart;
              _added = false;
            });
            Fluttertoast.showToast(
                msg: "${widget.show.name} removed from favorites!",
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: GlobalColors.pinkColor,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 2);
          }
        },
        child: ClipOval(
          child: Container(
              height: _height / 20,
              width: _height / 20,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  color: GlobalColors.pinkColor),
              child: Center(
                child: FaIcon(
                  _icon,
                  color: Colors.white,
                  size: _height / 30,
                ),
              )),
        ),
      ),
    );
  }
}

Widget buildShowDetails(WatchedTVShow show, double _width, double _height) {
  var episodes = Network().getEpisodes(showID: show.id);
  return ClipRRect(
    borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
    child: FutureBuilder<List<Episode>>(
        future: episodes,
        builder: (context, snapshot) {
          // print(snapshot.error);
          if (snapshot.hasData) {
            show.episodes = snapshot.data as List<Episode>;
            return WatchedDetailView(show: show);
          } else {
            return const WatchedDetailViewPlaceholder();
          }
        }),
  );
}
