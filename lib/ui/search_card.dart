import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eWoke/components/badge.dart';
import 'package:eWoke/components/expandable_text.dart';
import 'package:eWoke/components/image_sliver_delegate.dart';
import 'package:eWoke/components/latest_ep_carousel.dart';
import 'package:eWoke/components/snap_sheet.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/main.dart';
import 'package:eWoke/models/tvshow.dart';
import 'package:eWoke/models/tvshow_details.dart';
import 'package:eWoke/network/network.dart';
import 'package:eWoke/network/firebase_utils.dart';
import 'package:eWoke/screens/detail_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:status_alert/status_alert.dart';
import 'package:html/parser.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class ShowCard extends StatefulWidget {
  final TVShow show;

  final BorderRadiusGeometry _leftRadius = const BorderRadius.only(
    bottomRight: Radius.circular(25.0),
    topRight: Radius.circular(50.0),
  );

  const ShowCard({Key key, this.show}) : super(key: key);

  @override
  _ShowCardState createState() => _ShowCardState();
}

class _ShowCardState extends State<ShowCard> with AnimationMixin {
  TVShowDetails showDetails;

  bool _added = false;

  bool _done = false;

  double radius = 25.0;

  bool isExpanded = false;

  getDetailResults({TVShow show}) => new Network().getDetailResults(show: show);

