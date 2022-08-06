import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/constants/theme_utils.dart';
import 'package:show_time/features/watchlist/presentation/widgets/watchlist_card.dart';
import 'package:show_time/get_controllers/ui_controller.dart';
import 'package:show_time/features/home/data/models/watched.dart';
import 'package:show_time/network/firebase_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';

class WatchedCardWeb extends StatelessWidget {
  final WatchedTVShow show;
  final double maxWidth;
  final double maxHeight;

  WatchedCardWeb(
      {Key? key,
      required this.show,
      required this.maxWidth,
      required this.maxHeight})
      : super(key: key);

  final UIController? uiController = Get.put(UIController());

  @override
  Widget build(BuildContext context) {
    return buildWatchedCard(context);
  }

  Widget buildWatchedCard(BuildContext context) {
    final double _percentage = show.calculatedProgress;
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet<dynamic>(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0)),
            ),
            context: context,
            builder: (BuildContext context) {
              return buildShowDetails(show, _width, _height);
            },
            isScrollControlled: true);
      },
      child: Container(
        padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
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
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(85.0),
                          bottomLeft: Radius.circular(50.0),
                          bottomRight: Radius.circular(50.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.2),
                              blurRadius: 15.0,
                              spreadRadius: -2,
                              offset: const Offset(2, -2)),
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
                                      padding: const EdgeInsets.only(
                                          right: 50, left: 12, top: 5),
                                      child: AutoSizeText(
                                        show.name!,
                                        minFontSize:
                                            (maxWidth / 10).roundToDouble(),
                                        maxFontSize:
                                            (maxWidth / 5).roundToDouble(),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                width: maxWidth * .35,
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 20),
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      //Season
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        width: maxWidth / 3.5,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          border: Border.all(
                                              color:
                                                  GlobalColors.primaryGreen),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "S",
                                              style: TextStyle(
                                                color:
                                                    GlobalColors.primaryGreen,
                                                fontSize: maxWidth / 12,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                "${show.currentSeason}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: maxWidth / 15,
                                                  color: GlobalColors
                                                      .greyTextColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //Episode
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        width: maxWidth / 3.5,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          border: Border.all(
                                              color:
                                                  GlobalColors.primaryGreen),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Ep",
                                              style: TextStyle(
                                                color:
                                                    GlobalColors.primaryGreen,
                                                fontSize: maxWidth / 12,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                "${show.currentEpisode}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: maxWidth / 15,
                                                  color: GlobalColors
                                                      .greyTextColor,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10),
                                child: CircularPercentIndicator(
                                  radius: maxWidth / 3,
                                  lineWidth: 12.0,
                                  circularStrokeCap: CircularStrokeCap.round,
                                  percent: _percentage,
                                  center: AutoSizeText(
                                    "${(_percentage * 100).floor()} %",
                                    // maxFontSize: _width / 15,
                                    // minFontSize: _width / 23,
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: maxWidth / 10,
                                        fontWeight: FontWeight.w700,
                                        color: GlobalColors.primaryBlue),
                                  ),
                                  progressColor: GlobalColors.primaryBlue,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  _checkFireDisplay(_percentage, show.lastWatchDate!),
                  floatingActions(context, _percentage),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _checkFireDisplay(double percentage, String lastWatchDate) {
    var lastWatched = DateTime.parse("$lastWatchDate 00:00:00.000");
    var prevMonth = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
    int diffDays = lastWatched.difference(prevMonth).inDays;
    // print(percentage);
    if (diffDays.abs() < 15) {
      return Positioned(
        right: 5,
        top: 5,
        child: ClipOval(
          child: Container(
            width: maxWidth / 6,
            height: maxWidth / 6,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    percentage == 1.0
                        ? GlobalColors.primaryGreen
                        : GlobalColors.fireColor,
                    percentage == 1.0
                        ? GlobalColors.lightGreenColor
                        : Colors.orange,
                  ]),
              color: percentage == 1.0
                  ? GlobalColors.primaryGreen
                  : GlobalColors.fireColor,
              borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            ),
            child: Center(
              child: FaIcon(
                percentage == 1.0
                    ? FontAwesomeIcons.checkDouble
                    : FontAwesomeIcons.fire,
                size: maxWidth / 9,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    } else {
      if (percentage == 1.0) {
        return Positioned(
          right: 0,
          top: 0,
          child: ClipOval(
            child: Container(
              width: maxHeight / 10,
              height: maxHeight / 10,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      GlobalColors.primaryGreen,
                      GlobalColors.lightGreenColor,
                    ]),
                color: GlobalColors.primaryGreen,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.checkDouble,
                  size: maxHeight / 15,
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

  Widget floatingActions(BuildContext context, double _percentage) {
    if (_percentage < 1.0) {
      return Positioned(
        top: maxHeight - 30,
        left: maxWidth / 5,
        child: Container(
          height: 60,
          width: maxWidth * .5,
          decoration: BoxDecoration(
            color: GlobalColors.pinkColor,
            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            boxShadow: [
              BoxShadow(
                  color: GlobalColors.pinkColor.withOpacity(.3),
                  blurRadius: 15.0,
                  spreadRadius: -2,
                  offset: const Offset(2, 0)),
            ],
          ),
          child: GetBuilder<UIController>(
              init: uiController,
              builder: (controller) {
                return TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0))),
                  ),
                  onPressed: () {
                    try {
                      show.incrementEpisodeWatch();
                      show.setLastWatchedDate();
                      FirestoreUtils().updateEpisode(show);
                      controller.showToast(
                          context: context,
                          color: GlobalColors.primaryGreen,
                          text: "Episode added!",
                          icon: Icons.done);
                    } catch (e) {
                      controller.showToast(
                          context: context,
                          color: GlobalColors.primaryGreen,
                          text: "Couldn't add episode!",
                          icon: Icons.error);
                    }
                  },
                  child: const FaIcon(
                    Icons.add_to_queue,
                    color: Colors.white,
                    size: 40,
                  ),
                );
              }),
        ),
      );
    } else {
      return Container();
    }
  }
}
