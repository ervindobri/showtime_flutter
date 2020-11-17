import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/models/tvshow_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ImageSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool hideTitleWhenExpanded;
  final TVShowDetails show;

  ImageSliverAppBarDelegate({
    this.show,
    @required this.expandedHeight,
    this.hideTitleWhenExpanded = true,

  });



  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = expandedHeight - (shrinkOffset);
    final proportion = 2 - (expandedHeight / appBarSize);
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    double percentage = proportion;
    if (percentage < 0.0) percentage = 0.0;
    if (percentage > 1.0) percentage = 1.0;

    // print(proportion);
    return SafeArea(
      child: SizedBox(
        height: expandedHeight,
        child: Stack(
            children: [
                SizedBox(
                height: appBarSize < minExtent*.6 ? minExtent*.6 : appBarSize,
          //            height: appBarSize,
                    child: Container(
                      height: _height * .35,
                      child: Stack(
                        children: <Widget>[
                          Container(
                              height: _height * .25,
                              decoration: BoxDecoration(
                                  color: greenColor,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(percentage > 0.0 ? 25.0 : 0.0),
                                    bottomRight: Radius.circular(percentage > 0.0 ? 25.0 : 0.0)
                                  )
                              ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                  icon: FaIcon(FontAwesomeIcons.times),
                                  color: Colors.white,
                                  onPressed: () => Navigator.of(context).pop()
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Visibility(
                              visible: proportion > 0.0 ? true : false,
                              child: Opacity(
                                opacity: percentage,
                                child: Container(
                                  width: _width * .3,
                                  height: _width * .4,
                                  child: Hero(
                                    tag: 'thumbnailPhoto${show.id}',
                                    child: CachedNetworkImage(
                                      imageUrl: show.imageThumbnailPath,
                                      imageBuilder: (context, image){
                                        return Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(25.0),
                                                bottomRight: Radius.circular(25.0),
                                              ),
                                              boxShadow: [BoxShadow(
                                                color: Colors.grey.withOpacity(.5),
                                                spreadRadius: 10,
                                                blurRadius: 25,
                                                offset: Offset(0, 3), // changes position of shadow
                                              ),
                                              ],
                                              image: DecorationImage(
                                                  image: image,
                                                  fit: BoxFit.cover
                                              )
                                          ),
                                        );
                                      },

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            bottom: 0,
                            left: appBarSize < _width * .3 + 20 ? appBarSize : _width * .3 + 20,
                            // left: appBarSize,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: _height * .15,
                                  width: _width * .6,
                                  // color: CupertinoColors.black,
                                  child: Center(
                                    child: Container(
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: <Widget>[
                                            AutoSizeText(
                                                show.name,
                                                maxLines: 2,
                                                maxFontSize: 24.0,
                                                minFontSize: 10,
                                                style: TextStyle(
                                                  fontSize: _width / 15,
                                                  fontFamily: 'Raleway',
                                                  fontWeight: FontWeight.w700,
                                                  color: CupertinoColors.white,

                                                  shadows: [
                                                    new BoxShadow(
                                                      color: Colors.black.withOpacity(.3),
                                                      blurRadius: 10.0,
                                                      spreadRadius: 2
                                                    )
                                                  ]
                                                )),
                                            if (percentage > 0.0) Opacity(
                                              opacity: percentage,
                                              child: Text(show.startDate.split('-')[0].toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    color: CupertinoColors.white,
                                                    fontSize: _width / 20,
                                                    fontFamily: 'Raleway',
                                                      shadows: [
                                                        new BoxShadow(
                                                            color: Colors.black.withOpacity(.3),
                                                            blurRadius: 10.0,
                                                            spreadRadius: 2
                                                        )
                                                      ]

                                                  )),
                                            ),
                                          ]),

                                    ), //TITLE-YEAR
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ),
          ]
        ),
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => expandedHeight/2;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}