  Animation<double> animation;
  AnimationController _controller;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _done = false;
    });
    super.initState();
    _checkIfAdded();
    _getShowDetails();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: this,
    );

    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    );
  }

  _checkIfAdded() async {
    var res = await FirestoreUtils().checkIfShowExists(widget.show.id);
    setState(() {
      _added = res;
    });
  }

  _getShowDetails() async {
//    print("getting details: ${widget.show.name}");
    showDetails = await getDetailResults(show: widget.show);
  }

  @override
  void didUpdateWidget(ShowCard oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
//    print("updated");
    _getShowDetails();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    const BorderRadius _radius = BorderRadius.all(Radius.circular(25.0));
    const BorderRadius _bottomRadius = BorderRadius.only(
      bottomLeft: Radius.circular(25.0),
      bottomRight: Radius.circular(25.0),
    );

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 25),
        child: InkWell(
          onTap: () {
            _controller.reset();
            //TODO: add snapping sheet
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(radius),
                      topRight: Radius.circular(radius)),
                ),
                context: context,
                builder: (BuildContext context) {
                  double height = .66;
                  _controller.duration = Duration(milliseconds: 500);
                  _controller.forward();
                  return ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(radius),
                          topRight: Radius.circular(radius)),
                      child:
                          NotificationListener<DraggableScrollableNotification>(
                        onNotification: (n) {
                          if (n.extent < .87) {
                            setState(() {
                              isExpanded = false;
                            });
                          } else {
                            setState(() {
                              isExpanded = true;
                            });
                          }
                          return true;
                        },
                        child: DraggableScrollableSheet(
                            expand: false,
                            initialChildSize: height,
                            minChildSize: height,
                            maxChildSize: .95, //TODO: calculate safe height
                            builder: (context, scrollController) {
                              return Container(
                                  width: _width,
                                  height: _height * .95,
                                  decoration: BoxDecoration(
                                    color: bgColor,
                                    //              borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25.0),
                                        topRight: Radius.circular(25.0)),
                                  ),
                                  child: CustomScrollView(
                                      // physics: NeverScrollableScrollPhysics(),
                                      controller: scrollController,
                                      slivers: <Widget>[
                                        SliverPersistentHeader(
                                            pinned: true,
                                            floating: false,
                                            delegate: ImageSliverAppBarDelegate(
                                                expandedHeight: _height * .3,
                                                show:
                                                    showDetails)), //TOP IMAGES and title
                                        SliverToBoxAdapter(
                                          child: AnimationLimiter(
                                            child: Column(
                                              // physics: PageScrollPhysics(),
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 25.0,
                                                      vertical: 10.0),
                                                  child: Container(
                                                    height: _height / 20,
                                                    width: _width,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: List.generate(
                                                          showDetails.genres
                                                              .length, (index) {
                                                        return AnimationConfiguration
                                                            .staggeredList(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  200),
                                                          position: index,
                                                          child:
                                                              FadeInAnimation(
                                                            delay: Duration(
                                                                milliseconds:
                                                                    50 * index),
                                                            child:
                                                                SlideTransition(
                                                              position: Tween<
                                                                  Offset>(
                                                                begin: Offset(
                                                                    0, 0.1),
                                                                end:
                                                                    Offset.zero,
                                                              ).animate(
                                                                  animation),
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        5.0),
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      _height /
                                                                          20,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color:
                                                                        greenColor,
                                                                    borderRadius:
                                                                        _radius,
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            5.0),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        showDetails
                                                                            .genres[index],
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontFamily: 'Raleway'),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                  ),
                                                ),
                                                FadeTransition(
                                                    opacity: Tween<double>(
                                                      begin: 0,
                                                      end: 1,
                                                    ).animate(animation),
                                                    child: displayBadges(
                                                        _height, _width)),
                                                if (isExpanded)
                                                  FadeTransition(
                                                    opacity: Tween<double>(
                                                      begin: 0,
                                                      end: 1,
                                                    ).animate(animation),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 25.0,
                                                          vertical: 15.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom:
                                                                        5.0),
                                                            child: Text(
                                                              "Summary",
                                                              style: TextStyle(
                                                                fontSize:
                                                                    _width / 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color:
                                                                    greyTextColor,
                                                                fontFamily:
                                                                    'Raleway',
                                                              ),
                                                            ),
                                                          ),
                                                          ExpandableText(
                                                              text: showDetails
                                                                  .parseHtmlString(),
                                                              textLabel:
                                                                  isExpanded
                                                                      ? Text(
                                                                          "Show more",
                                                                          style:
                                                                              TextStyle(color: greenColor),
                                                                        )
                                                                      : Text(
                                                                          "...",
                                                                          style:
                                                                              TextStyle(color: greyTextColor),
                                                                        )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                if (isExpanded)
                                                  FadeTransition(
                                                    opacity: Tween<double>(
                                                      begin: 0,
                                                      end: 1,
                                                    ).animate(animation),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      25.0,
                                                                  vertical:
                                                                      5.0),
                                                          child: Text(
                                                            "Latest episodes",
                                                            style: TextStyle(
                                                              fontSize:
                                                                  _width / 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  greyTextColor,
                                                              fontFamily:
                                                                  'Raleway',
                                                            ),
                                                          ),
                                                        ),
                                                        latestEpisodesCarousel(
                                                            _width,
                                                            _height,
                                                            showDetails),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ]));
                            }),
                      ));
                },
                isScrollControlled: true);
          },
          child: Hero(
              tag: 'thumbnailPhoto${widget.show.id}',
              child: Container(
                width: _width * .3,
                height: _height / 1.7,
                constraints: BoxConstraints(
                    maxWidth: _width * 0.7, maxHeight: _height / 1.7),
                decoration: BoxDecoration(
                  color: bgColor,
                  image: DecorationImage(
                      image: NetworkImage(widget.show.imageThumbnailPath),
                      fit: BoxFit.fill),
                  borderRadius: _radius,
                  boxShadow: [
                    new BoxShadow(
                        color: Colors.black.withOpacity(.5),
                        blurRadius: 5.0,
                        spreadRadius: -2,
                        offset: Offset(2, 5)),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Stack(
                      children: [
                        new ClipRRect(
                          borderRadius: _bottomRadius,
                          child: new BackdropFilter(
                            filter: new ImageFilter.blur(
                                sigmaX: 10.0, sigmaY: 10.0),
                            child: new Container(
                              width: _width,
                              height: _height / 6,
                              decoration: new BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: _bottomRadius,
                              ),
                              child: new Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: _width / 3,
                                                  height: _height / 25,
                                                  decoration: BoxDecoration(
                                                    color: greyTextColor,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(25.0),
                                                      topRight:
                                                          Radius.circular(25.0),
                                                      bottomLeft:
                                                          Radius.circular(25.0),
                                                      bottomRight:
                                                          Radius.circular(25.0),
                                                    ),
                                                    boxShadow: [
                                                      new BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(.1),
                                                          blurRadius: 15.0,
                                                          spreadRadius: 3,
                                                          offset: Offset(0, 0)),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Text(
                                                        "Runtime",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Raleway',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              25,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${widget.show.runtime}",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Raleway',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              25,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      25,
                                                  decoration: BoxDecoration(
                                                    color: fireColor,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(25.0),
                                                      topRight:
                                                          Radius.circular(25.0),
                                                      bottomLeft:
                                                          Radius.circular(25.0),
                                                      bottomRight:
                                                          Radius.circular(25.0),
                                                    ),
                                                    boxShadow: [
                                                      new BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(.1),
                                                          blurRadius: 15.0,
                                                          spreadRadius: 3,
                                                          offset: Offset(0, 0)),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Center(
                                                        child: Text(
                                                          "Rating",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Raleway',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                25,
                                                          ),
                                                        ),
                                                      ),
                                                      Center(
                                                        child: Text(
                                                          "${widget.show.rating == 0 ? r"N\A" : widget.show.rating}",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Raleway',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                25,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Container(
                                              width: _height / 9,
                                              height: _height / 10,
                                              decoration: BoxDecoration(
                                                color: blueColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25)),
                                                boxShadow: [
                                                  new BoxShadow(
                                                      color: blueColor
                                                          .withOpacity(.1),
                                                      blurRadius: 12.0,
                                                      spreadRadius: 2,
                                                      offset:
                                                          Offset.fromDirection(
                                                              5, 0)),
                                                ],
                                              ),
                                              child: Container(
                                                child: IconButton(
                                                  onPressed: () {
                                                    if (!_added) {
                                                      FirestoreUtils()
                                                          .addToWatchedShows(
                                                              showDetails);
                                                      setState(() {
                                                        _added = true;
                                                      });
                                                      StatusAlert.show(
                                                        context,
                                                        duration: Duration(
                                                            seconds: 2),
                                                        blurPower: 5.0,
                                                        title: 'Show added',
                                                        configuration:
                                                            IconConfiguration(
                                                                icon:
                                                                    Icons.done),
                                                      );
                                                    } else {
                                                      // print(widget.show.id);
                                                      //FOR UPDATING SHOWS RATING
                                                      // _updateRating(showDetails);
                                                      StatusAlert.show(
                                                        context,
                                                        duration: Duration(
                                                            seconds: 2),
                                                        blurPower: 5.0,
                                                        title:
                                                            " ${widget.show.name} already added!",
                                                        configuration:
                                                            IconConfiguration(
                                                                icon:
                                                                    Icons.info),
                                                      );
                                                    }
                                                  },
                                                  icon: FaIcon(
                                                    FontAwesomeIcons.couch,
                                                    color: Colors.white,
                                                    size: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        10,
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
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ));
  }

  //TODO: DONE add more detail badges - status, language
  getBadges() {
    List<DetailBadge> badges = [];

    badges.add(new DetailBadge(
      text: showDetails.rating.toString(),
      colors: [pinkColor, lightPinkColor],
    ));
    badges.add(new DetailBadge(
      text: showDetails.runtime.toString(),
      colors: [goldColor, lightGoldColor],
    ));
    badges.add(new DetailBadge(
      text: showDetails.status.toString(),
      colors: [blueColor, Colors.lightBlue],
    ));
    badges.add(new DetailBadge(
      text: showDetails.countryCode(),
      colors: [orangeColor, Colors.orangeAccent],
    ));
    return badges;
  }

  Widget displayBadges(double _height, double _width) {
    List<Widget> badges = getBadges();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Container(
          // color: Colors.grey,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(.3),
                    offset: Offset(2, 3),
                    blurRadius: 10,
                    spreadRadius: 2)
              ]),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          "Details",
                          style: TextStyle(
                            color: greyTextColor,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w700,
                            fontSize: _width / 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        "About",
                        style: TextStyle(
                          color: greenColor,
                          fontFamily: 'Raleway',
                          fontSize: _width / 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 10, right: 10, bottom: 15.0),
                child: Container(
                  width: _width,
                  height: _height / 9,
                  child: AnimationLimiter(
                    child: ListView.builder(
                      itemCount: badges.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: FadeInAnimation(
                            duration: Duration(milliseconds: 350),
                            child: SlideAnimation(
                              horizontalOffset: 20.0,
                              child: badges[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  @override
  void dispose() {
    _added = null;
    showDetails = null;
    super.dispose();
  }

  Widget latestEpisodesCarousel(double width, double height, TVShowDetails showDetails) {
          return LatestEpisodesCarousel(show: showDetails);
  }

  // void _updateRating(TVShowDetails show) {
  //   FirebaseFirestore.instance
  //       .collection("${auth.currentUser.email}")
  //       .doc("shows")
  //       .collection("watched_shows")
  //       .doc(show.id.toString())
  //       .update(
  //           {"rating" : show.rating}
  //       );
  // }

}
