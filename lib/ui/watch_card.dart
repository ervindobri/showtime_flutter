import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:show_time/constants/custom_variables.dart';
import 'package:show_time/constants/theme_utils.dart';
import 'package:show_time/get_controllers/ui_controller.dart';
import 'package:show_time/models/watched.dart';
import 'package:show_time/network/firebase_utils.dart';
import 'package:show_time/ui/watchlist_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';


// ignore: must_be_immutable
class WatchedCard extends StatelessWidget {
  final WatchedTVShow show;
  WatchedCard({Key? key, required this.show}) : super(key: key);



  UIController? uiController = Get.put(UIController());


  @override
  Widget build(BuildContext context) {
    return buildWatchedCard(context);
  }

  Widget buildWatchedCard(BuildContext context) {
    double _percentage = show.calculateProgress();
    double _height = Get.height;
    double _width = Get.width;
    return InkWell(
        onTap: () {
      showModalBottomSheet<dynamic>(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0)),
          ),
          context: context,
          builder: (BuildContext context) {
            return createRouteShowDetail(show,  _width, _height);
          },
          isScrollControlled: true);
      // Navigator.push(context, _createRouteShowDetail(data, itemIndex)),
    },
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
          child: InkWell(
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 15,
                        left: 0,
                        right: 0,
                        child: Container(
                          // height: ,
                          height: _width/2.1,
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
                                                    this.show.name!,
                                                    minFontSize: (_width/20).roundToDouble(),
                                                    maxFontSize: (_width/10).roundToDouble(),
                                                    stepGranularity: .1,
                                                    maxLines: 1,
                                                    style: ShowTheme.watchCardTitleStyle,
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
                                              width: _width/3.5,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                border:
                                                    Border.all(color: GlobalColors.greenColor),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    "S",
                                                    style: TextStyle(
                                                      color: GlobalColors.greenColor,
                                                      fontSize: Get.width / 12,
                                                      fontWeight: FontWeight.w900,
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      "${this.show.currentSeason}",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: Get.width / 15,
                                                        color: GlobalColors.greyTextColor,
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
                                              width:  _width/3.5,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:BorderRadius.circular(25.0),
                                                border:
                                                    Border.all(color: GlobalColors.greenColor),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    "Ep",
                                                    style: TextStyle(
                                                      color: GlobalColors.greenColor,
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
                                                        color: GlobalColors.greyTextColor,
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
                                        radius: _width/4,
                                        lineWidth: 12.0,
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        percent: _percentage,
                                        center: AutoSizeText(
                                          "${(_percentage * 100).floor()} %",
                                          // maxFontSize: _width / 15,
                                          // minFontSize: _width / 23,
                                          style: TextStyle(
                                              fontFamily: 'Raleway',
                                              fontSize: _width / 15,
                                              fontWeight: FontWeight.w700,
                                              color: GlobalColors.blueColor),
                                        ),
                                        progressColor: GlobalColors.blueColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      _checkFireDisplay(context, _percentage, show.lastWatchDate!),
                      floatingActions(context, _percentage, _width/2.5),

                    ],
                  ),
                  splashColor: Colors.blue.withAlpha(30),
                ),
        ),
      )
    );
  }
  Widget _checkFireDisplay(BuildContext context, double percentage, String lastWatchDate){
    var lastWatched = DateTime.parse("$lastWatchDate 00:00:00.000");
    var prevMonth = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    int diffDays = lastWatched.difference(prevMonth).inDays;
    // print(percentage);
    if ( diffDays.abs() < 15){
      return Positioned(
        right: 5,
        top: 5,
        child: ClipOval(
          child: Container(
            width: Get.width/6,
            height: Get.width/6,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    percentage == 1.0 ? GlobalColors.greenColor : GlobalColors.fireColor,
                    percentage == 1.0 ? GlobalColors.lightGreenColor : Colors.orange,
                  ]),
              color: percentage == 1.0 ? GlobalColors.greenColor : GlobalColors.fireColor,
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
            ),
            child: Center(
              child: FaIcon(
                percentage == 1.0 ? FontAwesomeIcons.checkDouble : FontAwesomeIcons.fire,
                size: Get.width/9,
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
              width: Get.height/10,
              height: Get.height/10,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      GlobalColors.greenColor,
                      GlobalColors.lightGreenColor,
                    ]),
                color: GlobalColors.greenColor,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.checkDouble,
                  size: Get.height/15,
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
        bottom: 60/5,
        left: cardWidth/2,
        child: Container(
          height: 60,
          width: cardWidth*.7,
          decoration: BoxDecoration(
            color: GlobalColors.pinkColor,
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            boxShadow: [
              new BoxShadow(
                  color: GlobalColors.pinkColor.withOpacity(.3),
                  blurRadius: 15.0,
                  spreadRadius: -2,
                  offset: Offset(2, 0)),
            ],
          ),
          child: GetBuilder<UIController>(
            init: uiController,
            builder: (controller) {
              return TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.black),
                  shape: MaterialStateProperty.
                  all<RoundedRectangleBorder>(new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0))),
                ),
                onPressed: (){
                  try {
                    show.incrementEpisodeWatch();
                    show.setLastWatchedDate();
                    FirestoreUtils().updateEpisode(show);
                    controller.showAlert(title: "Episode added!",
                        seconds: 2,
                        blurPower: 15,
                        icon: Icons.done);
                  } catch (e) {
                    controller.showAlert(title: "Couldn\'t add episode!",
                        seconds: 2,
                        blurPower: 15,
                        icon: Icons.error);
                  }
                },
                child: FaIcon(
                  Icons.add_to_queue,
                  color: Colors.white,
                  size: 40,
                ),
              );
            }
          ),
        ),
      );
    }
    else{
      return Container();
    }
  }
}

