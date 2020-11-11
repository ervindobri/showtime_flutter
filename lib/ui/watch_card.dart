import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/models/watched.dart';
import 'package:eWoke/network/firebase_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:status_alert/status_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flip_card/flip_card.dart';
import 'package:cached_network_image/cached_network_image.dart';


class WatchedCard extends StatelessWidget {
  final WatchedTVShow show;

  const WatchedCard({Key key, this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildWatchedCard(context);
  }

  Widget buildWatchedCard(BuildContext context) {
    GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
    double _percentage = show.calculateProgress();
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onVerticalDragStart: (details) => cardKey.currentState.toggleCard(),
      child: Container(
        padding: const EdgeInsets.only(
          top: 15,
          // bottom: 10,
            right: 15,
            left: 15
        ),
        decoration: BoxDecoration(
          // color: Colors.black,
        ),
        child: Center(
            child: Stack(
              children: <Widget>[
                FlipCard(
                  direction: FlipDirection.VERTICAL,
                  flipOnTouch: false,
                  key: cardKey,
                  front: InkWell(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 15,
                          left: 0,
                          right: 0,
                          child: Container(
                            // height: ,
                            height: _width/2,
                            width: _width,
                            decoration: BoxDecoration(
                              color:Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(85.0),
                                bottomLeft: Radius.circular(50.0),
                                bottomRight: Radius.circular(50.0),
                              ),
                              boxShadow: [
                                new BoxShadow(
                                    color: Colors.black.withOpacity(.2),
                                    blurRadius: 15.0,
                                    spreadRadius: -2,
                                    offset: Offset(2, -2)),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                            child: Padding(
                                              padding: EdgeInsets.only(right:50, left: 12, top: 5),
                                                child: AutoSizeText(
                                                      this.show.name,
                                                      minFontSize: 10,
                                                      maxFontSize: 17,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w700,
                                                        color: greyTextColor,
                                                        fontSize: MediaQuery.of(context).size.height/30,
                                                        fontFamily: 'Raleway',
                                                      ),
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  // height: 300,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: _width * .35,
                                        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
                                        child: Center(
                                          child: Column(
                                            children: <Widget>[
                                              //Season
                                              Container(
                                                padding: EdgeInsets.only(left: 10, right: 10),
                                                width: _width/4,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25.0),
                                                  border:
                                                      Border.all(color: greenColor),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      "S",
                                                      style: TextStyle(
                                                        color: greenColor,
                                                        fontSize: MediaQuery.of(context).size.width / 12,
                                                        fontWeight: FontWeight.w900,
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        "${this.show.currentSeason}",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: MediaQuery.of(context).size.width / 15,
                                                          color: greyTextColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //Episode
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(left: 10, right: 10),
                                                width:  _width/4,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:BorderRadius.circular(25.0),
                                                  border:
                                                      Border.all(color: greenColor),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      "Ep",
                                                      style: TextStyle(
                                                        color: greenColor,
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                12,
                                                        fontWeight: FontWeight.w900,
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        "${this.show.currentEpisode}",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize:
                                                              MediaQuery.of(context)
                                                                      .size
                                                                      .width /
                                                                  15,
                                                          color: greyTextColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                                        child: new CircularPercentIndicator(
                                          radius: 80.0,
                                          lineWidth: 12.0,
                                          circularStrokeCap:
                                              CircularStrokeCap.round,
                                          percent: _percentage,
                                          center: new Text(
                                            "${(_percentage * 100).floor()} %",
                                            style: TextStyle(
                                                fontFamily: 'Raleway',
                                                fontSize: MediaQuery.of(context).size.width / 15,
                                                fontWeight: FontWeight.w700,
                                                color: blueColor),
                                          ),
                                          progressColor: blueColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        _checkFireDisplay(context, _percentage, show.lastWatchDate),
                        floatingActions(context, _percentage, _width/2.5),

                      ],
                    ),
                    splashColor: Colors.blue.withAlpha(30),
                  ),
                  back: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: show.imageThumbnailPath,
                              imageBuilder: (context, image){
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(.5),
                                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                    image: DecorationImage(
                                      image: image,
                                      fit: BoxFit.cover
                                    ),
                                  ),
                                );
                              },
                            ),
                            BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              child: CachedNetworkImage(
                                imageUrl: show.imageThumbnailPath,
                                imageBuilder: (context, image){
                                  return Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: image,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
    );
  }
  Widget _checkFireDisplay(BuildContext context, double percentage, String lastWatchDate){
    var lastWatched = DateTime.parse("$lastWatchDate 00:00:00.000");
    var prevMonth = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    int diffDays = lastWatched.difference(prevMonth).inDays;
    // print(percentage);
    if ( diffDays.abs() < 15){
      return Positioned(
        right: 0,
        top: 0,
        child: ClipOval(
          child: Container(
            width: MediaQuery.of(context).size.height/10,
            height: MediaQuery.of(context).size.height/10,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    percentage == 1.0 ? greenColor : fireColor,
                    percentage == 1.0 ? lightGreenColor : Colors.orange,
                  ]),
              color: percentage == 1.0 ? greenColor : fireColor,
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
            ),
            child: Center(
              child: FaIcon(
                percentage == 1.0 ? FontAwesomeIcons.checkDouble : FontAwesomeIcons.fire,
                size: MediaQuery.of(context).size.height/15,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }
    else{
      if ( percentage == 1.0){
        return Positioned(
          right: 0,
          top: 0,
          child: ClipOval(
            child: Container(
              width: MediaQuery.of(context).size.height/10,
              height: MediaQuery.of(context).size.height/10,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      greenColor,
                      lightGreenColor,
                    ]),
                color: greenColor,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.checkDouble,
                  size: MediaQuery.of(context).size.height/15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      }
      return Container();
    }
  }

  Widget floatingActions( BuildContext context, double _percentage, double cardWidth) {
    if ( _percentage < 1.0){
      return Positioned(
        bottom: 5,
        left: cardWidth/2,
        child: Container(
          height: 60,
          width: 100,
          decoration: BoxDecoration(
            color: pinkColor,
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            boxShadow: [
              new BoxShadow(
                  color: pinkColor.withOpacity(.3),
                  blurRadius: 15.0,
                  spreadRadius: -2,
                  offset: Offset(2, 0)),
            ],
          ),
          child: FlatButton(
            highlightColor: Colors.black,
            // color: greenColor,
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0)),
            onPressed: (){
              try {
                show.incrementEpisodeWatch();
                show.setLastWatchedDate();
                FirestoreUtils().updateEpisode(show);
                StatusAlert.show(context,
                  duration:
                  Duration(
                      seconds:
                      2),
                  blurPower: 15.0,
                  title:
                  'Episode added',
                  configuration:
                  IconConfiguration(
                      icon: Icons
                          .done),
                );
              } catch (e, s) {
                // print(s);
                StatusAlert.show(
                  context,
                  duration:
                  Duration(
                      seconds:
                      2),
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
            child: FaIcon(
              Icons.add_to_queue,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      );
    }
    else{
      return Container();
    }
  }
}


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
    // TODO: implement initState
    super.initState();
    _icon = widget.show.favorite ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart;
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
                                filter:  ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                                child:  Container(
                                width: _width*.55,
                                  decoration:  BoxDecoration(
                                      color: Colors.black.withOpacity(0.66),
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
                                              minFontSize: 15,
                                              maxFontSize: 20,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                shadows: [
                                                  new Shadow(
                                                    color: Colors.black,
                                                    blurRadius: 15,
                                                  )
                                                ],
                                                color: Colors.white,
                                                fontFamily: 'Raleway',
                                                fontWeight: FontWeight.w700,
                                                // fontSize: _width / 15,
                                              ),
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
                                    child: allBadges['finished'],
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
    double _height = MediaQuery.of(context).size.height;
    if ( _percentage == 1.0){
      return Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: [
              Text(
                widget.show.stopWatch().toString(),
                style: TextStyle(
                  shadows: [
                    new Shadow(
                      color: Colors.black,
                      blurRadius: 15,
                    )
                  ],
                  color: Colors.white,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w700,
                  fontSize: _width / 10,
                ),
              ),
              AutoSizeText(
                "Days to finish",
                style: TextStyle(
                  shadows: [
                    new Shadow(
                      color: Colors.black,
                      blurRadius: 15,
                    )
                  ],
                  color: Colors.white,
                  fontFamily: 'Raleway',
                  fontSize: _width / 20,
                ),
              ),
            ],
          ),
        ),
      );
    }
    else{
      return Container(
        child: Center(
          child: CircularPercentIndicator(
            radius: _width/4,
            lineWidth: 10,
            progressColor: blueColor,
            animation: true,
            backgroundColor: Colors.white,
            circularStrokeCap: CircularStrokeCap.round,
            percent: _percentage,
            center: new Text(
              "${(_percentage * 100).floor()} %",
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: _width/ 15,
                  fontWeight: FontWeight.w700,
                  color: blueColor),
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
            favorites.add(show);
            setState(() {
              _icon = FontAwesomeIcons.solidHeart;
              _added = true;
            });
            Fluttertoast.showToast(
                msg: "${widget.show.name} added to favorites!",
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: greenColor,
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
                backgroundColor: greenColor,
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
              color: pinkColor
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
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: goldColor
            ),
            child:
            Center(
              child: Text(
                widget.show.rating.toString() ?? "0.0",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w700,
                  fontSize: _width / 15,
                ),
              )
            )
        ),
      ),
  ),
    );
  }
}




