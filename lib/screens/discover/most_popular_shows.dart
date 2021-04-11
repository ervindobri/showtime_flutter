import 'package:carousel_slider/carousel_slider.dart';
import 'package:show_time/components/back.dart';
import 'package:show_time/components/popular_appbar.dart';
import 'package:show_time/constants/custom_variables.dart';
import 'package:show_time/constants/theme_utils.dart';
import 'package:show_time/models/tvshow.dart';
import 'package:show_time/network/imdb.dart';
import 'package:show_time/ui/mps_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class MostPopularShows extends StatefulWidget {
  @override
  _MostPopularShowsState createState() => _MostPopularShowsState();

  MostPopularShows();
}

class _MostPopularShowsState extends State<MostPopularShows>
    with AnimationMixin {
  // String _searchTerm;
  APIService apiService = APIService();
  // You future
  late Future future;
  late ScrollController _controller;

  double _offset = 1.0;

  String mostPopularLabel = "The 10 most popular shows right now";

  //Querys :          -----------------,         tconst(e.g. tt0944947),
  //Endpoints : title/get-most-popular-tv-shows, title/get-details

  late Animation<double> sizeAnimation;
  late AnimationController animationController;

  int threshold = 5;
  int nrShows = 10;

  int maxShows = 100;

  var _selectedIndex = 0;

  Map<int, List<dynamic>> limitMap = {
    1: [0, "1-10"],
    2: [10, "11-20"],
    3: [20, "21-30"],
    4: [30, "31-40"],
    5: [40, "41-50"],
    6: [50, "51-60"],
    7: [60, "61-70"],
    8: [70, "71-80"],
    9: [80, "81-90"],
    10: [90, "91-100"],
  };

  late PageController pageController;

  int maxPages = 10;
  String label = "";
  var pink = const Color(0xFFFF006F);

  static const  mostPopularEndpoint = '/title/get-most-popular-tv-shows';

  
  @override
  void initState() {
    nrShows += threshold;
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    sizeAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        curve: Curves.fastOutSlowIn, parent: animationController));
    animationController.forward();

    pageController = PageController(
      initialPage: _selectedIndex,
    );
    
    super.initState();
    future = apiService.get(
        endpoint: mostPopularEndpoint,
        query: {
          "purchaseCountry": "US",
          "currentCountry": "US",
          "homeCountry": "US"
        });
    label = limitMap[1]![1];
  }

  @override
  void dispose() {
    // _controller.removeListener(() {});
    // _controller.dispose();
    // popularShows.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
        brightness: Brightness.dark,
        backgroundColor: pink,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        color: pink,
        child: SafeArea(
          child: Container(
            color: pink,
            child: FutureBuilder(
                future: future,
                builder: (context, AsyncSnapshot snapshot) {
                  if ( GlobalVariables.limitedShows.isNotEmpty){
                    return CustomScrollView(
                      // key: UniqueKey(),
                        physics: NeverScrollableScrollPhysics(),
                        controller: _controller,
                        slivers: [
                          getSliverHeader(_width, _height),
                          SliverFillRemaining(
                            child: Stack(
                              children: [
                                ListView(
                                  physics: NeverScrollableScrollPhysics(),
                                  // direction: Axis.vertical,
                                  children: [
                                    if (!animationController.isCompleted)
                                      SizeTransition(
                                        axis: Axis.vertical,
                                        axisAlignment: 1,
                                        sizeFactor: sizeAnimation,
                                        child: Container(
                                          height: _height / 2,
                                          decoration: BoxDecoration(
                                              color: pink,
                                              borderRadius: BorderRadius.only(
                                                topLeft:
                                                Radius.circular(GlobalVariables.sliverRadius),
                                                topRight:
                                                Radius.circular(GlobalVariables.sliverRadius),
                                              )),
                                        ),
                                      ),
                                    CarouselSlider.builder(
                                      itemBuilder: (BuildContext context, int index, int what) {
                                        return FutureBuilder(
                                            future: getShowList(limitMap[index + 1]!),
                                            builder: (context, AsyncSnapshot snapshot) {
                                              // print(snapshot.connectionState);
                                              // print(snapshot.hasData);

                                              if ( GlobalVariables.limitedShows != null && GlobalVariables.limitedShows.length > index){
                                                // print("already got this batch ! - ${GlobalVariables.limitedShows.length} / ${index}");
                                                return Container(
                                                    // height: _height,
                                                    decoration: BoxDecoration(
                                                        color: GlobalColors.bgColor,
                                                        borderRadius:
                                                        BorderRadius.only(
                                                          topLeft: Radius.circular(
                                                              GlobalVariables.sliverRadius),
                                                          topRight: Radius.circular(
                                                              GlobalVariables.sliverRadius),
                                                        )),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10.0),
                                                      child: mostPopularList(
                                                          GlobalVariables.limitedShows[index]),
                                                    ));
                                              }
                                              else{
                                                if (snapshot.hasData) {
                                                  if ( snapshot.data.length > 0){
                                                    GlobalVariables.limitedShows.add(snapshot.data);
                                                    return Container(
                                                      // height: _height,
                                                        decoration: BoxDecoration(
                                                            color: GlobalColors.bgColor,
                                                            borderRadius:
                                                            BorderRadius.only(
                                                              topLeft: Radius.circular(GlobalVariables.sliverRadius),
                                                              topRight: Radius.circular(GlobalVariables.sliverRadius),
                                                            )),
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                          child: mostPopularList(
                                                              GlobalVariables.limitedShows[index]),
                                                        ));
                                                  }
                                                  // popularShows = [...GlobalVariables.limitedShows[index]]; //notice the spread operator
                                                  return Container();
                                                }
                                                else {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        color: GlobalColors.bgColor,
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(GlobalVariables.sliverRadius),
                                                          topRight: Radius.circular(GlobalVariables.sliverRadius),
                                                        )
                                                    ),
                                                    child: Shimmer.fromColors(
                                                      highlightColor:
                                                      Colors.white,
                                                      baseColor:
                                                      Colors.grey.shade300,
                                                      direction:
                                                      ShimmerDirection.ttb,
                                                      child: StaggeredGridView
                                                          .countBuilder(
                                                        itemCount: 12,
                                                        mainAxisSpacing: 4.0,
                                                        crossAxisSpacing: 4.0,
                                                        itemBuilder:
                                                            (BuildContext
                                                        context,
                                                            int index) {
                                                          return Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                8.0),
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      8.0),
                                                                  child:
                                                                  Container(
                                                                    height:
                                                                    _height /
                                                                        20,
                                                                    width:
                                                                    _width,
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade300,
                                                                      borderRadius:
                                                                      ShowTheme.radius25,
                                                                      boxShadow: [
                                                                        new BoxShadow(
                                                                            color: Colors.black.withOpacity(
                                                                                .3),
                                                                            blurRadius:
                                                                            15.0,
                                                                            spreadRadius:
                                                                            -4,
                                                                            offset:
                                                                            Offset(0, 5)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      8.0),
                                                                  child:
                                                                  Container(
                                                                    height:
                                                                    _height /
                                                                        3.1,
                                                                    width:
                                                                    _width,
                                                                    // color: Colors.blue,
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade300,
                                                                      borderRadius:
                                                              ShowTheme.radius25,
                                                                      boxShadow: [
                                                                        new BoxShadow(
                                                                            color: Colors.black.withOpacity(
                                                                                .3),
                                                                            blurRadius:
                                                                            15.0,
                                                                            spreadRadius:
                                                                            -4,
                                                                            offset:
                                                                            Offset(0, 5)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                        crossAxisCount: 4,
                                                        staggeredTileBuilder:
                                                            (int index) =>
                                                        new StaggeredTile
                                                            .count(
                                                            2,
                                                            index.isEven
                                                                ? 4
                                                                : 4),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }

                                            });
                                      },
                                      options: CarouselOptions(
                                          height: _height,
                                          enableInfiniteScroll: false,
                                          onPageChanged: (val, reason){
                                            setState(() {
                                              if ( val == 0){
                                                _selectedIndex = val;
                                              }
                                              else if( val == maxPages -1 ){
                                                _selectedIndex = 2;
                                              }
                                              else{
                                                _selectedIndex = 1;
                                                label = limitMap[val+1]![1].toString();
                                              }
                                            });
                                          },
                                          aspectRatio: 1,
                                          viewportFraction: 1,
                                          initialPage: _selectedIndex),
                                      itemCount: maxPages,
                                    )
                                  ],
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: _width/2 - 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25.0)
                                      ),
                                      child: GNav(
                                        gap: 8,
                                        iconSize: 20,
                                        selectedIndex: _selectedIndex,
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                        duration: Duration(milliseconds: 500),
                                        color: Colors.grey[800],
                                        activeColor: pink,
                                        backgroundColor: pink,
                                        tabBackgroundColor: Colors.white,
                                        tabMargin: EdgeInsets.all(5),
                                        textStyle: GoogleFonts.roboto(
                                          fontSize: 15,
                                          color: pink,
                                        ),
                                        tabs: [
                                          GButton(
                                            iconColor: Colors.white,
                                            icon: FontAwesomeIcons.chevronCircleLeft,
                                            text: '1-10',
                                          ),
                                          GButton(
                                            text: label,
                                            iconColor: Colors.white,
                                            icon: Icons.queue_play_next_rounded,
                                          ),
                                          GButton(
                                            text: '91-100',
                                            iconColor: Colors.white,
                                            icon: FontAwesomeIcons.chevronCircleRight
                                          ),
                                        ],
                                        onTabChange: (index) {
                                          setState(() {
                                            _selectedIndex = index;
                                          });
                                        }),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ]);
                  }
                  else{
                    if (snapshot.hasData) {
                      getShowLinks(snapshot.data!.take(maxShows));
                      return CustomScrollView(
                        // key: UniqueKey(),
                          physics: NeverScrollableScrollPhysics(),
                          controller: _controller,
                          slivers: [
                            getSliverHeader(_width, _height),
                            SliverFillRemaining(
                              child: Stack(
                                children: [
                                  ListView(
                                    // direction: Axis.vertical,
                                    children: [
                                      if (!animationController.isCompleted)
                                        SizeTransition(
                                          axis: Axis.vertical,
                                          axisAlignment: 1,
                                          sizeFactor: sizeAnimation,
                                          child: Container(
                                            height: _height / 2,
                                            decoration: BoxDecoration(
                                                color: pink,
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                  Radius.circular(GlobalVariables.sliverRadius),
                                                  topRight:
                                                  Radius.circular(GlobalVariables.sliverRadius),
                                                )),
                                          ),
                                        ),
                                      CarouselSlider(
                                        items: List.generate(maxPages, (index) {
                                          // Future<dynamic> popular = getShowList(limitMap[index + 1]);
                                          return FutureBuilder(
                                              future: getShowList(limitMap[index + 1]!),
                                              builder: (context, AsyncSnapshot snapshot) {
                                                // print(GlobalVariables.limitedShows.length);
                                                if ( GlobalVariables.limitedShows != null && GlobalVariables.limitedShows.length > index){
                                                  return Container(
                                                      // height: _height,
                                                      decoration: BoxDecoration(
                                                          color: GlobalColors.bgColor,
                                                          borderRadius:
                                                          BorderRadius.only(
                                                            topLeft: Radius.circular(
                                                                GlobalVariables.sliverRadius),
                                                            topRight: Radius.circular(
                                                                GlobalVariables.sliverRadius),
                                                          )),
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 10.0),
                                                        child: mostPopularList(
                                                            GlobalVariables.limitedShows[index]),
                                                      ));
                                                }
                                                else{
                                                  if (snapshot.hasData) {
                                                    GlobalVariables.limitedShows.add(snapshot.data);
                                                    // popularShows = [...GlobalVariables.limitedShows[index]]; //notice the spread operator
                                                    return Container(
                                                        // height: _height,
                                                        decoration: BoxDecoration(
                                                            color: GlobalColors.bgColor,
                                                            borderRadius:
                                                            BorderRadius.only(
                                                              topLeft: Radius.circular(
                                                                  GlobalVariables.sliverRadius),
                                                              topRight: Radius.circular(
                                                                  GlobalVariables.sliverRadius),
                                                            )),
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 10.0),
                                                          child: mostPopularList(
                                                              GlobalVariables.limitedShows[index]),
                                                        ));
                                                  }
                                                  else {
                                                    // print("fetching data;");
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                          color: GlobalColors.bgColor,
                                                          borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(GlobalVariables.sliverRadius),
                                                            topRight: Radius.circular(GlobalVariables.sliverRadius),
                                                          )
                                                      ),
                                                      child: Shimmer.fromColors(
                                                        highlightColor:
                                                        Colors.white,
                                                        baseColor:
                                                        Colors.grey.shade300,
                                                        direction:
                                                        ShimmerDirection.ttb,
                                                        child: StaggeredGridView
                                                            .countBuilder(
                                                          itemCount: 12,
                                                          mainAxisSpacing: 4.0,
                                                          crossAxisSpacing: 4.0,
                                                          itemBuilder:
                                                              (BuildContext
                                                          context,
                                                              int index) {
                                                            return Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                  8.0),
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                    child:
                                                                    Container(
                                                                      height:
                                                                      _height /
                                                                          20,
                                                                      width:
                                                                      _width,
                                                                      decoration:
                                                                      BoxDecoration(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade300,
                                                                        borderRadius:
                                                                        ShowTheme.radius25,
                                                                        boxShadow: [
                                                                          new BoxShadow(
                                                                              color: Colors.black.withOpacity(
                                                                                  .3),
                                                                              blurRadius:
                                                                              15.0,
                                                                              spreadRadius:
                                                                              -4,
                                                                              offset:
                                                                              Offset(0, 5)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                    child:
                                                                    Container(
                                                                      height:
                                                                      _height /
                                                                          3.1,
                                                                      width:
                                                                      _width,
                                                                      // color: Colors.blue,
                                                                      decoration:
                                                                      BoxDecoration(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade300,
                                                                        borderRadius:
                                                                ShowTheme.radius25,
                                                                        boxShadow: [
                                                                          new BoxShadow(
                                                                              color: Colors.black.withOpacity(
                                                                                  .3),
                                                                              blurRadius:
                                                                              15.0,
                                                                              spreadRadius:
                                                                              -4,
                                                                              offset:
                                                                              Offset(0, 5)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                          crossAxisCount: 4,
                                                          staggeredTileBuilder:
                                                              (int index) =>
                                                          new StaggeredTile
                                                              .count(
                                                              2,
                                                              index.isEven
                                                                  ? 4
                                                                  : 4),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }

                                              });
                                        }),
                                        options: CarouselOptions(
                                            height: _height,
                                            enableInfiniteScroll: false,
                                            onPageChanged: (val, reason){
                                              setState(() {
                                                if ( val == 0){
                                                  _selectedIndex = val;
                                                }
                                                else if( val == maxPages -1 ){
                                                  _selectedIndex = 2;
                                                }
                                                else{
                                                  _selectedIndex = 1;
                                                  label = limitMap[val+1]![1].toString();
                                                }
                                              });
                                            },
                                            aspectRatio: 1,
                                            viewportFraction: 1,
                                            initialPage: _selectedIndex),
                                      )
                                    ],
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    left: _width/2 - 100,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25.0)
                                        ),
                                        child: GNav(
                                          gap: 8,
                                          iconSize: 20,
                                          selectedIndex: _selectedIndex,
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                          duration: Duration(milliseconds: 500),
                                          color: Colors.grey[800],
                                          activeColor: pink,
                                          backgroundColor: pink,
                                          tabBackgroundColor: Colors.white,
                                          tabMargin: EdgeInsets.all(5),
                                          textStyle: GoogleFonts.roboto(
                                            fontSize: 15,
                                            color: pink,
                                          ),
                                          tabs: [
                                            GButton(
                                              iconColor: Colors.white,
                                              icon: Icons.queue_play_next_rounded,
                                              text: '1-10',
                                            ),
                                            GButton(
                                              text: label,
                                              iconColor: Colors.white,
                                              icon: Icons.queue_play_next_rounded,
                                            ),
                                            GButton(
                                              text: '91-100',
                                              iconColor: Colors.white,
                                              icon: Icons.queue_play_next_rounded,
                                            ),
                                          ],
                                          onTabChange: (index) {
                                            setState(() {
                                              _selectedIndex = index;
                                            });
                                          }),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ]);
                    }
                    else {
                      // print("Waiting on IMDB data");
                      return CustomScrollView(
                        // key: UniqueKey(),
                        controller: _controller,
                        slivers: [
                          getSliverHeader(_width, _height),
                          // displayLabel(_width),
                          SliverFillRemaining(
                            child: Container(
                                decoration: BoxDecoration(
                                    color: GlobalColors.bgColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(GlobalVariables.sliverRadius),
                                      topRight: Radius.circular(GlobalVariables.sliverRadius),
                                    )),
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            pink),
                                      ),
                                    ))),
                          ),
                        ],
                      );
                    }
                  }
                }
        // }
                ),
          ),
        ),
      ),
    );
  }

  Widget _textField() {
    return CupertinoTextField(
      onSubmitted: (value) {
        //TODO: implement SEARCH in MPS
        // setState(() {
        //   _searchTerm = value;
        // });
      },
      // controller: _filter,
      clearButtonMode: OverlayVisibilityMode.editing,
      keyboardType: TextInputType.text,
      placeholder: "Search..",
      placeholderStyle: TextStyle(
        color: GlobalColors.greyTextColor,
        fontSize: 20.0,
        fontFamily: 'Raleway',
      ),
      cursorColor: GlobalColors.greyTextColor,
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

  void getShowLinks(dynamic list) {
    list.forEach((element) {
      GlobalVariables.showLinks.add(element.split('/')[2]);
    });
    // print(showLinks[0]);
  }

  getShowList(List<dynamic> limits) async {
    List<TVShow> data = [];
    // print(showLinks.length);
    for (String show in GlobalVariables.showLinks.skip(limits[0]).take(10)) {
      TVShow tvshow = (await apiService.getShowResults(imdbLink: show))!;
      // print(tvshow);
      if (tvshow != null) {
        data.add(tvshow);
      }
    }
    return await new Future(() => data);
  }

  Widget mostPopularList(List<TVShow> data) {
    // print(data.length);

    return StaggeredGridView.countBuilder(
            shrinkWrap: false,
            // physics: ClampingScrollPhysics(),
            itemCount: data.length,
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 2.0,
            padding: const EdgeInsets.only(bottom: 140.0),
            itemBuilder: (BuildContext context, int index) {
              // print(index);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: PopularCard(show: data[index]),
              );
            },
            crossAxisCount: 4,
            staggeredTileBuilder: (int index) =>
                new StaggeredTile.count(2, index.isEven ? 3.5 : 3.5),
          );
  }

  displayLabel(double _width) {
    return Opacity(
      opacity: _offset >= 1
          ? 1.0
          : _offset <= 0
              ? 0.0
              : _offset,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
          child: Column(
            children: [
              Text(
                mostPopularLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: GlobalColors.greyTextColor,
                    fontFamily: 'Raleway',
                    fontSize: _width / 15,
                    fontWeight: FontWeight.w700),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  height: 1.2,
                  color: GlobalColors.pinkColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getSliverHeader(double _width, double _height) {
    return SliverPersistentHeader(
      delegate: PopularSliverDelegate(
        child: Container(
          width: _width,
          decoration: BoxDecoration(
              color: pink,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(GlobalVariables.sliverRadius),
                bottomRight: Radius.circular(GlobalVariables.sliverRadius),
              )),
          // color: Colors.black,
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
        expandedHeight: _height * .15,
        back: CustomBackButton(
          backPage: 'Home',
          itemColor: GlobalColors.white,
          backgroundColor: GlobalColors.pinkColor,

        ),
      ),
    );
  }
}
