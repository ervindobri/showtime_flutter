import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class PopularSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool hideTitleWhenExpanded;
  final Widget child;
  final Widget back;

  PopularSliverDelegate({
    this.child,
    @required this.back,
    @required this.expandedHeight,
    this.hideTitleWhenExpanded = true,

  });



  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = expandedHeight - (shrinkOffset);
    final proportion = 2 - (expandedHeight / appBarSize);

    return Container(
      child: SizedBox(
        height: expandedHeight,
        child: Stack(
          children: [
            SizedBox(
              height: appBarSize < minExtent*.6 ? minExtent*.6 : appBarSize,
//            height: appBarSize,
              child: child
          ),
            Positioned(
              bottom: 10,
                child: Visibility(
                  visible: proportion >= 0.0 ? true : false,
                  child: Opacity(
                    opacity: proportion >= 0.0 && proportion <= 1.0 ? proportion : 0,
                      child: back
                  ),
                )
            )
          ]
          ,
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