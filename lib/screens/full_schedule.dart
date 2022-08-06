import 'dart:math';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:show_time/components/back.dart';
import 'package:show_time/components/popular_appbar.dart';
import 'package:show_time/get_controllers/show_controller.dart';
import 'package:show_time/features/home/data/models/episode.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:show_time/ui/full_schedule_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:show_time/ui/schedule_timeline.dart';
import 'package:timeline_tile/timeline_tile.dart';

class FullSchedule extends StatefulWidget {
  @override
  _FullScheduleState createState() => _FullScheduleState();
}

class _FullScheduleState extends State<FullSchedule> {
  late String _searchTerm;
  List<List<Episode>> list = [];
  int currentStep = 0;
  int currentView = 0;
  int oldView = 0;

  int _loadingDuration = 569; // milliseconds

  ShowController showController = Get.put(ShowController())!;

  @override
  void initState() {
    super.initState();
    _searchTerm = "";
    list = showController.scheduledEpisodes.value;
    list = list.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: GlobalColors.primaryGreen,
        shadowColor: Colors.transparent,
        toolbarHeight: 0,
        // leading: null,
      ),
      body: Container(
        color: GlobalColors.primaryGreen,
        child: SafeArea(
          child: Container(
            color: GlobalColors.primaryGreen,
            child: CustomScrollView(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              // key: UniqueKey(),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: PopularSliverDelegate(
                    // hideTitleWhenExpanded: true,
                    expandedHeight: _height * .15,
                    back: CustomBackButton(
                      backPage: 'Home',
                      itemColor: GlobalColors.white,
                      backgroundColor: GlobalColors.primaryGreen,
                    ),
                    actions: getActions(),
                    child: Container(
                      width: _width,
                      decoration: BoxDecoration(
                          color: GlobalColors.primaryGreen,
                          borderRadius: BorderRadius.only(
                            bottomLeft:
                                Radius.circular(GlobalVariables.sliverRadius),
                            bottomRight:
                                Radius.circular(GlobalVariables.sliverRadius),
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 5),
                            child: _textField(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  // fillOverscroll: true,
                  child: list.length > 0
                      ? Center(
                          child: Container(
                          height: _height,
                          width: _width,
                          decoration: BoxDecoration(
                              color: GlobalColors.bgColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    GlobalVariables.sliverRadius),
                                topRight: Radius.circular(
                                    GlobalVariables.sliverRadius),
                              )),
                          child: Center(
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (_searchTerm != "" && currentView >= 0)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0, vertical: 20),
                                      child: Container(
                                        child: Center(
                                          child: AutoSizeText(
                                            "Showing search results for $_searchTerm",
                                            maxLines: 2,
                                            maxFontSize: 23,
                                            minFontSize: 20,
                                            style: GoogleFonts.openSans(
                                              color: GlobalColors.greyTextColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: AnimatedSwitcher(
                                        duration: Duration(milliseconds: 200),
                                        child: getCurrentView(_height, _width)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                      : Container(
                          height: _height,
                          decoration: BoxDecoration(
                              color: GlobalColors.bgColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    GlobalVariables.sliverRadius),
                                topRight: Radius.circular(
                                    GlobalVariables.sliverRadius),
                              )),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Oh no!",
                                        style: TextStyle(
                                            color: GlobalColors.greyTextColor,
                                            fontSize: 32,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Raleway'),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "There are no scheduled shows for you!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: GlobalColors.greyTextColor,
                                            fontSize: 27,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: 'Raleway'),
                                      ),
                                    ),
                                    SizedBox(
                                        child: Container(
                                      width: _width,
                                      height: _height / 3,
                                      child: FlareActor("assets/ohno.flr",
                                          alignment: Alignment.center,
                                          fit: BoxFit.contain,
                                          animation: "error-message"),
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
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
    return Container(
      width: _width,
      child: Center(
        child: list.length < 2
            ? Text(
                "Showing ${list.length} result for \"$_searchTerm\"",
                style: TextStyle(
                    color: GlobalColors.primaryGreen,
                    fontFamily: 'Raleway',
                    fontSize: 20),
              )
            : Text(
                "Showing ${list.length} results for \"$_searchTerm\"",
                style: TextStyle(
                    color: GlobalColors.primaryGreen,
                    fontFamily: 'Raleway',
                    fontSize: 20),
              ),
      ),
    );
  }

  Widget buildCarousel(List<List<Episode>> list) {
    double _height = MediaQuery.of(context).size.height;
    // double _width = MediaQuery.of(context).size.width;

    return CarouselSlider.builder(
      itemCount: list.length,
      itemBuilder: (_, index, what) {
        if (list.length > 0) {
          return FullScheduleCard(episodes: list[index]);
        } else {
          return Container();
        }
      },
      options: CarouselOptions(
          height: _height * .65,
          enableInfiniteScroll: list.length > 1 ? true : false,
          scrollDirection: Axis.horizontal,
          viewportFraction: .8,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.scale),
    );
  }

  Widget _textField() {
    return CupertinoTextField(
      // autofocus: true,
      onSubmitted: (value) async {
        setState(() {
          oldView = currentView;
          currentView = -1;
          //TODO: SEARCH IN WATCHLIST
          _searchTerm = value;
          list = GlobalVariables.scheduledEpisodes
              .where((e) => e[0]
                  .embedded!['show']['name']
                  .toLowerCase()
                  .contains(_searchTerm.toLowerCase()))
              .toList();
          list = list.toSet().toList();
          print(list[0][0].name);
        });
        print("searching");
        await Future.delayed(Duration(milliseconds: _loadingDuration), () {
          setState(() {
            currentView = oldView;
          });
        });
      },
      // clearButtonMode: OverlayVisibilityMode.editing,
      // keyboardType: TextInputType.text,
      placeholder: "Search",
      placeholderStyle: TextStyle(
        color: GlobalColors.greyTextColor.withOpacity(.4),
        fontSize: 20.0,
        fontFamily: 'Raleway',
      ),
      cursorColor: GlobalColors.greyTextColor,
      clearButtonMode: OverlayVisibilityMode.editing,
      cursorWidth: 3,
      style: TextStyle(
        color: GlobalColors.greyTextColor,
        fontSize: 20.0,
        fontFamily: 'Raleway',
      ),
      prefix: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Icon(
          Icons.search,
          color: GlobalColors.greyTextColor,
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            new BoxShadow(
                color: Colors.grey.withOpacity(.2),
                blurRadius: 25.0,
                spreadRadius: -25,
                offset: Offset(0, 5)),
          ],
          color: Colors.white),
    );
  }

  bool isEdgeIndex(int index) {
    return index == 0 || index == list.length + 1;
  }

  List<Step> getStepList(List<List<Episode>> list) {
    List<Step> stepList = [];
    for (List<Episode> x in list) {
      stepList.add(new Step(
          isActive: false,
          content: Container(
              width: 200,
              height: 150,
              child: Text(x.first.embedded!['show']['name'])),
          title: Text(x.first.name!)));
    }
    return stepList;
  }

  getActions() {
    return InkWell(
      highlightColor: GlobalColors.greyTextColor,
      splashColor: GlobalColors.primaryBlue,
      onTap: () {
        //switch view
        print("switching view");
        setState(() {
          currentView = currentView > 0 ? 0 : 1;
        });
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: FaIcon(
            FontAwesomeIcons.adjust,
            color: GlobalColors.primaryGreen,
            size: 15,
          ),
        ),
      ),
    );
  }

  getCurrentView(double height, double width) {
    Widget view = Container();
    switch (currentView) {
      case -1:
        view = Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(GlobalColors.primaryGreen),
          ),
        );
        break;
      case 1:
        view = buildCarousel(list);
        break;
      case 0:
        // view = buildCarousel(list);
        view = ScheduleTimeline(items: list);
        break;
    }
    return view;
  }
}
