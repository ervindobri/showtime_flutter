import 'package:eWoke/constants/custom_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'back.dart';


class PlayingSlivers extends StatefulWidget {
  @override
  _PlayingSliversState createState() => _PlayingSliversState();
}

class _PlayingSliversState extends State<PlayingSlivers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: CustomSliverDelegate(
                expandedHeight: 150,
              ),
            ),
            SliverFillRemaining(
              child: Center(
                child: Text("data"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool hideTitleWhenExpanded;
  final Widget child;

  CustomSliverDelegate({
    @required this.child,
    @required this.expandedHeight,
    this.hideTitleWhenExpanded = true,

  });



  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = expandedHeight - (shrinkOffset);
    final cardTopPosition = expandedHeight / 2 - shrinkOffset;
    final proportion = 2 - (expandedHeight / appBarSize);
    final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion+(1-proportion);
//    final percent = 1.0;
    final width = percent > 0.5 ? percent : 0.5;
   print(proportion);
    final double _radius = percent == 0.0 ? percent : 25;
    return SizedBox(
      height: expandedHeight + expandedHeight / 10,
      child: Stack(
        children: [
          SizedBox(
            height: appBarSize < minExtent*.65 ? minExtent*.65 : appBarSize,
//            height: appBarSize,
            child: AppBar(
              automaticallyImplyLeading: false,
              titleSpacing: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(_radius),
                        bottomRight: Radius.circular(_radius))),
              backgroundColor: greenColor,
              elevation: 0.0,
              centerTitle: true,
              title: Opacity(
//                  opacity: hideTitleWhenExpanded ? 1.0 - percent :  1.0,
                  opacity: proportion >= 0.0 && proportion <= 1.0 ? proportion : 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: back(context),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                              child: Text(
                            "Browse shows",
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                              ),
                          )
                ),
                        ],
                      ),
                    ],
                  )
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: cardTopPosition > 0 ? cardTopPosition : 0,
            bottom: -25,
            child: Opacity(
              opacity: 1.0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50 * width),
                  child: Center(
                    child: child
                  ),
                ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight + expandedHeight / 2;

  @override
  double get minExtent => kToolbarHeight*2;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}