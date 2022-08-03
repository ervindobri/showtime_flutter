import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/constants/styles.dart';
import 'package:show_time/core/constants/theme_utils.dart';
import 'package:show_time/core/utils/navigation.dart';
import 'package:show_time/features/home/presentation/widgets/watched_card_web.dart';
import 'package:show_time/features/home/data/models/watched.dart';
import 'package:show_time/network/firebase_utils.dart';
import 'package:show_time/features/home/presentation/widgets/watched_card.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeSlidingPanel extends StatefulWidget {
  @override
  State<HomeSlidingPanel> createState() => _HomeSlidingPanelState();
}

class _HomeSlidingPanelState extends State<HomeSlidingPanel> {
  PanelController _pc = new PanelController();
  PanelState _panelState = PanelState.CLOSED;

  final GlobalKey<ScaffoldState> _slidingPanelKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    late double _panelHeightOpen = height * .8;
    late double _panelHeightClosed = 100;
    return SlidingUpPanel(
      controller: _pc,
      maxHeight: _panelHeightOpen,
      minHeight: _panelHeightClosed,
      key: _slidingPanelKey,
      defaultPanelState: _panelState,
      boxShadow: [
        BoxShadow(
          color: GlobalColors.greenColor.withOpacity(0.15),
          spreadRadius: 10,
          blurRadius: 25,
          offset: Offset(0, -10), // changes position of shadow
        ),
      ],
      panelSnapping: true,
      collapsed: Center(
        child: Container(
          height: height * 0.8,
          width: width,
          decoration: BoxDecoration(
            borderRadius: ShowTheme.radius25,
            color: GlobalColors.greenColor,
          ),
          child: Shimmer.fromColors(
            period: const Duration(milliseconds: 3500),
            baseColor: Colors.white54,
            highlightColor: Colors.white,
            child: kIsWeb && width > 646
                ? InkWell(
                    // onTap: () => _pc.open(),
                    child: Center(
                      child: Container(
                        width: width / 3,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.arrowAltCircleUp,
                                color: GlobalColors.greenColor,
                              ),
                              Text(
                                "Open panel",
                                style: TextStyle(
                                    color: GlobalColors.greenColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: height / 30),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: width * .3,
                          height: 6,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0))),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
      panel: Container(
        height: height * 0.8,
        width: width,
        decoration: BoxDecoration(
          borderRadius: ShowTheme.topRadius25,
          gradient: const LinearGradient(
              stops: [0.6, 5.0],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                GlobalColors.greenColor,
                GlobalColors.blueColor,
              ]),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    child: Text("What are we watching today?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: height / 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway',
                        )),
                  ),
                ),
              ),
              blinkWidget(width),
              SizedBox(
                height: width / 10,
              ),
              // Last watched shows
              lastWatchedWidget(height),
            ],
          ),
        ),
      ),
      borderRadius: ShowTheme.topRadius25,
    );
  }

  InkWell blinkWidget(double width) {
    return InkWell(
      onTap: () {
        NavUtils.navigate(context, '/search_shows',
            transition: Transition.slide);
      },
      child: SizedBox(
        width: kIsWeb ? 150 : min(width * 0.6, 90),
        height: kIsWeb ? 150 : min(width * 0.6, 90),
        child: FlareActor(
          'assets/blink.flr',
          animation: 'Blink',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget lastWatchedWidget(double height) {
    return Column(
      children: <Widget>[
        //Label - LAst watched
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Last watched",
                style: GlobalStyles.theme(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ),
        StreamBuilder(
            stream: FirestoreUtils()
                .watchedShows
                .orderBy('lastWatched', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              // print(snapshot.connectionState);
              if (snapshot.hasData && snapshot.data != null) {
                // print("data");
                if (snapshot.data!.docs.length > 0) {
                  GlobalVariables.watchedShowList.clear();
                  // allWatchedShows.clear();
                  snapshot.data!.docs.forEach((f) {
                    WatchedTVShow show =
                        new WatchedTVShow.fromFirestore(f.data(), f.id);
                    GlobalVariables.watchedShowList.add(show);
                  });
                  return createCarouselSlider(
                      GlobalVariables.watchedShowList.take(5).toList());
                } else {
                  return Container(
                      height: height / 3,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              "Your watchlist is empty",
                              textAlign: TextAlign.center,
                            ),
                            AutoSizeText(
                              "Press the eye above for magic",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )));
                }
              } else {
                // print("no stream");
                return Container(
                    height: height / 3,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Text(
                        "Press the eye above for magic",
                        textAlign: TextAlign.center,
                        style: GlobalStyles.theme(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 16),
                      ),
                    )));
              }
            }),
      ],
    );
  }

  Widget createCarouselSlider(List<WatchedTVShow> data) {
    final width = MediaQuery.of(context).size.width;
    if (kIsWeb) {
      return Center(
        child: Container(
          width: width,
          height: 300,
          child: ListView.builder(
            itemCount: data.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int itemIndex) =>
                WatchedCardWeb(
              show: data[itemIndex],
              maxWidth: max(width / data.length - 10, 300),
              maxHeight: max(width / data.length - 100, 210),
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: CarouselSlider.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int itemIndex, int what) =>
              WatchedCard(
            show: data[itemIndex],
          ),
          options: CarouselOptions(
            height: width * .7,
            enableInfiniteScroll: false,
          ),
        ),
      );
    }
  }
}