class WatchedCardWeb extends StatelessWidget {
  final WatchedTVShow show;
  final double maxWidth;
  final double maxHeight;

  WatchedCardWeb({Key? key, required this.show, required this.maxWidth, required this.maxHeight}) : super(key: key);

  UIController? uiController = Get.put(UIController());

  @override
  Widget build(BuildContext context) {
    return buildWatchedCard(context);
  }

  Widget buildWatchedCard(BuildContext context) {
    final double _percentage = show.calculateProgress();
    final double _width = Get.width;
    final double _height = Get.height;

    return GestureDetector(
      onTap: (){
        showModalBottomSheet<dynamic>(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0)),
            ),
            context: context,
            builder: (BuildContext context) {
              return createRouteShowDetail(show, _width, _height);
            },
            isScrollControlled: true);
      },
      child: Container(
        padding: const EdgeInsets.only(
            top: 15,
            right: 15,
            left: 15
        ),
        width: maxWidth,
        height: maxHeight,
        child: Center(
          child: Stack(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Positioned(
                    top: 15,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: maxWidth,
                      height: maxHeight,
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
                                        this.show.name!,
                                        minFontSize: (maxWidth/10).roundToDouble(),
                                        maxFontSize: (maxWidth/5).roundToDouble(),
                                        stepGranularity: 1,
                                        maxLines: 2,
                                        style: ShowTheme.watchCardTitleStyle,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  width: maxWidth * .35,
                                  padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
                                  child: Center(
                                    child: Column(
                                      children: <Widget>[
                                        //Season
                                        Container(
                                          padding: EdgeInsets.only(left: 10, right: 10),
                                          width: maxWidth/3.5,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(25.0),
                                            border:
                                            Border.all(color: GlobalColors.greenColor),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "S",
                                                style: TextStyle(
                                                  color: GlobalColors.greenColor,
                                                  fontSize: maxWidth / 12,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                  "${this.show.currentSeason}",
                                                  style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.w300,
                                                    fontSize: maxWidth / 15,
                                                    color: GlobalColors.greyTextColor,
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
                                          width:  maxWidth/3.5,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:BorderRadius.circular(25.0),
                                            border:
                                            Border.all(color: GlobalColors.greenColor),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "Ep",
                                                style: TextStyle(
                                                  color: GlobalColors.greenColor,
                                                  fontSize:
                                                  maxWidth / 12,
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
                                                    maxWidth /
                                                        15,
                                                    color: GlobalColors.greyTextColor,
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
                                    radius: maxWidth/3,
                                    lineWidth: 12.0,
                                    circularStrokeCap:
                                    CircularStrokeCap.round,
                                    percent: _percentage,
                                    center: AutoSizeText(
                                      "${(_percentage * 100).floor()} %",
                                      // maxFontSize: _width / 15,
                                      // minFontSize: _width / 23,
                                      style: TextStyle(
                                          fontFamily: 'Raleway',
                                          fontSize: maxWidth / 10,
                                          fontWeight: FontWeight.w700,
                                          color: GlobalColors.blueColor),
                                    ),
                                    progressColor: GlobalColors.blueColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  _checkFireDisplay( _percentage, show.lastWatchDate!),
                  floatingActions(context, _percentage),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _checkFireDisplay( double percentage, String lastWatchDate){
    var lastWatched = DateTime.parse("$lastWatchDate 00:00:00.000");
    var prevMonth = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    int diffDays = lastWatched.difference(prevMonth).inDays;
    // print(percentage);
    if ( diffDays.abs() < 15){
      return Positioned(
        right: 5,
        top: 5,
        child: ClipOval(
          child: Container(
            width: maxWidth/6,
            height: maxWidth/6,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    percentage == 1.0 ? GlobalColors.greenColor : GlobalColors.fireColor,
                    percentage == 1.0 ? GlobalColors.lightGreenColor : Colors.orange,
                  ]),
              color: percentage == 1.0 ? GlobalColors.greenColor : GlobalColors.fireColor,
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
            ),
            child: Center(
              child: FaIcon(
                percentage == 1.0 ? FontAwesomeIcons.checkDouble : FontAwesomeIcons.fire,
                size: maxWidth/9,
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
              width: maxHeight/10,
              height: maxHeight/10,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      GlobalColors.greenColor,
                      GlobalColors.lightGreenColor,
                    ]),
                color: GlobalColors.greenColor,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.checkDouble,
                  size: maxHeight/15,
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

  Widget floatingActions( BuildContext context, double _percentage) {
    if ( _percentage < 1.0){
      return Positioned(
        top: maxHeight - 30,
        left: maxWidth/5,
        child: Container(
          height: 60,
          width: maxWidth*.5,
          decoration: BoxDecoration(
            color: GlobalColors.pinkColor,
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            boxShadow: [
              new BoxShadow(
                  color: GlobalColors.pinkColor.withOpacity(.3),
                  blurRadius: 15.0,
                  spreadRadius: -2,
                  offset: Offset(2, 0)),
            ],
          ),
          child: GetBuilder<UIController>(
              init: uiController,
              builder: (controller) {
              return TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.black),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0))),
                ),
                onPressed: (){
                  try {
                    show.incrementEpisodeWatch();
                    show.setLastWatchedDate();
                    FirestoreUtils().updateEpisode(show);
                    controller.showAlert(title:"Episode added!", seconds: 2, blurPower: 15, icon: Icons.done);

                  } catch (e) {
                    controller.showAlert(title:"Couldn\'t add episode!", seconds: 2, blurPower: 15, icon: Icons.error);
                  }
                },
                child: FaIcon(
                  Icons.add_to_queue,
                  color: Colors.white,
                  size: 40,
                ),
              );
            }
          ),
        ),
      );
    }
    else{
      return Container();
    }
  }
}







