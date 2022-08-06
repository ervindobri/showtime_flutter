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
    double _percentage = show.calculatedProgress;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return InkWell(
        onTap: () {
          showModalBottomSheet<dynamic>(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24)),
              ),
              context: context,
              builder: (BuildContext context) {
                return buildShowDetails(show, _width, _height);
              },
              isScrollControlled: true);
        },
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: <Widget>[
            Container(
              width: _width,
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
                              child: Text(
                                show.name!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: ShowTheme.watchCardTitleStyle.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              //Season
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                width: _width / 3.5,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                  border: Border.all(
                                      color: GlobalColors.primaryGreen),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "S",
                                      style: TextStyle(
                                        color: GlobalColors.primaryGreen,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                12,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "${show.currentSeason}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: MediaQuery.of(context)
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
                              //Episode
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                width: _width / 3.5,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                  border: Border.all(
                                      color: GlobalColors.primaryGreen),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Ep",
                                      style: TextStyle(
                                        color: GlobalColors.primaryGreen,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                12,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "${show.currentEpisode}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: MediaQuery.of(context)
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
                          child: CircularPercentIndicator(
                            radius: _width / 4,
                            lineWidth: 12.0,
                            circularStrokeCap: CircularStrokeCap.round,
                            percent: _percentage,
                            center: Text(
                              "${(_percentage * 100).floor()} %",
                              style: const TextStyle(
                                  fontFamily: 'Helvetica',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: GlobalColors.primaryBlue),
                            ),
                            progressColor: GlobalColors.primaryBlue,
                            backgroundColor:
                                GlobalColors.primaryBlue.withOpacity(.2),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            _checkFireDisplay(context, _percentage, show.lastWatchDate!),
            floatingActions(context, _percentage, _width / 2.5),
          ],
        ));
  }

  Widget _checkFireDisplay(
      BuildContext context, double percentage, String lastWatchDate) {
    var lastWatched = DateTime.parse("$lastWatchDate 00:00:00.000");
    var prevMonth =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    int diffDays = lastWatched.difference(prevMonth).inDays;
    // print(percentage);

    if (diffDays.abs() < 15) {
      return Positioned(
        right: 5,
        top: 5,
        child: Tooltip(
          message: 'You watched this not long ago',
          child: Container(
            width: 42,
            height: 42,
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
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                percentage == 1.0
                    ? FontAwesomeIcons.checkDouble
                    : FontAwesomeIcons.fire,
                color: Colors.white,
                size: 32,
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
          child: Container(
            width: 42,
            height: 42,
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
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.checkDouble,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
        );
      }
      return Container();
    }
  }

  Widget floatingActions(
      BuildContext context, double _percentage, double cardWidth) {
    if (_percentage < 1.0) {
      return Positioned(
        bottom: -24,
        child: Container(
          height: 48,
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
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: GetBuilder<UIController>(
              init: uiController,
              builder: (controller) {
                return TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
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
      return const SizedBox();
    }
  }
}
