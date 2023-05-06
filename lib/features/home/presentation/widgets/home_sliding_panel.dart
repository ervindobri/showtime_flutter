import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/constants/styles.dart';
import 'package:show_time/core/constants/theme_utils.dart';
import 'package:show_time/core/utils/navigation.dart';
import 'package:show_time/features/home/presentation/widgets/watched_card_web.dart';
import 'package:show_time/features/home/data/models/watched.dart';
import 'package:show_time/injection_container.dart';
import 'package:show_time/network/firebase_utils.dart';
import 'package:show_time/features/home/presentation/widgets/watched_card.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeSlidingPanel extends StatefulWidget {
  const HomeSlidingPanel({Key? key}) : super(key: key);

  @override
  State<HomeSlidingPanel> createState() => _HomeSlidingPanelState();
}

class _HomeSlidingPanelState extends State<HomeSlidingPanel> {
  final PanelController _pc = PanelController();
  final PanelState _panelState = PanelState.CLOSED;

  final GlobalKey<ScaffoldState> _slidingPanelKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    late double maxPanelHeight = height * .7;
    late double minPanelHeight = 100;
    return SlidingUpPanel(
      controller: _pc,
      maxHeight: maxPanelHeight,
      minHeight: minPanelHeight,
      key: _slidingPanelKey,
      defaultPanelState: _panelState,
      boxShadow: [
        BoxShadow(
          color: GlobalColors.primaryGreen.withOpacity(0.15),
          spreadRadius: 10,
          blurRadius: 25,
          offset: const Offset(0, -10), // changes position of shadow
        ),
      ],
      panelSnapping: true,
      collapsed: Center(
        child: Container(
          height: maxPanelHeight,
          width: width,
          decoration: const BoxDecoration(
            borderRadius: ShowTheme.radius24,
            color: GlobalColors.primaryGreen,
          ),
          child: Shimmer.fromColors(
            period: const Duration(milliseconds: 3500),
            baseColor: Colors.white54,
            highlightColor: Colors.white,
            child: SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: width * .3,
                    height: 6,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(24))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      panel: Container(
        height: maxPanelHeight,
        width: width,
        decoration: BoxDecoration(
          borderRadius: ShowTheme.topRadius25,
          gradient: const LinearGradient(
              stops: [0.6, 5.0],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                GlobalColors.primaryGreen,
                GlobalColors.primaryBlue,
              ]),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text("What are we watching today?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Raleway',
                    )),
              ),
              blinkWidget(width),
              const Spacer(),
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
        child: const FlareActor(
          'assets/animations/blink.flr',
          animation: 'Blink',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget lastWatchedWidget(double height) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //Label - LAst watched
          Text(
            "Last watched",
            style: GlobalStyles.theme(context).textTheme.bodyText1!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: StreamBuilder<QuerySnapshot>(
                stream: sl<FirestoreUtils>().getWatchedShows,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    // print("data: ${snapshot.data?.docs}");
                    if (snapshot.data?.docs.isNotEmpty ?? false) {
                      GlobalVariables.watchedShowList.clear();
                      // allWatchedShows.clear();
                      final shows = snapshot.data?.docs
                              .map(
                                (DocumentSnapshot f) =>
                                    WatchedTVShow.fromFirestore(
                                        f.data() as Map<String, dynamic>, f.id),
                              )
                              .toList() ??
                          [];
                      return buildCarouselSlider(shows.take(5).toList());
                    } else {
                      return SizedBox(
                          child: Center(
                              child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
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
                    return SizedBox(
                        height: height / 3,
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(24),
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
          ),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }

  Widget buildCarouselSlider(List<WatchedTVShow> data) {
    final width = MediaQuery.of(context).size.width;
    // print(data);
    if (kIsWeb) {
      return Center(
        child: SizedBox(
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
      return CarouselSlider.builder(
        itemCount: data.length,
        itemBuilder: (_, int itemIndex, __) => Padding(
          padding: const EdgeInsets.only(right: 16),
          child: WatchedCard(
            show: data[itemIndex],
          ),
        ),
        options: CarouselOptions(
          autoPlay: true,
          clipBehavior: Clip.none,
          enableInfiniteScroll: false,
          viewportFraction: .9,
          aspectRatio: 16 / 9,
        ),
      );
    }
  }
}
