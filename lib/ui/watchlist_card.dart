import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:show_time/components/badge.dart';
import 'package:show_time/constants/custom_variables.dart';
import 'package:show_time/constants/theme_utils.dart';
import 'package:show_time/models/episode.dart';
import 'package:show_time/models/watched.dart';
import 'package:show_time/network/firebase_utils.dart';
import 'package:show_time/network/network.dart';
import 'package:show_time/placeholders/watched_detail_view_placeholder.dart';
import 'package:show_time/screens/watched_detail_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
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
  late double _percentage;

  @override
  void initState() {
    setState(() {
      _percentage = widget.show.calculateProgress();
    });
    //weird behaviour: I have to call calculateProgress() every time, variable not working

    super.initState();
    _icon = widget.show.favorite! ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart;
    checkFavorite();
  }


  checkFavorite() async{
    _added = await FirestoreUtils().isFavorite(widget.show.id);
    widget.show.favorite = _added;
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    final double cardHeight = kIsWeb ?  _height/3 : _height/3.5;
    final double cardWidth = kIsWeb ? _width/7 : _height/3.5;
    final double spaceFill = 50;

    if ( kIsWeb){
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
        child: Container(
          width: cardWidth+spaceFill,
          height: cardHeight+spaceFill,
          // color: Colors.blue,
          child: Center(
            child: Stack(
              children: [
                InkWell(
                  onTap: (){
                    showModalBottomSheet<dynamic>(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0)),
                        ),
                        context: context,
                        builder: (_) {
                          return createRouteShowDetail(widget.show, _width, _height);
                        },
                        isScrollControlled: true);
                  },
                  child: Container(
                    width: cardWidth,
                    // height: cardHeight,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      boxShadow: [
                        const BoxShadow(
                            color: Colors.grey,
                            blurRadius: 30.0,
                            spreadRadius: -2,
                            offset: Offset(0, 3)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: LinearPercentIndicator(
                            progressColor: GlobalColors.blueColor,
                            animation: true,
                            backgroundColor: Colors.grey.shade100,
                            alignment: MainAxisAlignment.center,
                            lineHeight: 10,
                            width: cardWidth*.8,
                            percent: widget.show.calculateProgress(),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                          ),
                        ),
                        //Image
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              width: cardWidth*.9,
                              height: cardHeight*.7,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(widget.show.imageThumbnailPath!),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(25),
                                    // topLeft: Radius.circular(25.0),
                                    // topRight: Radius.circular(25.0)
                                // ),
                              ),
                            ),
                          ),
                        ),
                        //Text and progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25.0),
                              bottomRight: Radius.circular(25.0)
                          ),
                          child:  Container(
                            width: cardWidth,
                            height: cardHeight*.3 - 24 - 15,
                            child: Center(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Container(
                                      child: AutoSizeText(
                                        widget.show.name!,
                                        minFontSize: 10.roundToDouble(),
                                        maxFontSize: 20.roundToDouble(),
                                        stepGranularity: 2,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: ShowTheme.listWatchCardTitleStyle,
                                      ),
                                    ),
                                  ),
                                  _checkFinishedShow(cardWidth),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: cardHeight*.6,
                  left: 15,
                  child: _addToFavorites(widget.show),
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
    }
    else{
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
        child: InkWell(
          onTap: (){
            showModalBottomSheet<dynamic>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0)),
                ),
                context: context,
                builder: (_) {
                  return createRouteShowDetail(widget.show, _width, _height);
                },
                isScrollControlled: true);
          },
          child: Container(
            width: _width * .9,
            height: cardHeight,
            // color: Colors.blue,
            child: Stack(
              children: [
                Container(
                  width: _width * .9,
                  height: cardHeight,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(25.0),
                      bottomLeft: Radius.circular(50.0),
                      bottomRight: Radius.circular(25.0),),
                    boxShadow: [
                      const BoxShadow(
                          color: Colors.grey,
                          blurRadius: 20.0,
                          spreadRadius: -2,
                          offset: Offset(0, 3)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: _width*.35,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(widget.show.imageThumbnailPath!),
                              fit: BoxFit.cover),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              bottomLeft: Radius.circular(25.0)
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25.0),
                            bottomRight: Radius.circular(25.0)
                        ),
                        child:  Container(
                          width: _width*.55,
                          child: new Center(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: AutoSizeText(
                                      widget.show.name!,
                                      minFontSize: (_width/20).roundToDouble(),
                                      maxFontSize: (_width/10).roundToDouble(),
                                      stepGranularity: .1,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: ShowTheme.listWatchCardTitleStyle,
                                    ),
                                  ),
                                ),
                                _checkFinishedShow(cardWidth),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: _addToFavorites(widget.show),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      // left: _width/2,
                      child: Padding(
                        padding: const EdgeInsets.only(left:50.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.show.calculateProgress() == 1.0
                                ? Container(
                              child: Badge(description: "Finished",icon: FontAwesomeIcons.checkDouble, colors:[GlobalColors.greenColor, Colors.greenAccent], size: _height/20,),
                            )
                                : Container(
                              height: 1,
                              width: 1,
                            ),
                            _ratingBadge(),
                          ],
                        ),
                      )
                  ),
                ),

              ],
            ),
          ),
        ),
      );
    }

  }

  Widget _checkFinishedShow(double cardWidth) {
    double _width = Get.size.width;
    if ( widget.show.calculateProgress() == 1.0){
      if ( kIsWeb){
        return Container(
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(12)
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeText(
                  widget.show.stopWatch().toString(), //days
                  minFontSize: 20.roundToDouble(),
                  maxFontSize: 25.roundToDouble(),
                  style: ShowTheme.listWatchCardDaysStyle
                ),
                AutoSizeText(
                  "Days to finish",
                  style: ShowTheme.listWatchCardSubStyle,
                  minFontSize: 20,
                  maxFontSize: 25,

                ),
              ],
            ),
          ),
        );
      }
      else{
        return Container(
          child: Column(
            children: [
              AutoSizeText(
                widget.show.stopWatch().toString(), //days
                style: ShowTheme.listWatchCardDaysStyle,
              ),
              AutoSizeText(
                "Days to finish",
                style: ShowTheme.listWatchCardSubStyle,
                minFontSize: 20,
                maxFontSize: 25,
              ),
            ],
          ),
        );
      }
    }
    else{
      return Container(
        child:
        kIsWeb? Container(height: 1,): CircularPercentIndicator(
          radius: cardWidth/4,
          lineWidth: 10,
          progressColor: GlobalColors.blueColor,
          animation: true,
          backgroundColor: Colors.grey.shade100,
          circularStrokeCap: CircularStrokeCap.round,
          percent: widget.show.calculateProgress(),
          center: new Text(
              "${(widget.show.calculateProgress() * 100).floor()} %",
              style: ShowTheme.listWatchCardPercentStyle
          ),
        ),
      );
    }

  }

  Widget _addToFavorites(WatchedTVShow show) {
    final double _width = Get.size.width;
    final double _height = Get.size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:5.0),
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
                timeInSecForIosWeb: 2
            );
          }
          else{
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
                timeInSecForIosWeb: 2
            );
          }
        },
        child: ClipOval(
          child: Container(
              height: _height/20,
              width: _height/20,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  color: GlobalColors.pinkColor
              ),
              child:
              Center(
                child: FaIcon(
                  _icon,
                  color: Colors.white,
                  size: _height/30,
                ),
              )
          ),
        ),
      ),
    );
  }

  Widget _ratingBadge() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    // print(widget.show.rating);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: InkWell(
        onTap: () {
          Fluttertoast.showToast(
              msg: "The rating of this show is ${widget.show.rating}",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: GlobalColors.goldColor,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2
          );
        },
        child: Container(
          child: ClipOval(
            child: Container(
                height: _height/20,
                width: _height/20,
                decoration: const BoxDecoration(
                  borderRadius: ShowTheme.radius25,
                  gradient: LinearGradient(
                      colors: [GlobalColors.goldColor, GlobalColors.lightGoldColor]
                  ),
                ),
                child:
                Center(
                    child: Text(
                        widget.show.rating!.toString(),
                        style: ShowTheme.listWatchCardBadgeStyle
                    )
                )
            ),
          ),
        ),
      ),
    );
  }
}





createRouteShowDetail(WatchedTVShow show, double _width, double _height) {
  var episodes = new Network().getEpisodes(showID: show.id);
  return ClipRRect(
    borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
    child: FutureBuilder<List<Episode>>(
        future: episodes,
        builder: (context, snapshot) {
          print(snapshot.error);
          if ( snapshot.hasData){
            show.episodes = snapshot.data as List<Episode>;
            return WatchedDetailView(show: show);
          }
          else{
            return WatchedDetailViewPlaceholder();
          }
        }
    ),
  );
}