import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:show_time/components/badge.dart';
import 'package:show_time/components/image_sliver_delegate.dart';
import 'package:show_time/components/latest_ep_carousel.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/models/tvshow_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DetailView extends StatefulWidget {
  final TVShowDetails show;

  const DetailView({Key? key, required this.show}) : super(key: key);

  @override
  _WatchedDetailViewState createState() => _WatchedDetailViewState();
}

class _WatchedDetailViewState extends State<DetailView>
    with TickerProviderStateMixin {
  double radius = 25.0;

  bool isExpanded = false;

  late Animation<double> animation;
  late AnimationController _controller;
  List<Widget> badges = [];

  String moreLabel = "Show More";

  bool _tapped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: this,
    );

    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    );
//    print(widget.tvshow.name);

    _controller.reset();
    _controller.duration = const Duration(milliseconds: 500);
    _controller.forward();

    badges = getBadges();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TVShowDetails show = widget.show;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    // double _iconSize = _width/3;
    const BorderRadius _radius = BorderRadius.all(Radius.circular(25.0));
    const double height = .8;

    return ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius)),
        child: NotificationListener<DraggableScrollableNotification>(
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
              minChildSize: .2,
              maxChildSize: 1.0,
              builder: (context, scrollController) {
                return Container(
                    width: _width,
                    height: _height,
                    decoration: const BoxDecoration(
                      color: GlobalColors.bgColor,
                    ),
                    child: CustomScrollView(
                        // physics: NeverScrollableScrollPhysics(),
                        controller: scrollController,
                        slivers: <Widget>[
                          SliverPersistentHeader(
                              pinned: true,
                              floating: false,
                              delegate: ImageSliverAppBarDelegate(
                                  expandedHeight: _height,
                                  show: widget.show)), //TOP IMAGES and title
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 58.0),
                              child: AnimationLimiter(
                                child: Column(
                                  // physics: PageScrollPhysics(),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0, vertical: 10.0),
                                      child: SizedBox(
                                        height: _height / 20,
                                        width: _width,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: List.generate(
                                              widget.show.genres!.length,
                                              (index) {
                                            return AnimationConfiguration
                                                .staggeredList(
                                              duration:
                                                  const Duration(milliseconds: 200),
                                              position: index,
                                              child: FadeInAnimation(
                                                delay: Duration(
                                                    milliseconds:
                                                        250 * index + 1),
                                                child: SlideTransition(
                                                  position: Tween<Offset>(
                                                    begin: const Offset(0, 0.1),
                                                    end: Offset.zero,
                                                  ).animate(animation),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 5.0),
                                                    child: Container(
                                                      height: _height / 20,
                                                      decoration: const BoxDecoration(
                                                        color: GlobalColors
                                                            .primaryBlue,
                                                        borderRadius: _radius,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Center(
                                                          child: AutoSizeText(
                                                            widget.show
                                                                .genres![index],
                                                            maxFontSize: 16,
                                                            minFontSize: 13,
                                                            maxLines: 1,
                                                            style: GoogleFonts
                                                                .roboto(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        _width /
                                                                            20),
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
                                        child: displayBadges(_height, _width)),
                                    if (isExpanded)
                                      FadeTransition(
                                        opacity: Tween<double>(
                                          begin: 0,
                                          end: 1,
                                        ).animate(animation),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25.0, vertical: 15.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 15.0),
                                                child: Text(
                                                  "Summary",
                                                  style: TextStyle(
                                                    fontSize: _width / 20,
                                                    fontWeight: FontWeight.w700,
                                                    color: GlobalColors
                                                        .greyTextColor,
                                                    fontFamily: 'Raleway',
                                                  ),
                                                ),
                                              ),
                                              AnimatedSizeAndFade(
                                                vsync: this,
                                                child: _tapped
                                                    ? Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            widget.show
                                                                    .parseHtmlString()
                                                                    .substring(
                                                                        0,
                                                                        100) +
                                                                "...",
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                _tapped =
                                                                    !_tapped;
                                                              });
                                                            },
                                                            // textColor:
                                                                // GlobalColors
                                                                    // .primaryGreen,
                                                            child: const Center(
                                                              child: Text(
                                                                  "Show More"),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    : Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            widget.show
                                                                .parseHtmlString(),
                                                            style: GoogleFonts.roboto(
                                                                fontSize:
                                                                    _width / 26,
                                                                color: GlobalColors
                                                                    .greyTextColor),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                _tapped =
                                                                    !_tapped;
                                                              });
                                                            },
                                                            // textColor:
                                                                // GlobalColors
                                                                    // .primaryGreen,
                                                            child: const Center(
                                                              child: Text(
                                                                  "Show Less"),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                              ),
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
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25.0,
                                                      vertical: 5.0),
                                              child: Text(
                                                "Latest episodes",
                                                style: TextStyle(
                                                  fontSize: _width / 20,
                                                  fontWeight: FontWeight.w700,
                                                  color: GlobalColors
                                                      .greyTextColor,
                                                  fontFamily: 'Raleway',
                                                ),
                                              ),
                                            ),
                                            LatestEpisodesCarousel(
                                                show: widget.show),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]));
              }),
        ));
  }

  getBadges() {
    List<DetailBadge> badges = [];

    badges.add(DetailBadge(
      text: widget.show.rating != 0 ? widget.show.rating.toString() : r"N\A",
      colors: const [GlobalColors.pinkColor, GlobalColors.lightPinkColor],
    ));
    badges.add(DetailBadge(
      text: widget.show.runtime != 0 ? widget.show.runtime.toString() : r"N\A",
      colors: const [GlobalColors.goldColor, GlobalColors.lightGoldColor],
    ));
    badges.add(DetailBadge(
      text:
          GlobalVariables.statusCodes[widget.show.status.toString()].toString(),
      colors: const [GlobalColors.primaryBlue, Colors.lightBlue],
    ));
    badges.add(DetailBadge(
      text: widget.show.countryCode() ?? "",
      colors: const [GlobalColors.orangeColor, Colors.orangeAccent],
    ));
    return badges;
  }

  Widget displayBadges(double _height, double _width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Container(
          // color: Colors.grey,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(25.0)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(.3),
                    offset: const Offset(2, 3),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          "Details",
                          style: TextStyle(
                            color: GlobalColors.greyTextColor,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w700,
                            fontSize: _width / 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10),
                      child: AutoSizeText(
                        "About",
                        style: TextStyle(
                          color: GlobalColors.primaryGreen,
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
                child: SizedBox(
                  width: _width,
                  height: _height / 9,
                  child: AnimationLimiter(
                    child: Center(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: badges.length,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: FadeInAnimation(
                              duration: const Duration(milliseconds: 350),
                              child: SlideAnimation(
                                horizontalOffset: 30.0,
                                child: badges[index],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
