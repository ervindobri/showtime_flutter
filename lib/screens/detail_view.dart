import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eWoke/components/expandable_text.dart';
import 'package:eWoke/components/fadein.dart';
import 'package:eWoke/components/image_sliver_delegate.dart';

import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/models/tvshow.dart';
import 'package:eWoke/models/tvshow_details.dart';
import 'package:eWoke/models/watched.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/parser.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:status_alert/status_alert.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DetailView extends StatefulWidget {
  final TVShow tvshow;
  final TVShowDetails show;
  final ScrollController controller;

  const DetailView({Key key, this.tvshow, this.show, this.controller}) : super(key: key);

  @override
  _WatchedDetailViewState createState() => _WatchedDetailViewState();
}

class _WatchedDetailViewState extends State<DetailView> with TickerProviderStateMixin {
  RefreshController _refreshController;

   BorderRadius _standardRadius = BorderRadius.all(Radius.circular(25.0));
  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
//    print(widget.tvshow.name);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void enterRefresh() {
    _refreshController.requestLoading();
  }



  //TODO: refactor
  String _parseHtmlString(String htmlString) {

    try{
      var document = parse(htmlString);
      String parsedString = parse(document.body.text).documentElement.text;
      return parsedString;
    }
    catch(e){
     return "No description";
    }

  }

  @override
  Widget build(BuildContext context) {
    TVShowDetails show = widget.show;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    double _iconSize = _width/3;

    int columnCount = 2;
//    print(show.name);

    //TODO: REDESIGN detail view, with episode carousel, and pinned sliver with back button and show title
    //TODO: change details gridview, to BADGES like avatars
    return


      Container(
        width: _width,
        height: _height*.95,
        decoration: BoxDecoration(
          color: Colors.white,
//              borderRadius: BorderRadius.all(Radius.circular(50.0)),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0)),
        ),
        child: CustomScrollView(
          // physics: NeverScrollableScrollPhysics(),
          controller: widget.controller,
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: ImageSliverAppBarDelegate(
                expandedHeight: _height*.3,
                show: widget.show
              )
            ),//TOP IMAGES and title
            SliverFillRemaining(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                    child: Container(
                      height: _height/20,
                      width: _width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: List.generate(
                            show.genres.length, (index){
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Container(
                              height: _height/20,
                              decoration: BoxDecoration(
                                color: greenColor,
                                borderRadius: _standardRadius,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                  child: Text(
                                    show.genres[index],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Raleway'
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                              Text(
                                  "Summary",
                                  style: TextStyle(
                                    fontSize: _width/20,
                                    fontWeight: FontWeight.w700,
                                    color: greyTextColor,
                                    fontFamily: 'Raleway',
                                  ),
                              ),
                              ExpandableText(
                                text: _parseHtmlString(show.summary),
                                textLabel: Text(
                                  "Show more",
                                  style: TextStyle(
                                    color: greenColor
                                  ),
                                )
                              ),

                          ],
                        ),
                      ),
            // )), // SUMMARY
            // FadeIn(.66,
                  // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
            //   child: Container(
            //     child: Column(
            //       children: [
            //         Text(
            //             "Details",
            //           style: TextStyle(
            //             fontSize: _width/20,
            //             fontWeight: FontWeight.w700,
            //             color: greyTextColor,
            //             fontFamily: 'Raleway',
            //           ),
            //         ),
            //         AnimationLimiter(
            //           child: GridView.count(
            //             physics: NeverScrollableScrollPhysics(),
            //             shrinkWrap: true,
            //             crossAxisCount: columnCount,
            //             childAspectRatio: (10 / 10),
            //             children: [
            //               AnimationConfiguration.staggeredGrid(
            //                 position: 0,
            //                 columnCount: columnCount,
            //                 child: SlideAnimation(
            //                   child: FadeInAnimation(
            //                     child: Padding(
            //                       padding: const EdgeInsets.all(12.0),
            //                       child: Container(
            //                         decoration: BoxDecoration(
            //                           boxShadow: [new BoxShadow(
            //                             spreadRadius: -6,
            //                             blurRadius: 15.0,
            //                             color: Colors.redAccent,
            //                             offset: Offset(0,6),
            //                           )],
            //                           gradient: LinearGradient(
            //                               begin: Alignment.bottomCenter,
            //                               end: Alignment.topCenter,
            //                               colors: [fireColor, pinkColor]
            //                           ),
            //                           borderRadius: _standardRadius,
            //                         ),
            //                         child: Stack(
            //                           alignment: Alignment.center,
            //                           children: [
            //                             FaIcon(
            //                               FontAwesomeIcons.starHalfAlt,
            //                               color: Colors.white.withOpacity(.3),
            //                               size: _iconSize,
            //                             ),
            //                             Center(
            //                               child: Text(
            //                                 "${show.rating.toString()}",
            //                                 style: TextStyle(
            //                                   color: Colors.white,
            //                                   fontFamily: 'Raleway',
            //                                   fontWeight: FontWeight.w700,
            //
            //                                   fontSize: _width/10,
            //                                 ),
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               AnimationConfiguration.staggeredGrid(
            //                 position: 1,
            //                 columnCount: 2,
            //                 child: SlideAnimation(
            //                   child: FadeInAnimation(
            //                     child: Padding(
            //                       padding: const EdgeInsets.all(12.0),
            //                       child: Container(
            //                         decoration: BoxDecoration(
            //                           boxShadow: [new BoxShadow(
            //                             spreadRadius: -6,
            //                             blurRadius: 15.0,
            //                             color: Colors.teal.shade700,
            //                             offset: Offset(0,6),
            //                           )],
            //                           gradient: LinearGradient(
            //                               begin: Alignment.bottomCenter,
            //                               end: Alignment.topCenter,
            //                               colors: [Colors.teal.shade700, Colors.teal.shade300]
            //                           ),
            //                           borderRadius: _standardRadius,
            //                         ),
            //                         child: Stack(
            //                           alignment: Alignment.center,
            //                           children: [
            //                             FaIcon(
            //                               FontAwesomeIcons.stopwatch,
            //                               color: Colors.white.withOpacity(.3),
            //                               size: _iconSize,
            //                             ),
            //                             Center(
            //                               child: Text(
            //                                 "${show.runtime}",
            //                                 style: TextStyle(
            //                                   color: Colors.white,
            //                                   fontWeight: FontWeight.w700,
            //                                   fontFamily: 'Raleway',
            //                                   fontSize:  _width/10,
            //                                 ),
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               AnimationConfiguration.staggeredGrid(
            //                 position: 2,
            //                 columnCount: columnCount,
            //                 child: SlideAnimation(
            //                   child: FadeInAnimation(
            //                     child: Padding(
            //                       padding: const EdgeInsets.all(12.0),
            //                       child: Container(
            //                         decoration: BoxDecoration(
            //                           boxShadow: [new BoxShadow(
            //                             spreadRadius: -6,
            //                             blurRadius: 15.0,
            //                             color: Colors.grey.shade700,
            //                             offset: Offset(0,6),
            //                           )],
            //                           gradient: LinearGradient(
            //                               begin: Alignment.bottomCenter,
            //                               end: Alignment.topCenter,
            //                               colors: [Colors.grey.shade700, Colors.grey.shade300]
            //                           ),
            //                           borderRadius: _standardRadius,
            //                         ),
            //                         child: Stack(
            //                           alignment: Alignment.center,
            //                           children: [
            //                             FaIcon(
            //                               FontAwesomeIcons.paperclip,
            //                               color: Colors.white.withOpacity(.3),
            //                               size: _iconSize,
            //                             ),
            //                             Center(
            //                               child: Text(
            //                                 "${show.status}",
            //                                 textAlign: TextAlign.center,
            //                                 style: TextStyle(
            //                                   color: Colors.white,
            //                                   fontFamily: 'Raleway',
            //                                   fontWeight: FontWeight.w700,
            //                                   fontSize:  _width/20,
            //                                 ),
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               AnimationConfiguration.staggeredGrid(
            //                 position: 3,
            //                 columnCount: columnCount,
            //                 child: SlideAnimation(
            //                   child: FadeInAnimation(
            //                     child: Padding(
            //                       padding: const EdgeInsets.all(12.0),
            //                       child: Container(
            //                         decoration: BoxDecoration(
            //                           boxShadow: [new BoxShadow(
            //                             spreadRadius: -4,
            //                             blurRadius: 15.0,
            //                             color: Colors.blue.shade700.withOpacity(.4),
            //                             offset: Offset(0,3),
            //                           )],
            //                           gradient: LinearGradient(
            //                               begin: Alignment.bottomCenter,
            //                               end: Alignment.topCenter,
            //                               colors: [Colors.blue.shade700, Colors.blue.shade300]
            //                           ),
            //                           borderRadius: _standardRadius,
            //                         ),
            //                         child: Stack(
            //                           alignment: Alignment.center,
            //                           children: [
            //                             FaIcon(
            //                               FontAwesomeIcons.globe,
            //                               color: Colors.white.withOpacity(.3),
            //                               size: _iconSize,
            //                             ),
            //                             Center(
            //                               child: Text(
            //                                 "${show.language}",
            //                                 textAlign: TextAlign.center,
            //
            //                                 style: TextStyle(
            //                                   color: Colors.white,
            //                                   fontWeight: FontWeight.w700,
            //                                   fontFamily: 'Raleway',
            //                                   fontSize:  _width/20,
            //                                 ),
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Divider(
            //             height: 1.2,
            //             color: greenColor,
            //           ),
            //         ),
            //       ],
            //     )
            //   ),
            // )),
          ],
        ),
      ),
    ]));
  }
}
