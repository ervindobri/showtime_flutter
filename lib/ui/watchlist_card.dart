import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/constants/theme_utils.dart';
import 'package:eWoke/models/watched.dart';
import 'package:eWoke/network/firebase_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WatchedCardInList extends StatefulWidget {
  final WatchedTVShow show;

  const WatchedCardInList({Key key, this.show}) : super(key: key);

  @override
  _WatchedCardInListState createState() => _WatchedCardInListState();
}

class _WatchedCardInListState extends State<WatchedCardInList> {
  IconData _icon = FontAwesomeIcons.heart;

  bool _added = true;

  @override
  void initState() {
    super.initState();
    _icon = widget.show.favorite ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart;
    checkFavorite();
  }


  checkFavorite() async{
    _added = await FirestoreUtils().isFavorite(widget.show.id);
    widget.show.favorite = _added;
    print(_added);
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double _percentage = widget.show.calculateProgress();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: _width * .9,
        height: _width/2,
        child: Stack(
          children: [
            Container(
              width: _width * .9,
              height: _height/3.5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(25.0),
                  bottomLeft: Radius.circular(50.0),
                  bottomRight: Radius.circular(25.0),),
                boxShadow: [
                  new BoxShadow(
                      color: Colors.grey.withOpacity(1),
                      blurRadius: 20.0,
                      spreadRadius: -2,
                      offset: Offset(0, 3)),
                ],
              ),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.show.imageThumbnailPath,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          boxShadow: [ new BoxShadow(
                              color: Colors.black.withOpacity(.5),
                              blurRadius: 5.0,
                              spreadRadius:-2,
                              offset: Offset(2, 5)),
                          ],
                        ),
                      );
                    },
                    placeholder: (context, url) => CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CachedNetworkImage(
                          imageUrl: widget.show.imageThumbnailPath,
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              width: _width*.35,
                              decoration: BoxDecoration(
                                boxShadow: [ new BoxShadow(
                                    color: Colors.grey.withOpacity(.3),
                                    blurRadius: 25.0,
                                    spreadRadius: -4,
                                    offset: Offset(0, 0)),],
                                image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25.0),
                                    bottomLeft: Radius.circular(25.0)
                                ),
                              ),
                            );
                          },
                          placeholder: (context, url) => Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),)),
                          errorWidget: (context, url, error) => Center(child: Icon(Icons.error, color: Colors.white,),),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25.0),
                            bottomRight: Radius.circular(25.0)
                        ),
                        child:  BackdropFilter(
                          filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child:  Container(
                            width: _width*.55,
                            decoration:  BoxDecoration(
                              color: Colors.black.withOpacity(.33),
                              borderRadius: BorderRadius.only(
                                // topRight: Radius.circular(25.0),
                                // bottomRight: Radius.circular(25.0),
                              ),
                            ),
                            child: new Center(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: AutoSizeText(
                                        widget.show.name,
                                        minFontSize: (_width/20).roundToDouble(),
                                        maxFontSize: (_width/10).roundToDouble(),
                                        stepGranularity: .1,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: ShowTheme.listWatchCardTitleStyle,
                                      ),
                                    ),
                                  ),
                                  _checkFinishedShow(context, _percentage),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                // left: _width/2,
                child: Padding(
                  padding: const EdgeInsets.only(left:50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _addToFavorites(context, widget.show),
                      _percentage == 1.0
                          ? Container(
                        child: GlobalVariables.allBadges['finished'],
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

          ],
        ),
      ),
    );
  }

  Widget _checkFinishedShow(BuildContext context, double _percentage) {
    double _width = MediaQuery.of(context).size.width;
    // double _height = MediaQuery.of(context).size.height;
    if ( _percentage == 1.0){
      return Container(
        child: Column(
          children: [
            Text(
              widget.show.stopWatch().toString(), //days
              style: ShowTheme.listWatchCardDaysStyle,
            ),
            AutoSizeText(
              "Days to finish",
              style: ShowTheme.listWatchCardSubStyle,
            ),
          ],
        ),
      );
    }
    else{
      return Container(
        child: Center(
          child: CircularPercentIndicator(
            radius: _width/4,
            lineWidth: 10,
            progressColor: GlobalColors.blueColor,
            animation: true,
            backgroundColor: Colors.white,
            circularStrokeCap: CircularStrokeCap.round,
            percent: _percentage,
            center: new Text(
                "${(_percentage * 100).floor()} %",
                style: ShowTheme.listWatchCardPercentStyle
            ),
          ),
        ),
      );
    }

  }

  Widget _addToFavorites(BuildContext context, WatchedTVShow show) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:5.0),
      child: InkWell(
        onTap: () async {
          // print("tapped");
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
                backgroundColor: GlobalColors.greenColor,
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
                backgroundColor: GlobalColors.greenColor,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 2
            );

          }

        },
        child: ClipOval(
          child: Container(
              height: _height/10,
              width: _height/10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  color: GlobalColors.pinkColor
              ),
              child:
              Center(
                child: FaIcon(
                  _icon,
                  color: Colors.white,
                  size: _width/10,
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
      child: Container(
        child: ClipOval(
          child: Container(
              height: _height/10,
              width: _height/10,
              decoration: const BoxDecoration(
                borderRadius: ShowTheme.radius25,
                gradient: LinearGradient(
                    colors: [GlobalColors.goldColor, GlobalColors.lightGoldColor]
                ),
              ),
              child:
              Center(
                  child: Text(
                      widget.show.rating.toString() ?? "0.0",
                      style: ShowTheme.listWatchCardBadgeStyle
                  )
              )
          ),
        ),
      ),
    );
  }
}