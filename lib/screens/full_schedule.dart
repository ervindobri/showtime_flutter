import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:show_time/controllers/show_controller.dart';
import 'package:show_time/features/browse/presentation/pages/browse_shows.dart';
import 'package:show_time/features/home/data/models/episode.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:show_time/injection_container.dart';
import 'package:show_time/ui/full_schedule_card.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:show_time/ui/schedule_timeline.dart';

class FullSchedule extends StatefulWidget {
  const FullSchedule({Key? key}) : super(key: key);

  @override
  _FullScheduleState createState() => _FullScheduleState();
}

class _FullScheduleState extends State<FullSchedule> {
  late String _searchTerm;
  List<List<Episode>> list = [];
  bool timelineView = false;
  ShowController showController = sl<ShowController>();

  @override
  void initState() {
    super.initState();
    _searchTerm = "";
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: GlobalColors.bgColor,
      appBar: AppBar(
        backgroundColor: GlobalColors.primaryGreen,
        shadowColor: Colors.transparent,
        toolbarHeight: 0,
        // leading: null,
      ),
      body: Stack(
        children: [
          CustomScrollView(
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            // key: UniqueKey(),
            slivers: [
              const PopularSliverHeader(
                backgroundColor: GlobalColors.primaryGreen,
              ),
              ValueListenableBuilder<List<List<Episode>>>(
                valueListenable: showController.scheduledEpisodes,
                builder: (context, value, __) {
                  return SliverFillRemaining(
                    // fillOverscroll: true,
                    child: value.isNotEmpty
                        ? AnimatedSwitcher(
                            duration: const Duration(
                              milliseconds: 500,
                            ),
                            child: !timelineView
                                ? buildCarousel(value)
                                : ScheduleTimeline(
                                    items: value,
                                  ),
                          )
                        : Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Oh no!",
                                        style: TextStyle(
                                            color: GlobalColors.greyTextColor,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Raleway'),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "There are no scheduled shows for you!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: GlobalColors.greyTextColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: 'Raleway'),
                                      ),
                                    ),
                                    SizedBox(
                                        child: SizedBox(
                                      width: _width,
                                      height: _height / 3,
                                      child: const FlareActor("assets/ohno.flr",
                                          alignment: Alignment.center,
                                          fit: BoxFit.contain,
                                          animation: "error-message"),
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
          Positioned(
              bottom: 24,
              right: 24,
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    splashColor: GlobalColors.primaryGreen,
                    onTap: () {
                      //TODO: sort watchlist
                      setState(() => timelineView = !timelineView);
                    },
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: GlobalColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.timesCircle,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Episode latestEpisode(int index) {
    for (Episode x in list[index]) {
      if (!x.aired()) {
        return x;
      }
    }
    return list[index].first;
  }

  Widget resultLabel() {
    double _width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: _width,
      child: Center(
        child: list.length < 2
            ? Text(
                "Showing ${list.length} result for \"$_searchTerm\"",
                style: const TextStyle(
                    color: GlobalColors.primaryGreen,
                    fontFamily: 'Raleway',
                    fontSize: 20),
              )
            : Text(
                "Showing ${list.length} results for \"$_searchTerm\"",
                style: const TextStyle(
                    color: GlobalColors.primaryGreen,
                    fontFamily: 'Raleway',
                    fontSize: 20),
              ),
      ),
    );
  }

  Widget buildCarousel(List<List<Episode>> list) {
    double _height = MediaQuery.of(context).size.height;
    return CarouselSlider.builder(
      itemCount: list.length,
      itemBuilder: (_, index, what) => FullScheduleCard(episodes: list[index]),
      options: CarouselOptions(
        height: _height * .65,
        enableInfiniteScroll: true,
        scrollDirection: Axis.horizontal,
        viewportFraction: .8,
        enlargeCenterPage: true,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
      ),
    );
  }

  /// Search logic:
  ///
  /// setState(() {
  //   oldView = currentView;
  //   currentView = -1;
  //   //TODO: SEARCH IN WATCHLIST
  //   _searchTerm = value;
  //   list = GlobalVariables.scheduledEpisodes
  //       .where((e) => e[0]
  //           .embedded!['show']['name']
  //           .toLowerCase()
  //           .contains(_searchTerm.toLowerCase()))
  //       .toList();
  //   list = list.toSet().toList();
  //   // print(list[0][0].name);
  // });
  // // print("searching");
  // await Future.delayed(Duration(milliseconds: _loadingDuration), () {
  //   setState(() {
  //     currentView = oldView;
  //   });
  // });

  // bool isEdgeIndex(int index) {
  //   return index == 0 || index == list.length + 1;
  // }

  // List<Step> getStepList(List<List<Episode>> list) {
  //   List<Step> stepList = [];
  //   for (List<Episode> x in list) {
  //     stepList.add(Step(
  //         isActive: false,
  //         content: SizedBox(
  //             width: 200,
  //             height: 150,
  //             child: Text(x.first.embedded!['show']['name'])),
  //         title: Text(x.first.name!)));
  //   }
  //   return stepList;
  // }
}
