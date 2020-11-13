import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eWoke/components/back.dart';
import 'package:eWoke/components/custom_elevation.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/main.dart';
import 'package:eWoke/models/watched.dart';
import 'package:eWoke/network/firebase_utils.dart';
import 'package:eWoke/network/network.dart';
import 'package:eWoke/screens/watched_detail_view.dart';
import 'package:eWoke/ui/watch_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animate_icons/animate_icons.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'dart:developer';

import 'package:google_fonts/google_fonts.dart';
import 'package:flare_flutter/flare_actor.dart';



class DiscoverWatchList extends StatefulWidget {
  final List data;

  const DiscoverWatchList({Key key, this.data}) : super(key: key);
  @override
  _DiscoverWatchListState createState() => _DiscoverWatchListState();
}

class _DiscoverWatchListState extends State<DiscoverWatchList>
    with SingleTickerProviderStateMixin {
  List<WatchedTVShow> sortedList = [];

  Stream<QuerySnapshot> _watchedShowsStream;

  bool _sorting;
  String criteria = "Criteria";

  bool _ascending = false;

  bool isPlaying = false;

  Animation animation;

  AnimateIconController controller;
  final TextEditingController _filter = new TextEditingController();

  String _searchTerm;
  int _index = 0;

  var watchlistBlue = const Color(0xFF59b4ff);

  ScrollController listController = new ScrollController(
    initialScrollOffset: 0
  );


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sorting = false;
    sortedList.clear();
    sortedList = watchedShowList.toSet().toList();
    controller = AnimateIconController();
    _searchTerm = "";
    criteria = SORT_CATEGORIES[_index];

    // log(sortedList.length.toString());
    listController.addListener(onListen);


  }
  @override
  void dispose() {
    // TODO: implement dispose
    listController.removeListener(onListen);
    super.dispose();
  }

  void onListen() {
    setState(() {});
  }


  _onpressed() {
    setState(() {
      if (controller.isStart()) {
        controller.animateToEnd();
      } else if (controller.isEnd()) {
        controller.animateToStart();
      }
    });
  }

  Widget _textField() {
    return CupertinoTextField(
        onSubmitted: (value) {
          setState(() => _searchTerm = value);
          _filter.clear();
        },
        controller: _filter,
        clearButtonMode: OverlayVisibilityMode.editing,
        keyboardType: TextInputType.text,
        placeholder: "Search watchlist",
        placeholderStyle: TextStyle(
          color: greyTextColor.withOpacity(.5),
          fontSize: 20.0,
          fontFamily: 'Raleway',
        ),
      cursorColor: greyTextColor,
      cursorWidth: 3,
        style: TextStyle(
          color: greyTextColor,
          fontSize: 20.0,
          fontFamily: 'Raleway',
        ),
        prefix: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Icon(
            Icons.search,
            color: greyTextColor,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [ new BoxShadow(
              color: Colors.grey.withOpacity(.2),
              blurRadius: 25.0,
              spreadRadius: -25,
              offset: Offset(0, 5)),
          ],
          color: Colors.white
        ),
      );
  }
  Widget build(BuildContext context) {
    //TODO: set scrolloffset to 0 after sorting
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    // if (listController.hasClients) debugPrint(listController.position.toString());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.dark,
        shadowColor: Colors.transparent,
        backgroundColor: watchlistBlue,
        toolbarHeight: 0,
      ),
      body: Container(
        color:  watchlistBlue,
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                width: _width,
                height: _height,
                color: watchlistBlue,
                child: Column(
                  // alignment: Alignment.center,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _width,
                      height: _height*.16,
                      decoration: BoxDecoration(
                        color: watchlistBlue,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25.0),
                          bottomRight: Radius.circular(25.0),
                        )
                      ),
                      // color: Colors.black,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0),
                              child: _textField(),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  back(context),
                                  InkWell(
                                    onTap: () async {
                                      showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25.0),
                                                topRight: Radius.circular(25.0)),
                                          ),
                                          context: context,
                                          builder: (BuildContext context) {
                                            return createBottomSheet();
                                          });
                                    },
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            "Sort",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Raleway',
                                              fontSize: 20,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.sort),
                                            color: Colors.white,
                                            iconSize: 25,
                                            onPressed: () async {
                                              showModalBottomSheet(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(25.0),
                                                        topRight: Radius.circular(25.0)),
                                                  ),
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return createBottomSheet();
                                                  });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                          ],
                        ),
                      ),
                    Expanded(
                      child: Container(
                        height: _height * .8,
                        decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0),
                            )
                        ),
                        // ignore: missing_required_param
                        child: createListView(),
                      ),
                    ), //pass title, and get content
                  ],
                ),
              ),
              Positioned(
                bottom: 50,
                left: 50,
                child: _sorting
                    ? CustomElevation(
                      color: Colors.blueAccent.withOpacity(.3),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        color: watchlistBlue,
                        // elevation: 10,
                        highlightColor: Colors.blueAccent.shade700,
                        onPressed: () {
                          _onpressed();
                          _sortWatchList(criteria, !_ascending);
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: AutoSizeText(
                                  criteria,
                                  minFontSize: 10,
                                  maxFontSize: 20,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Raleway',
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              AnimateIcons(
                                controller: controller,
                                startIcon: Icons.keyboard_arrow_up,
                                endIcon: Icons.keyboard_arrow_down,
                                size: 35.0,
                                duration: Duration(milliseconds: 200),
                                color: Colors.white,
                                clockwise: false,
                                onStartIconPress: () {
                                  _onpressed();
                                  _sortWatchList(criteria, !_ascending);
                                  if ( listController.hasClients){
                                    listController.animateTo(
                                        0,
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.ease);
                                  }

                                  return true;
                                },
                                onEndIconPress: () {
                                  _onpressed();
                                  _sortWatchList(criteria, !_ascending);
                                  if ( listController.hasClients){
                                    listController.animateTo(
                                        0,
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.easeOut
                                    );
                                  }
                                  return true;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    : Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getCriteria(WatchedTVShow a, String criteria) {
    // print(a);
    Map<String, dynamic> criteriaMap = {
      "Title": a.name,
      "Year": a.startDate,
      "Runtime": a.runtime,
      "Progress": a.calculateProgress() ?? 0.0,
      "Rating" : a.rating ?? 0.0
    };
    return criteriaMap[criteria];
  }

  void _sortWatchList(String x, bool ascending) {
    setState(() {
      _ascending = ascending;
    });
    if (ascending) {
      sortedList.sort((a, b) => getCriteria(a, x).compareTo(getCriteria(b, x)));
    } else {
      sortedList.sort((a, b) => getCriteria(b, x).compareTo(getCriteria(a, x)));
    }
  }

  Widget createBottomSheet() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: _height / 8,
            color: Colors.white,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                    // alignment: Alignment.bottomCenter,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.arrow_back,
                            size: 30,) // the arrow back icon
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _sorting = true;
                          _sortWatchList(criteria, !_ascending);
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text(
                          "Confirm",
                          style: TextStyle(
                            color: greyTextColor,
                            decoration: TextDecoration.underline,
                            fontSize: 20,
                            fontFamily: 'Raleway',
                          ),
                      ),
                    ),
                  )
                ]),
                Center(
                    child: Text(
                      "Sort",
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                          color: greyTextColor),
                    ) // Your desired title
                ),
              ],
            ),
          ),
          Container(
            height: _height / 2.4,
            child: CupertinoPicker(
              itemExtent: 50,
              diameterRatio: 1,
              looping: true,
              useMagnifier: true,
              onSelectedItemChanged: (int value) {
                setState(() {
                  // _sorting = true;
                  _index = value;
                  criteria = SORT_CATEGORIES[_index];
                });
              }, children:
              new List<Widget>.generate(SORT_CATEGORIES.length, (index){
                return Container(
                  width: _width,
                  child: Center(
                      child: Text(
                        SORT_CATEGORIES[index],
                        style: TextStyle(
                          color: greyTextColor,
                          fontSize: 25,
                          fontFamily: 'Raleway',
                        ),
                      )),
                );
              }),

            ),
          )
        ],
      ),
    );
  }

  Widget createListView() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    // log(_searchTerm);
    // log(listController.hasClients.toString());
    if ( watchedShowList.isNotEmpty){
      // log("already fetched");
      var temp = sortedList.where((e) => e.name.toLowerCase().contains( _searchTerm.toLowerCase())).toList();
      if ( temp.length > 0){
        return WatchlistView(
          list: temp,
          scrollController: listController,
        );
      }
      else{
        return Container(
          width: _width,
          height: _height,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30),
                  child: AutoSizeText(
                    "Oopsie! You missed that shot. Try again",
                    minFontSize: 20,
                    maxFontSize: 30,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      color: watchlistBlue,
                      fontSize: 25,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: watchlistBlue
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  textColor: watchlistBlue,
                  color: bgColor,
                  onPressed: () {
                    setState(() {
                      _searchTerm = "";
                    });
                }, child: Container(
                  width: _width/3.5,
                  child: AutoSizeText(
                    "All shows",
                    minFontSize: 16,
                    maxFontSize: 20,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 25,
                        decoration: TextDecoration.underline
                    ),
                  ),
                ),
                ),
                SizedBox(
                  width: _width*.8,
                  height: _height/3,
                  child: FlareActor("assets/empty-blue.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: "Idle"),

                )
              ],
            ),
          ),
        );
      }
    }
    else{
        if (!_sorting){
          // log("not sorting");
          return StreamBuilder(
              stream: _watchedShowsStream,
              builder: (_, snapshot) {
                // log("stream");
                List<Widget> children;
                // ignore: missing_enum_constant_in_switch
                switch( snapshot.connectionState){
                  case ConnectionState.waiting:
                    return Container();
                    break;
                }
                if (!snapshot.hasData) {
                  //TODO: SHOW PROGRESS LOADING, PlACEHOLDER ANIMATED CARDS
                  return Container();
                } else {
                  //region BUILD_LIST
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      children = <Widget>[
                        Container(
                          height: _height,
                          child: Center(
                            child: Theme(
                              data: Theme.of(context)
                                  .copyWith(accentColor: Colors.white),
                              child: CircularProgressIndicator(
                                strokeWidth: 6.5,
                              ),
                            ),
                          ),
                        )
                      ];
                      break;
                  //endregion
                    default:
                      list.clear();
                      allWatchedShows.clear();
                      // log("cleared watched tv show lists");
                      snapshot.data.documents.forEach((f) {
                        WatchedTVShow show = new WatchedTVShow(
                          id: f.documentID,
                          name: f.data()['name'],
                          startDate: f.data()['start_date'],
                          runtime: f.data()['runtime'] != null ? f.data()['runtime'] : 0,
                          imageThumbnailPath: f.data()['image_thumbnail_path'],
                          totalSeasons: f.data()['total_seasons'],
                          episodePerSeason: f.data()['episodesPerSeason'],
                          currentSeason: f.data()['currentSeason'],
                          currentEpisode: f.data()['currentEpisode'],
                          firstWatchDate: f.data()['startedWatching'],
                          lastWatchDate: f.data()['lastWatched'],
                          rating: f.data()['rating'] ?? 0.0, //UPDATED WITH RATING
                          favorite: f.data()['favorite'] ?? false,);
                        list.add(show);
                        allWatchedShows.add(show);
                      });
                      break;
                  }
                }
                List filteredList = sortedList.where((e) => e.name.toLowerCase().contains( _searchTerm.toLowerCase())).toList();
                if ( _searchTerm != ""){
                  if (filteredList.length > 0 ){
                    return WatchlistView(list: filteredList,              scrollController: listController,
                    );
                  }
                  else{
                    return Text("No data");
                  }
                }
                else {
                  return WatchlistView(
                      list: watchedShowList,
                    scrollController: listController,

                  );
                }
              }
          );
        }
        else{
          //If we are searching,
          if ( _searchTerm != ""){
            log("building search view");

            return WatchlistView(
              list: sortedList.where((e) => e.name.toLowerCase().contains( _searchTerm.toLowerCase())).toList(),
              scrollController: listController,

            );
          }
          else{
            //If we are not searching
            log("building search view");
            return new WatchlistView(
              list: sortedList,
              scrollController: listController,
            );
          }
        }
    }
  }
}

