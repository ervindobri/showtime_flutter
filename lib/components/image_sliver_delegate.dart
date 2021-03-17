import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:show_time/constants/custom_variables.dart';
import 'package:show_time/models/tvshow_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ImageSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool hideTitleWhenExpanded;
  final TVShowDetails show;

  ImageSliverAppBarDelegate({
    required this.show,
    required this.expandedHeight,
    this.hideTitleWhenExpanded = true,

  });



  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = expandedHeight - (shrinkOffset);
    final proportion = 2 - (expandedHeight / appBarSize);
    double _height = Get.size.height;
    double _width = Get.size.width;
    double percentage = proportion;
    if (percentage < 0.0) percentage = 0.0;
    if (percentage > 1.0) percentage = 1.0;

    // print(proportion);
    return SafeArea(
      child: SizedBox(
        height: expandedHeight,
        child: Container(
          height: (_height)*percentage,
          child: Stack(
            children: <Widget>[
              Stack(
                children: [
                  Opacity(
                    opacity: percentage,
                    child: CachedNetworkImage(
                      imageUrl: this.show.imageThumbnailPath!,
                      width: _width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                    child: Container(
                      width: _width,
                      color: Colors.black.withOpacity(.2),
                    ),
                  )
                ],
              ),
              Container(
                // height: _height * .45,
                height: _height,
                width: _width,
                child: Opacity(
                  opacity: percentage,
                  child: CachedNetworkImage(
                    imageUrl: this.show.imageThumbnailPath!,
                    width: _width,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: IconButton(
                        icon: FaIcon(FontAwesomeIcons.times),
                        color: GlobalColors.greyTextColor,
                        onPressed: () => Navigator.of(context).pop()
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   bottom: 0,
              //   child: Visibility(
              //     visible: proportion > 0.0 ? true : false,
              //     child: Opacity(
              //       opacity: percentage,
              //       child: Container(
              //         width: _width * .3,
              //         height: _width * .4,
              //         child: Hero(
              //           tag: 'thumbnailPhoto${show.id}',
              //           child: CachedNetworkImage(
              //             imageUrl: show.imageThumbnailPath,
              //             imageBuilder: (context, image){
              //               return Container(
              //                 decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.only(
              //                       topRight: Radius.circular(25.0),
              //                       bottomRight: Radius.circular(25.0),
              //                     ),
              //                     boxShadow: [BoxShadow(
              //                       color: Colors.grey.withOpacity(.5),
              //                       spreadRadius: 10,
              //                       blurRadius: 25,
              //                       offset: Offset(0, 3), // changes position of shadow
              //                     ),
              //                     ],
              //                     image: DecorationImage(
              //                         image: image,
              //                         fit: BoxFit.cover
              //                     )
              //                 ),
              //               );
              //             },
              //
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Positioned.fill(
                bottom: 0,
                left: 1/_width,
                child: Opacity(
                  opacity: 1.0 - percentage,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10,
                        right: 30.0
                    ),
                    child: Center(
                      child: Container(
                        // height: 25,
                        child: AutoSizeText(
                            show.name!,
                            maxLines: 3,
                            maxFontSize: 28.0,
                            minFontSize: 13,
                            style: TextStyle(
                              fontSize: _width / 15,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              // color: GlobalColors.greyTextColor,

                              shadows: [
                                new BoxShadow(
                                  color: Colors.black.withOpacity(.3),
                                  blurRadius: 10.0,
                                  spreadRadius: 2
                                )
                              ]
                            )),

                      ), //TITLE-YEAR
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => expandedHeight/6;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}