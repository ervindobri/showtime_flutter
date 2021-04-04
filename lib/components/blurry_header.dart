import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlurrySliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool hideTitleWhenExpanded;
  final Widget child;
  final Widget back;
  final Widget? actions;
  final Widget? cancel;
  final Color backgroundColor;

  BlurrySliverDelegate(  {
    required this.backgroundColor,
    required this.child,
    required this.back,
    required this.expandedHeight,
    this.hideTitleWhenExpanded = true,
    this.actions,
    this.cancel,
  });



  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = expandedHeight - (shrinkOffset);
    final proportion = 2 - (expandedHeight / appBarSize);


    return kIsWeb
      ? ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: expandedHeight,
          color: backgroundColor.withOpacity(.4),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    back,
                    Container(
                        width: Get.width*.7,
                        child: child),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: cancel),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: actions ?? Container(),
                    ),
                  ],
                )
            ),
          ),
        ),
      ),
    )
      : ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: expandedHeight,
          color: backgroundColor.withOpacity(.4),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0, right: 5, left: 5),
                child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            width: Get.width*.7,
                            child: child),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: cancel),
                        )
                      ],
                    )
                ),
              ),
              Visibility(
                visible: proportion >= 0.0 ? true : false,
                child: Opacity(
                    opacity: proportion >= 0.0 && proportion <= 1.0 ? proportion : 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        back,
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: actions ?? Container(),
                        )
                      ],
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}