class WatchlistView extends StatefulWidget {
  final List list;
  final ScrollController scrollController;

  const WatchlistView({Key key, this.list, this.scrollController}) : super(key: key);
  @override
  _WatchlistViewState createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView> {
  // ScrollController scrollController = ScrollController(
  //   initialScrollOffset: 0.0,
  // );
  ScrollController scrollController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = widget.scrollController;
    scrollController.addListener(onListen);

    print("watchliested");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.removeListener(onListen);
    super.dispose();
  }

  void onListen() {
    setState(() {});
  }

  final options = LiveOptions(
    // Start animation after (default zero)
    delay: Duration(seconds: 0),

    // Show each item through (default 250)
    showItemInterval: Duration(milliseconds: 100),

    // Animation duration (default 250)
    showItemDuration: Duration(milliseconds: 100),

    // Animations starts at 0.05 visible
    // item fraction in sight (default 0.025)
    visibleFraction: 0.0005,

    // Repeat the animation of the appearance
    // when scrolling in the opposite direction (default false)
    // To get the effect as in a showcase for ListView, set true
    reAnimateOnVisibility: false,
  );

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    final itemSize = _height / 2.7;
    // print("watchlist");
    return AnimationLimiter(
      child: ListView.builder(
          // options: options,
          // key: UniqueKey(),
          // physics: ,
          controller: widget.scrollController,
          itemCount: widget.list.length,
          itemBuilder: (_, index) {
            final itemPositionOffset = index * itemSize;
            final difference = scrollController.offset - itemPositionOffset;
            final percent = 1 - (difference / (itemSize));
            double scalex = percent;
            if (scalex > 1.0) scalex = 1.0;

            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0*index,
                child: FadeInAnimation(
                  delay: Duration(milliseconds:index*50 ),
                  child: Center(
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..scale(scalex, scalex),
                      child: SizedBox(
                        height: itemSize,
                        child: InkWell(
                            onTap: (){
                              showModalBottomSheet<dynamic>(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25.0),
                                        topRight: Radius.circular(25.0)),
                                  ),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return _createRouteShowDetail(widget.list,index, _width, _height);
                                  },
                                  isScrollControlled: true);
                            },
                            child: WatchedCardInList(
                                show: widget.list[index % widget.list.length])),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}


 _createRouteShowDetail(List<WatchedTVShow> data, int index, double _width, double _height) {
  Future<List<dynamic>> episodes = new Network().getEpisodes(showID: data[index].id);
  print("creating route to details");
  return ClipRRect(
    borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
    child: FutureBuilder<Object>(
        future: episodes,
        builder: (context, snapshot) {
          if ( snapshot.hasData){
            data[index].episodes = snapshot.data;
            // print(data[index].episodes.length);
            return WatchedDetailView(show: data[index]);
          }
          else{
            return Container(
              width: _width,
              height: _height*.95,
              color: bgColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: _width,
                    // color: Colors.black,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(greenColor),
                        // backgroundColor: greenColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

        }
      ),
  );
}

Widget discoverFavorites() {
  return Container();
}
